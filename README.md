# Painel COVID-19 - 15a Regional de Saude do Parana

Aplicacao interativa desenvolvida em R e Shiny para apoiar o acompanhamento epidemiologico dos municipios da 15a Regional de Saude do Parana.

O painel transforma registros de casos em indicadores, tabelas, mapas e graficos para analise da distribuicao e da evolucao da COVID-19, cobrindo os 30 municipios da regional. A aplicacao preserva o fluxo historico de autenticacao, navegacao por abas e visualizacao dos dados regionais.

O projeto nasceu durante a pandemia para substituir a leitura manual de planilhas eletronicas diarias por uma visao consolidada e atualizada da situacao epidemiologica. Na epoca, isso reduziu o tempo gasto pelos agentes de saude da regional compilando casos, obitos e incidencia por municipio, alem de apoiar a priorizacao por nivel de risco e a comunicacao dos resultados com gestores municipais e colaboradores.

## Objetivos

- Consolidar os registros epidemiologicos dos municipios da regional.
- Apresentar casos por dia, casos acumulados e incidencia por milhao de habitantes.
- Disponibilizar indicadores de obitos, sexo e faixa etaria.
- Permitir a consulta dos dados por municipio em mapas e graficos interativos.
- Exibir rankings de risco e estimativas relacionadas a propagacao da doenca.
- Oferecer uma calculadora baseada no modelo SEIR para simulacoes exploratorias.
- Apoiar a comunicacao dos resultados para equipes de saude e colaboradores.

## O que pode ser encontrado

- **Painel Geral**: indicadores consolidados de casos confirmados e obitos (incluindo KPIs separados por sexo), distribuicao por sexo e por faixa etaria (isolada e cruzada faixa etaria x sexo), casos confirmados por dia com media movel de 7 dias, evolucao acumulada de casos, incidencia por milhao de habitantes e comparativo entre municipios.
- **Mapa de cidades**: mapa interativo (Leaflet) com os casos confirmados por municipio; ao clicar em uma cidade abre um modal detalhado com serie historica, casos por dia (com media movel de 7 dias), incidencia, faixa etaria e indicadores de viagem.
- **Nivel de risco**: ranking dos municipios segundo o risco estimado de aumento de casos, calculado a partir da prevalencia das infeccoes, da taxa de propagacao estimada e do tamanho da populacao.
- **Comportamento inicial**: simulacoes de como o atraso na adocao de medidas de mitigacao ou a chegada de pessoas expostas afeta o crescimento inicial da epidemia em uma cidade escolhida.
- **Calculadora SEIR**: simulacao da evolucao da epidemia com o modelo SEIR (Suscetiveis-Expostos-Infectados-Recuperados), ajustando populacao, taxas de propagacao, incubacao, recuperacao e valores iniciais.
- **Colaboradores**: equipe responsavel pelo acompanhamento epidemiologico da regional e pelo desenvolvimento estatistico e computacional do painel, em parceria com os departamentos de Estatistica e Matematica da UEM.
- **Sobre**: pagina Quarto (`R_code/modules/sobre/sobre.qmd`) com o objetivo, o conteudo, a organizacao e o impacto do painel.

## Tecnologias

- R 4.x
- Shiny
- `bslib` para o tema visual (Bootstrap 5, cores, tipografia e componentes `card`) - a versao do Bootstrap e fixa em 5+ porque `bslib::card()`/`card_header()`/`card_body()` exigem essa versao; nao e possivel baixar para 3/4
- Shiny Dashboard e Shiny Dashboard Plus (componentes legados, usados apenas onde ainda nao ha equivalente em `bslib`)
- `plotly` para graficos interativos
- `leaflet` e `sf` para mapas e dados espaciais
- `DT` para tabelas interativas
- `dplyr`, `tidyverse`, `stringr` e `lubridate` para tratamento dos dados
- `readxl` para leitura da planilha populacional
- `arrow` para leitura/escrita dos arquivos parquet do pipeline de dados (camadas prata e ouro)
- `brazilmaps` para limites geograficos dos municipios
- `deSolve` e `EpiDynamics` para componentes de modelagem
- `shinyWidgets`, `shinyjs` e `shinyBS` para controles e interacoes da interface
- `shinycssloaders` para os indicadores de carregamento (`withSpinner()`) dos graficos, tabelas e do mapa
- `ggplot2`, `gganimate` e `gifski` para visualizacoes e animacoes
- `sass` para compilar as regras de tema definidas em `assets/sass/`
- `renv` para reproducibilidade das dependencias

A lista completa, incluindo versoes resolvidas e dependencias transitivas, esta em `renv.lock`.

