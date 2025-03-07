using Microsoft.AspNetCore.Mvc;
using System.IO;
using System.Threading.Tasks;

[ApiController]
[Route("relatorio")]
public class RelatorioController : ControllerBase
{
    private readonly AlunoService _alunoService;

    public RelatorioController(AlunoService alunoService)
    {
        _alunoService = alunoService;
    }

    [HttpGet("gerar-pdf")]
    public async Task<IActionResult> GerarRelatorioPdf([FromQuery] int mes, [FromQuery] int ano)
    {
        var relatorio = await _alunoService.ObterRelatorioFrequenciaPorMes(mes, ano);
        if (relatorio == null) return NotFound("Relatório não encontrado.");

        var htmlContent = $@"
            <html>
            <head>
                <style>
                    table {{ border-collapse: collapse; width: 100%; }}
                    th, td {{ border: 1px solid #ddd; padding: 8px; }}
                    th {{ background-color: #f2f2f2; }}
                </style>
            </head>
            <body>
                <h1>{relatorio.Titulo}</h1>
                <table>
                    <thead>
                        <tr>
                            <th>{relatorio.Coluna1}</th>
                            <th>{relatorio.Coluna2}</th>
                            <th>{relatorio.Coluna3}</th>
                        </tr>
                    </thead>
                    <tbody>
                        {string.Join("", relatorio.Dados.Select(d => $"<tr><td>{d.Coluna1}</td><td>{d.Coluna2}</td><td>{d.Coluna3}</td></tr>"))}
                    </tbody>
                </table>
            </body>
            </html>";

        var renderer = new IronPdf.HtmlToPdf();
        var pdfDocument = renderer.RenderHtmlAsPdf(htmlContent);

       
        return File(pdfDocument.BinaryData, "application/pdf", $"Relatorio_Frequencia_{mes}_{ano}.pdf");
    }
}
