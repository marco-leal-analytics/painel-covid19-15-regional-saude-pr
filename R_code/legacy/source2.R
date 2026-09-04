# ####################################################################################################################
# #############################          LEITURA DE DADOS           ###############################################
# ####################################################################################################################
# 
# 
# 
# 
# 
# 
# 
# read_excel_allsheets <- function(filename, tibble = FALSE) {
# 
#   sheets <- readxl::excel_sheets(filename)
#   x <- lapply(sheets, function(X) readxl::read_excel(filename, sheet = X))
#   if(!tibble) x <- lapply(x, as.data.frame)
#   names(x) <- sheets
#   x
# }
# 
# 
# dados <- read_excel_allsheets("www/database2.xlsx")
# #dados <- read_excel_allsheets("D:\\OneDrive\\Notebook Dell G3\\Desktop\\Covid\\webpage\\covid19\\www\\database2.xlsx")
# 
# 
# 
# 
# astorga                      <- dados$ASTORGA
# atalaia                      <- dados$ATALAIA
# colorado                     <- dados$COLORADO
# doutorcamargo                <- dados$`DOUTOR CAMARGO`
# floresta                     <- dados$FLORESTA
# florida                      <- dados$FLÓRIDA
# iguaracu                     <- dados$IGUARAÇU
# itambe                       <- dados$ITAMBÉ
# ivatuba                      <- dados$IVATUBA
# lobato                       <- dados$LOBATO
# mandaguacu                   <- dados$MANDAGUAÇU
# mandaguari                   <- dados$MANDAGUARI
# marialva                     <- dados$MARIALVA
# maringa                      <- dados$MARINGÁ
# munhozdemelo                 <- dados$`MUNHOZ DE MELO`
# novaesperanca                <- dados$`NOVA ESPERANÇA`
# paicandu                     <- dados$PAIÇANDU
# paranacity                   <- dados$PARANACITY
# presidentecastelobranco      <- dados$`PRES CASTELO BCO`
# santafe                      <- dados$`SANTA FÉ`
# santoinacio                  <- dados$`SANTO INACIO`
# sarandi                      <- dados$SARANDI
# uniflor                      <- dados$UNIFLOR
# 
# 
# 
# 
# 
# 
# 
# 
# ####################################################################################################################
# #############################              CITY SELECT              ###############################################
# ####################################################################################################################
# 
# 
# 
# 
# cityinit<-input$cidade2
# cityinit<-gsub(" ","",cityinit)
# cityinit<-tolower(cityinit)
# city<-eval(as.name(paste(cityinit)))
# 
# 
# 
# 
# 
# 
# 
# ####################################################################################################################
# #############################       SELECT AND RENAME OF COLUMNS     ###############################################
# ####################################################################################################################
# 
# 
# 
# # cols<-c('DT INICIO SINTOMA', 'DT. COLETA', 'RESULTADO DE EXAME',
# #         'TIPO DE VIRUS', 'FONTE NOTIF.', 'IDADE', 'SEXO',
# #         'COMORBIDAD.', 'COLETOU EXAME PARA COVID 19', 'LAB. DE COLETA',
# #         'SITUAÇÃO', 'ESTADO CLINICO', 'TIPO DE INTERNAÇÃO', 'VIAGEM NOS ULTIMOS 15 DIAS')
# 
# 
# if (cityinit == "maringa") {
# 
#   dadoscity<-data.frame(city$'DT. COLETA', city$'RESULTADO DE EXAME',
#                         city$'COLETOU EXAME PARA COVID 19')
# 
#   colnames(dadoscity) <- c('coleta', 'resultadocovid', 'examecovid')
# 
# 
# } else {
# 
#   colnames(city)[16] <-"coleta"
#   colnames(city)[18] <-"resultadocovid"
#   dadoscity<-data.frame(city$coleta,city$resultadocovid)
#   colnames(dadoscity) <- c('coleta', 'resultadocovid')
# 
# }
# 
# 
# 
# 
# 
# 
# ####################################################################################################################
# #############################                  SELECT               ###############################################
# ####################################################################################################################
# 
# 
# 
# if (cityinit == "maringa") {
# 
#   dadoscity <- select(filter(dadoscity, examecovid == "SIM" & resultadocovid == "POSITIVO" ), colnames(dadoscity))
# 
# 
# } else {
# 
#   a<-dadoscity %>%
#     filter(str_detect(resultadocovid, "POSITIVO"))
# 
#   b<-dadoscity %>%
#     filter(str_detect(resultadocovid, "DETECTAVEL"))
# 
#   c<-dadoscity %>%
#     filter(str_detect(resultadocovid, "CONFIRMADO"))
# 
#   dadoscity <- rbind(a,b,c)
# 
# }
# 
# 
# totalcasos<-nrow(dadoscity)
# 
# 
# 
# if (nrow(dadoscity) < 2) {numberofrow<-0  } else {
# 
#   ####################################################################################################################
#   #############################              NOVAS COLUNAS            ###############################################
#   ####################################################################################################################
# 
# 
# 
# 
#   dadoscity$coleta <- as.Date(dadoscity$coleta, format="%d/%m/%Y")
#   #dadosmga$sintomas <- as.Date(dadosmga$sintomas, format="%d/%m/%Y")
#   dadoscity<-arrange(dadoscity, coleta)
#   a<-dadoscity  %>%  group_by ( coleta ) %>%  count ( coleta )
#   a<-data.frame(a)
#   time<-seq(a$coleta[1], as.Date(a$coleta[nrow(a)]), by=1)
#   dadosfinal<-data.frame(time)
#   casos<-c()
#   for (i in 1:nrow(dadosfinal)) {
#     for (j in 1:nrow(a)) {
#       aux<-ifelse(dadosfinal$time[i]==a$coleta[j],a$n[j],0)
#       if (dadosfinal$time[i]==a$coleta[j]){break}
#     }
#     casos<-cbind(casos,aux[1])
#   }
#   casos<-as.vector(casos)
#   dadosfinal$casos<-casos
#   acumulado<-c()
#   for (i in 1:nrow(dadosfinal)) {
#     aux<-sum(dadosfinal$casos[1:i])
#     acumulado<-cbind(acumulado,aux)
#   }
#   acumulado<-as.vector(acumulado)
#   dadosfinal$acumulado<-acumulado
#   fim<-min(10,nrow(dadosfinal))
#   if (nrow(dadosfinal)>10) {
#     infectados<-dadosfinal$acumulado[1:10]
#     for (i in 11:nrow(dadosfinal)) {
#       infectados<-c(infectados,(infectados[i-1]+dadosfinal$casos[i]-dadosfinal$casos[i-10]))
#     }
#   } else {
#     infectados<-dadosfinal$acumulado[1:nrow(dadosfinal)]
#   }
# 
#   dadosfinal$infectados<-as.vector(infectados)
# 
#   numberofrow<-nrow(dadosfinal)
# 
# 
# 
# 
# 
# 
# }
# 
# 