## Arquitetura

O ponto de entrada e `app.R`. Ele define a raiz do projeto, ativa o `renv`, carrega os pacotes, prepara os dados, monta o tema `bslib`, carrega os modulos de interface e cria o objeto `shinyApp`.

O projeto foi migrado de um `server.R` monolitico para modulos Shiny reais (`moduleServer()`/`NS()`), um por aba, cada um em sua propria pasta com `ui.R` e `server.R`. Os 7 modulos (`panorama_geral`, `mapa_cidades`, `nivel_risco`, `colaboradores`, `calculadora`, `comportamento_inicial` e `sobre`) ja seguem esse padrao. Nao ha tela de login: todas as abas ficam sempre visiveis via `page_navbar(...)`. `R_code/server.R` continua existindo, mas hoje cuida apenas das chamadas `*Server(id)` de cada modulo - nao ha mais outputs soltos de aba nesse arquivo.

```text
.
|-- app.R                         # Bootstrap e ponto de entrada Shiny
|-- pipeline/                     # Pipeline de dados (bronze -> prata -> ouro), EXTERNO a aplicacao
|   |-- run_pipeline.R            # Orquestrador (Rscript pipeline/run_pipeline.R)
|   `-- R/
|       |-- 00_utils.R            # Normalizacao de nomes de cidade, datas, sexo, idade
|       |-- 01_silver.R           # Le data/bronze/ (raw) -> limpeza/unificacao -> data/silver/*.parquet
|       `-- 02_gold.R             # Le data/silver/ -> agregados prontos para o painel -> data/gold/*.parquet
|-- assets/                       # Design system (tema bslib e estilos)
|   |-- sass/                     # Tokens (_variables.scss, _mixins.scss, main.scss)
|   |-- css/                      # CSS compilado adicional (app.css)
|   `-- www/                      # Estilos e imagens complementares servidos via /assets
|-- R_code/
|   |-- packages.R                # Pacotes usados pela aplicacao (inclui bslib, arrow)
|   |-- functions.R               # Funcoes auxiliares reutilizaveis
|   |-- constants.R               # Constantes, helpers de UI (ex.: box_card()) e configuracoes legadas
|   |-- theme.R                   # Definicao do bs_theme() a partir dos tokens em assets/ (version = 5, obrigatorio)
|   |-- data.R                    # Leitura da camada ouro (data/gold/*.parquet) e montagem dos objetos do mapa
|   |-- ui.R                      # Composicao principal da interface (fluidPage com theme = app_theme)
|   |-- server.R                  # Login, navegacao e chamadas *Server(id) de cada modulo
|   |-- modules/                  # Um modulo Shiny real por aba (ui.R + server.R)
|   |   |-- panorama_geral/
|   |   |-- mapa_cidades/
|   |   |-- nivel_risco/
|   |   |-- colaboradores/
|   |   |-- calculadora/
|   |   |-- comportamento_inicial/
|   |   `-- sobre/                 # Pagina Quarto (sobre.qmd -> sobre.html), incorporada via iframe
|   `-- legacy/                   # Scripts antigos ainda referenciados via source()
|-- data/
|   |-- bronze/                  # Camada bronze: arquivos brutos no formato original (fonte)
|   |   |-- dataset.csv          # Dataset principal (lido apenas pelo pipeline)
|   |   |-- dataset2.csv         # Dataset historico/alternativo (nao usado pelo pipeline/painel)
|   |   |-- obitos.csv           # Base auxiliar de obitos (nao usada pelo pipeline/painel)
|   |   `-- auxiliary/
|   |       |-- pop_municipios.xlsx  # Populacao usada na incidencia (lida apenas pelo pipeline)
|   |       |-- latitude-longitude-bairros.csv
|   |       |-- table.RData
|   |       `-- F4993300
|   |-- silver/                  # Camada prata: dados limpos/unificados em parquet
|   `-- gold/                    # Camada ouro: dados agregados prontos para o painel (o que app.R le)
|-- www/                         # Recursos publicados pelo Shiny na raiz (/)
|   |-- styles.css, custom.css
|   |-- code.js
|   |-- footer.html
|   `-- imagens, icones, SVGs e animacoes
|-- renv.lock                    # Manifesto reprodutivel de pacotes
|-- renv/                        # Infraestrutura gerada pelo renv
|-- covid_19.Rproj               # Projeto RStudio
|-- .gitignore                   # Regras para arquivos locais e temporarios
`-- README.md
```

## Fluxo de execucao

