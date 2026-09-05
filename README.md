# Painel COVID-19 - 15a Regional de Saude do Parana

Aplicacao interativa desenvolvida em R e Shiny para apoiar o acompanhamento epidemiologico dos municipios da 15a Regional de Saude do Parana.

O painel transforma registros de casos em indicadores, tabelas, mapas e graficos para analise da distribuicao e da evolucao da COVID-19. A aplicacao preserva o fluxo historico de autenticacao, navegacao por abas e visualizacao dos dados regionais.

## Objetivos

- Consolidar os registros epidemiologicos dos municipios da regional.
- Apresentar casos por dia, casos acumulados e incidencia por milhao de habitantes.
- Disponibilizar indicadores de obitos, sexo e faixa etaria.
- Permitir a consulta dos dados por municipio em mapas e graficos interativos.
- Exibir rankings de risco e estimativas relacionadas a propagacao da doenca.
- Oferecer uma calculadora baseada no modelo SEIR para simulacoes exploratorias.
- Apoiar a comunicacao dos resultados para equipes de saude e colaboradores.

## Tecnologias

- R 4.x
- Shiny
- `bslib` para o tema visual (Bootstrap 5, cores, tipografia e componentes `card`)
- Shiny Dashboard e Shiny Dashboard Plus (componentes legados, em migracao para `bslib`)
- `plotly` para graficos interativos
- `leaflet` e `sf` para mapas e dados espaciais
- `DT` para tabelas interativas
- `dplyr`, `tidyverse`, `stringr` e `lubridate` para tratamento dos dados
- `readxl` para leitura da planilha populacional
- `brazilmaps` para limites geograficos dos municipios
- `deSolve` e `EpiDynamics` para componentes de modelagem
- `shinyWidgets`, `shinyjs` e `shinyBS` para controles e interacoes da interface
- `ggplot2`, `gganimate` e `gifski` para visualizacoes e animacoes
- `sass` para compilar as regras de tema definidas em `assets/sass/`
- `renv` para reproducibilidade das dependencias

A lista completa, incluindo versoes resolvidas e dependencias transitivas, esta em `renv.lock`.

## Arquitetura

O ponto de entrada e `app.R`. Ele define a raiz do projeto, ativa o `renv`, carrega os pacotes, prepara os dados, monta o tema `bslib`, carrega os modulos de interface e cria o objeto `shinyApp`.

O projeto esta em migracao incremental de um `server.R` monolitico para modulos Shiny reais (`moduleServer()`/`NS()`), um por aba, cada um em sua propria pasta com `ui.R` e `server.R`. Ate o momento, **panorama_geral**, **mapa_cidades** e **nivel_risco** ja seguem esse padrao; **colaboradores**, **calculadora**, **configuracoes** e **comportamento_inicial** ainda estao no formato legado (um unico arquivo com um objeto `tabPanel` global e outputs soltos em `server.R`) e serao convertidos nas proximas etapas.

