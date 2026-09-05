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

- **Painel Geral**: indicadores consolidados de casos confirmados e obitos, distribuicao por sexo e por faixa etaria, evolucao diaria e acumulada de casos, incidencia por milhao de habitantes e comparativo entre municipios.
- **Mapa de cidades**: mapa interativo (Leaflet) com os casos confirmados por municipio; ao clicar em uma cidade abre um painel detalhado com serie historica, incidencia, faixa etaria e indicadores de viagem.
- **Nivel de risco**: ranking dos municipios segundo o risco estimado de aumento de casos, calculado a partir da prevalencia das infeccoes, da taxa de propagacao estimada e do tamanho da populacao.
- **Comportamento inicial**: simulacoes de como o atraso na adocao de medidas de mitigacao ou a chegada de pessoas expostas afeta o crescimento inicial da epidemia em uma cidade escolhida.
- **Calculadora SEIR**: simulacao da evolucao da epidemia com o modelo SEIR (Suscetiveis-Expostos-Infectados-Recuperados), ajustando populacao, taxas de propagacao, incubacao, recuperacao e valores iniciais.
- **Colaboradores**: equipe responsavel pelo acompanhamento epidemiologico da regional e pelo desenvolvimento estatistico e computacional do painel, em parceria com os departamentos de Estatistica e Matematica da UEM.
- **Configuracoes**: consulta aos dados brutos e as tabelas de casos e populacao utilizadas pelo painel (disponivel apos login).
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
- `brazilmaps` para limites geograficos dos municipios
- `deSolve` e `EpiDynamics` para componentes de modelagem
- `shinyWidgets`, `shinyjs` e `shinyBS` para controles e interacoes da interface
- `ggplot2`, `gganimate` e `gifski` para visualizacoes e animacoes
- `sass` para compilar as regras de tema definidas em `assets/sass/`
- `renv` para reproducibilidade das dependencias

A lista completa, incluindo versoes resolvidas e dependencias transitivas, esta em `renv.lock`.

## Arquitetura

O ponto de entrada e `app.R`. Ele define a raiz do projeto, ativa o `renv`, carrega os pacotes, prepara os dados, monta o tema `bslib`, carrega os modulos de interface e cria o objeto `shinyApp`.