####################################################################################################################
#############################              FUNÇÂO ATRASO NAS MEDIDAS            ###############################################
####################################################################################################################







atraso <- function(k) {
  
  pop   <- c(2928,26111,3892,
             24012,5979,4929,
             6774,2689,4404,
             4568,6108,3259,
             4787,22819,34400,
             35496,423666,3984,
             4008,27904,3428,
             41281,11472,5306,
             12037,1596,5438,
             5551,96688,2605)
  
  city <-  c("ANGULO","ASTORGA","ATALAIA",
             "COLORADO","DOUTOR CAMARGO", "FLORAI",
             "FLORESTA","FLORIDA","IGUARACU",
             "ITAGUAJE","ITAMBE","IVATUBA",
             "LOBATO","MANDAGUACU","MANDAGUARI",
             "MARIALVA","MARINGA","MUNHOZ DE MELO",
             "NOSSA SENHORA DAS GRACAS","NOVA ESPERANCA","OURIZONA",
             "PAICANDU","PARANACITY","PRESIDENTE CASTELO BRANCO",
             "SANTA FE","SANTA INES","SANTO INACIO",
             "SAO JORGE DO IVAI","SARANDI","UNIFLOR")
  
  cidade<-input$cidade2
  
  aux  <- cbind(city,pop)
  aux  <- as.data.frame(aux)
  colnames(aux) <- c("cidade","populacao")
  populacao<-as.numeric(as.character(aux[which(cidade==aux$cidade),2]))
  
  S<-1-5/populacao
  E<-3/populacao
  I<-2/populacao
  R<-0
  b<-data.frame(c(), c(), c(), c(), c())
  
  a<-SEIR(pars = c(mu = 0, beta = 0.3, sigma = 1 /5 , gamma = 0.1), init = c(S = S, E = E, I = I, R = R), time = 0:k)
  S<-a$results$S[length(a$results$S)]
  E<-a$results$E[length(a$results$S)]
  I<-a$results$I[length(a$results$S)]
  R<-a$results$R[length(a$results$S)]
  aux<-data.frame(a$results$S[1:k], a$results$E[1:k], a$results$I[1:k], a$results$R[1:k])
  b<-rbind(b,aux)
  
  colnames(b)<-c("S","E","I","R")
  S<-b$S[length(b$S)]
  E<-b$E[length(b$S)]
  I<-b$I[length(b$S)]
  R<-b$R[length(b$S)]
  
  fim<-89-k 
  
  a<-SEIR(pars = c(mu = 0, beta = 0.12, sigma = 1 /5 , gamma = 0.1), init = c(S = S, E = E, I = I, R = R), time = 0:fim)
  aux<-data.frame(a$results$S[1:length(a$results$S)], a$results$E[1:length(a$results$S)], a$results$I[1:length(a$results$S)], a$results$R[1:length(a$results$S)])
  colnames(aux)<-c("S","E","I","R")
  b<-rbind(b,aux)
  
  
  fig<-plot_ly(x = ~ 1:nrow(b), y = ~populacao*b$S, mode = 'lines', type="scatter", visible="legendonly",
               text = "neste dia", line = list(color = 'rgb(8,48,107)', width = 4), name = 'Suscetíveis')
  fig<-fig %>% add_trace(y = ~ populacao*b$E, mode = 'lines+markers', name = 'Expostos', visible=TRUE,
                         line = list(color = 'orange', width = 4))
  fig<-fig %>% add_trace(y = ~ populacao*b$I, mode = 'lines+markers', name = 'Infectados', visible=TRUE,
                         line = list(color = 'red', width = 4), color = I("red"))
  fig<-fig %>% add_trace(y = ~ populacao*b$R, mode = 'lines', name = 'Recuperados', visible=TRUE, #dash = 'dash','dot'
                         line = list(color = 'green', width = 4))
  fig <- fig %>% layout(title = "<b>Modelo SEIR</b>", hovermode = TRUE, spikedistance =  -1,
                        xaxis = list(title = "<b>DIAS</b>", showspikes = TRUE, titlefont = list(size = 24),
                                     spikemode  = 'across', #toaxis, across, marker
                                     spikesnap = 'cursor',  ticks = "outside",tickangle = 0,
                                     showline=TRUE,tickfont = list(size = 24),
                                     showgrid=TRUE), 
                        yaxis = list (title = "<b>NÚMERO DE PESSOAS</b>",
                                      spikemode  = 'across', #toaxis, across, marker
                                      spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),
                                      showline=TRUE,tickfont = list(size = 24),
                                      showgrid=TRUE),
                        height= 450
                        
  )
  return(fig)
}






