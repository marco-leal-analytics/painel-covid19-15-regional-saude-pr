options(warn = 0)
################################################################################################################
######################################## LEITURA DE DADOS ######################################################
################################################################################################################
#data_obitos               <- read.table(file = "www/obitos.csv",header = T,sep = ";")
#dataset1                    <- drop_read_csv(file = "data_covid/dataset.csv",sep=";", header=T, stringsAsFactors = F,dtoken = token )
dataset1               <- read.table(file = "www/dataset.csv",header = T,sep = ";")

populacao_municipio        <- readxl::read_xlsx(path = "www/pop_municipios.xlsx",col_names = TRUE,sheet = "Planilha1" )
dataset1$coleta             <- as.Date(strptime(dataset1$coleta, "%d/%m/%Y"))
dados2                    <- dataset1
link                      <- dataset1$atualizado[2]
colnames(dados2)          <- toupper(colnames(dados2))
dados2$CIDADE             <- toupper(toupper(dados2$CIDADE))
dados2$CIDADE[dados2$CIDADE == 'PRESIDENTECASTELOBRANCO'] = "PRESIDENTE CASTELO BRANCO"
dados2$CIDADE[dados2$CIDADE == 'SANTAINES'] = "SANTA INES"
dados2$CIDADE[dados2$CIDADE == 'DOUTORCAMARGO'] = "DOUTOR CAMARGO"
dados2$CIDADE[dados2$CIDADE == 'MUNHOZDEMELO'] = "MUNHOZ DE MELO"
dados2$CIDADE[dados2$CIDADE == 'SAOJORGEDOIVAI'] = "SAO JORGE DO IVAI"
dados2$CIDADE[dados2$CIDADE == 'NOVAESPERANCA'] = "NOVA ESPERANCA"
dados2$CIDADE[dados2$CIDADE == 'SANTAFE'] = "SANTA FE"
dados2$CIDADE[dados2$CIDADE == 'SANTOINACIO'] = "SANTO INACIO"



unique(dados2$CIDADE)
if(is.na(dataset1$atualizado[2])){
  data_fim       <-  dataset1$atualizado[1]
}else{
  data_fim       <-  dataset1$atualizado[1]
  
}
atualizado1 <- as.Date(strptime(data_fim, "%d/%m/%Y"))
#atualizado1 <- gsub("-","/",atualizado1)
# data_fim                  <<- drop_read_csv(file = "data_covid/data_atualizacao.csv",sep=",", header=T, stringsAsFactors = F,dtoken = token,encoding="UTF-8" )
# data_fim                  <<- as.Date(data_fim[1,1],format='%d/%m/%Y')
#qdias                     <- drop_read_csv(file = "data_covid/qdias.csv",sep=",", header=T, stringsAsFactors = F,dtoken = token,encoding="UTF-8" )

#dados_sesa                <- read.csv(file = url("https://raw.githubusercontent.com/thaispaiva/app_COVID19/master/R/STAN/EstadosCov19.csv"),header = T,sep = ";",stringsAsFactors = F,encoding = "UTF-8",skip = 0)
#dados_sesa                <- dados_sesa %>% filter(estado == 'PR')
#dados_sesa$data           <- as.Date(dados_sesa$data,format='%d/%m/%Y')
#dados_sesa[,"values"]    <- (dados_sesa$casos.acumulados/as.numeric(populacao_municipio[populacao_municipio$Municipios == "Paraná",2]))*1000000
#dados_sesa$data          <- as.character(dados_sesa$data)
#dados2                    <- dados2[which(dados2$MUNICIPIO %in% rm_accent(lista_cidade_upper)),]

#dados2$NOTIFICA       <- transform_dates(dados2$NOTIFICA)



for( i in 1:length(dados2$NOTIFICA)){
  
  if(is.na(dados2$NOTIFICA[i])){
    
    dados2$NOTIFICA[i] <- dados2$COLETA[i]
    
  }
  
}



