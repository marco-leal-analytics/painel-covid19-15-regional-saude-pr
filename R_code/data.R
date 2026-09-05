options(warn = 0)
data_dir <- file.path(getwd(), "data")
gold_dir <- file.path(data_dir, "gold")

################################################################################################################
######################################## LEITURA DA CAMADA OURO ################################################
################################################################################################################
# Toda a leitura, limpeza, unificacao e agregacao dos dados brutos acontece
# FORA da aplicacao, no pipeline em pipeline/run_pipeline.R (camadas
# bronze -> prata -> ouro, ver data/bronze, data/silver e data/gold). A
# aplicacao le exclusivamente os parquets ja prontos para consumo em
# data/gold/ — nenhum dataset.csv, xlsx ou csv bruto e lido aqui.
#
# Sempre que os dados de origem forem atualizados, rode:
#   Rscript pipeline/run_pipeline.R

gold <- function(nome) arrow::read_parquet(file.path(gold_dir, paste0(nome, ".parquet")))

metadados           <- gold("metadados")
casos_detalhe       <- gold("casos_detalhe")
data_casos          <- as.data.frame(gold("casos_por_dia"))
incidencias         <- as.data.frame(gold("incidencias"))
faixa_etaria        <- as.data.frame(gold("faixa_etaria"))
faixa_etaria_sexo   <- as.data.frame(gold("faixa_etaria_sexo"))
casos_sexo          <- as.data.frame(gold("casos_por_sexo"))
obitos_mun          <- as.data.frame(gold("obitos_por_municipio"))
resumo_municipios   <- as.data.frame(gold("resumo_municipios"))
populacao_municipio <- as.data.frame(gold("populacao_municipios"))
coordenadas_bairros_15regional <- as.data.frame(gold("bairros_15regional"))

data_casos$label_datas  <- as.Date(data_casos$label_datas)
incidencias$label_datas <- as.Date(incidencias$label_datas)

datas      <- data_casos$label_datas
range_data <- range(datas)

numero_casos_total <- apply(data_casos[, 2:32], 2, sum)

qtd_cidade <- metadados$qtd_cidades_com_casos[1]
data_fim   <- metadados$data_atualizacao_str[1]
link       <- metadados$video_id_youtube[1]
atualizado1 <- as.Date(strptime(data_fim, "%d/%m/%Y"))

obitos      <- metadados$total_obitos[1]
obitos_sexo <- c(F = metadados$obitos_feminino[1], M = metadados$obitos_masculino[1])

data_list <- list("Casos por dia" = data_casos, "Incidências" = incidencias)

################################################################################################################
######################################## COMPATIBILIDADE COM TELAS/SCRIPTS LEGADOS #############################
################################################################################################################
# `dataset1` e `dados2` reproduzem, a partir da camada ouro, as mesmas
# estruturas linha-a-linha que R_code/legacy/source.R e
# R_code/legacy/source3.R (curva epidemica por cidade, ranking de risco) e
# a tela de Configuracoes esperam. A regra de negocio desses dois scripts
# nao foi alterada — apenas a origem dos dados, que deixou de ser o CSV
# bruto e passou a ser o parquet da camada ouro.

dataset1 <- data.frame(
  notifica       = casos_detalhe$NOTIFICA,
  cidade         = tolower(casos_detalhe$CIDADE_CHAVE),
  nome           = casos_detalhe$NOME,
  idade          = casos_detalhe$IDADE,
  sexo           = casos_detalhe$SEXO,
  viajem         = casos_detalhe$VIAJEM,
  obito          = casos_detalhe$OBITO,
  coleta         = casos_detalhe$COLETA,
  resultadocovid = casos_detalhe$RESULTADOCOVID,
  atualizado     = NA_character_,
  stringsAsFactors = FALSE
)

dados2 <- data.frame(
  NOTIFICA       = casos_detalhe$NOTIFICA,
  CIDADE         = casos_detalhe$CIDADE,
  NOME           = casos_detalhe$NOME,
  IDADE          = casos_detalhe$IDADE,
  SEXO           = casos_detalhe$SEXO,
  VIAJEM         = casos_detalhe$VIAJEM,
  OBITO          = casos_detalhe$OBITO,
  COLETA         = casos_detalhe$COLETA,
  RESULTADOCOVID = casos_detalhe$RESULTADOCOVID,
  ATUALIZADO     = casos_detalhe$ATUALIZADO,
  stringsAsFactors = FALSE
)

################################################################################################################
######################################## MAPA (GEOMETRIA DOS MUNICÍPIOS) #######################################
################################################################################################################
# As geometrias dos municípios vêm de um serviço externo (pacote brazilmaps),
# não de um arquivo de dados do projeto — por isso continuam sendo obtidas
# aqui, em tempo de execução, e combinadas com os indicadores já prontos da
# camada ouro (`resumo_municipios`).

resumo_ord <- resumo_municipios[match(lista_cidade_upper, resumo_municipios$CIDADE), ]

parana_maps   <- get_brmap(geo = "City", geo.filter = list(State = 41), class = "sf")
regional_maps <- parana_maps[which(toupper(parana_maps$name) %in% lista_cidade_upper), ]
regional_maps <- st_transform(regional_maps, crs = 4326)
regional_maps$incidencia <- resumo_ord$INCIDENCIA[match(toupper(regional_maps$name), lista_cidade_upper)]

objeto_sf <- data.frame(
  name = lista_cidade_upper, x = coordenadas[, 1], y = coordenadas[, 2],
  casos = resumo_ord$CASOS, row.names = NULL
) %>% st_as_sf(coords = c("x", "y"), crs = 4326)
objeto_sf$uid <- lista_cidade_upper

labels_map <- sprintf(
  "<strong>%s</strong><br/><strong>POPULAÇÃO : </strong>%g<br/><strong>CASOS : </strong>%g<br/><strong>ÓBITOS : </strong>%g<br/><strong>INCIDÊNCIA : </strong>%g<br/>",
  lista_cidade_upper, resumo_ord$POPULACAO, resumo_ord$CASOS, resumo_ord$OBITOS, resumo_ord$INCIDENCIA
) %>% lapply(htmltools::HTML)

incidencia_for_heat <- resumo_ord$INCIDENCIA
incidencia_range     <- range(incidencia_for_heat[incidencia_for_heat > 0])
inc                   <- ceiling(incidencia_range[2] / 10)
bins                  <- seq(0, incidencia_range[2] + inc, inc)
i                     <- which(incidencia_for_heat[1] <= bins)
bin2                  <- c(bins[i[1]], bins[i[1] + 1])
heatcols              <- c("#008000", heat.colors(6, rev = TRUE))
pal                   <- colorBin(palette = heatcols, domain = incidencia_for_heat, bins = bins)
pal2                  <- colorBin(palette = heatcols, domain = incidencia_for_heat, bins = bin2)