####################################################################################################################
#############################              FUNÇÂO CHEGADA DE ESPOSTOS             ###############################################
####################################################################################################################


espostos <- function(q) {
  
  
  pop   <- c(2928,26111,3892,
             24012,5979,4929,
             6774,2689,4404,
             4568,6108,3259,
             4787,22819,34400,
             35496,423666,3984,
             4008,27904,3428,
             41281,11472,5306,
             12037,1596,5438,
             5551,96688,2605)
  
  
  city <-  c("ANGULO","ASTORGA","ATALAIA",
             "COLORADO","DOUTOR CAMARGO", "FLORAI",
             "FLORESTA","FLORIDA","IGUARACU",
             "ITAGUAJE","ITAMBE","IVATUBA",
             "LOBATO","MANDAGUACU","MANDAGUARI",
             "MARIALVA","MARINGA","MUNHOZ DE MELO",
             "NOSSA SENHORA DAS GRACAS","NOVA ESPERANCA","OURIZONA",
             "PAICANDU","PARANACITY","PRESIDENTE CASTELO BRANCO",
             "SANTA FE","SANTA INES","SANTO INACIO",
             "SAO JORGE DO IVAI","SARANDI","UNIFLOR")
  cidade<-input$cidade2
  
  aux  <- cbind(city,pop)
  aux  <- as.data.frame(aux)
  colnames(aux) <- c("cidade","populacao")
  populacao<-as.numeric(as.character(aux[which(cidade==aux$cidade),2]))

k<-1
S<-1
E<-0
I<-0
R<-0
b<-data.frame(c(), c(), c(), c(), c())
for (i in 1:30) {
  E<-E+q/populacao
  S<-S-q/populacao
  a<-SEIR(pars = c(mu = 0, beta = 0.3, sigma = 1 /5 , gamma = 0.1), init = c(S = S, E = E, I = I, R = R), time = 0:k)
  S<-a$results$S[length(a$results$S)]
  E<-a$results$E[length(a$results$S)]
  I<-a$results$I[length(a$results$S)]
  R<-a$results$R[length(a$results$S)]
  aux<-data.frame(a$results$S[1:k], a$results$E[1:k], a$results$I[1:k], a$results$R[1:k])
  b<-rbind(b,aux)
}
colnames(b)<-c("S","E","I","R")
S<-b$S[length(b$S)]
E<-b$E[length(b$S)]
I<-b$I[length(b$S)]
R<-b$R[length(b$S)]

a<-SEIR(pars = c(mu = 0, beta = 0.12, sigma = 1 /5 , gamma = 0.1), init = c(S = S, E = E, I = I, R = R), time = 0:59)
aux<-data.frame(a$results$S[1:length(a$results$S)], a$results$E[1:length(a$results$S)], a$results$I[1:length(a$results$S)], a$results$R[1:length(a$results$S)])
colnames(aux)<-c("S","E","I","R")
b<-rbind(b,aux)




fig<-plot_ly(x = ~ 1:nrow(b), y = ~populacao*b$S, mode = 'lines', type="scatter", visible="legendonly",
             text = "neste dia", line = list(color = 'rgb(8,48,107)', width = 4), name = 'Suscetíveis')
fig<-fig %>% add_trace(y = ~ populacao*b$E, mode = 'lines+markers', name = 'Expostos', visible=TRUE,
                       line = list(color = 'orange', width = 4))
fig<-fig %>% add_trace(y = ~ populacao*b$I, mode = 'lines+markers', name = 'Infectados', visible=TRUE,
                       line = list(color = 'red', width = 4), color = I("red"))
fig<-fig %>% add_trace(y = ~ populacao*b$R, mode = 'lines', name = 'Recuperados', visible=TRUE, #dash = 'dash','dot'
                       line = list(color = 'green', width = 4))
fig <- fig %>% layout(title = "<b>Modelo SEIR</b>", hovermode = TRUE, spikedistance =  -1,
                      xaxis = list(title = "<b>DIAS</b>", showspikes = TRUE, titlefont = list(size = 24),
                                   spikemode  = 'across', #toaxis, across, marker
                                   spikesnap = 'cursor',  ticks = "outside",tickangle = 0,
                                   showline=TRUE,tickfont = list(size = 24),
                                  
                                   
                                   
                                   showgrid=TRUE), 
                      yaxis = list (title = "<b>NÚMERO DE PESSOAS</b>",
                                    spikemode  = 'across', #toaxis, across, marker
                                    spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),
                                    showline=TRUE,tickfont = list(size = 24),
                                    showgrid=TRUE),
                      height= 450
                      
)
return(fig)




}