O projeto foi migrado de um `server.R` monolitico para modulos Shiny reais (`moduleServer()`/`NS()`), um por aba, cada um em sua propria pasta com `ui.R` e `server.R`. Os 8 modulos (`panorama_geral`, `mapa_cidades`, `nivel_risco`, `colaboradores`, `calculadora`, `comportamento_inicial`, `configuracoes` e `sobre`) ja seguem esse padrao. `R_code/server.R` continua existindo, mas hoje cuida apenas do login/navegacao e das chamadas `*Server(id)` de cada modulo - nao ha mais outputs soltos de aba nesse arquivo.

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
|   |-- theme.R                   # Definicao do bs_theme() a partir dos tokens em assets/ (version = 5, obrigatorio)
|   |-- data.R                    # Ingestao e preparacao dos dados
|   |-- ui.R                      # Composicao principal da interface (fluidPage com theme = app_theme)
|   |-- server.R                  # Login, navegacao e chamadas *Server(id) de cada modulo
|   |-- modules/                  # Um modulo Shiny real por aba (ui.R + server.R)
|   |   |-- panorama_geral/
|   |   |-- mapa_cidades/
|   |   |-- nivel_risco/
|   |   |-- colaboradores/
|   |   |-- calculadora/
|   |   |-- configuracoes/
|   |   |-- comportamento_inicial/
|   |   `-- sobre/                 # Pagina Quarto (sobre.qmd -> sobre.html), incorporada via iframe
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
7. Os arquivos de `R_code/modules/<nome>/{ui.R,server.R}` sao carregados aos pares - cada um define `<nome>UI(id)` e `<nome>Server(id)`.
8. `R_code/ui.R` monta a interface principal com `fluidPage(theme = app_theme, ...)`.
9. `R_code/server.R` chama `<nome>Server(id)` de cada modulo e monta o `tabsetPanel(id = 'navbar', <nome1>UI("id1"), ...)` com as UIs; tambem cuida de login, logout e da liberacao condicional da aba "Configuracoes" via `appendTab()`.
10. `shinyApp(ui = ui, server = server)` inicia a aplicacao.

> Nota sobre `source()` dentro de `server.R`: como o Shiny executa `app.R` em um ambiente proprio (nao o `.GlobalEnv`) e os `source()` internos de `app.R` avaliam o conteudo no `.GlobalEnv` por padrao, qualquer caminho de arquivo usado dentro de `server.R`/modulos deve ser construido com `getwd()` (jamais com a variavel `project_root`, que so existe no escopo do proprio `app.R`).

> Nota sobre modais: `shinyBS::bsModal()` depende do jQuery/`data-toggle` do Bootstrap 3-4 e nao funciona sob `bs_theme(version = 5)` (o Bootstrap 5 removeu o jQuery e renomeou esses atributos para `data-bs-*`) - o clique no gatilho simplesmente nao abre nada, sem erro no console. Use sempre `shiny::showModal(shiny::modalDialog(...))` (nativo do Shiny, compativel com qualquer Bootstrap) em vez de `bsModal`/`toggleModal`. O modulo `nivel_risco` segue esse padrao (`observeEvent(input$Id113, { showModal(...) })`).

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

Todos os 8 modulos seguem o padrao `moduleServer()`/`NS()`, cada um em `R_code/modules/<nome>/{ui.R,server.R}`.

| Modulo | Na navegacao? | Descricao |
|---|---|---|
| **Panorama geral** (`panorama_geral`) | Sim | Indicadores regionais, casos, obitos, sexo, faixa etaria e incidencia. |
| **Mapa por cidades** (`mapa_cidades`) | Sim | Mapa Leaflet, modal por cidade com casos acumulados, casos diarios, incidencia, viagem, sexo e indicadores de propagacao. |
| **Nivel de risco** (`nivel_risco`) | Sim | Rankings por risco estimado, data de referencia e escala linear ou logaritmica; modal de ajuda com video (`showModal`/`modalDialog`). |
| **Colaboradores** (`colaboradores`) | Sim | Informacoes institucionais das equipes participantes. Aba puramente estatica - `colaboradoresServer()` nao tem outputs proprios. |
| **Sobre** (`sobre`) | Sim | Objetivo, conteudo, organizacao e impacto do painel. Pagina Quarto estatica (`sobre.qmd` renderizado para `sobre.html`), incorporada via `iframe`; `sobreServer()` nao tem outputs proprios. |
| **Configuracoes** (`configuracoes`) | Condicional | Consulta dos dados brutos, tabelas de casos e populacao. So aparece apos login do usuario `mleal`, via `appendTab(inputId = "navbar", configuracoesUI("configuracoes"))` dentro do `observeEvent(input$login)` em `R_code/server.R`. |
| **Calculadora SEIR** (`calculadora`) | Nao | Controles para populacao, periodo, taxas e estados iniciais do modelo. Modulo funcional, mas a referencia em `R_code/ui.R` (dentro do objeto `mais`) esta comentada. |
| **Comportamento inicial** (`comportamento_inicial`) | Nao | Estimativas de atraso nas medidas de mitigacao e chegada de expostos, por cidade. Mesmo status do `calculadora`: funcional, porem fora da navegacao (referencia comentada em `mais`). |

Cada `ui.R` expoe uma funcao `<nome>UI(id)` (usada em `R_code/server.R` dentro do `tabsetPanel(id = 'navbar', ...)`, ou via `appendTab()` no caso de `configuracoes`) e cada `server.R` expoe `<nome>Server(id)` (chamada uma vez dentro de `server <- function(input, output, session) {...}`). O `mapa_cidades` tem uma peculiaridade: o painel exibido no modal ao clicar numa cidade vem de uma segunda funcao, `mapa_cidades_panelUI(id)`, chamada a partir do proprio `server.R` do modulo (e nao do `ui.R` principal), pois o conteudo do modal e montado dinamicamente no clique.

Para religar `calculadora`/`comportamento_inicial` na navegacao: descomente as chamadas correspondentes (`calculadora_seirUI("calculadora")` / `comportamento_inicialUI("comportamento_inicial")`) dentro do objeto `mais` em `R_code/ui.R`, e garanta que os respectivos `*Server(id)` (ja chamados em `R_code/server.R`) usem o mesmo `id` passado na UI.

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
2. Preserve os IDs de inputs e outputs usados pela interface e pelo servidor - todos os modulos usam IDs namespaced (`ns("id")` no `ui.R`, lidos como `input$id`/`output$id` dentro do `moduleServer` correspondente).
3. Mantenha a ingestao de dados em `R_code/data.R` e a apresentacao nos modulos.
4. Ao criar ou alterar um modulo: use `box_card()` (helper compartilhado em `R_code/constants.R`) em vez de `shinydashboard::box()`, namespaced todo `*Output(...)`/`inputId` com `ns()` no `ui.R`, use `getwd()` (nunca `project_root`) em qualquer `source()` interno ao `server.R` do modulo, e **nao use `shinyBS::bsModal()`/`toggleModal()`** - use `shiny::showModal(shiny::modalDialog(...))`, disparado por um `observeEvent()` no botao (veja `nivel_risco` como referencia).
5. Nao baixe a versao do `bs_theme()` em `R_code/theme.R` para resolver algum componente legado quebrado - `bslib::card()` exige Bootstrap 5+. Troque o componente incompativel por um equivalente nativo do Shiny em vez de mexer na versao do tema.
6. Execute `renv::status()` para verificar as dependencias.
7. Inicie o Shiny e teste as abas, filtros, tabelas, mapas, modais e autenticacao afetados.
8. Evite colocar datasets, scripts R ou artefatos gerados em `www/` ou `assets/`.
9. Ao editar `R_code/modules/sobre/sobre.qmd`, renderize o documento (`quarto render sobre.qmd` dentro de `R_code/modules/sobre/`) para atualizar `sobre.html` - o modulo `sobre` serve o HTML pre-renderizado via `iframe`, entao alteracoes no `.qmd` sozinhas nao aparecem na aplicacao.

## Validacao atual

A estrutura reorganizada foi validada com:

- parse (`parse()`) de todos os arquivos R do bootstrap, do tema e dos modulos;
- inicializacao real do servidor Shiny (`shiny::runApp`) e requisicao HTTP local com resposta `200`, confirmando que o bundle servido e Bootstrap 5 (`bootstrap-5.x.x/bootstrap.min.css`);
- testes isolados de UI e servidor com `shiny::testServer()` para cada um dos 7 modulos, incluindo: cliques simulados no mapa (cidade com e sem dados de viagem), troca de escala Linear/Logaritmica e do gatilho de ajuda no ranking de risco, troca das 3 opcoes de dados em Configuracoes, e o modelo SEIR com valores reais de entrada;
- teste do fluxo de login completo (`shiny::testServer(server, {...})` com as credenciais reais do usuario `mleal`), validando o `appendTab()` que libera a aba Configuracoes;
- verificacao de consistencia do ambiente `renv`.

Durante a inicializacao podem aparecer avisos de pacotes carregados previamente pelo ambiente local do R e avisos de deprecacao de componentes visuais. Eles nao impedem a execucao do painel.

## Seguranca e versionamento

O projeto possui credenciais legadas em `R_code/constants.R`. Elas nao devem ser reutilizadas em novos ambientes ou publicacoes. O recomendado e migrar usuarios e senhas para variaveis de ambiente ou um mecanismo externo de autenticacao.

O `.gitignore` exclui estado local do R/RStudio, tokens, caches, logs, bibliotecas do `renv`, artefatos de execucao e configuracoes de deploy. Dados necessarios para reproduzir a aplicacao devem permanecer versionados apenas quando a politica de dados do projeto permitir.

## Licenca e responsabilidade pelos dados

Este repositorio nao declara uma licenca especifica. Antes de redistribuir o codigo, imagens ou dados, confirme as permissoes dos respectivos autores e fontes institucionais. Os dados epidemiologicos devem ser tratados conforme as regras aplicaveis de privacidade, governanca e uso institucional.
