# Painel COVID-19 - 15a Regional de Saude do Parana

Aplicacao Shiny para monitoramento de casos, incidencia, obitos e indicadores epidemiologicos dos municipios da 15a Regional de Saude do Parana.

## Estrutura

- `app.R`: ponto unico de entrada da aplicacao.
- `R_code/packages.R`: carregamento dos pacotes.
- `R_code/functions.R`: funcoes auxiliares e calculos reutilizaveis.
- `R_code/constants.R`: credenciais legadas, constantes, temas e coordenadas.
- `R_code/data.R`: ingestao e preparacao dos dados para os paineis.
- `R_code/modules/`: componentes de UI das abas existentes.
- `R_code/ui.R` e `R_code/server.R`: composicao da interface e logica reativa.
- `www/`: datasets, imagens, JavaScript e CSS servidos pelo Shiny.
- `R_code/legacy/`: scripts antigos/experimentais mantidos para referencia, fora do fluxo de execucao.
- `renv.lock`: versoes das dependencias R usadas na aplicacao.

## Execucao

Com R instalado, a partir da raiz do projeto:

```r
renv::restore()
shiny::runApp()
```

O `app.R` ativa automaticamente o ambiente local quando `renv/activate.R` esta presente. Os dados principais sao lidos de `www/dataset.csv` e `www/pop_municipios.xlsx`.

## Dados e seguranca

Arquivos com credenciais, tokens, estado local do R/RStudio, caches e artefatos de execucao sao ignorados pelo Git. As credenciais atualmente presentes em `R_code/constants.R` sao um legado da aplicacao e devem ser substituidas por variaveis de ambiente antes de qualquer publicacao nova.

