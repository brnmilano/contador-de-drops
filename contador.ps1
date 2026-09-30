# ============================================================
#  Contador de drops (Dusk, PW 1.2.6)
#  Servidor local: abra http://localhost:8765. A API é consultada
#  ao abrir a página e a cada F5. Ctrl+C para encerrar.
# ============================================================

$Porta     = 8765
$EntityId  = '434529'                  # ID do personagem no ranking
$Nomes     = @('CadeMeuRed?', 'FizzKoko', 'Khaidron') # nome atual primeiro, depois os antigos
# Se o personagem trocar de nome, o contador descobre o nome novo sozinho pelo ID.

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
    15258 = 'Armadura de Ferro da Escuridão'
    15260 = 'Chifre Longo do Escravo Demônio'
    15261 = 'Chifre do Cavalo de Feng'
    15262 = 'Mão da Mulher Demônio'
    15263 = 'Jóia da Sagrada Mãe'
    15265 = 'Poeira Estelar'
    15267 = 'Antena do Devorador de Almas'
    15268 = 'Carapaça da Grande Besta'
    15269 = 'Roda das Sete Luminárias'
    15270 = 'Pedra Astral'
    15271 = 'Chifre do Demônio Ancestral'
    15272 = 'Poeira do Demônio'
    15273 = 'Carapaça do Escravo Fantasma'
    15274 = 'Diadema da Sagrada Mãe'
    15276 = 'Casco da Grande Besta'
    15277 = 'Poder das Sete Luminárias'
    15278 = 'Alma do Demônio Ancestral'
    15280 = 'Armadura da Escuridão'
    15281 = 'Lâmina-Machado do Fantasma'
    15282 = 'Ferramentas da Escuridão'
    15283 = 'Coroa da Mulher Demônio'
    15284 = 'Coração de Fogo do Fantasma'
    15285 = 'Pedra Espiritual da Sagrada Mãe'
    15286 = 'Energia da Mulher Demônio'
    15287 = 'Poder do Rei Fantasma'
    15288 = 'Coração da Sagrada Mãe'
    15289 = 'Hálito Negro da Grande Besta'
    15290 = 'Seda Dourada do Rei Fantasma'
    15291 = 'Chifre Rubro da Grande Besta'
    15292 = 'Jóia Verdejante'
    15293 = 'Lâmina Verdejante'
    15294 = 'Máscara Fantasma de Tsu'
    15295 = 'Selo do Ministro'
    15296 = 'Espírito Guerreiro do Rei'
    15297 = 'Chicote de Seda Pura'
    15298 = 'Fonte Espelhada Ilusória'
    15299 = 'Alma da Mulher Demônio'
    15300 = 'Bainha do Rei Fantasma'
    15301 = 'Alma da Grande Besta'
    15302 = 'Destino do Crepúsculo'
    15303 = 'Alma Pura da Escuridão'
    15304 = 'Remorso do Crepúsculo'
    15305 = 'Asas Puras Brilhantes'
    15306 = 'Marca do Senhor das Ilusões'
    15307 = 'Pedra dos Sonhos'
    15308 = 'Símbolo do Crepúsculo'
    15309 = 'Máscara Dourada'
    15310 = 'Cetro do Poder do Crepúsculo'
    15311 = 'Espírito do Céu e da Terra'
}

