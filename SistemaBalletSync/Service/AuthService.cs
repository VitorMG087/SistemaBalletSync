using Npgsql;
using System.ComponentModel.DataAnnotations;

public class UsuarioService
{
    private readonly string _connectionString;

    public UsuarioService(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection");
    }

    public async Task<Usuario?> ValidarUsuarioAsync(string nome, string senha)
    {
        using var conn = new NpgsqlConnection(_connectionString);
        await conn.OpenAsync();

        var cmd = new NpgsqlCommand(
            "SELECT id, nome, email FROM usuarios WHERE nome = @nome AND senha = @senha", conn);

        cmd.Parameters.AddWithValue("nome", nome.Trim());
        cmd.Parameters.AddWithValue("senha", senha.Trim());

        using var reader = await cmd.ExecuteReaderAsync();

        if (await reader.ReadAsync())
        {
            return new Usuario
            {
                Id = reader.GetInt32(0),
                Nome = reader.GetString(1),
                Email = reader.GetString(2),
                Senha = senha
            };
        }

        return null;
    }
}

public class Usuario
{
    public int Id { get; set; }

    [Required(ErrorMessage = "O nome de usuário é obrigatório.")]
    public string Nome { get; set; }

    [Required(ErrorMessage = "A senha é obrigatória.")]
    public string Senha { get; set; }

    public string Email { get; set; }
}
