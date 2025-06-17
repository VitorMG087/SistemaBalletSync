using IronPdf;
using System.Threading.Tasks;

namespace SistemaBalletSync.Services
{
    public class PdfService
    {
        private readonly HtmlToPdf _renderer;

        public PdfService()
        {
            _renderer = new HtmlToPdf();
            // Configurações opcionais, ex:
            // _renderer.PrintOptions.PaperSize = PdfPrintOptions.PdfPaperSize.A4;
            // _renderer.PrintOptions.MarginTop = 20;
            // _renderer.PrintOptions.MarginBottom = 20;
            // _renderer.PrintOptions.MarginLeft = 20;
            // _renderer.PrintOptions.MarginRight = 20;
            // _renderer.PrintOptions.Dpi = 300;
        }

        // Método síncrono que gera PDF e retorna bytes
        public byte[] GerarPdfDeHtml(string html)
        {
            var pdf = _renderer.RenderHtmlAsPdf(html);
            return pdf.BinaryData;
        }

        // Método async que roda a geração em thread separada
        public Task<byte[]> GerarPdfDeHtmlAsync(string html)
        {
            return Task.Run(() =>
            {
                var pdf = _renderer.RenderHtmlAsPdf(html);
                return pdf.BinaryData;
            });
        }
public async Task<byte[]> GerarRelatorioMensalidadesAsync(List<Mensalidade> mensalidades, int mes, int ano)
        {
            var totalGeral = mensalidades.Sum(m => m.Valor);
            var totalPago = mensalidades.Where(m => m.EstaPago).Sum(m => m.Valor);
            var totalEmAberto = mensalidades.Where(m => !m.EstaPago).Sum(m => m.Valor);

            var htmlContent = $@"
<!DOCTYPE html>
<html>
<head>
    <meta charset='utf-8'>
    <title>Relatório de Mensalidades</title>
    <style>
        body {{
            font-family: Arial, sans-serif;
            margin: 20px;
            font-size: 12px;
            color: #333;
        }}
        .header {{
            text-align: center;
            margin-bottom: 30px;
            border-bottom: 3px solid #d63384;
            padding-bottom: 15px;
        }}
        .header h1 {{
            color: #d63384;
            margin: 0;
            font-size: 28px;
            font-weight: bold;
        }}
        .header h2 {{
            color: #6c757d;
            margin: 10px 0 5px 0;
            font-size: 20px;
        }}
        .header p {{
            margin: 5px 0;
            color: #6c757d;
            font-size: 14px;
        }}
        .resumo {{
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
            border-left: 5px solid #d63384;
        }}
        .resumo-grid {{
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 20px;
            margin-top: 15px;
        }}
        .resumo-item {{
            text-align: center;
            padding: 15px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }}
        .resumo-item h3 {{
            margin: 0 0 10px 0;
            font-size: 14px;
            color: #6c757d;
            text-transform: uppercase;
        }}
        .resumo-item .valor {{
            font-size: 18px;
            font-weight: bold;
            margin: 0;
        }}
        .valor-total {{ color: #0d6efd; }}
        .valor-pago {{ color: #198754; }}
        .valor-aberto {{ color: #dc3545; }}
        table {{
            width: 100%;
            border-collapse: collapse;
            margin-top: 25px;
            background: white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border-radius: 8px;
            overflow: hidden;
        }}
        th {{
            background: linear-gradient(135deg, #d63384 0%, #c02366 100%);
            color: white;
            padding: 15px 10px;
            text-align: center;
            font-weight: bold;
            font-size: 13px;
            text-transform: uppercase;
        }}
        td {{
            padding: 12px 10px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
        }}
        tr:nth-child(even) {{
            background-color: #f8f9fa;
        }}
        tr:hover {{
            background-color: #e3f2fd;
        }}
        .valor {{
            text-align: right;
            font-weight: bold;
        }}
        .status-pago {{
            color: #198754;
            font-weight: bold;
            text-align: center;
        }}
        .status-aberto {{
            color: #dc3545;
            font-weight: bold;
            text-align: center;
        }}
        .footer {{
            margin-top: 40px;
            text-align: center;
            font-size: 11px;
            color: #6c757d;
            border-top: 1px solid #e9ecef;
            padding-top: 20px;
        }}
        .data-vencimento {{
            text-align: center;
        }}
        .vencido {{
            color: #dc3545;
            font-weight: bold;
        }}
    </style>
</head>
<body>
    <div class='header'>
        <h1>Sistema Ballet Sync</h1>
        <h2>Relatório de Mensalidades</h2>
        <p>Período: {mes:D2}/{ano}</p>
        <p>Gerado em: {DateTime.Now:dd/MM/yyyy HH:mm}</p>
    </div>

    <div class='resumo'>
        <h3 style='margin-top: 0; color: #d63384; font-size: 16px;'>Resumo Financeiro</h3>
        <div class='resumo-grid'>
            <div class='resumo-item'>
                <h3>Total Geral</h3>
                <p class='valor valor-total'>R$ {totalGeral:N2}</p>
            </div>
            <div class='resumo-item'>
                <h3>Total Pago</h3>
                <p class='valor valor-pago'>R$ {totalPago:N2}</p>
            </div>
            <div class='resumo-item'>
                <h3>Em Aberto</h3>
                <p class='valor valor-aberto'>R$ {totalEmAberto:N2}</p>
            </div>
        </div>
    </div>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Aluno</th>
                <th>Valor</th>
                <th>Vencimento</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>";

            foreach (var mensalidade in mensalidades.OrderBy(m => m.DataVencimento))
            {
                var status = mensalidade.EstaPago ? "PAGO" : "EM ABERTO";
                var statusClass = mensalidade.EstaPago ? "status-pago" : "status-aberto";
                var vencidoClass = !mensalidade.EstaPago && mensalidade.DataVencimento < DateTime.Now ? "vencido" : "";

                htmlContent += $@"
            <tr>
                <td>{mensalidade.Id}</td>
                <td>{mensalidade.NomeAluno}</td>
                <td class='valor'>R$ {mensalidade.Valor:N2}</td>
                <td class='data-vencimento {vencidoClass}'>{mensalidade.DataVencimento:dd/MM/yyyy}</td>
                <td class='{statusClass}'>{status}</td>
            </tr>";
            }

            htmlContent += $@"
        </tbody>
    </table>

    <div class='footer'>
        <p>Relatório gerado automaticamente pelo Sistema Ballet Sync</p>
        <p>Total de registros: {mensalidades.Count}</p>
    </div>
</body>
</html>";

            return await GerarPdfDeHtmlAsync(htmlContent);
        }

        public async Task<byte[]> GerarRelatorioRecebimentosAsync(List<Recebimento> recebimentos, int mes, int ano)
        {
            var totalGeral = recebimentos.Sum(r => r.Valor);
            var recebimentosPorCategoria = recebimentos.GroupBy(r => r.Categoria ?? "Sem Categoria")
                                                     .Select(g => new { Categoria = g.Key, Total = g.Sum(r => r.Valor) })
                                                     .OrderByDescending(x => x.Total);

            var htmlContent = $@"
<!DOCTYPE html>
<html>
<head>
    <meta charset='utf-8'>
    <title>Relatório de Recebimentos</title>
    <style>
        body {{
            font-family: Arial, sans-serif;
            margin: 20px;
            font-size: 12px;
            color: #333;
        }}
        .header {{
            text-align: center;
            margin-bottom: 30px;
            border-bottom: 3px solid #198754;
            padding-bottom: 15px;
        }}
        .header h1 {{
            color: #198754;
            margin: 0;
            font-size: 28px;
            font-weight: bold;
        }}
        .header h2 {{
            color: #6c757d;
            margin: 10px 0 5px 0;
            font-size: 20px;
        }}
        .header p {{
            margin: 5px 0;
            color: #6c757d;
            font-size: 14px;
        }}
        .resumo {{
            background: linear-gradient(135deg, #d1e7dd 0%, #a3cfbb 100%);
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
            border-left: 5px solid #198754;
        }}
        .resumo-item {{
            display: flex;
            justify-content: space-between;
            margin: 10px 0;
            padding: 10px;
            background: white;
            border-radius: 5px;
        }}
        .resumo-item:last-child {{
            font-weight: bold;
            font-size: 16px;
            background: #198754;
            color: white;
        }}
        table {{
            width: 100%;
            border-collapse: collapse;
            margin-top: 25px;
            background: white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border-radius: 8px;
            overflow: hidden;
        }}
        th {{
            background: linear-gradient(135deg, #198754 0%, #146c43 100%);
            color: white;
            padding: 15px 10px;
            text-align: center;
            font-weight: bold;
            font-size: 13px;
            text-transform: uppercase;
        }}
        td {{
            padding: 12px 10px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
        }}
        tr:nth-child(even) {{
            background-color: #f8f9fa;
        }}
        tr:hover {{
            background-color: #d1e7dd;
        }}
        .valor {{
            text-align: right;
            font-weight: bold;
            color: #198754;
        }}
        .data {{
            text-align: center;
        }}
        .footer {{
            margin-top: 40px;
            text-align: center;
            font-size: 11px;
            color: #6c757d;
            border-top: 1px solid #e9ecef;
            padding-top: 20px;
        }}
    </style>
</head>
<body>
    <div class='header'>
        <h1>Sistema Ballet Sync</h1>
        <h2>Relatório de Recebimentos</h2>
        <p>Período: {mes:D2}/{ano}</p>
        <p>Gerado em: {DateTime.Now:dd/MM/yyyy HH:mm}</p>
    </div>

    <div class='resumo'>
        <h3 style='margin-top: 0; color: #198754; font-size: 16px;'>Resumo por Categoria</h3>";

            foreach (var categoria in recebimentosPorCategoria)
            {
                htmlContent += $@"
        <div class='resumo-item'>
            <span>{categoria.Categoria}</span>
            <span>R$ {categoria.Total:N2}</span>
        </div>";
            }

            htmlContent += $@"
        <div class='resumo-item'>
            <span>TOTAL GERAL</span>
            <span>R$ {totalGeral:N2}</span>
        </div>
    </div>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Descrição</th>
                <th>Categoria</th>
                <th>Valor</th>
                <th>Data</th>
            </tr>
        </thead>
        <tbody>";

            foreach (var recebimento in recebimentos.OrderByDescending(r => r.Data))
            {
                htmlContent += $@"
            <tr>
                <td>{recebimento.Id}</td>
                <td>{recebimento.Descricao}</td>
                <td>{recebimento.Categoria ?? "Sem Categoria"}</td>
                <td class='valor'>R$ {recebimento.Valor:N2}</td>
                <td class='data'>{recebimento.Data:dd/MM/yyyy}</td>
            </tr>";
            }

            htmlContent += $@"
        </tbody>
    </table>

    <div class='footer'>
        <p>Relatório gerado automaticamente pelo Sistema Ballet Sync</p>
        <p>Total de registros: {recebimentos.Count} | Total arrecadado: R$ {totalGeral:N2}</p>
    </div>
</body>
        </html>";

            return await GerarPdfDeHtmlAsync(htmlContent);
        }
    }

    public class Mensalidade
    {
        public int Id { get; set; }
        public string NomeAluno { get; set; } = string.Empty;
        public decimal Valor { get; set; }
        public DateTime DataVencimento { get; set; }
        public bool EstaPago { get; set; }
    }

    public class Recebimento
    {
        public int Id { get; set; }
        public string Descricao { get; set; } = string.Empty;
        public string? Categoria { get; set; }
        public decimal Valor { get; set; }
        public DateTime Data { get; set; }
    }
}

