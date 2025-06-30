using Npgsql;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;






public class AlunoService
{
	private readonly string _connectionString;

	public AlunoService(string connectionString)
	{
		_connectionString = connectionString;
	}

    public async Task<List<Aluno>> GetAlunosAsync()
    {
        var alunos = new List<Aluno>();

        using (var connection = new NpgsqlConnection(_connectionString))
        {
            await connection.OpenAsync();

            string query = @"SELECT id, Alunos.nome, cpf, telefone, cep, estado, cidade, bairro, endereco, complemento, p.nome, p.valor, ativo FROM Alunos LEFT JOIN planos p ON p.id_plano = Alunos.id_plano";

            using (var cmd = new NpgsqlCommand(query, connection))
            using (var reader = await cmd.ExecuteReaderAsync())
            {
                while (await reader.ReadAsync())
                {
                    alunos.Add(new Aluno
                    {
                        Id = reader.GetInt32(0),
                        Nome = reader.GetString(1),
                        CPF = reader.GetString(2),
                        Telefone = reader.GetString(3),
                        Cep = reader.IsDBNull(4) ? null : reader.GetString(4),
                        Estado = reader.GetString(5),
                        Cidade = reader.GetString(6),
                        Bairro = reader.IsDBNull(7) ? null : reader.GetString(7),
                        Endereco = reader.GetString(8),
                        Complemento = reader.IsDBNull(9) ? null : reader.GetString(9),
						NomePlano = reader.IsDBNull(10) ? "Sem plano" : reader.GetString(10) + " - " + reader.GetDecimal(11).ToString("C2"),
						Ativo = !reader.IsDBNull(12) && reader.GetBoolean(12)


					});
                }
            }
        }

        return alunos;
    }
    public async Task<Aluno> GetAlunoByIdAsync(int id)
    {
        var aluno = new Aluno();

        using (var connection = new NpgsqlConnection(_connectionString))
        {
            await connection.OpenAsync();

            using (var cmd = new NpgsqlCommand("SELECT id, nome, cpf, telefone, cep, estado, cidade, bairro, endereco, complemento FROM Alunos WHERE id = @id", connection))
            {
                cmd.Parameters.AddWithValue("id", id);

                using (var reader = await cmd.ExecuteReaderAsync())
                {
                    if (await reader.ReadAsync())
                    {
                        aluno = new Aluno
                        {
                            Id = reader.GetInt32(0),
                            Nome = reader.GetString(1),
                            CPF = reader.GetString(2),
                            Telefone = reader.GetString(3),
                            Cep = reader.IsDBNull(4) ? null : reader.GetString(4),
                            Estado = reader.GetString(5),
                            Cidade = reader.GetString(6),
                            Bairro = reader.IsDBNull(7) ? null : reader.GetString(7),
                            Endereco = reader.GetString(8),
                            Complemento = reader.IsDBNull(9) ? null : reader.GetString(9),
                        };
                    }
                }
            }
        }
        return aluno;
    }




    public async Task AddAlunoAsync(Aluno aluno)
    {
        using (var connection = new NpgsqlConnection(_connectionString))
        {
            await connection.OpenAsync();
            var query = @" INSERT INTO alunos (nome, cpf, telefone, cep, estado, cidade, bairro, endereco, complemento, id_plano, ativo) VALUES (@nome, @cpf, @telefone, @cep, @estado, @cidade, @bairro, @endereco, @complemento, @id_plano, @ativo)";

            using (var cmd = new NpgsqlCommand(query, connection))
            {
                cmd.Parameters.AddWithValue("nome", aluno.Nome);
                cmd.Parameters.AddWithValue("cpf", aluno.CPF);
                cmd.Parameters.AddWithValue("telefone", aluno.Telefone);
                cmd.Parameters.AddWithValue("cep", (object?)aluno.Cep ?? DBNull.Value);
                cmd.Parameters.AddWithValue("estado", aluno.Estado);
                cmd.Parameters.AddWithValue("cidade", aluno.Cidade);
                cmd.Parameters.AddWithValue("bairro", (object?)aluno.Bairro ?? DBNull.Value);
                cmd.Parameters.AddWithValue("endereco", aluno.Endereco);
                cmd.Parameters.AddWithValue("complemento", (object?)aluno.Complemento ?? DBNull.Value);
                cmd.Parameters.AddWithValue("id_plano", aluno.IdPlano == 0 ? DBNull.Value : aluno.IdPlano);
                cmd.Parameters.AddWithValue("ativo", aluno.Ativo); // novo campo booleano

                await cmd.ExecuteNonQueryAsync();
            }
        }
    }


