using Npgsql;
using System.Collections.Generic;
using System.Threading.Tasks;

public class DespesaService
{
    private readonly string _connectionString;

    public DespesaService(string connectionString)
    {
        _connectionString = connectionString;
    }

    public async Task<List<Despesa>> GetDespesasAsync()
    {
        var despesas = new List<Despesa>();

        using var connection = new NpgsqlConnection(_connectionString);
        await connection.OpenAsync();

        var query = "SELECT id, descricao, valor, data, categoria FROM despesas";
        using var cmd = new NpgsqlCommand(query, connection);
        using var reader = await cmd.ExecuteReaderAsync();

        while (await reader.ReadAsync())
        {
            despesas.Add(new Despesa
            {
                Id = reader.GetInt32(0),
                Descricao = reader.GetString(1),
                Valor = reader.GetDecimal(2),
                Data = reader.GetDateTime(3),
                Categoria = reader.IsDBNull(4) ? null : reader.GetString(4)
            });
        }

        return despesas;
    }

    public async Task<Despesa?> GetDespesaByIdAsync(int id)
    {
        using var connection = new NpgsqlConnection(_connectionString);
        await connection.OpenAsync();

        var query = "SELECT id, descricao, valor, data, categoria FROM despesas WHERE id = @Id";
        using var cmd = new NpgsqlCommand(query, connection);
        cmd.Parameters.AddWithValue("Id", id);

        using var reader = await cmd.ExecuteReaderAsync();
        if (await reader.ReadAsync())
        {
            return new Despesa
            {
                Id = reader.GetInt32(0),
                Descricao = reader.GetString(1),
                Valor = reader.GetDecimal(2),
                Data = reader.GetDateTime(3),
                Categoria = reader.IsDBNull(4) ? null : reader.GetString(4)
            };
        }

        return null;
    }

    public async Task AddDespesaAsync(Despesa despesa)
    {
        using var connection = new NpgsqlConnection(_connectionString);
        await connection.OpenAsync();

        var query = "INSERT INTO despesas (descricao, valor, data, categoria) VALUES (@Descricao, @Valor, @Data, @Categoria)";
        using var cmd = new NpgsqlCommand(query, connection);
        cmd.Parameters.AddWithValue("Descricao", despesa.Descricao);
        cmd.Parameters.AddWithValue("Valor", despesa.Valor);
        cmd.Parameters.AddWithValue("Data", despesa.Data);
        cmd.Parameters.AddWithValue("Categoria", (object?)despesa.Categoria ?? DBNull.Value);

        await cmd.ExecuteNonQueryAsync();
    }

    public async Task UpdateDespesaAsync(Despesa despesa, int id)
    {
        using var connection = new NpgsqlConnection(_connectionString);
        await connection.OpenAsync();

        var query = "UPDATE despesas SET descricao = @Descricao, valor = @Valor, data = @Data, categoria = @Categoria WHERE id = @Id";
        using var cmd = new NpgsqlCommand(query, connection);
        cmd.Parameters.AddWithValue("Descricao", despesa.Descricao);
        cmd.Parameters.AddWithValue("Valor", despesa.Valor);
        cmd.Parameters.AddWithValue("Data", despesa.Data);
        cmd.Parameters.AddWithValue("Categoria", (object?)despesa.Categoria ?? DBNull.Value);
        cmd.Parameters.AddWithValue("Id", id);

        await cmd.ExecuteNonQueryAsync();
    }

    public async Task DeleteDespesaAsync(int id)
    {
        using var connection = new NpgsqlConnection(_connectionString);
        await connection.OpenAsync();

        var query = "DELETE FROM despesas WHERE id = @Id";
        using var cmd = new NpgsqlCommand(query, connection);
        cmd.Parameters.AddWithValue("Id", id);

        await cmd.ExecuteNonQueryAsync();
    }
}

public class Despesa
{
    public int Id { get; set; }
    public string Descricao { get; set; } = string.Empty;
    public decimal Valor { get; set; }
    public DateTime Data { get; set; }
    public string? Categoria { get; set; }
}
