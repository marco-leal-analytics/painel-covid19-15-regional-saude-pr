# Camada PRATA: leitura dos dados brutos (camada bronze, em data/bronze/,
# nos formatos originais de origem: .csv / .xlsx) e limpeza/tipagem/
# unificacao para parquet. Aqui vivem as regras de qualidade de dados:
# normalizacao de nomes de cidade, datas, sexo, idade, e o cruzamento
# (join) entre as fontes.

build_silver <- function(bronze_dir, silver_dir) {
  ensure_dir(silver_dir)

  log_step("PRATA: lendo casos notificados (bronze/dataset.csv)")
  # O arquivo de origem esta em Latin-1/Windows-1252 (nao UTF-8); fileEncoding
  # converte corretamente os acentos ao ler.
  casos_bronze <- read.table(
    file.path(bronze_dir, "dataset.csv"),
    header = TRUE, sep = ";", stringsAsFactors = FALSE, fileEncoding = "latin1"
  )

  log_step("PRATA: lendo populacao dos municipios (bronze/auxiliary/pop_municipios.xlsx)")
  populacao_bronze <- as.data.frame(readxl::read_xlsx(
    file.path(bronze_dir, "auxiliary", "pop_municipios.xlsx"),
    sheet = "Planilha1", col_names = TRUE
  ))

  log_step("PRATA: lendo coordenadas de bairros (bronze/auxiliary/latitude-longitude-bairros.csv)")
  bairros_bronze <- read.table(
    file.path(bronze_dir, "auxiliary", "latitude-longitude-bairros.csv"),
    header = TRUE, sep = ";", fileEncoding = "UTF-8", stringsAsFactors = FALSE
  )

  log_step("PRATA: limpando e unificando casos notificados")
  casos <- data.frame(
    NOTIFICA = parse_data_br(casos_bronze$notifica),
    CIDADE = resolve_municipio(casos_bronze$cidade),
    CIDADE_CHAVE = municipio_chave_app(resolve_municipio(casos_bronze$cidade)),
    NOME = trimws(casos_bronze$nome),
    IDADE = parse_idade(casos_bronze$idade),
    SEXO = normalize_sexo(casos_bronze$sexo),
    VIAJEM = casos_bronze$viajem,
    OBITO = normalize_sim_nao(casos_bronze$obito),
    COLETA = parse_data_br(casos_bronze$coleta),
    RESULTADOCOVID = trimws(casos_bronze$resultadocovid),
    ATUALIZADO = casos_bronze$atualizado,
    stringsAsFactors = FALSE
  )
  # NOTIFICA ausente: assume a data de coleta do exame (mesma regra da app original).
  falta_notifica <- is.na(casos$NOTIFICA)
  casos$NOTIFICA[falta_notifica] <- casos$COLETA[falta_notifica]

  arrow::write_parquet(casos, file.path(silver_dir, "casos.parquet"))

  log_step("PRATA: unificando cadastro de populacao dos municipios")
  colnames(populacao_bronze) <- c("MUNICIPIO_RAW", "POPULACAO")
  populacao <- data.frame(
    MUNICIPIO_RAW = populacao_bronze$MUNICIPIO_RAW,
    MUNICIPIO_CHAVE = compact_key(populacao_bronze$MUNICIPIO_RAW),
    POPULACAO = suppressWarnings(as.numeric(populacao_bronze$POPULACAO)),
    stringsAsFactors = FALSE
  )
  # A primeira linha da planilha e o total da regional ("15 RS"), nao um municipio.
  populacao_regional <- populacao[1, , drop = FALSE]
  populacao_municipios <- populacao[-1, , drop = FALSE]
  populacao_municipios$CIDADE <- resolve_municipio(populacao_municipios$MUNICIPIO_RAW)
  populacao_municipios$CIDADE_CHAVE <- municipio_chave_app(populacao_municipios$CIDADE)

  arrow::write_parquet(populacao_municipios, file.path(silver_dir, "populacao_municipios.parquet"))
  arrow::write_parquet(populacao_regional, file.path(silver_dir, "populacao_regional.parquet"))

  log_step("PRATA: filtrando bairros dos municipios da 15a regional")
  bairros <- bairros_bronze
  bairros$MUNICIPIO_CHAVE <- compact_key(bairros$municipio)
  municipios_chave <- municipio_chave_app(municipios_15_regional)
  bairros_15regional <- bairros[bairros$uf == "PR" & bairros$MUNICIPIO_CHAVE %in% municipios_chave, ]
  bairros_15regional$CIDADE <- resolve_municipio(bairros_15regional$municipio)

  arrow::write_parquet(bairros_15regional, file.path(silver_dir, "bairros_15regional.parquet"))

  invisible(list(
    casos = casos,
    populacao_municipios = populacao_municipios,
    populacao_regional = populacao_regional,
    bairros_15regional = bairros_15regional
  ))
}
