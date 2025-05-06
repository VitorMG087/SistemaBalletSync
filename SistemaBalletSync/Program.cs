using SistemaBalletSync.Components;

var builder = WebApplication.CreateBuilder(args);


string connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddSingleton(new RecebimentoService(connectionString));



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


builder.Services.AddHttpClient();
builder.Services.AddHttpClient("MyClient", client =>
{
    client.BaseAddress = new Uri("https://localhost:7051/");  // ⚠️ Corrigido o URL duplicado
});


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


app.MapRazorComponents<App>()
    .AddInteractiveServerRenderMode();

app.Run();
