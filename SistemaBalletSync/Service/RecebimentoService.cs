using Dapper;
using Npgsql;
using System.Collections.Generic;
using System.Threading.Tasks;

public class RecebimentoService
{
    private readonly string _connectionString;

    public RecebimentoService(string connectionString)
    {
        _connectionString = connectionString;
    }

    public async Task<List<Recebimento>> GetAllRecebimentosAsync()
    {
        using var connection = new NpgsqlConnection(_connectionString);
        var query = "SELECT * FROM recebimentos";
        var result = await connection.QueryAsync<Recebimento>(query);
        return result.AsList();
    }

    public async Task<Recebimento> GetRecebimentoByIdAsync(string id)
    {
        using var connection = new NpgsqlConnection(_connectionString);
        var query = "SELECT * FROM recebimentos WHERE id = @Id";
        var result = await connection.QuerySingleOrDefaultAsync<Recebimento>(query, new { Id = id });
        return result;
    }

    public async Task AddRecebimentoAsync(Recebimento recebimento)
    {
        using var connection = new NpgsqlConnection(_connectionString);
        var query = "INSERT INTO recebimentos (descricao, valor, data, categoria) VALUES (@Descricao, @Valor, @Data, @Categoria)";
        await connection.ExecuteAsync(query, recebimento);
    }

    public async Task UpdateRecebimentoAsync(Recebimento recebimento, string id)
    {
        using var connection = new NpgsqlConnection(_connectionString);
        var query = "UPDATE recebimentos SET descricao = @Descricao, valor = @Valor, data = @Data, categoria = @Categoria WHERE id = @Id";
        await connection.ExecuteAsync(query, new { recebimento.Descricao, recebimento.Valor, recebimento.Data, recebimento.Categoria, Id = id });
    }

    public async Task DeleteRecebimentoAsync(int id)
    {
        using var connection = new NpgsqlConnection(_connectionString);
        var sql = "DELETE FROM Recebimentos WHERE Id = @Id";
        await connection.ExecuteAsync(sql, new { Id = id });
    }


}

public class Recebimento
{
    public int Id { get; set; }
    public string Descricao { get; set; }
    public decimal Valor { get; set; }
    public DateTime Data { get; set; }
    public string Categoria { get; set; }
}
