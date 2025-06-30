using DinkToPdf;
using DinkToPdf.Contracts;
using Microsoft.AspNetCore.Mvc;
using SistemaBalletSync.Components.Pages.Cadastro; 
using System;
using System.IO;
using System.Text;
using System.Threading.Tasks;

namespace SistemaBalletSync.Controllers
{
    [ApiController]
    [Route("relatorio/aula")]
    public class RelatorioAulaController : ControllerBase
    {
        private readonly IConverter _converter;
        private readonly AulaService _aulaService;

        public RelatorioAulaController(IConverter converter, AulaService aulaService)
        {
            _converter = converter;
            _aulaService = aulaService;
        }

        [HttpGet("gerar-pdf-aulas")]
        public async Task<IActionResult> GerarPdfAulas(int mes, int ano)
        {
            var tituloColunaNome = "Nome";
            var relatorio = await _aulaService.ObterRelatorioAulasPorMes(mes, ano);

            
            var sbLinhas = new StringBuilder();
            foreach (var item in relatorio.Itens)
            {
                sbLinhas.AppendLine("<tr>");
                sbLinhas.AppendLine($"<td>{item.Data}</td>");
                sbLinhas.AppendLine($"<td>{item.Professor}</td>");
                sbLinhas.AppendLine($"<td>{item.Tema}</td>");
                sbLinhas.AppendLine("</tr>");
            }

            
            string logoPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "img", "icone.jpg");
            string logoBase64 = "";
            if (System.IO.File.Exists(logoPath))
            {
                byte[] logoBytes = await System.IO.File.ReadAllBytesAsync(logoPath);
                logoBase64 = $"data:image/jpeg;base64,{Convert.ToBase64String(logoBytes)}";
            }

            string htmlContent = $@"
<!DOCTYPE html>
<html lang='pt-BR'>
<head>
  <meta charset='UTF-8' />
  <title>Relatório de Aulas</title>
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

    <h1 class='titulo-relatorio'>Relatório de Aulas - {mes:00}/{ano}</h1>

    <div class='filtros'>
      <p><strong>Filtros:</strong></p>
      <p>Data Inicial: 01/{mes:00}/{ano}</p>
      <p>Data Final: {DateTime.DaysInMonth(ano, mes):00}/{mes:00}/{ano}</p>
    </div>

    <table>
      <thead>
        <tr>
          <th>{relatorio.TituloColunaData}</th>
          <th>{relatorio.TituloColunaProfessor}</th>
          <th>{relatorio.TituloColunaTema}</th>
        </tr>
      </thead>
 <thead>
            <tr>
                <th>{tituloColunaNome}</th>
            </tr>
        </thead>
      <tbody>
        {sbLinhas}
      </tbody>
    </table>

    <footer>
      © 2025 Escola de Ballet - Todos os Direitos Reservados.
    </footer>
  </div>
</body>
</html>";

            var doc = new HtmlToPdfDocument()
            {
                GlobalSettings = new GlobalSettings
                {
                    PaperSize = PaperKind.A4,
                    Orientation = Orientation.Portrait,
                    Margins = new MarginSettings { Top = 10, Bottom = 10, Left = 10, Right = 10 }
                },
                Objects =
                {
                    new ObjectSettings
                    {
                        HtmlContent = htmlContent,
                        WebSettings = { DefaultEncoding = "utf-8" }
                    }
                }
            };

            var pdf = _converter.Convert(doc);

            return File(pdf, "application/pdf", $"Relatorio_Aulas_{mes}_{ano}.pdf");
        }
    }
}
