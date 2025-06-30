using Npgsql;
using System.ComponentModel.DataAnnotations;
using System.Security.Claims;
using System.Text;
using System.IdentityModel.Tokens.Jwt;
using Microsoft.IdentityModel.Tokens;
using System.Security.Cryptography;
using System.Text;


public class UsuarioService
{
    private readonly string _connectionString;

    public UsuarioService(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection");
    }
    public async Task<Usuario?> ValidarUsuarioAsync(string nome, string senha)
    {
        using var conexao = new NpgsqlConnection(_connectionString);
        await conexao.OpenAsync();

        var comando = conexao.CreateCommand();
        comando.CommandText = "SELECT id, nome, senha FROM usuarios WHERE nome = @nome";
        comando.Parameters.AddWithValue("@nome", nome);

        using var reader = await comando.ExecuteReaderAsync();
        if (await reader.ReadAsync())
        {
            var hashSalvo = reader["senha"].ToString();
            var senhaDigitadaHash = CriptografiaHelper.GerarHashSha256(senha);

            if (string.Equals(hashSalvo, senhaDigitadaHash, StringComparison.OrdinalIgnoreCase))
            {
                return new Usuario
                {
                    Id = Convert.ToInt32(reader["id"]),
                    Nome = reader["nome"].ToString()
                };
            }
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

    public static class CriptografiaHelper
    {
        public static string GerarHashSha256(string senha)
        {
            using var sha256 = SHA256.Create();
            var bytes = Encoding.UTF8.GetBytes(senha);
            var hash = sha256.ComputeHash(bytes);
            return Convert.ToHexString(hash);
        }
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