1. `app.R` identifica a raiz do projeto e configura `data_dir`.
2. O ambiente `renv` e ativado quando `renv/activate.R` esta disponivel.
3. `R_code/packages.R` carrega os pacotes da aplicacao (inclui `bslib`) e `app.R` registra `assets/` como recurso publico via `addResourcePath("assets", ...)`.
4. `R_code/functions.R` e `R_code/constants.R` disponibilizam funcoes, helpers de UI (`box_card()`) e configuracoes.
5. `R_code/theme.R` monta `app_theme <- bslib::bs_theme(...)` a partir dos tokens em `assets/sass/` e aplica as regras extra de `assets/sass/main.scss`.
6. `R_code/data.R` le os parquets ja prontos em `data/gold/` (gerados previamente pelo pipeline em `pipeline/run_pipeline.R`) e monta os objetos analiticos e de mapa consumidos pelos modulos.
7. Os arquivos de `R_code/modules/<nome>/{ui.R,server.R}` sao carregados aos pares - cada um define `<nome>UI(id)` e `<nome>Server(id)`.
8. `R_code/ui.R` monta a interface principal com `fluidPage(theme = app_theme, ...)`.
9. `R_code/server.R` chama `<nome>Server(id)` de cada modulo, uma vez por aba; `R_code/ui.R` monta a navegacao com `page_navbar(..., nav_panel(...))`, com todas as abas sempre visiveis (nao ha login).
10. `shinyApp(ui = ui, server = server)` inicia a aplicacao.

> Nota sobre `source()` dentro de `server.R`: como o Shiny executa `app.R` em um ambiente proprio (nao o `.GlobalEnv`) e os `source()` internos de `app.R` avaliam o conteudo no `.GlobalEnv` por padrao, qualquer caminho de arquivo usado dentro de `server.R`/modulos deve ser construido com `getwd()` (jamais com a variavel `project_root`, que so existe no escopo do proprio `app.R`).

> Nota sobre modais: `shinyBS::bsModal()` depende do jQuery/`data-toggle` do Bootstrap 3-4 e nao funciona sob `bs_theme(version = 5)` (o Bootstrap 5 removeu o jQuery e renomeou esses atributos para `data-bs-*`) - o clique no gatilho simplesmente nao abre nada, sem erro no console. Use sempre `shiny::showModal(shiny::modalDialog(...))` (nativo do Shiny, compativel com qualquer Bootstrap) em vez de `bsModal`/`toggleModal`. O modulo `nivel_risco` segue esse padrao (`observeEvent(input$Id113, { showModal(...) })`).

## Dados

Os dados nao sao mais armazenados em `www/`. Essa pasta e reservada a arquivos que o navegador precisa acessar diretamente.

A leitura, limpeza e agregacao dos dados brutos acontecem **fora da aplicacao**, em um pipeline de dados no formato medallion (`pipeline/`), totalmente independente do Shiny. `R_code/data.R` nunca le `dataset.csv`, o `.xlsx` ou o `.csv` de bairros diretamente — ele so le os arquivos parquet ja prontos em `data/gold/`.

### Pipeline de dados (`pipeline/`)

```
data/bronze/dataset.csv                            (dado bruto, pousado, formato original)
data/bronze/auxiliary/*.xlsx|csv
        │  Rscript pipeline/run_pipeline.R
        ▼
data/silver/*.parquet   -> limpeza, tipagem e unificacao (nomes de cidade, datas, sexo, idade)
        ▼
data/gold/*.parquet     -> agregados prontos para consumo (o que R_code/data.R le)
```

- **Bronze** (`data/bronze/`): os arquivos brutos em si, no formato original da fonte (`dataset.csv`, `auxiliary/pop_municipios.xlsx`, `auxiliary/latitude-longitude-bairros.csv`) — nenhuma transformacao, e o pipeline so os le, nunca os gera.
- **Prata** (`data/silver/`): `casos.parquet`, `populacao_municipios.parquet`, `populacao_regional.parquet`, `bairros_15regional.parquet` — nomes de municipio normalizados (acentos/abreviacoes/espacos), datas convertidas, sexo/idade/obito padronizados.
- **Ouro** (`data/gold/`): tabelas prontas para o painel — `metadados`, `casos_detalhe`, `casos_por_dia`, `incidencias`, `faixa_etaria`, `faixa_etaria_sexo`, `casos_por_sexo`, `obitos_por_municipio`, `resumo_municipios`, `populacao_municipios`, `bairros_15regional`.

Rode o pipeline sempre que os arquivos em `data/bronze/` forem atualizados (substituindo o `.csv`/`.xlsx` mantendo o mesmo nome/formato):

```r
# a partir da raiz do projeto
renv::install(c("arrow", "readxl"))   # uma vez, se ainda nao estiver instalado/no lockfile
Rscript pipeline/run_pipeline.R
```

