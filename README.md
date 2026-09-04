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
- Shiny Dashboard e Shiny Dashboard Plus
- `plotly` para graficos interativos
- `leaflet` e `sf` para mapas e dados espaciais
- `DT` para tabelas interativas
- `dplyr`, `tidyverse`, `stringr` e `lubridate` para tratamento dos dados
- `readxl` para leitura da planilha populacional
- `brazilmaps` para limites geograficos dos municipios
- `deSolve` e `EpiDynamics` para componentes de modelagem
- `shinyWidgets`, `shinyjs` e `shinyBS` para controles e interacoes da interface
- `ggplot2`, `gganimate` e `gifski` para visualizacoes e animacoes
- `renv` para reproducibilidade das dependencias

A lista completa, incluindo versoes resolvidas e dependencias transitivas, esta em `renv.lock`.

## Arquitetura

O ponto de entrada e `app.R`. Ele define a raiz do projeto, ativa o `renv`, carrega os pacotes, prepara os dados, carrega os modulos de interface e cria o objeto `shinyApp`.

```text
.
|-- app.R                         # Bootstrap e ponto de entrada Shiny
|-- R_code/
|   |-- packages.R                # Pacotes usados pela aplicacao
|   |-- functions.R               # Funcoes auxiliares reutilizaveis
|   |-- constants.R               # Constantes, temas e configuracoes legadas
|   |-- data.R                    # Ingestao e preparacao dos dados
|   |-- ui.R                      # Composicao principal da interface
|   |-- server.R                  # Logica reativa e outputs
|   |-- modules/                  # Componentes das abas do painel
|   |   |-- panorama_geral.R
|   |   |-- mapa_cidades.R
|   |   |-- nivel_risco.R
|   |   |-- colaboradores.R
|   |   |-- calculadora.R
|   |   |-- configuracoes.R
|   |   `-- comportamento_inicial.R
|   `-- legacy/                   # Scripts antigos mantidos para referencia
|-- data/
|   |-- dataset.csv              # Dataset principal utilizado no painel
|   |-- dataset2.csv             # Dataset historico/alternativo
|   |-- obitos.csv               # Base auxiliar de obitos
|   `-- auxiliary/
|       |-- pop_municipios.xlsx  # Populacao usada na incidencia
|       |-- latitude-longitude-bairros.csv
|       |-- table.RData
|       `-- F4993300
|-- www/                         # Recursos publicados pelo Shiny
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
3. `R_code/packages.R` carrega os pacotes da aplicacao.
4. `R_code/functions.R` e `R_code/constants.R` disponibilizam funcoes e configuracoes.
5. `R_code/data.R` le os arquivos de `data/` e prepara os objetos analiticos.
6. Os arquivos de `R_code/modules/` constroem as abas e componentes da interface.
7. `R_code/ui.R` monta a interface principal.
8. `R_code/server.R` registra reatividade, tabelas, graficos, mapas, login e navegacao.
9. `shinyApp(ui = ui, server = server)` inicia a aplicacao.

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

- **Panorama geral**: indicadores regionais, casos, obitos, sexo, faixa etaria e incidencia.
- **Mapa por cidades**: mapas municipais, casos acumulados, casos diarios, incidencia, viagem, sexo e indicadores de propagacao.
- **Nivel de risco**: rankings por risco estimado, data de referencia e escala linear ou logaritmica.
- **Colaboradores**: informacoes institucionais das equipes participantes.
- **Configuracoes**: consulta dos dados brutos, tabelas de casos e populacao; acesso condicionado ao usuario autorizado.
- **Calculadora SEIR**: controles para populacao, periodo, taxas e estados iniciais do modelo.
- **Comportamento inicial**: modulo historico mantido em `R_code/modules/`, atualmente fora da navegacao principal.

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
2. Preserve os IDs de inputs e outputs usados pela interface e pelo servidor.
3. Mantenha a ingestao de dados em `R_code/data.R` e a apresentacao nos modulos.
4. Execute `renv::status()` para verificar as dependencias.
5. Inicie o Shiny e teste as abas, filtros, tabelas, mapas e autenticacao afetados.
6. Evite colocar datasets, scripts R ou artefatos gerados em `www/`.

## Validacao atual

A estrutura reorganizada foi validada com:

- parse dos arquivos R do bootstrap e dos componentes principais;
- verificacao dos caminhos de dados;
- inicializacao do servidor Shiny;
- requisicao HTTP local com resposta `200`;
- verificacao de consistencia do ambiente `renv`.

Durante a inicializacao podem aparecer avisos de pacotes carregados previamente pelo ambiente local do R e avisos de deprecacao de componentes visuais. Eles nao impedem a execucao do painel.

## Seguranca e versionamento

O projeto possui credenciais legadas em `R_code/constants.R`. Elas nao devem ser reutilizadas em novos ambientes ou publicacoes. O recomendado e migrar usuarios e senhas para variaveis de ambiente ou um mecanismo externo de autenticacao.

O `.gitignore` exclui estado local do R/RStudio, tokens, caches, logs, bibliotecas do `renv`, artefatos de execucao e configuracoes de deploy. Dados necessarios para reproduzir a aplicacao devem permanecer versionados apenas quando a politica de dados do projeto permitir.

## Licenca e responsabilidade pelos dados

Este repositorio nao declara uma licenca especifica. Antes de redistribuir o codigo, imagens ou dados, confirme as permissoes dos respectivos autores e fontes institucionais. Os dados epidemiologicos devem ser tratados conforme as regras aplicaveis de privacidade, governanca e uso institucional.
