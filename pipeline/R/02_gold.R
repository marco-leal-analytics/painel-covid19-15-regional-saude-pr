# Camada OURO: le a camada prata (data/silver/) e produz dados refinados e
# agregados, prontos para o painel consumir diretamente (a aplicacao so faz
# leitura destes arquivos, sem nenhuma transformacao adicional).

build_gold <- function(silver_dir, gold_dir) {
  ensure_dir(gold_dir)

  casos <- arrow::read_parquet(file.path(silver_dir, "casos.parquet"))
  populacao_municipios <- arrow::read_parquet(file.path(silver_dir, "populacao_municipios.parquet"))
  populacao_regional <- arrow::read_parquet(file.path(silver_dir, "populacao_regional.parquet"))
  bairros_15regional <- arrow::read_parquet(file.path(silver_dir, "bairros_15regional.parquet"))

  cidades <- municipios_15_regional
  chaves <- municipio_chave_app(cidades)
  label_faixa_etaria <- c("0 - 09", "10 - 18", "19 - 40", "41 - 60", "61 - 80", "81+")
  breaks_faixa_etaria <- c(0, 10, 19, 41, 61, 81, 150)

  datas <- seq(min(casos$COLETA, na.rm = TRUE), max(casos$COLETA, na.rm = TRUE), by = "days")

  # ---------------------------------------------------------------------
  # CASOS POR DIA (equivalente a `data_casos`)
  # ---------------------------------------------------------------------
  log_step("OURO: construindo casos por dia (regional e por municipio)")
  casos_por_dia <- data.frame(label_datas = datas)
  casos_por_dia$REGIONAL <- as.integer(table(factor(casos$COLETA, levels = as.character(datas)))[as.character(datas)])
  casos_por_dia$REGIONAL[is.na(casos_por_dia$REGIONAL)] <- 0L

  for (i in seq_along(cidades)) {
    contagem <- casos$COLETA[casos$CIDADE_CHAVE == chaves[i]]
    tab <- table(factor(contagem, levels = as.character(datas)))
    casos_por_dia[[cidades[i]]] <- as.integer(tab[as.character(datas)])
  }
  arrow::write_parquet(casos_por_dia, file.path(gold_dir, "casos_por_dia.parquet"))

  # ---------------------------------------------------------------------
  # INCIDENCIA ACUMULADA (casos acumulados por milhao de habitantes)
  # ---------------------------------------------------------------------
  log_step("OURO: calculando incidencias acumuladas")
  incidencias <- data.frame(label_datas = datas)
  incidencias$REGIONAL <- round(cumsum(casos_por_dia$REGIONAL) / populacao_regional$POPULACAO * 1e6, 2)
  for (i in seq_along(cidades)) {
    pop_cidade <- populacao_municipios$POPULACAO[populacao_municipios$CIDADE_CHAVE == chaves[i]]
    incidencias[[cidades[i]]] <- round(cumsum(casos_por_dia[[cidades[i]]]) / pop_cidade * 1e6, 2)
  }
  arrow::write_parquet(incidencias, file.path(gold_dir, "incidencias.parquet"))

  # ---------------------------------------------------------------------
  # FAIXA ETARIA (regional e por municipio)
  # ---------------------------------------------------------------------
  log_step("OURO: distribuicao por faixa etaria")
  faixa_regional <- cut(casos$IDADE, breaks = breaks_faixa_etaria, right = FALSE, labels = label_faixa_etaria)
  faixa_etaria <- data.frame(label_datas = label_faixa_etaria)
  faixa_etaria$REGIONAL <- as.integer(table(factor(faixa_regional, levels = label_faixa_etaria)))
  for (i in seq_along(cidades)) {
    idade_cidade <- casos$IDADE[casos$CIDADE_CHAVE == chaves[i]]
    faixa_cidade <- cut(idade_cidade, breaks = breaks_faixa_etaria, right = FALSE, labels = label_faixa_etaria)
    faixa_etaria[[cidades[i]]] <- as.integer(table(factor(faixa_cidade, levels = label_faixa_etaria)))
  }
  arrow::write_parquet(faixa_etaria, file.path(gold_dir, "faixa_etaria.parquet"))

  log_step("OURO: distribuicao por faixa etaria x sexo (regional)")
  casos_sexo_valido <- casos[casos$SEXO %in% c("F", "M"), ]
  faixa_etaria_sexo <- as.data.frame(table(
    faixa_etaria = cut(casos_sexo_valido$IDADE, breaks = breaks_faixa_etaria, right = FALSE, labels = label_faixa_etaria),
    sexo = casos_sexo_valido$SEXO
  ))
  colnames(faixa_etaria_sexo) <- c("faixa_etaria", "sexo", "casos")
  faixa_etaria_sexo$sexo <- factor(faixa_etaria_sexo$sexo, levels = c("F", "M"), labels = c("FEMININO", "MASCULINO"))
  arrow::write_parquet(faixa_etaria_sexo, file.path(gold_dir, "faixa_etaria_sexo.parquet"))

  # ---------------------------------------------------------------------
  # CASOS POR SEXO (regional e por municipio)
  # ---------------------------------------------------------------------
  log_step("OURO: casos por sexo")
  casos_sexo <- data.frame(REGIONAL = c(
    sum(casos$SEXO == "F", na.rm = TRUE),
    sum(casos$SEXO == "M", na.rm = TRUE)
  ))
  for (i in seq_along(cidades)) {
    sexo_cidade <- casos$SEXO[casos$CIDADE_CHAVE == chaves[i]]
    casos_sexo[[cidades[i]]] <- c(sum(sexo_cidade == "F", na.rm = TRUE), sum(sexo_cidade == "M", na.rm = TRUE))
  }
  rownames(casos_sexo) <- c("F", "M")
  arrow::write_parquet(casos_sexo, file.path(gold_dir, "casos_por_sexo.parquet"))

  # ---------------------------------------------------------------------
  # OBITOS
  # ---------------------------------------------------------------------
  log_step("OURO: obitos por municipio")
  obitos_casos <- casos[casos$OBITO == "SIM", ]
  obitos_mun <- data.frame(matrix(0L, nrow = 1, ncol = length(cidades)))
  colnames(obitos_mun) <- cidades
  for (i in seq_along(cidades)) {
    obitos_mun[[cidades[i]]] <- sum(obitos_casos$CIDADE_CHAVE == chaves[i])
  }
  arrow::write_parquet(obitos_mun, file.path(gold_dir, "obitos_por_municipio.parquet"))

  # ---------------------------------------------------------------------
  # RESUMO POR MUNICIPIO (populacao + casos + obitos + incidencia final)
  # ---------------------------------------------------------------------
  log_step("OURO: resumo por municipio")
  incidencia_final <- as.numeric(incidencias[nrow(incidencias), cidades])
  resumo_municipios <- data.frame(
    CIDADE = cidades,
    CIDADE_CHAVE = chaves,
    POPULACAO = populacao_municipios$POPULACAO[match(chaves, populacao_municipios$CIDADE_CHAVE)],
    CASOS = as.numeric(colSums(casos_por_dia[, cidades, drop = FALSE])),
    OBITOS = as.numeric(obitos_mun[1, cidades]),
    INCIDENCIA = incidencia_final,
    stringsAsFactors = FALSE
  )
  arrow::write_parquet(resumo_municipios, file.path(gold_dir, "resumo_municipios.parquet"))

  # Tabela de populacao no formato de exibicao usado nas telas do painel:
  # primeira linha = total da regional, demais linhas = cada municipio.
  populacao_display <- rbind(
    data.frame(Municipios = "15 RS", População = populacao_regional$POPULACAO, stringsAsFactors = FALSE),
    data.frame(Municipios = cidades, População = resumo_municipios$POPULACAO, stringsAsFactors = FALSE)
  )
  arrow::write_parquet(populacao_display, file.path(gold_dir, "populacao_municipios.parquet"))

  # ---------------------------------------------------------------------
  # BAIRROS DA 15A REGIONAL (referencia geografica)
  # ---------------------------------------------------------------------
  arrow::write_parquet(bairros_15regional, file.path(gold_dir, "bairros_15regional.parquet"))

  # ---------------------------------------------------------------------
  # CASOS - DETALHE (linha a linha, ja limpo, pronto para telas administrativas
  # e para series temporais por municipio calculadas sob demanda no painel)
  # ---------------------------------------------------------------------
  arrow::write_parquet(casos, file.path(gold_dir, "casos_detalhe.parquet"))

  # ---------------------------------------------------------------------
  # METADADOS
  # ---------------------------------------------------------------------
  log_step("OURO: metadados")
  # As duas primeiras linhas da coluna `atualizado` da fonte original
  # carregam, por convencao do time de dados, a data de atualizacao do
  # painel e o id do video do YouTube exibido na aba "Nivel de risco".
  metadados <- data.frame(
    data_atualizacao_str = as.character(casos$ATUALIZADO[1]),
    video_id_youtube = as.character(casos$ATUALIZADO[2]),
    data_inicio = min(datas),
    data_fim_serie = max(datas),
    total_casos = nrow(casos),
    total_obitos = nrow(obitos_casos),
    obitos_feminino = sum(obitos_casos$SEXO == "F", na.rm = TRUE),
    obitos_masculino = sum(obitos_casos$SEXO == "M", na.rm = TRUE),
    qtd_cidades_com_casos = length(unique(casos$CIDADE_CHAVE[casos$CIDADE_CHAVE %in% chaves])),
    stringsAsFactors = FALSE
  )
  arrow::write_parquet(metadados, file.path(gold_dir, "metadados.parquet"))

  invisible(list(
    casos_por_dia = casos_por_dia,
    incidencias = incidencias,
    faixa_etaria = faixa_etaria,
    faixa_etaria_sexo = faixa_etaria_sexo,
    casos_sexo = casos_sexo,
    obitos_mun = obitos_mun,
    resumo_municipios = resumo_municipios,
    metadados = metadados
  ))
}
