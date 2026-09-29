# ============================================================
#  Contador de drops (Dusk, PW 1.2.6)
#  Servidor local: abra http://localhost:8765. A API é consultada
#  ao abrir a página e a cada F5. Ctrl+C para encerrar.
# ============================================================

$Porta     = 8765
$EntityId  = '434529'                  # ID do personagem no ranking
$Nomes     = @('FizzKoko', 'Khaidron') # nomes que ele já usou

# Mostra qualquer erro inesperado em vez de fechar a janela
trap {
    Write-Host ''
    Write-Host "ERRO: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Linha: $($_.InvocationInfo.ScriptLineNumber)" -ForegroundColor Red
    Read-Host 'Aperte Enter para sair'
    exit 1
}

Write-Host "PowerShell $($PSVersionTable.PSVersion) - carregando o contador..."
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Itens = @{
    15227 = 'Lâmina de Chientien'
    15233 = 'Pele do Leão Frenético'
    15239 = 'Placa de Chin'
    15240 = 'Tambor de Guerra'
    15241 = 'Garra do Leão Frenético'
    15245 = 'Fragmento Resistente de Armadura Dourada'
    15247 = 'Dente do Macaco Gigante'
    15250 = 'Pele do Macaco Gigante'
    15251 = 'Juba do Devorador de Almas'
    15253 = 'Espírito Dourado'
    15257 = 'Lâmina do Leão Frenético'
    15258 = 'Placa de Ferro das Trevas'
    15260 = 'Chifre do Lacaio Maligno'
    15261 = 'Chifre do Cavalo de Feng'
    15262 = 'Mão da Feiticeira'
    15263 = 'Orbe da Mãe Sagrada'
    15265 = 'Poeira Estelar'
    15267 = 'Antena do Devorador de Almas'
    15268 = 'Armadura da Besta Gigante'
    15269 = 'Roda das Sete Luminárias'
    15270 = 'Pedra Astral'
    15271 = 'Chifre do Demônio Ancestral'
    15272 = 'Poeira do Demônio'
    15274 = 'Aura da Mãe Sagrada'
    15277 = 'Poder das Sete Luminárias'
    15278 = 'Alma do Demônio Ancestral'
    15280 = 'Fragmentos das Trevas'
    15281 = 'Fio do Machado do Lacaio Maligno'
    15282 = 'Pinças Gigantes das Trevas'
    15283 = 'Adorno de Cabeça da Feiticeira'
    15284 = 'Coração Ardente do Lacaio Maligno'
    15285 = 'Pedra da Mãe Sagrada'
    15286 = 'Aura da Feiticeira'
    15287 = 'Poder do Senhor Fantasma'
    15288 = 'Coração da Mãe Sagrada'
    15289 = 'Aura Negra da Besta Gigante'
    15290 = 'Aura Sombria do Senhor Fantasma'
    15291 = 'Chifre Carmesim da Besta Gigante'
    15292 = 'Orbe de Skaidread'
    15293 = 'Lâmina de Skaidread'
    15294 = 'Máscara Fantasma de Tsu'
    15295 = 'Pedra do Ministro'
    15296 = 'Vontade do Monarca'
    15297 = 'Chicote de Seda de Tsuchun'
    15298 = 'Fonte da Ilusão'
    15299 = 'Alma da Feiticeira'
    15300 = 'Proteção do Senhor Fantasma'
    15301 = 'Pegada da Besta Gigante'
    15302 = 'Imagem das Costas do Império'
    15303 = 'Alma Sombria de Tsuchun'
    15304 = 'Suspiro do Império'
    15305 = 'Asas Flamejantes de Tsuchun'
    15306 = 'Pedra do Senhor da Ilusão'
    15307 = 'Pedra da Ilusão'
    15309 = 'Máscara Dourada'
}

$Cache = @{}

function Buscar-Api([string]$ref, [string]$q) {
    $url = 'https://ranking.theclassic.games/index.php?__route=api/entries&game=pw126&ranking=dusk' +
           '&period=weekly&page=1&class=&sort=position&dir=asc' +
           '&ref=' + [Uri]::EscapeDataString($ref) + '&q=' + [Uri]::EscapeDataString($q)
    $wc = New-Object System.Net.WebClient
    $wc.Encoding = [System.Text.Encoding]::UTF8
    $wc.Headers.Add('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0 Safari/537.36')
    $wc.Headers.Add('Accept', 'application/json')
    try {
        Write-Host ("[{0:HH:mm:ss}] Consultando API (semana: {1}, nome: {2})" -f (Get-Date), $(if ($ref) { $ref } else { 'atual' }), $q)
        return ($wc.DownloadString($url) | ConvertFrom-Json)
    } finally { $wc.Dispose() }
}

function Obter-Semana([string]$ref) {
    # Consulta a API a cada carregamento da página (ao abrir ou apertar F5).
    # O último resultado fica guardado só para ser exibido se a consulta falhar.
    $c = $Cache[$ref]
    try {
        $dados = $null; $linha = $null
        foreach ($n in $Nomes) {
            $dados = (Buscar-Api $ref $n).data
            $linha = $dados.rows | Where-Object { "$($_.entity_id)" -eq $EntityId } | Select-Object -First 1
            if ($linha) { break }
        }
        $novo = @{ Hora = Get-Date; Dados = $dados; Linha = $linha; Erro = $null }
        $Cache[$ref] = $novo
        return $novo
    } catch {
        $msg = $_.Exception.Message
        Write-Host "  Falha na consulta: $msg" -ForegroundColor Yellow
        if ($c) { return @{ Hora = $c.Hora; Dados = $c.Dados; Linha = $c.Linha; Erro = $msg } }
        return @{ Hora = Get-Date; Dados = $null; Linha = $null; Erro = $msg }
    }
}