```text
.
|-- app.R                         # Bootstrap e ponto de entrada Shiny
|-- assets/                       # Design system (tema bslib e estilos)
|   |-- sass/                     # Tokens (_variables.scss, _mixins.scss, main.scss)
|   |-- css/                      # CSS compilado adicional (app.css)
|   `-- www/                      # Estilos e imagens complementares servidos via /assets
|-- R_code/
|   |-- packages.R                # Pacotes usados pela aplicacao (inclui bslib)
|   |-- functions.R               # Funcoes auxiliares reutilizaveis
|   |-- constants.R               # Constantes, helpers de UI (ex.: box_card()) e configuracoes legadas
|   |-- theme.R                   # Definicao do bs_theme() a partir dos tokens em assets/
|   |-- data.R                    # Ingestao e preparacao dos dados
|   |-- ui.R                      # Composicao principal da interface (fluidPage com theme = app_theme)
|   |-- server.R                  # Logica reativa e outputs das abas ainda nao modularizadas
|   |-- modules/                  # Componentes das abas do painel
|   |   |-- panorama_geral/       # ui.R + server.R (modulo Shiny real)
|   |   |-- mapa_cidades/         # ui.R + server.R (modulo Shiny real)
|   |   |-- nivel_risco/          # ui.R + server.R (modulo Shiny real)
|   |   |-- colaboradores.R       # legado (a converter)
|   |   |-- calculadora.R         # legado (a converter)
|   |   |-- configuracoes.R       # legado (a converter)
|   |   `-- comportamento_inicial.R # legado (a converter)
|   `-- legacy/                   # Scripts antigos ainda referenciados via source()
|-- data/
|   |-- dataset.csv              # Dataset principal utilizado no painel
|   |-- dataset2.csv             # Dataset historico/alternativo
|   |-- obitos.csv               # Base auxiliar de obitos
|   `-- auxiliary/
|       |-- pop_municipios.xlsx  # Populacao usada na incidencia
|       |-- latitude-longitude-bairros.csv
|       |-- table.RData
|       `-- F4993300
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
6. `R_code/data.R` le os arquivos de `data/` e prepara os objetos analiticos.
7. Os arquivos de `R_code/modules/` (pastas com `ui.R`/`server.R` para os modulos ja migrados, ou arquivo unico para os legados) constroem as abas e componentes da interface.
8. `R_code/ui.R` monta a interface principal com `fluidPage(theme = app_theme, ...)`.
9. `R_code/server.R` registra a reatividade das abas ainda nao modularizadas, chama `*Server(id)` dos modulos ja convertidos, e cuida de login e navegacao.
10. `shinyApp(ui = ui, server = server)` inicia a aplicacao.

> Nota sobre `source()` dentro de `server.R`: como o Shiny executa `app.R` em um ambiente proprio (nao o `.GlobalEnv`) e os `source()` internos de `app.R` avaliam o conteudo no `.GlobalEnv` por padrao, qualquer caminho de arquivo usado dentro de `server.R`/modulos deve ser construido com `getwd()` (jamais com a variavel `project_root`, que so existe no escopo do proprio `app.R`).

## Dados

Os dados nao sao mais armazenados em `www/`. Essa pasta e reservada a arquivos que o navegador precisa acessar diretamente.

### Dataset principal

`data/dataset.csv` e a fonte principal carregada por `R_code/data.R`. O arquivo usa separador `;` e possui campos como municipio, datas, sexo, idade, viagem, obito e resultado do exame.

### Dados auxiliares

- `data/auxiliary/pop_municipios.xlsx`: populacao municipal utilizada nos calculos de incidencia.
- `data/auxiliary/latitude-longitude-bairros.csv`: coordenadas e identificacao de bairros.
- `data/obitos.csv`: base auxiliar historica de obitos.
- `data/dataset2.csv`: versao historica ou alternativa do dataset principal.
- `data/auxiliary/table.RData` e `data/auxiliary/F4993300`: artefatos auxiliares preservados para compatibilidade e referencia.

Para atualizar os dados, substitua os arquivos mantendo os nomes, colunas esperadas, separadores e formatos. Alteracoes no schema podem exigir ajustes em `R_code/data.R`, `R_code/server.R` e nos modulos que usam os objetos preparados.

## Modulos do painel

| Modulo | Status | Descricao |
|---|---|---|
| **Panorama geral** (`panorama_geral`) | Migrado (`moduleServer`/`NS`) | Indicadores regionais, casos, obitos, sexo, faixa etaria e incidencia. |
| **Mapa por cidades** (`mapa_cidades`) | Migrado (`moduleServer`/`NS`) | Mapa Leaflet, modal por cidade com casos acumulados, casos diarios, incidencia, viagem, sexo e indicadores de propagacao. |
| **Nivel de risco** (`nivel_risco`) | Migrado (`moduleServer`/`NS`) | Rankings por risco estimado, data de referencia e escala linear ou logaritmica. |
| **Colaboradores** | Legado | Informacoes institucionais das equipes participantes. |
| **Configuracoes** | Legado | Consulta dos dados brutos, tabelas de casos e populacao; acesso condicionado ao usuario autorizado. |
| **Calculadora SEIR** | Legado | Controles para populacao, periodo, taxas e estados iniciais do modelo. |
| **Comportamento inicial** | Legado, fora da navegacao | Modulo historico mantido em `R_code/modules/`, nao esta ligado a nenhuma aba visivel atualmente. |