# Raridade dos itens do Capítulo 3 (gold = amarelo, red = vermelho na tabela oficial)
$Raros = @{
    # gold (nomes em amarelo na tabela oficial)
    15273 = 'gold'  # Carapaça do Escravo Fantasma (90)
    15274 = 'gold'  # Diadema da Sagrada Mãe (90)
    15276 = 'gold'  # Casco da Grande Besta (90)
    15299 = 'gold'  # Alma da Mulher Demônio (99)
    15300 = 'gold'  # Bainha do Rei Fantasma (99)
    15301 = 'gold'  # Alma da Grande Besta (99)
    15302 = 'gold'  # Destino do Crepúsculo (99)
    15303 = 'gold'  # Alma Pura da Escuridão (99)
    15304 = 'gold'  # Remorso do Crepúsculo (99)
    15305 = 'gold'  # Asas Puras Brilhantes (99)
    15306 = 'gold'  # Marca do Senhor das Ilusões (99)
    15307 = 'gold'  # Pedra dos Sonhos (99)
    # red (nomes em vermelho na tabela oficial)
    15309 = 'red'   # Máscara Dourada (100)
    15310 = 'red'   # Cetro do Poder do Crepúsculo (100)
    15311 = 'red'   # Espírito do Céu e da Terra (100)
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

# Descobre o nome atual do personagem pela página de perfil (usa o ID)
$script:PerfilConsultado = $false
function Descobrir-Nome {
    $url = "https://ranking.theclassic.games/player/pw126/$EntityId"
    $wc = New-Object System.Net.WebClient
    $wc.Encoding = [System.Text.Encoding]::UTF8
    $wc.Headers.Add('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0 Safari/537.36')
    try {
        Write-Host ("[{0:HH:mm:ss}] Procurando o nome atual pelo ID {1}" -f (Get-Date), $EntityId)
        $html = $wc.DownloadString($url)
        $m = [regex]::Match($html, '<title>\s*(.*?)\s+—\s+PW')
        if ($m.Success) { return [System.Net.WebUtility]::HtmlDecode($m.Groups[1].Value).Trim() }
        return $null
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
        # Não achou por nenhum nome conhecido: talvez ele tenha trocado de nome.
        # Consulta o perfil (no máximo uma vez enquanto o contador estiver aberto).
        if (-not $linha -and -not $script:PerfilConsultado) {
            $script:PerfilConsultado = $true
            $atual = Descobrir-Nome
            if ($atual -and ($Nomes -notcontains $atual)) {
                Write-Host "  Nome novo detectado: $atual" -ForegroundColor Green
                $script:Nomes = @($atual) + $Nomes
                $dados = (Buscar-Api $ref $atual).data
                $linha = $dados.rows | Where-Object { "$($_.entity_id)" -eq $EntityId } | Select-Object -First 1
            }
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
<meta name="color-scheme" content="dark">
<title>Contador de drops</title>
<style>
  html, body { background: #000; }
  body { font-family: Arial, sans-serif; max-width: 640px; margin: 24px auto; padding: 0 16px; color: #fff; }
  .aviso { background: #1a1a1a; border: 1px solid #555; padding: 8px 12px; border-radius: 4px; font-size: 16px; }
  table { border-collapse: collapse; margin-top: 16px; font-size: 20px; }
  th, td { text-align: left; padding: 4px 0; }
  td.qtd, th.qtd { text-align: right; font-weight: bold; padding-left: 24px; }
  .bolinha { display: inline-block; width: 12px; height: 12px; border-radius: 50%; margin-right: 10px; vertical-align: middle; }
  .bolinha.gold { background: #f5c542; }
  .bolinha.red { background: #ff4d4d; }
  select { font-size: 18px; padding: 4px 8px; background: #000; color: #fff; border: 1px solid #555; border-radius: 4px; }
  label { font-size: 18px; }
</style></head><body>
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
        $lista = @($lista)
        # Mostra somente os itens raros (gold e red)
        $lista = @($lista | Where-Object { $Raros.ContainsKey($_.Id) })

        if ($lista.Count -eq 0) {
            [void]$sb.Append('<p>Nenhum item gold ou red nesta semana.</p>')
        } else {
            [void]$sb.Append('<table><tr><th>Item</th><th class="qtd">Quantidade</th></tr>')
            foreach ($i in $lista) {
                $nome = if ($Itens.ContainsKey($i.Id)) { $Itens[$i.Id] } else { "Item $($i.Id)" }
                $bolinha = "<span class='bolinha $($Raros[$i.Id])' title='$($Raros[$i.Id])'></span>"
                [void]$sb.Append("<tr><td>$bolinha$(Esc $nome)</td><td class='qtd'>$($i.Qtd)</td></tr>")
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
