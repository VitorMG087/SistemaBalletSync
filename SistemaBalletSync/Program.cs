using SistemaBalletSync.Components;

var builder = WebApplication.CreateBuilder(args);


string connectionString = builder.Configuration.GetConnectionString("DefaultConnection");


builder.Services.AddSingleton(new ProfessorService(connectionString));
builder.Services.AddHttpClient();
builder.Services.AddHttpClient("MyClient", client =>
{
    client.BaseAddress = new Uri("https://https://localhost:7051/"); 
});




builder.Services.AddSingleton<AulaService>(provider =>
{
    var professorService = provider.GetRequiredService<ProfessorService>();
    return new AulaService(connectionString, professorService);
});

builder.Services.AddSingleton(new AlunoService(connectionString));

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
