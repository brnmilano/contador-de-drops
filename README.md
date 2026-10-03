# Contador de drops — The Classic PW 1.2.6 (Dusk)

Mostra, no navegador, os itens **raros (gold e red)** que dois personagens droparam no ranking **Dusk** do [The Classic PW 1.2.6](https://ranking.theclassic.games/pw126/dusk), com o nome e a quantidade de cada item, semana a semana. A tela é dividida em duas colunas, uma para cada personagem.

Os dados vêm da API pública do ranking. O contador só consulta a API quando você abre a página ou aperta **F5**.

## Requisitos

- Windows 10 ou 11.
- Nada para instalar: o script usa o PowerShell que já vem no Windows.

## Como usar

1. Baixe o projeto:
   - **Com Git:** `git clone https://github.com/brnmilano/contador-de-drops.git`
   - **Sem Git:** clique em **Code → Download ZIP** aqui no GitHub e extraia a pasta.
2. Dê dois cliques em **`iniciar.bat`**.
3. Abrem três coisas: uma janela preta (o servidor), o guia `COMO-USAR.txt` e o navegador em **http://localhost:8765**.
4. Aperte **F5** para atualizar e use o filtro **Semana** para ver semanas anteriores. O filtro vale para as duas colunas. Cada lista mostra só os itens gold e red, com uma bolinha dourada ou vermelha antes do nome.
5. Para encerrar, feche a janela preta.

O passo a passo completo, inclusive como conferir os valores, está no [`COMO-USAR.txt`](COMO-USAR.txt).

> **Baixou pelo ZIP e o Windows mostrou "O Windows protegeu o computador"?**
> Isso acontece com arquivos baixados da internet. Clique em **Mais informações → Executar assim mesmo**. Outra opção: clique com o botão direito no `.zip` → **Propriedades** → marque **Desbloquear** → OK, e só então extraia.

## Trocar os personagens

Os personagens estão configurados no início do `contador.ps1`. Abra o arquivo no Bloco de Notas e altere o bloco:

```powershell
$Personagens = @(
    @{ Titulo = 'Monarca'; Id = '434529'; Nomes = @('CadeMeuRed?', 'FizzKoko', 'Khaidron') }
    @{ Titulo = 'Gabriel'; Id = '921824'; Nomes = @('MrSantana') }
)
```

Cada linha é uma coluna, na ordem em que aparece na tela: a primeira fica à esquerda.

- **`Titulo`:** o nome mostrado no topo da coluna. Pode ser qualquer texto, não precisa ser o nome do personagem no jogo.
- **`Id`:** o ID do personagem no ranking. Abra o perfil dele no site: o número no final do endereço é o ID. Por exemplo, em `https://ranking.theclassic.games/player/pw126/434529`, o ID é `434529`.
- **`Nomes`:** os nomes do personagem no jogo: o atual primeiro e, se ele já trocou de nome, os nomes antigos. O script procura por eles para encontrar as semanas anteriores.

Se um personagem trocar de nome depois, não precisa editar nada: quando o contador não o encontra pelos nomes conhecidos, ele consulta o perfil pelo ID e descobre o nome novo sozinho.

Os arquivos `drops_fizzkoko.html` e `fizzkoko_dusk_semanal.json` são um retrato fixo do histórico do FizzKoko e não mudam com essa configuração.

## Arquivos

| Arquivo | Para que serve |
| --- | --- |
| `iniciar.bat` | Abre o contador. É o único arquivo que você precisa clicar. |
| `contador.ps1` | Servidor local que consulta a API e monta a página. |
| `COMO-USAR.txt` | Guia de uso, abre junto com o contador. |
| `drops_fizzkoko.html` | Histórico fixo do FizzKoko (semanas 22 a 40 de 2026), sem atualização. |
| `fizzkoko_dusk_semanal.json` | Os mesmos dados do histórico, em JSON. |

## Observações

- **Nomes dos itens:** os itens do Capítulo 3 (Ópera do Crepúsculo) usam os nomes oficiais do servidor. Os dos capítulos 1 e 2 são tradução livre do [Perfect World Database](https://www.pwdatabase.com/) (versão internacional) e podem não bater com os nomes do jogo. Itens desconhecidos aparecem como `Item <ID>`.
- **Raridade:** a lista mostra só os itens gold e red do Capítulo 3 (Ópera do Crepúsculo). Os itens comuns e os dos capítulos 1 e 2 não aparecem.
- **Uso da API:** cada F5 faz uma consulta por personagem. O ranking é atualizado periodicamente pelo próprio site. Apertar F5 várias vezes seguidas não traz dados novos, só gera carga no servidor deles.
- **Projeto não oficial:** não tem ligação com o The Classic Games.