O pipeline usa suas proprias funcoes de normalizacao (`pipeline/R/00_utils.R`) e nao depende de nada em `R_code/` — pode ser executado, testado e agendado (ex.: cron) de forma independente da aplicacao. `pipeline/R/01_silver.R` le os arquivos de `data/bronze/` (o `dataset.csv` esta em Latin-1/Windows-1252, nao UTF-8 — a leitura ja trata essa conversao) e `pipeline/R/02_gold.R` le `data/silver/` e escreve `data/gold/`.

### `pipeline/R/00_utils.R` — utilitarios de normalizacao

Funcoes puras, sem efeitos colaterais, reutilizadas por `01_silver.R` e `02_gold.R`:

| Funcao | Entrada -> Saida | Uso |
|---|---|---|
| `rm_accent(str)` | string(s) com acento -> mesma string sem acento | Base para `normalize_key()`; troca vogais/consoantes acentuadas pela forma "nua" via `chartr()`. |
| `normalize_key(x)` | string bruta -> `TOUPPER`, sem acento, sem espaco nas pontas | Chave de comparacao geral (ex.: nomes vindos de planilha). |
| `compact_key(x)` | string bruta -> so letras `A-Z`, maiusculas, sem espaco/acento/pontuacao | Chave "compacta" no formato gravado pelo sistema de origem (ex.: `"doutorcamargo"`). |
| `municipios_15_regional` | (constante) | Lista oficial dos 30 municipios da 15a Regional, em maiusculas com acento — mesma ordem usada nas planilhas de origem e mesmo formato usado por `R_code/constants.R` (`lista_cidade_upper`). |
| `municipio_aliases` | (constante) | Abreviacoes conhecidas que a chave compacta nao resolve sozinha (hoje: `PCB -> PRESIDENTE CASTELO BRANCO`). |
| `build_municipio_lookup()` | — -> vetor nomeado `chave_compacta -> nome canonico` | Combina `municipios_15_regional` + `municipio_aliases` num unico lookup. |
| `resolve_municipio(x)` | token de cidade (raw) -> nome canonico com acento | Usa `build_municipio_lookup()`; tokens nao reconhecidos sao preservados (normalizados) em vez de descartados, para nao perder registros silenciosamente. |
| `municipio_chave_app(nome_canonico)` | nome canonico -> chave compacta | Chave usada pelas telas do painel para identificar uma cidade (ex.: `"saojorgedoivai"`). |
| `parse_data_br(x)` | string `dd/mm/aaaa` -> `Date` | Conversao de datas do formato brasileiro. |
| `parse_idade(x)` | string de idade suja (ex.: `"57 anos"`) -> `numeric` | Extrai o primeiro token numerico do campo. |
| `normalize_sexo(x)` | string livre -> `"M"`, `"F"` ou `NA` | Classifica pelo primeiro caractere (`^M`/`^F`), maiusculizado. |
| `normalize_sim_nao(x)` | string livre -> `"SIM"`/`"NAO"` (maiusculas, sem espaco) | Usado para o campo de obito. |
| `ensure_dir(path)` | caminho -> cria o diretorio se nao existir | Usado antes de escrever cada camada (`silver_dir`, `gold_dir`). |
| `log_step(...)` | `sprintf(...)` -> mensagem com timestamp no console | Log padronizado de cada etapa do pipeline. |

### `pipeline/R/01_silver.R` — `build_silver(bronze_dir, silver_dir)`

1. Le `dataset.csv` (Latin-1/Windows-1252, separador `;`), `auxiliary/pop_municipios.xlsx` (aba `Planilha1`) e `auxiliary/latitude-longitude-bairros.csv` (UTF-8, separador `;`).
2. Constroi a tabela `casos`: converte `notifica`/`coleta` com `parse_data_br()`, resolve `cidade` com `resolve_municipio()` + `municipio_chave_app()`, idade com `parse_idade()`, sexo com `normalize_sexo()`, obito com `normalize_sim_nao()`; quando falta `NOTIFICA`, usa a data de `COLETA` (mesma regra da aplicacao original). Grava `casos.parquet`.
3. Separa a primeira linha da planilha de populacao (total "15 RS") do restante (`populacao_regional` x `populacao_municipios`), resolve o nome/chave de cada municipio e grava `populacao_municipios.parquet` e `populacao_regional.parquet`.
4. Filtra os bairros do arquivo de coordenadas para `uf == "PR"` e municipios da 15a regional, resolve o nome do municipio e grava `bairros_15regional.parquet`.