parana_maps              <- get_brmap(geo = "City", geo.filter = list(State=41),class      = "sf")
regional_maps            <- parana_maps[which(parana_maps$nome %in% lista_cidade_upper),]
datas                    <- as.Date(seq(pu_dia(dados2$COLETA)[1],pu_dia(dados2$COLETA)[2], by="days"))
range_data               <- pu_dia(dados2$COLETA);range_data

#dados_sesa               <- dados_sesa[1:which(dados_sesa$data %in% as.character(range_data[2]-qdias[1,1])),]

age <- c()
idades <- strsplit(x = as.character(dados2$IDADE),split = " ")
for(i in 1:length(idades)){
  age[i] <- idades[[i]][1]
}
dados2$IDADE <-age
dados2$SEXO[str_detect(dados2$SEXO, "^M|^m")]        <- 'M'  
dados2$SEXO[str_detect(dados2$SEXO, "^F|^f")]        <- 'F'



################################################################################################################
######################################## DADOS PARA ABA INFORME ################################################
################################################################################################################

data_casos                                             <- data.frame(label_datas=datas,REGIONAL=rep(0,length(datas)))
data_casos[,3:(length(lista_cidade_upper)+2)]          <- 0
colnames(data_casos)[2:(length(lista_cidade_upper)+2)] <- c("REGIONAL",lista_cidade_upper)
# Casos por dia regional
casos_por_dia                                          <- as.vector(tapply(X = dados2$RESULTADOCOVID,INDEX = dados2$COLETA,length))
pos_casos_regional                                     <- which(data_casos$label_datas %in% as.Date(dados2$COLETA))
data_casos[pos_casos_regional,2]                       <- as.vector(casos_por_dia)
# Casos por dia dos Municipios
dados_municipios                                       <- split(dados2,dados2$CIDADE)
lista_casos_municipios                                 <- sapply(1:length(dados_municipios),function(i) tapply(dados_municipios[[i]]$CIDADE,INDEX = dados_municipios[[i]]$COLETA,length))
lista_cidade                                           <- names(dados_municipios)
lista_cidade[lista_cidade=="PCB"]                      <- 'PRESIDENTE CASTELO BRANCO'
qtd_cidade                                             <- length(unique(dados2$CIDADE))
pos_cidades                                            <- which(rm_accent(lista_cidade)  %in% rm_accent(colnames(data_casos)))
lista_casos_aux                                        <- lista_casos_municipios [pos_cidades]
j=1
item                                                   <- which(rm_accent(rm_accent(colnames(data_casos))) %in% rm_accent(lista_cidade)[pos_cidades])
for(i in item){
  data_casos[,i][which(data_casos$label_datas %in% as.Date(names(lista_casos_aux[[j]])))] <- lista_casos_aux[[j]]
  j=j+1
}
data_casos                                            <- as.data.frame(data_casos)
numero_casos_total                                    <- apply(data_casos[,2:32],2,sum)

################################################################################################################
######################################## OBITOS ######################################################
################################################################################################################

# colnames(data_obitos)                                      <- c("DATA","NOME","IDADE","SEXO","MUNICIPIO")
# data_obitos$MUNICIPIO <- toupper(rm_accent(data_obitos$MUNICIPIO))
# data_obitos$SEXO[str_detect(data_obitos$SEXO, "^M")]        <- 'M'  
# data_obitos$SEXO[str_detect(data_obitos$SEXO, "^F")]        <- 'F'    
# obitos                                                      <- length(data_obitos[,2])
# obitos_sexo                                                 <- tapply(data_obitos$SEXO,data_obitos$SEXO,length)

data_obitos                                                   <- dados2 %>% filter(OBITO == "SIM") 
obitos                                                        <- data_obitos %>% filter(OBITO == "SIM") %>% summarise(n())
obitos_sexo                                                   <- tapply(data_obitos$SEXO,data_obitos$SEXO,length)
# Obitos por municipio

