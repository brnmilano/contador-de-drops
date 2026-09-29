# Contador de drops — The Classic PW 1.2.6 (Dusk)

Mostra, no navegador, os itens que um personagem dropou no ranking **Dusk** do [The Classic PW 1.2.6](https://ranking.theclassic.games/pw126/dusk), com o nome e a quantidade de cada item, semana a semana.

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
4. Aperte **F5** para atualizar e use o filtro **Semana** para ver semanas anteriores.
5. Para encerrar, feche a janela preta.

O passo a passo completo, inclusive como conferir os valores, está no [`COMO-USAR.txt`](COMO-USAR.txt).

> **Baixou pelo ZIP e o Windows mostrou "O Windows protegeu o computador"?**
> Isso acontece com arquivos baixados da internet. Clique em **Mais informações → Executar assim mesmo**. Outra opção: clique com o botão direito no `.zip` → **Propriedades** → marque **Desbloquear** → OK, e só então extraia.

## Acompanhar outro personagem

O personagem está configurado no início do `contador.ps1`. Abra o arquivo no Bloco de Notas e altere:

```powershell
$EntityId  = '434529'                  # ID do personagem no ranking
$Nomes     = @('FizzKoko', 'Khaidron') # nomes que ele já usou
```

Para descobrir o ID de um personagem, abra o perfil dele no site do ranking. O número no final do endereço é o ID. Por exemplo, em `https://ranking.theclassic.games/player/pw126/434529`, o ID é `434529`.

Em `$Nomes`, coloque o nome atual do personagem e, se ele já trocou de nome, os nomes antigos. O script procura por eles para encontrar as semanas anteriores.

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

- **Nomes dos itens:** vêm do [Perfect World Database](https://www.pwdatabase.com/) (versão internacional) e foram traduzidos livremente. Podem não bater exatamente com os nomes do jogo. Itens desconhecidos aparecem como `Item <ID>`.
- **Pontos e total de itens:** cada item vale 1 ponto, exceto a **Pedra do Senhor da Ilusão (15306)**, que vale 20. Por isso os dois números podem ser diferentes.
- **Uso da API:** o ranking é atualizado periodicamente pelo próprio site. Apertar F5 várias vezes seguidas não traz dados novos, só gera carga no servidor deles.
- **Projeto não oficial:** não tem ligação com o The Classic Games.
