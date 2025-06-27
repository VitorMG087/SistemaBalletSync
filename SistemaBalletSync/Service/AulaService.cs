using Npgsql;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Threading.Tasks;
using QuestPDF.Fluent;
using QuestPDF.Infrastructure;
using SistemaBalletSync.Components.Pages.Cadastro;


public class AulaService
{
	private readonly string _connectionString;
	private readonly ProfessorService _professorService;

	public AulaService(string connectionString, ProfessorService professorService)
	{
		_connectionString = connectionString;
		_professorService = professorService;
	}

	public async Task<List<Aula>> GetAulasAsync()
	{
		var aulas = new List<Aula>();

		using (var connection = new NpgsqlConnection(_connectionString))
		{
			await connection.OpenAsync();

			using (var cmd = new NpgsqlCommand("SELECT a.id, a.local, a.datahora, a.idprofessor, p.nome FROM aulas a inner join professores p on p.id = a.idprofessor", connection))
			using (var reader = await cmd.ExecuteReaderAsync())
			{
				while (await reader.ReadAsync())
				{
					aulas.Add(new Aula
					{
						Id = reader.GetInt32(0),
						Local = reader.GetString(1),
						DataHora = reader.GetDateTime(2),
						IdProfessor = reader.GetInt32(3),
						NomeProfessor = reader.GetString(4)
					});
				}
			}
		}

		return aulas;
	}

	public async Task<Aula> GetAulaByIdAsync(int id)
	{
		using (var connection = new NpgsqlConnection(_connectionString))
		{
			await connection.OpenAsync();

			using (var cmd = new NpgsqlCommand("SELECT a.id, a.local, a.datahora, a.idprofessor, p.nome FROM aulas a inner join professores p on p.id = a.idprofessor WHERE a.id = @Id", connection))
			{
				cmd.Parameters.AddWithValue("Id", id);

				using (var reader = await cmd.ExecuteReaderAsync())
				{
					if (await reader.ReadAsync())
					{
						return new Aula
						{
							Id = reader.GetInt32(0),
							Local = reader.GetString(1),
							DataHora = reader.GetDateTime(2),
							IdProfessor = reader.GetInt32(3),
							NomeProfessor = reader.GetString(4)
						};
					}
				}
			}
		}

		return null;
	}

	public async Task<string> AddAulaAsync(Aula aula)
	{
		using (var connection = new NpgsqlConnection(_connectionString))
		{
			await connection.OpenAsync();

			var query = "INSERT INTO aulas (local, datahora, idprofessor) VALUES (@Local, @DataHora, @IdProfessor)";
			using (var cmd = new NpgsqlCommand(query, connection))
			{
				cmd.Parameters.AddWithValue("Local", aula.Local);
				cmd.Parameters.AddWithValue("DataHora", aula.DataHora);
				cmd.Parameters.AddWithValue("IdProfessor", aula.IdProfessor);

				await cmd.ExecuteNonQueryAsync();
			}
		}

		return null;
	}

	public async Task<string> UpdateAulaAsync(Aula aula, int id)
	{
		using (var connection = new NpgsqlConnection(_connectionString))
		{
			await connection.OpenAsync();

			var query = "UPDATE aulas SET local = @Local, datahora = @DataHora, idprofessor = @IdProfessor WHERE id = @Id";
			using (var cmd = new NpgsqlCommand(query, connection))
			{
				cmd.Parameters.AddWithValue("Local", aula.Local);
				cmd.Parameters.AddWithValue("DataHora", aula.DataHora);
				cmd.Parameters.AddWithValue("IdProfessor", aula.IdProfessor);
				cmd.Parameters.AddWithValue("Id", id);

				await cmd.ExecuteNonQueryAsync();
			}
		}

		return null;
	}

	public async Task DeleteAulaAsync(int id)
	{
		using (var connection = new NpgsqlConnection(_connectionString))
		{
			await connection.OpenAsync();

			var query = "DELETE FROM aulas WHERE id = @Id";
			using (var cmd = new NpgsqlCommand(query, connection))
			{
				cmd.Parameters.AddWithValue("Id", id);

				await cmd.ExecuteNonQueryAsync();
			}
		}
	}
    public async Task<List<Aula>> GetAulasPorMesEAnoAsync(int mes, int ano)
    {
        var aulas = new List<Aula>();

        using (var connection = new NpgsqlConnection(_connectionString))
        {
            await connection.OpenAsync();

            var query = @"
            SELECT a.id, a.local, a.datahora, a.idprofessor, p.nome 
            FROM aulas a 
            INNER JOIN professores p ON p.id = a.idprofessor
            WHERE EXTRACT(MONTH FROM a.datahora) = @Mes
              AND EXTRACT(YEAR FROM a.datahora) = @Ano
            ORDER BY a.datahora";

            using (var cmd = new NpgsqlCommand(query, connection))
            {
                cmd.Parameters.AddWithValue("Mes", mes);
                cmd.Parameters.AddWithValue("Ano", ano);

                using (var reader = await cmd.ExecuteReaderAsync())
                {
                    while (await reader.ReadAsync())
                    {
                        aulas.Add(new Aula
                        {
                            Id = reader.GetInt32(0),
                            Local = reader.GetString(1),
                            DataHora = reader.GetDateTime(2),
                            IdProfessor = reader.GetInt32(3),
                            NomeProfessor = reader.GetString(4)
                        });
                    }
                }
            }
        }

        return aulas;
    }