obitos_mun                                           <- data.frame(NULL)
obitos_mun[1,1:(length(lista_cidade_upper))]         <- 0
colnames(obitos_mun)[1:(length(lista_cidade_upper))] <- c(lista_cidade_upper)
cont_obitos                                          <- data_obitos %>% group_by(CIDADE ) %>% tally()
pos_obitos                                           <- which(rm_accent(lista_cidade_upper)%in% rm_accent(cont_obitos$CIDADE)  )
obitos_mun[,pos_obitos]                              <- t(as.matrix(cont_obitos[,2]))


# CASOS POR SEXO ------
cont_obitos_sexo <- as.data.frame(dados2 %>% group_by(SEXO,CIDADE ) %>% tally())

pos_obitos_f   <-  cont_obitos_sexo %>% filter(SEXO == "F")  
pos_obitos_f   <-  which(rm_accent(lista_cidade_upper) %in% rm_accent(pos_obitos_f$CIDADE)  )
pos_obitos_m   <-  cont_obitos_sexo %>% filter(SEXO == "M")  
pos_obitos_m   <-  which(rm_accent(lista_cidade_upper) %in% rm_accent(pos_obitos_m$CIDADE)  )

cont_sexo   <-  dados2 %>% group_by(SEXO ) %>% tally()
casos_sexo                                              <- data.frame(REGIONAL=rep(0,2))
casos_sexo[,2:(length(lista_cidade_upper)+1)]           <- 0
colnames(casos_sexo)[2:(length(lista_cidade_upper)+1)]  <- c(lista_cidade_upper)
casos_sexo[1,c(1,pos_obitos_f+1)]                       <- c(cont_sexo$n[1],t(cont_obitos_sexo %>% filter(SEXO == "F") %>% select(n)))
casos_sexo[2,c(1,pos_obitos_m+1)]                       <- c(cont_sexo$n[2],t(cont_obitos_sexo %>% filter(SEXO == "M") %>% select(n)))
####



# CASOS POR Faixa Etaria
faixa_etaria                                               <- data.frame(label_datas=label_faixa_etaria,REGIONAL=rep(0,length(label_faixa_etaria)))
faixa_etaria[,3:(length(lista_cidade_upper)+2)]            <- 0
colnames(faixa_etaria)[3:(length(lista_cidade_upper)+2)]   <- c(lista_cidade_upper)

idades                                                     <- strsplit(x = as.character(dados2$IDADE),split = " ")
for(i in 1:length(idades)){
  idades[i] <- as.numeric(idades[[i]][1])
}
dados2$IDADE                                                <-idades

faixa_etaria$REGIONAL   <- as.data.frame(table(cut(as.numeric(dados2$IDADE), breaks=c(0,10,19,41,61,81,150), right = FALSE,)))[,2]
dados_faixa_etaria      <-  sapply(1:length(dados_municipios),function(i) as.data.frame(table(cut(as.numeric(dados_municipios[[i]]$IDADE),breaks=c(0,10,19,41,61,81,150), right = FALSE))))
pos_faixa_etaria        <- seq(0,length(dados_faixa_etaria)-2,2)
faixa_etaria_municipio  <-lapply(pos_faixa_etaria,function(i) data.frame(label=dados_faixa_etaria[[i+1]],freq=dados_faixa_etaria[[i+2]]))
teste                   <-as.data.frame(faixa_etaria_municipio)[,seq(2,length(faixa_etaria_municipio)*2,2)]


item  <- which(rm_accent(colnames(data_casos)) %in% rm_accent(lista_cidade)[pos_cidades])

faixa_etaria[,item] <- teste

# INCIDENCIAS -----------------------


incidencias    <- data.frame(label_datas=datas,REGIONAL=rep(0,length(datas)))
incidencias[,3:(length(lista_cidade_upper)+2)] <- 0
colnames(incidencias)[3:(length(lista_cidade_upper)+2)] <- lista_cidade_upper
incidencias[,2:32]   <- as.data.frame(sapply(2:32, function(i) cumsum((data_casos[,i]))))
incidencias[,2:32]   <- as.data.frame(sapply(2:32, function(i)  ((incidencias[,i]/populacao_municipio$População[i-1])*1000000)))
incidencias[,2:32]   <- round(x = incidencias[,2:32],digits = 2)


