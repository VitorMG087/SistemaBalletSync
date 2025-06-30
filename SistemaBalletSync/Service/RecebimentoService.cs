using Dapper;
using Npgsql;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Threading.Tasks;


public class RecebimentoService
{
    private readonly string _connectionString;

    public RecebimentoService(string connectionString)
    {
        _connectionString = connectionString;
    }

    
    public async Task<List<Mensalidade>> GetMensalidadesPorMesEAnoAsync(int mes, int ano)
    {
        using var connection = new NpgsqlConnection(_connectionString);

        
        var alunosSemMensalidade = await connection.QueryAsync<(int Id, string Nome, decimal Valor)>(@"
        SELECT 
            a.id, 
            a.nome, 
            p.valor
        FROM alunos a
        INNER JOIN planos p ON a.id_plano = p.id_plano
        WHERE a.ativo = true 
          AND p.valor > 0
          AND NOT EXISTS (
              SELECT 1 FROM mensalidades m 
              WHERE m.aluno_id = a.id 
                AND EXTRACT(MONTH FROM m.data_vencimento) = @Mes
                AND EXTRACT(YEAR FROM m.data_vencimento) = @Ano
          )", new { Mes = mes, Ano = ano });

        
        foreach (var aluno in alunosSemMensalidade)
        {
            var dataVencimento = new DateTime(ano, mes, 10);

            await connection.ExecuteAsync(@"
            INSERT INTO mensalidades (aluno_id, nome_aluno, valor, data_vencimento, esta_pago)
            VALUES (@AlunoId, @NomeAluno, @Valor, @DataVencimento, false)", new
            {
                AlunoId = aluno.Id,
                NomeAluno = aluno.Nome,
                Valor = aluno.Valor,
                DataVencimento = dataVencimento
            });
        }

       
        var query = @"
        SELECT 
            m.id, 
            m.aluno_id, 
            a.nome AS ""NomeAluno"", 
            m.valor, 
            m.data_vencimento AS ""DataVencimento"", 
            m.esta_pago AS ""EstaPago""
        FROM mensalidades m
        INNER JOIN alunos a ON m.aluno_id = a.id
        WHERE EXTRACT(MONTH FROM m.data_vencimento) = @Mes
          AND EXTRACT(YEAR FROM m.data_vencimento) = @Ano
          AND a.ativo = true
        ORDER BY m.data_vencimento";

        var result = await connection.QueryAsync<Mensalidade>(query, new { Mes = mes, Ano = ano });
        return result.AsList();
    }

    public async Task<List<Mensalidade>> GetMensalidadesAbertasDoMesAsync(int mes, int ano)
    {
        using var connection = new NpgsqlConnection(_connectionString);

        
        var alunosSemMensalidade = await connection.QueryAsync<(int Id, string Nome, decimal Valor)>(@"
        SELECT 
            a.id, 
            a.nome, 
            p.valor
        FROM alunos a
        INNER JOIN planos p ON a.id_plano = p.id_plano
        WHERE a.ativo = true 
          AND p.valor > 0
          AND NOT EXISTS (
              SELECT 1 FROM mensalidades m 
              WHERE m.aluno_id = a.id 
                AND EXTRACT(MONTH FROM m.data_vencimento) = @Mes
                AND EXTRACT(YEAR FROM m.data_vencimento) = @Ano
          )", new { Mes = mes, Ano = ano });

        
        foreach (var aluno in alunosSemMensalidade)
        {
            var dataVencimento = new DateTime(ano, mes, 10);

            await connection.ExecuteAsync(@"
            INSERT INTO mensalidades (aluno_id, nome_aluno, valor, data_vencimento, esta_pago)
            VALUES (@AlunoId, @NomeAluno, @Valor, @DataVencimento, false)", new
            {
                AlunoId = aluno.Id,
                NomeAluno = aluno.Nome,
                Valor = aluno.Valor,
                DataVencimento = dataVencimento
            });
        }

        
        var query = @"
        SELECT 
            m.id, 
            m.aluno_id, 
            a.nome AS ""NomeAluno"", 
            m.valor, 
            m.data_vencimento AS ""DataVencimento"", 
            m.esta_pago AS ""EstaPago""
        FROM mensalidades m
        INNER JOIN alunos a ON m.aluno_id = a.id
        WHERE m.esta_pago = false
          AND EXTRACT(MONTH FROM m.data_vencimento) = @Mes
          AND EXTRACT(YEAR FROM m.data_vencimento) = @Ano
          AND a.ativo = true
        ORDER BY m.data_vencimento";

        var result = await connection.QueryAsync<Mensalidade>(query, new { Mes = mes, Ano = ano });
        return result.AsList();
    }

    public async Task DarBaixaMensalidadeAsync(int mensalidadeId)
    {
        using var connection = new NpgsqlConnection(_connectionString);

        
        var rowsAffected = await connection.ExecuteAsync(
            "UPDATE mensalidades SET esta_pago = true WHERE id = @Id",
            new { Id = mensalidadeId });

        if (rowsAffected == 0)
            throw new Exception("Mensalidade não encontrada ou já atualizada.");

        
        var mensalidade = await connection.QuerySingleAsync<Mensalidade>(@"
        SELECT 
            m.id, 
            m.aluno_id, 
            a.nome AS ""NomeAluno"", 
            m.valor, 
            m.data_vencimento, 
            m.esta_pago
        FROM mensalidades m
        INNER JOIN alunos a ON m.aluno_id = a.id
        WHERE m.id = @Id", new { Id = mensalidadeId });

        await connection.ExecuteAsync(@"
        INSERT INTO recebimentos (descricao, valor, data, categoria)
        VALUES (@Descricao, @Valor, @Data, @Categoria)", new
        {
            Descricao = $"Mensalidade - {mensalidade.NomeAluno}",
            Valor = mensalidade.Valor,
            Data = DateTime.Now, 
            Categoria = "Mensalidade"
        });
    }

    public async Task GerarMensalidadesAsync(int mes, int ano)
    {
        using var connection = new NpgsqlConnection(_connectionString);
        await connection.OpenAsync();

        var alunosAtivos = await connection.QueryAsync<(int Id, string Nome, decimal Valor)>(@"
        SELECT 
            a.id, 
            a.nome, 
            p.valor
        FROM alunos a
        INNER JOIN planos p ON a.id_plano = p.id_plano
        WHERE a.ativo = true AND p.valor > 0
        ");

        foreach (var aluno in alunosAtivos)
        {
            var dataVencimento = new DateTime(ano, mes, 10);

            var existe = await connection.ExecuteScalarAsync<bool?>(@"
            SELECT EXISTS(
                SELECT 1 FROM mensalidades
                WHERE aluno_id = @AlunoId
                  AND EXTRACT(MONTH FROM data_vencimento) = @Mes
                  AND EXTRACT(YEAR FROM data_vencimento) = @Ano
            )", new { AlunoId = aluno.Id, Mes = mes, Ano = ano });

            if (!existe.GetValueOrDefault())
            {
                await connection.ExecuteAsync(@"
                INSERT INTO mensalidades (aluno_id, nome_aluno, valor, data_vencimento, esta_pago)
                VALUES (@AlunoId, @NomeAluno, @Valor, @DataVencimento, false)
                ", new
                {
                    AlunoId = aluno.Id,
                    NomeAluno = aluno.Nome,
                    Valor = aluno.Valor,
                    DataVencimento = dataVencimento
                });
            }
        }
    }

    public async Task<List<Recebimento>> GetAllRecebimentosAsync()
    {
        using var connection = new NpgsqlConnection(_connectionString);
        var result = await connection.QueryAsync<Recebimento>("SELECT * FROM recebimentos ORDER BY data DESC");
        return result.AsList();
    }

    public async Task<Recebimento> GetRecebimentoByIdAsync(int id)
    {
        using var connection = new NpgsqlConnection(_connectionString);
        return await connection.QuerySingleOrDefaultAsync<Recebimento>(
            "SELECT * FROM recebimentos WHERE id = @Id", new { Id = id });
    }

    public async Task UpdateRecebimentoAsync(Recebimento recebimento, int id)
    {
        using var connection = new NpgsqlConnection(_connectionString);
        var query = @"
            UPDATE recebimentos 
            SET descricao = @Descricao, valor = @Valor, data = @Data, categoria = @Categoria 
            WHERE id = @Id";
        await connection.ExecuteAsync(query, new
        {
            recebimento.Descricao,
            recebimento.Valor,
            recebimento.Data,
            recebimento.Categoria,
            Id = id
        });
    }

    public async Task AddRecebimentoAsync(Recebimento recebimento)
    {
        using var connection = new NpgsqlConnection(_connectionString);
        var query = @"
            INSERT INTO recebimentos (descricao, valor, data, categoria) 
            VALUES (@Descricao, @Valor, @Data, @Categoria)";
        await connection.ExecuteAsync(query, recebimento);
    }

    public async Task DeleteRecebimentoAsync(int id)
    {
        using var connection = new NpgsqlConnection(_connectionString);

        var recebimento = await connection.QuerySingleOrDefaultAsync<Recebimento>(
            "SELECT * FROM recebimentos WHERE Id = @Id", new { Id = id });

        if (recebimento?.Categoria == "Mensalidade")
        {
            string nomeAluno = recebimento.Descricao.Replace("Mensalidade - ", "").Trim();

            var mensalidadeId = await connection.QueryFirstOrDefaultAsync<int?>(@"
                SELECT m.id
                FROM mensalidades m
                INNER JOIN alunos a ON m.aluno_id = a.id
                WHERE m.valor = @Valor
                  AND a.nome = @NomeAluno
                  AND DATE(m.data_vencimento) = DATE(@Data)", new
            {
                Valor = recebimento.Valor,
                Data = recebimento.Data,
                NomeAluno = nomeAluno
            });

            if (mensalidadeId.HasValue)
            {
                await connection.ExecuteAsync(
                    "UPDATE mensalidades SET esta_pago = false WHERE id = @Id",
                    new { Id = mensalidadeId.Value });
            }
        }

        await connection.ExecuteAsync("DELETE FROM recebimentos WHERE Id = @Id", new { Id = id });
    }

    public async Task<List<Recebimento>> GetRecebimentosPorMesEAnoAsync(int mes, int ano)
    {
        using var connection = new NpgsqlConnection(_connectionString);
        var query = @"
            SELECT * FROM recebimentos 
            WHERE EXTRACT(MONTH FROM data) = @Mes 
              AND EXTRACT(YEAR FROM data) = @Ano
            ORDER BY data DESC";
        var result = await connection.QueryAsync<Recebimento>(query, new { Mes = mes, Ano = ano });
        return result.AsList();
    }
    public async Task<RelatorioRecebimento> ObterRelatorioRecebimentosPorMes(int mes, int ano)
    {
        using var connection = new NpgsqlConnection(_connectionString);

        var query = @"
        SELECT descricao, valor, data 
        FROM recebimentos 
        WHERE EXTRACT(MONTH FROM data) = @Mes 
          AND EXTRACT(YEAR FROM data) = @Ano
        ORDER BY data";

        var dados = await connection.QueryAsync(query, new { Mes = mes, Ano = ano });

        var relatorio = new RelatorioRecebimento
        {
            Titulo = $"Recebimentos do mês {mes:00}/{ano}",
            Coluna1 = "Descrição",
            Coluna2 = "Valor",
            Coluna3 = "Data",
            Dados = new List<RelatorioItemRecebimento>()
        };

        foreach (var item in dados)
        {
            relatorio.Dados.Add(new RelatorioItemRecebimento
            {
                Coluna1 = item.descricao,
                Coluna2 = Convert.ToDecimal(item.valor).ToString("C"),
                Coluna3 = Convert.ToDateTime(item.data).ToString("dd/MM/yyyy")
            });
        }

        return relatorio;
    }

   public async Task DeleteRecebimento(int id)
{
    using var connection = new NpgsqlConnection(_connectionString);

    var recebimento = await connection.QuerySingleOrDefaultAsync<Recebimento>(
        "SELECT * FROM recebimentos WHERE id = @Id", new { Id = id });

    if (recebimento == null)
        throw new Exception("Recebimento não encontrado.");

    // Se for um recebimento de mensalidade, desfaz a baixa
    if (recebimento.Categoria == "Mensalidade")
    {
        string nomeAluno = recebimento.Descricao.Replace("Mensalidade - ", "").Trim();

        // Corrigido para procurar por data de vencimento (não pela data do recebimento!)
        var mensalidadeId = await connection.QueryFirstOrDefaultAsync<int?>(@"
            SELECT m.id
            FROM mensalidades m
            INNER JOIN alunos a ON m.aluno_id = a.id
            WHERE a.nome = @NomeAluno
              AND m.valor = @Valor
              AND m.esta_pago = true
              AND m.data_vencimento = (
                  SELECT MIN(m2.data_vencimento)
                  FROM mensalidades m2
                  INNER JOIN alunos a2 ON m2.aluno_id = a2.id
                  WHERE a2.nome = @NomeAluno
                    AND m2.valor = @Valor
                    AND m2.esta_pago = true
              )", new
        {
            NomeAluno = nomeAluno,
            Valor = recebimento.Valor
        });

        if (mensalidadeId.HasValue)
        {
            await connection.ExecuteAsync(
                "UPDATE mensalidades SET esta_pago = false WHERE id = @Id",
                new { Id = mensalidadeId.Value });
        }
    }

    await connection.ExecuteAsync("DELETE FROM recebimentos WHERE id = @Id", new { Id = id });
}



}


public class Mensalidade
{
    public int Id { get; set; }
    public int Aluno_Id { get; set; }
    public string NomeAluno { get; set; }
    public decimal Valor { get; set; }
    public DateTime DataVencimento { get; set; }
    public bool EstaPago { get; set; }
}

public class Recebimento
{
    public int Id { get; set; }

    [Required(ErrorMessage = "A descrição é obrigatória.")]
    public string Descricao { get; set; }

    [Required(ErrorMessage = "O valor é obrigatório.")]
    [Range(0.01, double.MaxValue, ErrorMessage = "O valor deve ser maior que zero.")]
    public decimal Valor { get; set; }

    [Required(ErrorMessage = "A data é obrigatória.")]
    public DateTime Data { get; set; }

    [Required(ErrorMessage = "A categoria é obrigatória.")]
    public string Categoria { get; set; }
}

public class RelatorioRecebimento
{
    public string Titulo { get; set; }
    public string Coluna1 { get; set; }
    public string Coluna2 { get; set; }
    public string Coluna3 { get; set; }
    public List<RelatorioItemRecebimento> Dados { get; set; }
}

public class RelatorioItemRecebimento
{
    public string Coluna1 { get; set; }
    public string Coluna2 { get; set; }
    public string Coluna3 { get; set; }
}