    public async Task<List<Aluno>> GetAlunosByAulaIdAsync(int idAula)
	{
		var alunos = new List<Aluno>();

		using (var connection = new NpgsqlConnection(_connectionString))
		{
			await connection.OpenAsync();

			var query = @"
            SELECT a.id, a.nome, a.cpf
            FROM alunos a
            INNER JOIN alunos_aulas aa ON aa.aluno_id = a.id
            WHERE aa.aula_id = @IdAula";

			using (var cmd = new NpgsqlCommand(query, connection))
			{
				cmd.Parameters.AddWithValue("IdAula", idAula);

				using (var reader = await cmd.ExecuteReaderAsync())
				{
					while (await reader.ReadAsync())
					{
						alunos.Add(new Aluno
						{
							Id = reader.GetInt32(0),
							Nome = reader.GetString(1),
							CPF = reader.GetString(2)
						});
					}
				}
			}
		}

		return alunos;
	}
	public async Task<List<Aluno>> GetAlunosDisponiveisAsync(int idAula)
{
    var alunos = new List<Aluno>();

    using (var connection = new NpgsqlConnection(_connectionString))
    {
        await connection.OpenAsync();
        var query = @"
            SELECT a.id, a.nome, a.cpf 
            FROM alunos a
            WHERE a.id NOT IN (
                SELECT aluno_id 
                FROM alunos_aulas 
                WHERE aula_id = @IdAula
            )";

        using (var cmd = new NpgsqlCommand(query, connection))
        {
            cmd.Parameters.AddWithValue("IdAula", idAula);

            using (var reader = await cmd.ExecuteReaderAsync())
            {
                while (await reader.ReadAsync())
                {
                    alunos.Add(new Aluno
                    {
                        Id = reader.GetInt32(0),
                        Nome = reader.GetString(1),
                        CPF = reader.GetString(2)
                    });
                }
                }
            }
        }
        return alunos;
}
    public async Task AdicionarAlunoAulaAsync(int idAula, int idAluno)
    {
        using (var connection = new NpgsqlConnection(_connectionString))
        {
            await connection.OpenAsync();

            var query = "INSERT INTO alunos_aulas (aula_id, aluno_id) VALUES (@AulaId, @AlunoId)";
            using (var cmd = new NpgsqlCommand(query, connection))
            {
                cmd.Parameters.AddWithValue("AulaId", idAula);
                cmd.Parameters.AddWithValue("AlunoId", idAluno);

                await cmd.ExecuteNonQueryAsync();
            }
        }
    }

    
    public async Task RemoverAlunoAulaAsync(int idAula, int idAluno)
    {
        using (var connection = new NpgsqlConnection(_connectionString))
        {
            await connection.OpenAsync();

            var query = "DELETE FROM alunos_aulas WHERE aula_id = @AulaId AND aluno_id = @AlunoId";
            using (var cmd = new NpgsqlCommand(query, connection))
            {
                cmd.Parameters.AddWithValue("AulaId", idAula);
                cmd.Parameters.AddWithValue("AlunoId", idAluno);

                await cmd.ExecuteNonQueryAsync();
            }
        }
    }
    public async Task<RelatorioAula> ObterRelatorioAulasPorMes(int mes, int ano)
    {
        var aulas = await GetAulasPorMesEAnoAsync(mes, ano);

        var itens = aulas.Select(a => new ItemRelatorioAula
        {
            Data = a.DataHora?.ToString("dd/MM/yyyy") ?? "",
            Professor = a.NomeProfessor ?? "",
            Tema = a.Local ?? "" // ou outro campo que represente o tema da aula
        }).ToList();

        return new RelatorioAula
        {
            TituloColunaData = "Data",
            TituloColunaProfessor = "Professor",
            TituloColunaTema = "Local da Aula",
            Itens = itens
        };
    }
}

public class Aula
{
	public int Id { get; set; }
	public string Local { get; set; }
	[Column("data_hora")]
	public DateTime? DataHora { get; set; }
	public int IdProfessor { get; set; }
	public string? NomeProfessor { get; set; }
    public int? StatusAula { get; set; }  // Se quiser nullable
}
public class RelatorioAula
{
    public string TituloColunaData { get; set; }
    public string TituloColunaProfessor { get; set; }
    public string TituloColunaTema { get; set; }
    public List<ItemRelatorioAula> Itens { get; set; }
}

public class ItemRelatorioAula
{
    public string Data { get; set; }
    public string Professor { get; set; }
    public string Tema { get; set; }
}
