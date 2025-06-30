using System.IdentityModel.Tokens.Jwt;
using SistemaBalletSync.Components;
using DinkToPdf;
using DinkToPdf.Contracts;
using Microsoft.Extensions.DependencyInjection;
using SistemaBalletSync.Services;

var builder = WebApplication.CreateBuilder(args);
var context = new CustomAssemblyLoadContext();
var dllPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "wkhtmltox", "libwkhtmltox.dll");
context.LoadUnmanagedLibrary(dllPath);


string connectionString = builder.Configuration.GetConnectionString("DefaultConnection");


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


builder.Services.AddScoped<UsuarioService>();
builder.Services.AddScoped<SessaoUsuario>();
builder.Services.AddScoped<TokenService>();
builder.Services.AddScoped<TokenStorageService>();
builder.Services.AddSingleton<TokenService>(); 
builder.Services.AddScoped<LogService>();
builder.Services.AddHttpClient<ViaCepService>();






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


builder.Services.AddControllers();
builder.Services.AddRazorComponents()
       .AddInteractiveServerComponents();

var app = builder.Build();


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