function Esc($s) { [System.Net.WebUtility]::HtmlEncode("$s") }

function Montar-Pagina([string]$ref) {
    $r = Obter-Semana $ref
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.Append(@'
<!DOCTYPE html>
<html lang="pt-BR"><head><meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Contador de drops</title>
<style>
  body { font-family: Arial, sans-serif; max-width: 640px; margin: 24px auto; padding: 0 16px; color: #222; }
  h1 { font-size: 22px; margin-bottom: 8px; }
  .info { color: #555; font-size: 14px; margin: 12px 0; line-height: 1.6; }
  .aviso { background: #fff4d6; border: 1px solid #e0c060; padding: 8px 12px; border-radius: 4px; font-size: 14px; }
  table { border-collapse: collapse; width: 100%; }
  th, td { text-align: left; padding: 6px 8px; border-bottom: 1px solid #ddd; }
  td.qtd, th.qtd { text-align: right; font-weight: bold; }
  select { font-size: 15px; padding: 4px 8px; }
</style></head><body>
<h1>Drops no Dusk — PW 1.2.6</h1>
'@)

    # Filtro de semana
    [void]$sb.Append('<label>Semana: <select onchange="location.href=''/?ref=''+this.value">')
    $sel = if ($ref -eq '') { ' selected' } else { '' }
    [void]$sb.Append("<option value=''$sel>Semana atual</option>")
    $refs = if ($r.Dados) { $r.Dados.refs } elseif ($Cache['']) { $Cache[''].Dados.refs } else { @() }
    foreach ($x in $refs) {
        $sel = if ($x.ref -eq $ref) { ' selected' } else { '' }
        [void]$sb.Append("<option value='$(Esc $x.ref)'$sel>$(Esc $x.label)</option>")
    }
    [void]$sb.Append('</select></label>')

    if ($r.Erro) {
        [void]$sb.Append("<p class='aviso'>Não consegui consultar a API agora ($(Esc $r.Erro)). ")
        if ($r.Linha) { [void]$sb.Append('Mostrando o último resultado obtido.') }
        [void]$sb.Append('</p>')
    }

    $l = $r.Linha
    if (-not $l) {
        if (-not $r.Erro) { [void]$sb.Append('<p class="aviso">Personagem não encontrado no ranking desta semana.</p>') }
    } else {
        $lista = @()
        if ($l.extra -and $l.extra.items) {
            $lista = $l.extra.items.PSObject.Properties | ForEach-Object {
                [pscustomobject]@{ Id = [int]$_.Name; Qtd = [int]$_.Value }
            } | Sort-Object Qtd -Descending
        }
        $total = ($lista | Measure-Object Qtd -Sum).Sum
        if (-not $total) { $total = 0 }

        [void]$sb.Append("<div class='info'>Personagem: <b>$(Esc $l.name)</b> · Posição: <b>$(Esc $l.position)</b> · Pontos: <b>$(Esc $l.score)</b> · Total de itens: <b>$total</b><br>")
        [void]$sb.Append("Ranking atualizado pelo servidor em: $(Esc $r.Dados.updated_at)<br>")
        [void]$sb.Append("Consultado por este script às: $('{0:HH:mm:ss}' -f $r.Hora)")
        [void]$sb.Append(' (aperte F5 para consultar de novo)')
        [void]$sb.Append('</div>')

        if ($lista.Count -eq 0) {
            [void]$sb.Append('<p>Nenhum drop registrado ainda nesta semana.</p>')
        } else {
            [void]$sb.Append('<table><tr><th>Item</th><th class="qtd">Quantidade</th></tr>')
            foreach ($i in $lista) {
                $nome = if ($Itens.ContainsKey($i.Id)) { $Itens[$i.Id] } else { "Item $($i.Id)" }
                [void]$sb.Append("<tr><td>$(Esc $nome)</td><td class='qtd'>$($i.Qtd)</td></tr>")
            }
            [void]$sb.Append('</table>')
        }
    }
    [void]$sb.Append('</body></html>')
    return $sb.ToString()
}

# ---------------- Servidor HTTP local ----------------
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$Porta/")
try { $listener.Start() } catch {
    Write-Host "Não consegui abrir a porta $Porta. Talvez o contador já esteja rodando em outra janela." -ForegroundColor Red
    Read-Host 'Aperte Enter para sair'
    exit 1
}

Write-Host "Contador de drops rodando em http://localhost:$Porta"
Write-Host 'Aperte F5 no navegador para atualizar. Ctrl+C aqui para encerrar.'
Start-Process "http://localhost:$Porta/"

try {
    while ($listener.IsListening) {
        $task = $listener.GetContextAsync()
        while (-not $task.AsyncWaitHandle.WaitOne(500)) { }
        $ctx = $task.GetAwaiter().GetResult()
        try {
            if ($ctx.Request.Url.AbsolutePath -ne '/') {
                $ctx.Response.StatusCode = 404
                $ctx.Response.Close()
                continue
            }
            $ref = $ctx.Request.QueryString['ref']
            if (-not $ref -or $ref -notmatch '^\d{4}-W\d{2}$') { $ref = '' }
            $bytes = [System.Text.Encoding]::UTF8.GetBytes((Montar-Pagina $ref))
            $ctx.Response.ContentType = 'text/html; charset=utf-8'
            $ctx.Response.ContentLength64 = $bytes.Length
            $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
            $ctx.Response.Close()
        } catch {
            Write-Host "Erro ao montar a página: $($_.Exception.Message)" -ForegroundColor Red
            try { $ctx.Response.Abort() } catch { }
        }
    }
} finally {
    $listener.Stop()
    $listener.Close()
}
