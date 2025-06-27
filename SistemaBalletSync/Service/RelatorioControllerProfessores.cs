using DinkToPdf.Contracts;
using DinkToPdf;
using Microsoft.AspNetCore.Mvc;
using System;
using System.IO;
using System.Text;
using System.Threading.Tasks;
using System.Collections.Generic;

namespace SistemaBalletSync.Controllers
{
    [ApiController]
    [Route("relatorio/professor")]
    public class RelatorioProfessorController : ControllerBase
    {
        private readonly IConverter _converter;
        private readonly ProfessorService _professorService;

        public RelatorioProfessorController(IConverter converter, ProfessorService professorService)
        {
            _converter = converter;
            _professorService = professorService;
        }

        [HttpGet("gerar-pdf-professores")]
        public async Task<IActionResult> GerarPdfProfessores(int mes, int ano)
        {
            var itens = await _professorService.ObterProfessoresPorMesEAnoAsync(mes, ano);

            var tituloColunaNome = "Nome";

            var linhasTabela = new StringBuilder();
            foreach (var item in itens)
            {
                linhasTabela.Append($"<tr><td>{item.Nome}</td></tr>");
            }

            string logoBase64 = "file:///" + Path.GetFullPath("wwwroot/img/icone.jpg").Replace("\\", "/");

            string htmlContent = $@"
<!DOCTYPE html>
<html lang='pt-BR'>
<head>
    <meta charset='UTF-8' />
    <title>Relatório de Professores</title>
    <style>
        :root {{
            --primary-color: #d88da7;
            --secondary-color: #fdf5fa;
            --text-color: #4a3f4a;
            --border-color: #a59ff9;
        }}
        body {{
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: var(--secondary-color);
            color: var(--text-color);
            padding: 20px 40px;
        }}
        header img.logo {{
            height: 50px;
        }}
        .titulo-relatorio {{
            font-size: 1.6rem;
            text-align: center;
            margin-top: 10px;
            color: var(--primary-color);
            border-bottom: 2px solid var(--border-color);
            padding-bottom: 5px;
            margin-bottom: 25px;
        }}
        .filtros {{
            background: #fff0f6;
            padding: 10px 15px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            margin-bottom: 20px;
        }}
        table {{
            width: 100%;
            border-collapse: collapse;
            background: white;
            color: #000;
            box-shadow: 0 0 8px rgba(216, 141, 167, 0.15);
            border-radius: 8px;
            overflow: hidden;
        }}
        th, td {{
            padding: 12px 18px;
            text-align: left;
        }}
        tr, th {{
                color: #000;
        }}
        thead {{
            background-color: var(--primary-color);
            color: white;
        }}
        tbody tr:nth-child(odd) {{
            background-color: #fdf4f8;
        }}
        footer {{
            text-align: center;
            font-style: italic;
            margin-top: 40px;
            border-top: 1px solid var(--border-color);
            padding-top: 15px;
            color: #7a6a7a;
        }}
    </style>
</head>
<body>
    <header>
        <img src='{logoBase64}' class='logo' />
    </header>
    <h1 class='titulo-relatorio'>Relatório de Professores - {mes:00}/{ano}</h1>
    <div class='filtros'>
        <p><strong>Filtros:</strong></p>
      <p>Data Inicial: 01/{mes:00}/{ano}</p>
      <p>Data Final: {DateTime.DaysInMonth(ano, mes):00}/{mes:00}/{ano}</p>
    </div>
    <table>
        <thead>
            <tr>
                <th>{tituloColunaNome}</th>
            </tr>
        </thead>
        <tbody>
            {linhasTabela}
        </tbody>
    </table>
    <footer>© 2025 Escola de Ballet - Todos os Direitos Reservados.</footer>
</body>
</html>";

            var doc = new HtmlToPdfDocument
            {
                GlobalSettings = new GlobalSettings
                {
                    PaperSize = PaperKind.A4,
                    Orientation = Orientation.Portrait
                },
                Objects = {
            new ObjectSettings
            {
                HtmlContent = htmlContent,
                WebSettings = { DefaultEncoding = "utf-8" }
            }
        }
            };

            var pdf = _converter.Convert(doc);
            return File(pdf, "application/pdf", $"Relatorio_Professores_{mes}_{ano}.pdf");
        }

    }
}