### `pipeline/R/02_gold.R` — `build_gold(silver_dir, gold_dir)`

Le as quatro tabelas da camada prata e escreve as tabelas de consumo do painel: contagens diarias e por municipio (`casos_por_dia`), incidencia acumulada por milhao de habitantes (`incidencias`), distribuicao por faixa etaria isolada e cruzada com sexo (`faixa_etaria`, `faixa_etaria_sexo`), contagem por sexo (`casos_por_sexo`), obitos por municipio (`obitos_por_municipio`), um resumo por municipio com populacao/casos/obitos/incidencia final (`resumo_municipios`), a tabela de populacao no formato de exibicao (`populacao_municipios`), a copia da camada de bairros (`bairros_15regional`), o detalhe linha-a-linha de casos ja limpo (`casos_detalhe`, copia de `casos.parquet`) e uma linha de metadados (`metadados`) com data de atualizacao, id do video do YouTube, totais de casos/obitos por sexo e quantidade de cidades com casos.

### Dicionario de dados — camada prata (`data/silver/`)

**`casos.parquet`** (uma linha por caso notificado)

| Coluna | Tipo | Descricao |
|---|---|---|
| `NOTIFICA` | `Date` | Data de notificacao do caso; quando ausente na origem, recebe a data de `COLETA`. |
| `CIDADE` | `character` | Nome do municipio, forma canonica com acento (ex.: `"Doutor Camargo"`). |
| `CIDADE_CHAVE` | `character` | Chave compacta do municipio (ex.: `"doutorcamargo"`), usada para join/filtro. |
| `NOME` | `character` | Nome do paciente, sem espacos nas pontas. |
| `IDADE` | `numeric` | Idade extraida do campo de origem (`parse_idade()`). |
| `SEXO` | `character` | `"M"`, `"F"` ou `NA`. |
| `VIAJEM` | `character` | Indicador de viagem, como gravado na origem. |
| `OBITO` | `character` | `"SIM"`/`"NAO"` (padronizado). |
| `COLETA` | `Date` | Data de coleta do exame. |
| `RESULTADOCOVID` | `character` | Resultado do exame, sem espacos nas pontas. |
| `ATUALIZADO` | `character` | Campo livre de origem; as duas primeiras linhas carregam, por convencao, a data de atualizacao do painel e o id do video do YouTube (ver `metadados` na camada ouro). |

**`populacao_municipios.parquet`** (uma linha por municipio da regional)

| Coluna | Tipo | Descricao |
|---|---|---|
| `MUNICIPIO_RAW` | `character` | Nome do municipio como veio da planilha de populacao. |
| `MUNICIPIO_CHAVE` | `character` | Chave compacta do nome bruto (antes da resolucao). |
| `POPULACAO` | `numeric` | Populacao do municipio. |
| `CIDADE` | `character` | Nome canonico do municipio (`resolve_municipio()`). |
| `CIDADE_CHAVE` | `character` | Chave compacta do nome canonico — usada para join com `casos`. |

**`populacao_regional.parquet`** (uma linha, total da regional)

| Coluna | Tipo | Descricao |
|---|---|---|
| `MUNICIPIO_RAW` | `character` | Rotulo do total (`"15 RS"`). |
| `MUNICIPIO_CHAVE` | `character` | Chave compacta do rotulo. |
| `POPULACAO` | `numeric` | Populacao total da 15a Regional de Saude. |

**`bairros_15regional.parquet`** (uma linha por bairro)

| Coluna | Tipo | Descricao |
|---|---|---|
| `municipio`, `uf`, ... | (colunas originais) | Todas as colunas do CSV de origem (`latitude-longitude-bairros.csv`), filtradas para `uf == "PR"` e municipios da 15a regional. |
| `MUNICIPIO_CHAVE` | `character` | Chave compacta do campo `municipio` original. |
| `CIDADE` | `character` | Nome canonico do municipio (`resolve_municipio()`). |

### Dicionario de dados — camada ouro (`data/gold/`)

Todas as tabelas "largas" abaixo (`casos_por_dia`, `incidencias`, `faixa_etaria`, `casos_por_sexo`, `obitos_por_municipio`) tem uma coluna por municipio da regional (os 30 nomes de `municipios_15_regional`), alem das colunas indicadas.

