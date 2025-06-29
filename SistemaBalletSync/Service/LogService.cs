using Dapper;
using Npgsql;
using Microsoft.Extensions.Configuration;
using System;
using System.Threading.Tasks;

namespace SistemaBalletSync.Services
{
    public class LogService
    {
        private readonly string _connectionString;

        public LogService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        public async Task RegistrarLogAsync(string usuario, string acao, string detalhe)
        {
            using var connection = new NpgsqlConnection(_connectionString);
            string sql = @"
                INSERT INTO logs (usuario, acao, detalhe)
                VALUES (@usuario, @acao, @detalhe)";

            await connection.ExecuteAsync(sql, new
            {
                usuario = string.IsNullOrEmpty(usuario) ? "Desconhecido" : usuario,
                acao,
                detalhe
            });
        }

    }

    namespace SistemaBalletSync.Models
    {
        public class Log
        {
            public int Id { get; set; }
            public string Usuario { get; set; }
            public string Acao { get; set; }
            public DateTime DataHora { get; set; }
            public string Detalhe { get; set; }
        }
    }
}
