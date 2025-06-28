using DinkToPdf;
using DinkToPdf.Contracts;
using Microsoft.AspNetCore.Mvc;
using System;
using System.IO;
using System.Threading.Tasks;

namespace SistemaBalletSync.Controllers
{
    [Route("relatorio/frequencia")]
    [ApiController]
    public class RelatorioFrequenciaController : ControllerBase
    {
        private readonly IConverter _converter;
        private readonly AlunoService _alunoService;

        public RelatorioFrequenciaController(IConverter converter, AlunoService alunoService)
        {
            _converter = converter;
            _alunoService = alunoService;
        }

        [HttpGet("gerar-pdf")]
        public async Task<IActionResult> GerarPdfFrequencia(int mes, int ano)
        {
            var tituloColunaNome = "Nome";
            var relatorio = await _alunoService.ObterRelatorioFrequenciaPorMes(mes, ano);

            var tituloColuna1 = string.IsNullOrWhiteSpace(relatorio.Coluna1) ? "Aluno" : relatorio.Coluna1;
            var tituloColuna2 = string.IsNullOrWhiteSpace(relatorio.Coluna2) ? "Presenças" : relatorio.Coluna2;
            var tituloColuna3 = string.IsNullOrWhiteSpace(relatorio.Coluna3) ? "Total de Aulas" : relatorio.Coluna3;

            string linhasTabela = "";
            foreach (var item in relatorio.Dados)
            {
                linhasTabela += $"<tr>" +
                                $"<td>{item.Coluna1}</td>" +
                                $"<td>{item.Coluna2}</td>" +
                                $"<td>{item.Coluna3}</td>" +
                                $"</tr>";
            }

            string logoBase64 = "file:///" + Path.GetFullPath("wwwroot/img/icone.jpg").Replace("\\", "/");

            string htmlContent = @$"<!DOCTYPE html>
<html lang='pt-BR'>
<head>
  <meta charset='UTF-8' />
  <title>Relatório de Frequência - Escola de Ballet</title>
  <style>
    :root {{
      --primary-color: #d88da7;
      --secondary-color: #fdf5fa;
      --text-color: #4a3f4a;
      --border-color: #a59ff9;
    }}
    body {{
      margin: 0;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      color: var(--text-color);
    }}
    #container {{
      background-color: var(--secondary-color);
      padding: 20px 40px;
      min-height: 100vh;
    }}
    header {{
      text-align: left;
      margin-bottom: 10px;
    }}
    header img.logo {{
      height: 50px;
    }}
    .titulo-relatorio {{
      font-size: 1.6rem;
      color: var(--primary-color);
      font-weight: bold;
      text-align: center;
      margin-bottom: 25px;
      margin-top: 10px;
      border-bottom: 2px solid var(--border-color);
      padding-bottom: 5px;
    }}
    .filtros {{
      margin-bottom: 20px;
      font-size: 0.95rem;
      background: #fff0f6;
      border: 1px solid var(--border-color);
      padding: 10px 15px;
      border-radius: 8px;
      color: var(--text-color);
    }}
    .filtros p {{
      margin: 2px 0;
    }}
    table {{
      width: 100%;
      border-collapse: collapse;
      box-shadow: 0 0 8px rgba(216, 141, 167, 0.15);
      background: white;
      border-radius: 8px;
      overflow: hidden;
    }}
    th, td {{
      padding: 12px 18px;
      text-align: left;
    }}
    thead {{
      background-color: var(--primary-color);
      color: white;
      font-weight: 600;
    }}
    tbody tr:nth-child(odd) {{
      background-color: #fdf4f8;
    }}
    tbody tr:hover {{
      background-color: #f9d3e0;
    }}
    footer {{
      margin-top: 40px;
      font-size: 0.9rem;
      color: #7a6a7a;
      text-align: center;
      border-top: 1px solid var(--border-color);
      padding-top: 15px;
      font-style: italic;
    }}
  </style>
</head>
<body>
  <div id='container'>
    <header>
      <img src='{logoBase64}' class='logo' />
    </header>

    <h1 class='titulo-relatorio'>Relatório de Frequência - {mes:00}/{ano}</h1>

    <div class='filtros'>
      <p><strong>Filtros:</strong></p>
      <p>Data Inicial: 01/{mes:00}/{ano}</p>
      <p>Data Final: {DateTime.DaysInMonth(ano, mes):00}/{mes:00}/{ano}</p>
    </div>

    <table>
      <thead>
        <tr>
          <th>{tituloColuna1}</th>
          <th>{tituloColuna2}</th>
          <th>{tituloColuna3}</th>
        </tr>
      </thead>
 <thead>
            <tr>
                <th>{tituloColunaNome}</th>
            </tr>
        </thead>
      <tbody>
        {linhasTabela}
      </tbody>
    </table>

    <footer>
      © 2025 Escola de Ballet - Todos os Direitos Reservados.
    </footer>
  </div>
</body>
</html>";

            var doc = new HtmlToPdfDocument
            {
                GlobalSettings = new GlobalSettings
                {
                    PaperSize = PaperKind.A4,
                    Orientation = Orientation.Portrait,
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
            return File(pdf, "application/pdf", $"Relatorio_Frequencia_{mes}_{ano}.pdf");
        }
    }
}
