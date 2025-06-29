using System.Security.Claims;
using System.Text;
using System.IdentityModel.Tokens.Jwt;
using Microsoft.IdentityModel.Tokens;
using Microsoft.JSInterop;
using System.Threading.Tasks;


// Serviço para gerar token JWT no servidor
public class TokenService
{
    private const string KeyString = "12345678901234567890123456789012abcdefghi!@#"; // >= 32 chars

    public string GerarToken(Usuario usuario)
    {
        var tokenHandler = new JwtSecurityTokenHandler();
        var key = Encoding.ASCII.GetBytes(KeyString);

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
    public class TokenServiceverf
    {
        private readonly IJSRuntime _jsRuntime;

        public TokenServiceverf(IJSRuntime jsRuntime)
        {
            _jsRuntime = jsRuntime;
        }

        public async Task<string?> GetTokenAsync()
        {
            return await _jsRuntime.InvokeAsync<string>("sessionStorage.getItem", "authToken");
        }

        public async Task RemoveTokenAsync()
        {
            await _jsRuntime.InvokeVoidAsync("sessionStorage.removeItem", "authToken");
        }

        public bool TokenExpirado(string token)
        {
            if (string.IsNullOrEmpty(token)) return true;

            var handler = new JwtSecurityTokenHandler();
            var jwt = handler.ReadJwtToken(token);

            return jwt.ValidTo < DateTime.UtcNow;
        }
    }
}

// Serviço para manipular token no browser via JSInterop no Blazor


public class TokenStorageService
{
    private readonly IJSRuntime _jsRuntime;

    public TokenStorageService(IJSRuntime jsRuntime)
    {
        _jsRuntime = jsRuntime;
    }

    public async Task<string?> GetTokenAsync()
    {
        return await _jsRuntime.InvokeAsync<string?>("sessionStorage.getItem", "authToken");
    }

    public async Task SetTokenAsync(string token)
    {
        await _jsRuntime.InvokeVoidAsync("sessionStorage.getItem", "authToken", token);
    }

    public async Task RemoveTokenAsync()
    {
        await _jsRuntime.InvokeVoidAsync("sessionStorage.getItem", "authToken");
    }
}

