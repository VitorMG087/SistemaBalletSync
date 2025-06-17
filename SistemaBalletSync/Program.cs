using SistemaBalletSync.Components;
using SistemaBalletSync.Services;

var builder = WebApplication.CreateBuilder(args);

string connectionString = builder.Configuration.GetConnectionString("DefaultConnection");

// Configuração do IronPDF
try
{
    // Configurar IronPDF
    IronPdf.License.LicenseKey = "YOUR_LICENSE_KEY"; // Substitua pela sua licença, se tiver

    // Inicializa o IronPDF (opcional, mas recomendado)
    IronPdf.Installation.Initialize();

    Console.WriteLine("IronPDF configurado com sucesso!");
}
catch (Exception ex)
{
    Console.WriteLine($"Erro ao configurar IronPDF: {ex.Message}");
    // O IronPDF pode funcionar em modo trial sem licença
}

// Registrar serviços no DI container
builder.Services.AddSingleton(new RecebimentoService(connectionString));

// Registrar PdfService apenas uma vez, com namespace correto
builder.Services.AddScoped<PdfService>();

builder.Services.AddScoped<PlanoService>();

builder.Services.AddScoped<ProfessorService>(provider =>
{
    return new ProfessorService(connectionString);
});

builder.Services.AddScoped<AulaService>(provider =>
{
    var professorService = provider.GetRequiredService<ProfessorService>();
    return new AulaService(connectionString, professorService);
});

builder.Services.AddScoped<AlunoService>(provider =>
{
    return new AlunoService(connectionString);
});

builder.Services.AddScoped<DespesaService>(provider =>
{
    return new DespesaService(connectionString);
});

// Configurar HttpClient para consumo HTTP
builder.Services.AddHttpClient();
builder.Services.AddHttpClient("MyClient", client =>
{
    client.BaseAddress = new Uri("https://localhost:7051/");
});

// Registrar HttpClient via factory
builder.Services.AddScoped(sp =>
{
    var httpClientFactory = sp.GetRequiredService<IHttpClientFactory>();
    var httpClient = httpClientFactory.CreateClient();
    httpClient.BaseAddress = new Uri("https://localhost:7051/");
    return httpClient;
});

// Configurações MVC e Razor Components
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
