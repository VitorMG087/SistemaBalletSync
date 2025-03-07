using Npgsql;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using static SistemaBalletSync.Components.Pages.Cadastro.CadastroAulas;

public class ProfessorService
{
    private readonly string _connectionString;

    public ProfessorService(string connectionString)
    {
        _connectionString = connectionString;
    }

    public async Task<List<Professor>> GetProfessoresAsync()
    {
        var professores = new List<Professor>();

        using (var connection = new NpgsqlConnection(_connectionString))
        {
            await connection.OpenAsync();

            using (var cmd = new NpgsqlCommand("SELECT id, nome, cpf, telefone, cep, estado, cidade, bairro, endereco, complemento FROM Professores", connection))
            using (var reader = await cmd.ExecuteReaderAsync())
            {
                while (await reader.ReadAsync())
                {
                    professores.Add(new Professor
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

        return professores;
    }

    public async Task<Professor> GetProfessorByIdAsync(string id)
    {
        var professores = new Professor();

        using (var connection = new NpgsqlConnection(_connectionString))
        {
            await connection.OpenAsync();

            using (var cmd = new NpgsqlCommand($"SELECT id, nome, cpf, telefone, cep, estado, cidade, bairro, endereco, complemento FROM Professores WHERE id = @id", connection))
            using (var reader = await cmd.ExecuteReaderAsync())
            {
                while (await reader.ReadAsync())
                {
                    professores = new Professor
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

        return professores;
    }

    public async Task<List<Professor>> GeOptionsProfessorByIdAsync()
    {
        var professores = new List<Professor>();

        using (var connection = new NpgsqlConnection(_connectionString))
        {
            await connection.OpenAsync();

            using (var cmd = new NpgsqlCommand("SELECT id, nome FROM Professores", connection))
            using (var reader = await cmd.ExecuteReaderAsync())
            {
                while (await reader.ReadAsync())
                {
                    professores.Add(new Professor
					{
                        Id = reader.GetInt32(0),
                        Nome = reader.GetString(1),
                    });
                }
            }
        }

        return professores;
    }

    public async Task AddProfessorAsync(Professor professor)
    {
        using (var connection = new NpgsqlConnection(_connectionString))
        {
            await connection.OpenAsync();

            var query = "INSERT INTO professores (nome, cpf, telefone, cep, estado, cidade, bairro, endereco, complemento ) VALUES (@Nome, @CPF, @Telefone, @Cep, @Estado, @Cidade, @Bairro, @Endereco, @complemento)";
            using (var cmd = new NpgsqlCommand(query, connection))
            {
                cmd.Parameters.AddWithValue("Nome", professor.Nome);
                cmd.Parameters.AddWithValue("CPF", professor.CPF);
                cmd.Parameters.AddWithValue("Telefone", professor.Telefone);
                cmd.Parameters.AddWithValue("Cep", (object?)professor.Cep ?? DBNull.Value);
                cmd.Parameters.AddWithValue("Estado", professor.Estado);
                cmd.Parameters.AddWithValue("Cidade", professor.Cidade);
                cmd.Parameters.AddWithValue("Bairro", (object?)professor.Bairro ?? DBNull.Value);
                cmd.Parameters.AddWithValue("Endereco", professor.Endereco);
                cmd.Parameters.AddWithValue("Complemento", (object?)professor.Complemento ?? DBNull.Value);

                await cmd.ExecuteNonQueryAsync();
            }
        }
    }

    public async Task UpdateProfessorAsync(Professor professor, string id)
    {
        using (var connection = new NpgsqlConnection(_connectionString))
        {
            await connection.OpenAsync();

            var query = $"UPDATE Professores set nome = @Nome, cpf = @CPF, telefone = @Telefone, cep = @Cep, estado = @Estado, cidade = @Cidade, bairro = @Bairro, endereco = @Endereco, complemento = @Complemento  where id = {id}";
            using (var cmd = new NpgsqlCommand(query, connection))
            {
                cmd.Parameters.AddWithValue("Nome", professor.Nome);
                cmd.Parameters.AddWithValue("CPF", professor.CPF);
                cmd.Parameters.AddWithValue("Telefone", professor.Telefone);
                cmd.Parameters.AddWithValue("Cep", (object?)professor.Cep ?? DBNull.Value);
                cmd.Parameters.AddWithValue("Estado", professor.Estado);
                cmd.Parameters.AddWithValue("Cidade", professor.Cidade);
                cmd.Parameters.AddWithValue("Bairro", (object?)professor.Bairro ?? DBNull.Value);
                cmd.Parameters.AddWithValue("Endereco", professor.Endereco);
                cmd.Parameters.AddWithValue("Complemento", (object?)professor.Complemento ?? DBNull.Value);

                await cmd.ExecuteNonQueryAsync();
            }
        }
    }

    public async Task DeleteProfessorAsync(int id)
    {
        using (var connection = new NpgsqlConnection(_connectionString))
        {
            await connection.OpenAsync();

            var query = "DELETE FROM Professores WHERE id = @Id";
            using (var cmd = new NpgsqlCommand(query, connection))
            {
                cmd.Parameters.AddWithValue("Id", id);

                await cmd.ExecuteNonQueryAsync();
            }
        }
    }
}

public class Professor
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

public class ProfessorOptions
{
    public int Id { get; set; }
    public string Nome { get; set; }
}
