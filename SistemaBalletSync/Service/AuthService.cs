using Npgsql;
using System.ComponentModel.DataAnnotations;
using System.Security.Claims;
using System.Text;
using System.IdentityModel.Tokens.Jwt;
using Microsoft.IdentityModel.Tokens;

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
    public string GerarToken(Usuario usuario)
    {
        var tokenHandler = new JwtSecurityTokenHandler();
        var key = Encoding.ASCII.GetBytes("esta_e_uma_chave_muito_secreta_com_32chars!");


        var tokenDescriptor = new SecurityTokenDescriptor
        {
            Subject = new ClaimsIdentity(new[]
            {
            new Claim(ClaimTypes.Name, usuario.Nome),
            new Claim("id", usuario.Id.ToString())
        }),
           Expires = DateTime.UtcNow.AddHours(1),
            //Expires = DateTime.UtcNow.AddSeconds(5),

            SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
        };

        var token = tokenHandler.CreateToken(tokenDescriptor);
        return tokenHandler.WriteToken(token);
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
