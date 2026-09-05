# Pipeline de dados do painel COVID-19 / 15a Regional de Saude do Parana.
#
# Roda de forma totalmente EXTERNA a aplicacao Shiny (nao e sourced pelo
# app.R). Le os dados brutos ja pousados em data/bronze/ (nos formatos
# originais de origem: .csv / .xlsx) e produz duas camadas em parquet:
#
#   data/bronze/  -> pouso dos arquivos brutos, no formato original da fonte
#                    (.csv / .xlsx) — NAO gerado pelo pipeline, apenas lido
#   data/silver/  -> limpeza, tipagem e unificacao entre fontes (parquet)
#   data/gold/    -> agregados e tabelas refinadas, prontas para o painel ler
#                    (parquet)
#
# Uso (a partir da raiz do projeto):
#   Rscript pipeline/run_pipeline.R
#
# Pre-requisito: pacotes `arrow` e `readxl` instalados (renv::install(c("arrow","readxl"))).
# Rode este script sempre que um novo arquivo de dados (data/bronze/dataset.csv,
# data/bronze/auxiliary/pop_municipios.xlsx, data/bronze/auxiliary/latitude-longitude-bairros.csv)
# for atualizado. O aplicativo (app.R) le exclusivamente os parquets gerados
# em data/gold/.

find_script_path <- function() {
  # Rscript pipeline/run_pipeline.R
  file_arg <- grep("^--file=", commandArgs(trailingOnly = FALSE), value = TRUE)
  if (length(file_arg) > 0) return(sub("^--file=", "", file_arg[1]))
  # source("pipeline/run_pipeline.R") dentro de uma sessao R interativa
  ofile <- tryCatch(sys.frame(1)$ofile, error = function(e) NULL)
  if (!is.null(ofile)) return(ofile)
  NULL
}

script_path <- find_script_path()
project_root <- if (!is.null(script_path)) {
  dirname(dirname(normalizePath(script_path)))
} else {
  normalizePath(getwd())
}

if (file.exists(file.path(project_root, "renv/activate.R"))) {
  source(file.path(project_root, "renv/activate.R"), encoding = "UTF-8")
}

if (!requireNamespace("arrow", quietly = TRUE)) {
  stop("O pacote 'arrow' e necessario para rodar o pipeline. Instale com renv::install('arrow').")
}
if (!requireNamespace("readxl", quietly = TRUE)) {
  stop("O pacote 'readxl' e necessario para rodar o pipeline. Instale com renv::install('readxl').")
}

source(file.path(project_root, "pipeline/R/00_utils.R"), encoding = "UTF-8")
source(file.path(project_root, "pipeline/R/01_silver.R"), encoding = "UTF-8")
source(file.path(project_root, "pipeline/R/02_gold.R"), encoding = "UTF-8")

bronze_dir <- file.path(project_root, "data", "bronze")
silver_dir <- file.path(project_root, "data", "silver")
gold_dir <- file.path(project_root, "data", "gold")

if (!file.exists(file.path(bronze_dir, "dataset.csv"))) {
  stop(sprintf("Arquivo bruto nao encontrado: %s. A camada bronze deve conter os arquivos originais (.csv/.xlsx).", file.path(bronze_dir, "dataset.csv")))
}

log_step("Iniciando pipeline de dados (bronze -> prata -> ouro)")
build_silver(bronze_dir, silver_dir)
build_gold(silver_dir, gold_dir)
log_step("Pipeline concluido. Camada ouro disponivel em: %s", gold_dir)