| Tabela | Granularidade | Colunas principais |
|---|---|---|
| `casos_por_dia.parquet` | 1 linha por dia da serie | `label_datas` (`Date`); `REGIONAL` (`integer`, casos do dia na regional); uma coluna `integer` por municipio com os casos do dia. Base de `data_casos` em `R_code/data.R`. |
| `incidencias.parquet` | 1 linha por dia da serie | `label_datas` (`Date`); `REGIONAL` (`numeric`, incidencia acumulada por milhao na regional); uma coluna `numeric` por municipio com a incidencia acumulada por milhao de habitantes. |
| `faixa_etaria.parquet` | 1 linha por faixa etaria (`"0 - 09"`, `"10 - 18"`, `"19 - 40"`, `"41 - 60"`, `"61 - 80"`, `"81+"`) | `label_datas` (`character`, rotulo da faixa); `REGIONAL` (`integer`); uma coluna `integer` por municipio. |
| `faixa_etaria_sexo.parquet` | 1 linha por combinacao faixa etaria x sexo | `faixa_etaria` (`factor`); `sexo` (`factor`: `"FEMININO"`/`"MASCULINO"`); `casos` (`integer`). |
| `casos_por_sexo.parquet` | 2 linhas (`F`, `M`) | `REGIONAL` (`integer`, total na regional); uma coluna `integer` por municipio. `rownames` = sexo. |
| `obitos_por_municipio.parquet` | 1 linha | Uma coluna `integer` por municipio com o total de obitos. |
| `resumo_municipios.parquet` | 1 linha por municipio | `CIDADE` (`character`); `CIDADE_CHAVE` (`character`); `POPULACAO` (`numeric`); `CASOS` (`numeric`, total acumulado); `OBITOS` (`numeric`); `INCIDENCIA` (`numeric`, incidencia acumulada final por milhao). |
| `populacao_municipios.parquet` | 1 linha por municipio + 1 linha do total regional | `Municipios` (`character`, `"15 RS"` na primeira linha, nome do municipio nas demais); `População` (`numeric`). |
| `bairros_15regional.parquet` | 1 linha por bairro | Copia identica da tabela de mesmo nome da camada prata. |
| `casos_detalhe.parquet` | 1 linha por caso notificado | Copia identica de `casos.parquet` da camada prata — usada para series sob demanda por municipio e pelas telas administrativas. |
| `metadados.parquet` | 1 linha | `data_atualizacao_str` (`character`, `dd/mm/aaaa`); `video_id_youtube` (`character`); `data_inicio`/`data_fim_serie` (`Date`); `total_casos` (`integer`); `total_obitos` (`integer`); `obitos_feminino`/`obitos_masculino` (`integer`); `qtd_cidades_com_casos` (`integer`). |

`R_code/data.R` le cada uma dessas tabelas (funcao `gold(nome)`) e monta os objetos consumidos pelos modulos (`data_casos`, `incidencias`, `faixa_etaria`, `faixa_etaria_sexo`, `casos_sexo`, `obitos_mun`, `resumo_municipios`, `populacao_municipio`, `metadados`, `qtd_cidade`, `data_fim`, `link`, `obitos`, `obitos_sexo`, `dataset1`), alem de combinar `resumo_municipios` com a geometria de `brazilmaps` para montar o mapa Leaflet.

### Fontes de dados (lidas apenas pelo pipeline)

- `data/bronze/dataset.csv`: dataset principal de casos notificados. Separador `;`, codificacao Latin-1/Windows-1252, campos como municipio, datas, sexo, idade, viagem, obito e resultado do exame.
- `data/bronze/auxiliary/pop_municipios.xlsx`: populacao municipal utilizada nos calculos de incidencia.
- `data/bronze/auxiliary/latitude-longitude-bairros.csv`: coordenadas e identificacao de bairros (usado para a camada de bairros da 15a regional).
- `data/bronze/obitos.csv` e `data/bronze/dataset2.csv`: arquivos historicos que nao sao mais referenciados pelo pipeline nem pelo painel; mantidos em bronze apenas como registro.
- `data/bronze/auxiliary/table.RData` e `data/bronze/auxiliary/F4993300`: artefatos auxiliares preservados para compatibilidade e referencia (nao utilizados).

Para atualizar os dados, substitua os arquivos em `data/bronze/` mantendo nomes, colunas esperadas, separadores e formatos, e rode `Rscript pipeline/run_pipeline.R` novamente. Alteracoes de schema podem exigir ajustes em `pipeline/R/01_silver.R`/`02_gold.R` e, se novos objetos forem necessarios, em `R_code/data.R`.

## Modulos do painel

Todos os 7 modulos seguem o padrao `moduleServer()`/`NS()`, cada um em `R_code/modules/<nome>/{ui.R,server.R}`. O modulo `configuracoes` (consulta aos dados brutos) foi removido do projeto: a inspecao dos dados de origem passou a ser feita diretamente sobre as camadas do pipeline (`data/silver/`, `data/gold/`), fora da aplicacao.

