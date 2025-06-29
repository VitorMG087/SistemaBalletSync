using System.IdentityModel.Tokens.Jwt;
using SistemaBalletSync.Components;
using DinkToPdf;
using DinkToPdf.Contracts;
using Microsoft.Extensions.DependencyInjection;

var builder = WebApplication.CreateBuilder(args);
var context = new CustomAssemblyLoadContext();
var dllPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "wkhtmltox", "libwkhtmltox.dll");
context.LoadUnmanagedLibrary(dllPath);

// Conexão com PostgreSQL
string connectionString = builder.Configuration.GetConnectionString("DefaultConnection");

// Serviços do sistema
builder.Services.AddSingleton(new RecebimentoService(connectionString));
builder.Services.AddSingleton(typeof(IConverter), new SynchronizedConverter(new PdfTools()));

builder.Services.AddScoped<PdfService>();
builder.Services.AddScoped<PlanoService>();


builder.Services.AddScoped<ProfessorService>(_ =>
    new ProfessorService(connectionString));

builder.Services.AddScoped<AulaService>(provider =>
{
    var professorService = provider.GetRequiredService<ProfessorService>();
    return new AulaService(connectionString, professorService);
});

builder.Services.AddScoped<AlunoService>(_ =>
    new AlunoService(connectionString));

builder.Services.AddScoped<DespesaService>(_ =>
    new DespesaService(connectionString));

// ✅ Registro do UsuarioService
builder.Services.AddScoped<UsuarioService>();
builder.Services.AddScoped<SessaoUsuario>();
builder.Services.AddScoped<TokenService>();
builder.Services.AddScoped<TokenStorageService>();
builder.Services.AddSingleton<TokenService>(); // se quiser gerar token no backend




// Configuração do HttpClient
builder.Services.AddHttpClient();
builder.Services.AddHttpClient("MyClient", client =>
{
    client.BaseAddress = new Uri("https://localhost:7051/");
});

builder.Services.AddScoped(sp =>
{
    var httpClientFactory = sp.GetRequiredService<IHttpClientFactory>();
    var httpClient = httpClientFactory.CreateClient();
    httpClient.BaseAddress = new Uri("https://localhost:7051/");
    return httpClient;
});

// MVC + Blazor Server
builder.Services.AddControllers();
builder.Services.AddRazorComponents()
       .AddInteractiveServerComponents();

var app = builder.Build();

// Middlewares padrão
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error", createScopeForErrors: true);
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseAntiforgery();

app.MapControllers();

app.MapRazorComponents<App>()
    .AddInteractiveServerRenderMode();

app.Run();
