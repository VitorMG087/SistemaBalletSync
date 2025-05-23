﻿using Npgsql;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using static SistemaBalletSync.Components.Pages.Cadastro.Relatorios;




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

			using (var cmd = new NpgsqlCommand("SELECT id, nome, cpf, telefone, cep, estado, cidade, bairro, endereco, complemento FROM Alunos", connection))
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

					});
				}
			}
		}

		return alunos;
	}
	public async Task<Aluno> GetAlunoByIdAsync(string id)
	{
		var alunos = new Aluno();

		using (var connection = new NpgsqlConnection(_connectionString))
		{
			await connection.OpenAsync();

			using (var cmd = new NpgsqlCommand("SELECT id, nome, cpf, telefone, cep, estado, cidade, bairro, endereco, complemento FROM Alunos WHERE id = @id", connection))
			{
				cmd.Parameters.AddWithValue("id", Convert.ToInt32(id));

				using (var reader = await cmd.ExecuteReaderAsync())
				{
					if (await reader.ReadAsync())
					{
						alunos = new Aluno
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

		return alunos;
	}


	public async Task AddAlunoAsync(Aluno aluno)
	{
		using (var connection = new NpgsqlConnection(_connectionString))
		{
			await connection.OpenAsync();

			var query = "INSERT INTO alunos (nome, cpf, telefone, cep, estado, cidade, bairro, endereco, complemento ) VALUES (@Nome, @CPF, @Telefone, @Cep, @Estado, @Cidade, @Bairro, @Endereco, @complemento)";
			using (var cmd = new NpgsqlCommand(query, connection))
			{
				cmd.Parameters.AddWithValue("Nome", aluno.Nome);
				cmd.Parameters.AddWithValue("CPF", aluno.CPF);
				cmd.Parameters.AddWithValue("Telefone", aluno.Telefone);
				cmd.Parameters.AddWithValue("Cep", (object?)aluno.Cep ?? DBNull.Value);
				cmd.Parameters.AddWithValue("Estado", aluno.Estado);
				cmd.Parameters.AddWithValue("Cidade", aluno.Cidade);
				cmd.Parameters.AddWithValue("Bairro", (object?)aluno.Bairro ?? DBNull.Value);
				cmd.Parameters.AddWithValue("Endereco", aluno.Endereco);
				cmd.Parameters.AddWithValue("Complemento", (object?)aluno.Complemento ?? DBNull.Value);

				await cmd.ExecuteNonQueryAsync();
			}
		}
	}

	public async Task UpdateAlunoAsync(Aluno aluno, string id)
	{
		using (var connection = new NpgsqlConnection(_connectionString))
		{
			await connection.OpenAsync();

			var query = $"UPDATE Alunos set nome = @Nome, cpf = @CPF, telefone = @Telefone, cep = @Cep, estado = @Estado, cidade = @Cidade, bairro = @Bairro, endereco = @Endereco, complemento = @Complemento  where id = {id}";
			using (var cmd = new NpgsqlCommand(query, connection))
			{
				cmd.Parameters.AddWithValue("Nome", aluno.Nome);
				cmd.Parameters.AddWithValue("CPF", aluno.CPF);
				cmd.Parameters.AddWithValue("Telefone", aluno.Telefone);
				cmd.Parameters.AddWithValue("Cep", (object?)aluno.Cep ?? DBNull.Value);
				cmd.Parameters.AddWithValue("Estado", aluno.Estado);
				cmd.Parameters.AddWithValue("Cidade", aluno.Cidade);
				cmd.Parameters.AddWithValue("Bairro", (object?)aluno.Bairro ?? DBNull.Value);
				cmd.Parameters.AddWithValue("Endereco", aluno.Endereco);
				cmd.Parameters.AddWithValue("Complemento", (object?)aluno.Complemento ?? DBNull.Value);

				await cmd.ExecuteNonQueryAsync();
			}
		}
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
    public async Task<Relatorio> ObterRelatorioFrequenciaPorMes(int mes, int ano)
    {

        var dados = new List<RelatorioItem>();

        using (var connection = new NpgsqlConnection(_connectionString))
        {
            await connection.OpenAsync();

            
            string query = @"
        SELECT 
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
		[Required(ErrorMessage = "O estado é obrigatório.")]
		[RegularExpression(@"^[A-Za-z\s]+$", ErrorMessage = "O estado deve conter apenas letras.")]
		public string Estado { get; set; }
		[Required(ErrorMessage = "A cidade é obrigatório.")]
		[RegularExpression(@"^[A-Za-z\s]+$", ErrorMessage = "deve conter uma cidade ")]
		public string Cidade { get; set; }

		public string? Bairro { get; set; }

		public string Endereco { get; set; }

		public string? Complemento { get; set; }
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