| Modulo | Na navegacao? | Descricao |
|---|---|---|
| **Panorama geral** (`panorama_geral`) | Sim | Indicadores regionais, casos, obitos, sexo, faixa etaria e incidencia. |
| **Mapa por cidades** (`mapa_cidades`) | Sim | Mapa Leaflet, modal por cidade com casos acumulados, casos diarios, incidencia, viagem, sexo e indicadores de propagacao. |
| **Nivel de risco** (`nivel_risco`) | Sim | Rankings por risco estimado, data de referencia e escala linear ou logaritmica; modal de ajuda com video (`showModal`/`modalDialog`). |
| **Colaboradores** (`colaboradores`) | Sim | Informacoes institucionais das equipes participantes. Aba puramente estatica - `colaboradoresServer()` nao tem outputs proprios. |
| **Sobre** (`sobre`) | Sim | Objetivo, conteudo, organizacao e impacto do painel. Pagina Quarto estatica (`sobre.qmd` renderizado para `sobre.html`), incorporada via `iframe`; `sobreServer()` nao tem outputs proprios. |
| **Comportamento inicial** (`comportamento_inicial`) | Sim | Estimativas de atraso nas medidas de mitigacao e chegada de expostos, por cidade. |
| **Calculadora SEIR** (`calculadora`) | Sim | Controles para populacao, periodo, taxas e estados iniciais do modelo. |

Cada `ui.R` expoe uma funcao `<nome>UI(id)` (usada em `R_code/ui.R` dentro do `page_navbar(..., nav_panel(...))`) e cada `server.R` expoe `<nome>Server(id)` (chamada uma vez dentro de `server <- function(input, output, session) {...}` em `R_code/server.R`). O `mapa_cidades` tem uma peculiaridade: o painel exibido no modal ao clicar numa cidade vem de uma segunda funcao, `mapa_cidades_panelUI(id)`, chamada a partir do proprio `server.R` do modulo (e nao do `ui.R` principal), pois o conteudo do modal e montado dinamicamente no clique.

## Padroes de UI e graficos

- **Centralizacao das paginas**: cada `nav_panel(...)` em `R_code/ui.R` envolve a UI do modulo em `tags$div(class = "module-shell", ...)` (exceto `Sobre`, que gerencia seu proprio layout full-bleed via iframe). A classe `.module-shell` (definida em `assets/css/app.css`) limita a largura do conteudo a `--mla-max` (1180px) e centraliza na pagina - use o mesmo padrao ao adicionar um novo `nav_panel`.
- **Legendas dos graficos**: `dark_plotly()` (helper compartilhado em `R_code/components.R`, aplicado ao final de todo `renderPlotly` do projeto) fixa a legenda como horizontal e centralizada no topo do grafico (`orientation = "h"`, `x = 0.5, xanchor = "center"`, `y = 1.15, yanchor = "bottom"`). Como e aplicado por ultimo, sobrescreve qualquer `legend` definida antes no `layout()` do grafico - novos graficos herdam o padrao automaticamente ao encadear `%>% dark_plotly()`.
- **Modal por cidade (`mapa_cidades`)**: o painel exibido via `shinyWidgets::show_alert()` usa a classe `.mla-modal-panel` (ver `mapa_cidades_panelUI()`), com CSS proprio em `assets/css/app.css` para o tamanho e as cores do popup. O SweetAlert2 define `width`/tamanho via estilo inline por JavaScript depois que o CSS da pagina e lido, entao essas regras usam seletores compostos (`body .swal2-container .swal2-popup.swal2-popup`) e `!important` para vencer esse estilo inline - ajustes de tamanho/cor do modal devem seguir o mesmo padrao. O titulo do modal (`.mla-modal-panel h3`) fica em um "pill" branco com texto preto para garantir contraste independente do fundo escuro do popup.

## Instalacao e execucao

Na raiz do projeto, execute no R ou RStudio:

```r
install.packages("renv")
renv::restore()
renv::install("arrow")   # ainda nao esta no renv.lock; necessario para o pipeline e para R_code/data.R
Rscript pipeline/run_pipeline.R   # gera data/bronze, data/silver e data/gold
shiny::runApp()
```

Ou abra `app.R` no RStudio e execute a aplicacao pelo botao **Run App** (depois de rodar o pipeline pelo menos uma vez).

O comando `renv::restore()` instala as versoes registradas em `renv.lock`. Em uma maquina nova, a restauracao pode exigir ferramentas de compilacao ou bibliotecas do sistema para pacotes espaciais como `sf`. Depois de instalar `arrow`, rode `renv::snapshot()` para registra-lo no lockfile (ver "Reproducibilidade").