# INCIDENCIAS COMPARACAO  -----------

# n_casos <- apply(data_casos[,3:(length(lista_cidade_upper)+2)], MARGIN = 2,sum);n_casos
# 
# pos <- which(n_casos>0)
# pos2 <- data_casos[,2]>0
# data_mult_plot <- incidencias[pos2,c("REGIONAL",names(pos))]
# incidencias_long <-stack(data_mult_plot, select = c(names(pos),"REGIONAL"))
# 
# lab <- rep(incidencias$label_datas[pos2],length(pos)+1)
# incidencias_long$lab <- as.character(lab)
# cum_inc<-tapply(stak$values,INDEX = stak$ind,cumsum)
# cum_inc<-stack(cum_inc)
# lab <- rep(data_incidencia$labels,length(names(pos))+1)
# stak$lab <- as.character(lab)
# stak$cumulative <- cum_inc$values

#
# # ATRIBUTOS PARA O MAPA -------
#
objeto_sf      <- data.frame(name=lista_cidade_upper,x=coordenadas[,1],y=coordenadas[,2],
                             casos=apply(data_casos[,3:32],2,sum),row.names = NULL) %>%
  st_as_sf(coords = c("x", "y"), crs = 4326)
objeto_sf$uid  <- lista_cidade_upper

labels_map <- sprintf(
  "<strong>%s</strong><br/><strong>POPULAÇÃO : </strong>%g<br/><strong>CASOS : </strong>%g<br/><strong>INCIDÊNCIA : </strong>%g<br/>",
  lista_cidade_upper, populacao_municipio$População[2:31],apply(data_casos[,3:32],2,sum),incidencias[length(incidencias[,1]),3:32]
) %>% lapply(htmltools::HTML)

labels_map <- sprintf(
  "<strong>%s</strong><br/><strong>POPULAÇÃO : </strong>%g<br/><strong>CASOS : </strong>%g<br/><strong>ÓBITOS : </strong>%g<br/><strong>INCIDÊNCIA : </strong>%g<br/>",
  lista_cidade_upper, populacao_municipio$População[2:31],apply(data_casos[,3:32],2,sum),obitos_mun,incidencias[length(incidencias[,1]),3:32]
) %>% lapply(htmltools::HTML)



incidencia_for_heat    <- as.vector(incidencias[length(incidencias[,1]),2:32])
incidencia_range       <- range(incidencia_for_heat[incidencia_for_heat>0])
inc                    <- ceiling(incidencia_range[2]/10)

bins                  <- seq(0,incidencia_range[2]+inc,inc) ;bins
i                     <- which(incidencia_for_heat[1] <= bins)
bin2                  <- c(bins[i[1]],bins[i[1]+1])
heatcols              <- c("#008000",heat.colors(6,rev = TRUE))
pal                   <- colorBin(palette = heatcols,domain = incidencia_for_heat, bins = bins)

pal2                  <- colorBin(palette = heatcols,domain = incidencia_for_heat, bins = bin2)

############# BAIRROS ########

coordenadas_bairros            <- read.table(file = "www/latitude-longitude-bairros.csv",header = T,sep = ";",encoding = "UTF-8")
coordenadas_bairros_pr         <- coordenadas_bairros %>% filter(uf == "PR")
pos                            <- which(toupper(coordenadas_bairros_pr$municipio) %in%  regional_maps$nome )
coordenadas_bairros_15regional <- coordenadas_bairros_pr[pos,]
coordenadas_bairros            <- read.table(file = "www/latitude-longitude-bairros.csv",header = T,sep = ";",encoding = "UTF-8")
data_list <- list('Casos por dia'=data_casos,'Incidências'=incidencias)