Nos modulos ja migrados, cada `ui.R` expoe uma funcao `<nome>UI(id)` (usada em `server.R` dentro do `tabsetPanel(id = 'navbar', ...)`) e cada `server.R` expoe `<nome>Server(id)` (chamada uma vez dentro de `server <- function(input, output, session) {...}`). O `mapa_cidades` tem uma peculiaridade: o painel exibido no modal ao clicar numa cidade vem de uma segunda funcao, `mapa_cidades_panelUI(id)`, chamada a partir do proprio `server.R` do modulo (e nao do `ui.R` principal), pois o conteudo do modal e montado dinamicamente no clique.

## Instalacao e execucao

Na raiz do projeto, execute no R ou RStudio:

```r
install.packages("renv")
renv::restore()
shiny::runApp()
```

Ou abra `app.R` no RStudio e execute a aplicacao pelo botao **Run App**.

O comando `renv::restore()` instala as versoes registradas em `renv.lock`. Em uma maquina nova, a restauracao pode exigir ferramentas de compilacao ou bibliotecas do sistema para pacotes espaciais como `sf`.

## Reproducibilidade

Depois de alterar dependencias, atualize o lockfile a partir de uma sessao limpa:

```r
renv::snapshot()
renv::status()
```

Nao versione `renv/library/`, caches ou bibliotecas locais. O arquivo `renv.lock` deve ser versionado, pois e o manifesto usado para reconstruir o ambiente.

## Desenvolvimento

Antes de abrir uma alteracao:

1. Confirme que os dados esperados existem em `data/`.
2. Preserve os IDs de inputs e outputs usados pela interface e pelo servidor. Nos modulos ja migrados, os IDs sao namespaced (`ns("id")` no `ui.R`); em modulos legados, os IDs ainda sao globais e compartilhados com `server.R`.
3. Mantenha a ingestao de dados em `R_code/data.R` e a apresentacao nos modulos.
4. Ao converter um modulo legado para o padrao `ui.R`/`server.R`: crie a pasta `R_code/modules/<nome>/`, troque `shinydashboard::box()` por `box_card()` (helper compartilhado em `R_code/constants.R`), namespaced todos os `*Output(...)` com `ns()`, use `getwd()` (nunca `project_root`) em qualquer `source()` interno, e atualize `app.R` (source dos dois arquivos), `R_code/server.R` (chamada `<nome>Server(id)` e troca do objeto global por `<nome>UI(id)` no `tabsetPanel`).
5. Execute `renv::status()` para verificar as dependencias.
6. Inicie o Shiny e teste as abas, filtros, tabelas, mapas e autenticacao afetados.
7. Evite colocar datasets, scripts R ou artefatos gerados em `www/` ou `assets/`.

## Validacao atual

A estrutura reorganizada foi validada com:

- parse (`parse()`) de todos os arquivos R do bootstrap, do tema e dos modulos;
- inicializacao real do servidor Shiny (`shiny::runApp`) e requisicao HTTP local com resposta `200`;
- testes isolados de UI e servidor com `shiny::testServer()` para cada modulo migrado (`panorama_geral`, `mapa_cidades`, `nivel_risco`), incluindo simulacao de cliques no mapa e troca de escala Linear/Logaritmica no ranking de risco;
- verificacao de consistencia do ambiente `renv`.

Durante a inicializacao podem aparecer avisos de pacotes carregados previamente pelo ambiente local do R e avisos de deprecacao de componentes visuais. Eles nao impedem a execucao do painel.

## Seguranca e versionamento

O projeto possui credenciais legadas em `R_code/constants.R`. Elas nao devem ser reutilizadas em novos ambientes ou publicacoes. O recomendado e migrar usuarios e senhas para variaveis de ambiente ou um mecanismo externo de autenticacao.

O `.gitignore` exclui estado local do R/RStudio, tokens, caches, logs, bibliotecas do `renv`, artefatos de execucao e configuracoes de deploy. Dados necessarios para reproduzir a aplicacao devem permanecer versionados apenas quando a politica de dados do projeto permitir.

## Licenca e responsabilidade pelos dados

Este repositorio nao declara uma licenca especifica. Antes de redistribuir o codigo, imagens ou dados, confirme as permissoes dos respectivos autores e fontes institucionais. Os dados epidemiologicos devem ser tratados conforme as regras aplicaveis de privacidade, governanca e uso institucional.