## Reproducibilidade

Depois de alterar dependencias, atualize o lockfile a partir de uma sessao limpa:

```r
renv::snapshot()
renv::status()
```

Nao versione `renv/library/`, caches ou bibliotecas locais. O arquivo `renv.lock` deve ser versionado, pois e o manifesto usado para reconstruir o ambiente.

## Desenvolvimento

Antes de abrir uma alteracao:

1. Confirme que os parquets esperados existem em `data/gold/` (rode `Rscript pipeline/run_pipeline.R` se `data/dataset.csv` ou os arquivos em `data/auxiliary/` tiverem mudado).
2. Preserve os IDs de inputs e outputs usados pela interface e pelo servidor - todos os modulos usam IDs namespaced (`ns("id")` no `ui.R`, lidos como `input$id`/`output$id` dentro do `moduleServer` correspondente).
3. Mantenha a ingestao/limpeza/agregacao de dados em `pipeline/` (nunca leia CSV/xlsx bruto em `R_code/`) - `R_code/data.R` so le `data/gold/*.parquet` e monta a apresentacao para os modulos.
4. Ao criar ou alterar um modulo: use `box_card()` (helper compartilhado em `R_code/constants.R`) em vez de `shinydashboard::box()`, namespaced todo `*Output(...)`/`inputId` com `ns()` no `ui.R`, use `getwd()` (nunca `project_root`) em qualquer `source()` interno ao `server.R` do modulo, e **nao use `shinyBS::bsModal()`/`toggleModal()`** - use `shiny::showModal(shiny::modalDialog(...))`, disparado por um `observeEvent()` no botao (veja `nivel_risco` como referencia).
5. Nao baixe a versao do `bs_theme()` em `R_code/theme.R` para resolver algum componente legado quebrado - `bslib::card()` exige Bootstrap 5+. Troque o componente incompativel por um equivalente nativo do Shiny em vez de mexer na versao do tema.
6. Execute `renv::status()` para verificar as dependencias.
7. Inicie o Shiny e teste as abas, filtros, tabelas, mapas e modais afetados.
8. Evite colocar datasets, scripts R ou artefatos gerados em `www/` ou `assets/`.
9. Ao editar `R_code/modules/sobre/sobre.qmd`, renderize o documento (`quarto render sobre.qmd` dentro de `R_code/modules/sobre/`) para atualizar `sobre.html` - o modulo `sobre` serve o HTML pre-renderizado via `iframe`, entao alteracoes no `.qmd` sozinhas nao aparecem na aplicacao.
10. Siga os padroes de UI e graficos descritos na secao "Padroes de UI e graficos" (centralizacao via `.module-shell`, legenda centralizada no topo via `dark_plotly()`, estilo do modal por cidade) ao adicionar novas abas, graficos ou modais.

## Validacao atual

A estrutura reorganizada foi validada com:

- parse (`parse()`) de todos os arquivos R do bootstrap, do tema e dos modulos;
- inicializacao real do servidor Shiny (`shiny::runApp`) e requisicao HTTP local com resposta `200`, confirmando que o bundle servido e Bootstrap 5 (`bootstrap-5.x.x/bootstrap.min.css`);
- testes isolados de UI e servidor com `shiny::testServer()` para os modulos, incluindo: cliques simulados no mapa (cidade com e sem dados de viagem), troca de escala Linear/Logaritmica e do gatilho de ajuda no ranking de risco, e o modelo SEIR com valores reais de entrada;
- verificacao de consistencia do ambiente `renv`.

Durante a inicializacao podem aparecer avisos de pacotes carregados previamente pelo ambiente local do R e avisos de deprecacao de componentes visuais. Eles nao impedem a execucao do painel.

## Seguranca e versionamento

O projeto possui credenciais legadas em `R_code/constants.R`. Elas nao devem ser reutilizadas em novos ambientes ou publicacoes. O recomendado e migrar usuarios e senhas para variaveis de ambiente ou um mecanismo externo de autenticacao.

O `.gitignore` exclui estado local do R/RStudio, tokens, caches, logs, bibliotecas do `renv`, artefatos de execucao e configuracoes de deploy. Dados necessarios para reproduzir a aplicacao devem permanecer versionados apenas quando a politica de dados do projeto permitir.

## Licenca e responsabilidade pelos dados

Este repositorio nao declara uma licenca especifica. Antes de redistribuir o codigo, imagens ou dados, confirme as permissoes dos respectivos autores e fontes institucionais. Os dados epidemiologicos devem ser tratados conforme as regras aplicaveis de privacidade, governanca e uso institucional.
