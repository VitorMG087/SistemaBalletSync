using System.Data;
using Npgsql;

public class PlanoService
{
    private readonly string _connectionString;

    public PlanoService(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection");
    }

    public async Task<List<Plano>> GetPlanosAsync()
    {
        var planos = new List<Plano>();

        using var connection = new NpgsqlConnection(_connectionString);
        await connection.OpenAsync();

        using var command = new NpgsqlCommand("SELECT id_plano, nome, valor FROM planos", connection);
        using var reader = await command.ExecuteReaderAsync();

        while (await reader.ReadAsync())
        {
            planos.Add(new Plano
            {
                Id = reader.GetInt32(0),
                Nome = reader.GetString(1),
                Valor = reader.GetDecimal(2)
            });
        }

        return planos;
    }

}
