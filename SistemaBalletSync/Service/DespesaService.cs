using Dapper;
using Npgsql;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
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
    public async Task<List<Despesa>> GetDespesasPorMesEAnoAsync(int mes, int ano)
    {
        var despesas = new List<Despesa>();

        using var connection = new NpgsqlConnection(_connectionString);
        await connection.OpenAsync();

        var query = "SELECT id, descricao, valor, data, categoria FROM despesas WHERE EXTRACT(MONTH FROM data) = @Mes AND EXTRACT(YEAR FROM data) = @Ano";
        using var cmd = new NpgsqlCommand(query, connection);
        cmd.Parameters.AddWithValue("Mes", mes);
        cmd.Parameters.AddWithValue("Ano", ano);

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
    public async Task<RelatorioDespesa> ObterRelatorioDespesasPorMes(int mes, int ano)
    {
        await using var connection = new NpgsqlConnection(_connectionString);
        await connection.OpenAsync();

        var query = @"
        SELECT descricao, valor, data
        FROM despesas
        WHERE EXTRACT(MONTH FROM data) = @Mes 
          AND EXTRACT(YEAR FROM data) = @Ano
        ORDER BY data";

        var dados = await connection.QueryAsync(query, new { Mes = mes, Ano = ano });

        var relatorio = new RelatorioDespesa
        {
            Titulo = $"Despesas do mês {mes:00}/{ano}",
            Coluna1 = "Descrição",
            Coluna2 = "Valor",
            Coluna3 = "Data",
            Dados = new List<RelatorioItemDespesa>()
        };

        foreach (var item in dados)
        {
            relatorio.Dados.Add(new RelatorioItemDespesa
            {
                Coluna1 = item.descricao,
                Coluna2 = Convert.ToDecimal(item.valor).ToString("C"),
                Coluna3 = Convert.ToDateTime(item.data).ToString("dd/MM/yyyy")
            });
        }

        return relatorio;
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
public class RelatorioDespesa
{
    public string Titulo { get; set; }
    public string Coluna1 { get; set; }
    public string Coluna2 { get; set; }
    public string Coluna3 { get; set; }
    public List<RelatorioItemDespesa> Dados { get; set; }
}

public class RelatorioItemDespesa
{
    public string Coluna1 { get; set; }
    public string Coluna2 { get; set; }
    public string Coluna3 { get; set; }
}