    public async Task UpdateAlunoAsync(Aluno aluno, string idAluno)
    {
        using var connection = new NpgsqlConnection(_connectionString);
        await connection.OpenAsync();

        if (!int.TryParse(idAluno, out int id))
            throw new ArgumentException("ID do aluno inválido");

        var cmd = new NpgsqlCommand(@"
        UPDATE alunos SET 
            nome = @nome,
            cpf = @cpf,
            telefone = @telefone,
            cep = @cep,
            estado = @estado,
            cidade = @cidade,
            bairro = @bairro,
            endereco = @endereco,
            complemento = @complemento,
            id_plano = @id_plano,
            ativo = @ativo
        WHERE id = @id", connection);

        cmd.Parameters.AddWithValue("@id", id);
        cmd.Parameters.AddWithValue("@nome", aluno.Nome);
        cmd.Parameters.AddWithValue("@cpf", aluno.CPF);
        cmd.Parameters.AddWithValue("@telefone", aluno.Telefone);
        cmd.Parameters.AddWithValue("@cep", (object?)aluno.Cep ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@estado", (object?)aluno.Estado ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@cidade", (object?)aluno.Cidade ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@bairro", (object?)aluno.Bairro ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@endereco", aluno.Endereco);
        cmd.Parameters.AddWithValue("@complemento", (object?)aluno.Complemento ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@id_plano", aluno.IdPlano == 0 ? DBNull.Value : aluno.IdPlano);
        cmd.Parameters.AddWithValue("@ativo", aluno.Ativo); 

        await cmd.ExecuteNonQueryAsync();
    }



    public async Task DeleteAlunoAsync(int id)
	{
		using (var connection = new NpgsqlConnection(_connectionString))
		{
			await connection.OpenAsync();

			var query = "DELETE FROM Alunos WHERE id = @Id";
			using (var cmd = new NpgsqlCommand(query, connection))
			{
				cmd.Parameters.AddWithValue("Id", id);

				await cmd.ExecuteNonQueryAsync();
			}
		}
	}

	public async Task<bool> ValidarCpfAsync(string cpf)
	{
		using (var connection = new NpgsqlConnection(_connectionString))
		{
			await connection.OpenAsync();

			using (var cmd = new NpgsqlCommand("SELECT COUNT(*) FROM Alunos WHERE cpf = @Cpf", connection))
			{
				cmd.Parameters.AddWithValue("Cpf", cpf);

				var count = (long)await cmd.ExecuteScalarAsync();

				return count > 0;
			}
		}
	}
    public async Task<List<Plano>> GetPlanosAsync()
    {
        var planos = new List<Plano>();

        using var connection = new NpgsqlConnection(_connectionString);
        await connection.OpenAsync();

        string query = "SELECT id_plano, nome, valor FROM planos";

        using var command = new NpgsqlCommand(query, connection);
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

    public async Task<Relatorio> ObterRelatorioFrequenciaPorMes(int mes, int ano)
    {

        var dados = new List<RelatorioItem>();

        using (var connection = new NpgsqlConnection(_connectionString))
        {
            await connection.OpenAsync();

            
            string query = @"SELECT 
            a.id AS AlunoId,
            a.nome AS NomeAluno,
            COUNT(aa.aluno_id) AS Frequencia,
            STRING_AGG(DISTINCT au.local, ', ') AS Locais
        FROM 
            alunos_aulas aa
        INNER JOIN 
            alunos a ON aa.aluno_id = a.id
        INNER JOIN 
            aulas au ON aa.aula_id = au.id
        WHERE 
            EXTRACT(MONTH FROM au.datahora) = @Mes AND
            EXTRACT(YEAR FROM au.datahora) = @Ano
        GROUP BY 
            a.id, a.nome
        ORDER BY 
            Frequencia DESC";

            using (var cmd = new NpgsqlCommand(query, connection))
            {
                cmd.Parameters.AddWithValue("Mes", mes);
                cmd.Parameters.AddWithValue("Ano", ano);

                using (var reader = await cmd.ExecuteReaderAsync())
                {
                    while (await reader.ReadAsync())
                    {
                        dados.Add(new RelatorioItem
                        {
                            Coluna1 = reader["NomeAluno"].ToString(), 
                            Coluna2 = $"{reader["Frequencia"]} presenças", 
                            Coluna3 = reader["Locais"].ToString() 
                        });
                    }
                }
            }
        }

        return new Relatorio
        {
            Titulo = $"Relatório de Frequência - {new DateTime(ano, mes, 1):MMMM yyyy}",
            Coluna1 = "Aluno",
            Coluna2 = "Frequência",
            Coluna3 = "Locais",
            Dados = dados
        };
    }


}
public class Aluno
	{
		public int Id { get; set; }
		public string Nome { get; set; }
		[Required(ErrorMessage = "O CPF é obrigatório.")]
		[RegularExpression(@"^\d{11}$", ErrorMessage = "O CPF deve conter exatamente 11 números.")]
		public string CPF { get; set; }

		[Required(ErrorMessage = "O telefone é obrigatório.")]
		[RegularExpression(@"^\d{10,12}$", ErrorMessage = "O telefone deve conter entre 10 e 12 números.")]
		public string Telefone { get; set; }
		[Required(ErrorMessage = "O CEP é obrigatório.")]
		[RegularExpression(@"^\d{8}$", ErrorMessage = "O CEP deve conter exatamente 8 números.")]
		public string? Cep { get; set; }
		
		public string Estado { get; set; }
		
		public string Cidade { get; set; }

		public string? Bairro { get; set; }

		public string Endereco { get; set; }

		public string? Complemento { get; set; }
        public int IdPlano { get; set; }
	    public string? NomePlano { get; set; }
	    public bool Ativo { get; set; } = true;






}
public class AlunoAula
	{
		public int AlunoId { get; set; }
		public Aluno Aluno { get; set; }

		public int AulaId { get; set; }
		public Aula Aula { get; set; }
	}
	public class Relatorio
	{
		public string Titulo { get; set; }
		public string Coluna1 { get; set; }
		public string Coluna2 { get; set; }
		public string Coluna3 { get; set; }
		public List<RelatorioItem> Dados { get; set; }
	}

	public class RelatorioItem
	{
		public string Coluna1 { get; set; }
		public string Coluna2 { get; set; }
		public string Coluna3 { get; set; }
	}
    public class Plano
{
    public int Id { get; set; }
    public string Nome { get; set; }
    public decimal Valor { get; set; }
}


