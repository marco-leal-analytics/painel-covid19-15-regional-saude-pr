####################################################################################################################
#############################            RANKING           ###############################################
####################################################################################################################



# temp_path                 <- tempfile(fileext = ".xlsx")
# dataset                   <- rdrop2::drop_download(path = "data_covid/dataset.xlsx",local_path = temp_path)
# dataset                   <- read_excel_allsheets(temp_path)$dataset
atualizado1      <- input$calendar
dataset <- dataset1
dataset$coleta   <- as.Date(dataset$coleta)
dataset          <- select(filter(dataset, coleta <= atualizado1), colnames(dataset), -"atualizado")

#which(dataset$coleta <= atualizado)



cidades<-c("ANGULO","ASTORGA","ATALAIA","COLORADO","DOUTOR CAMARGO",
           "FLORAI","FLORESTA","FLORIDA","IGUARACU","ITAGUAJE","ITAMBE",
           "IVATUBA","LOBATO","MANDAGUACU","MANDAGUARI","MARIALVA","MARINGA",
           "MUNHOZ DE MELO","NOSSA SENHORA DAS GRACAS","NOVA ESPERANCA",
           "OURIZONA","PAICANDU","PARANACITY","PRESIDENTE CASTELO BRANCO",
           "SANTA FE","SANTA INES","SANTO INACIO","SAO JORGE DO IVAI","SARANDI","UNIFLOR")



totalcasos<-c() #contém o número de casos total de cada cidade
taxapropagacao<-c()
prevalencia<-c()
rsquared<-c()
pvalue<-c()


####################################################################################################################
####################################################################################################################
####################################################################################################################
#############################       INÍCIO DO LAÇO    ##############################################################
####################################################################################################################
####################################################################################################################
####################################################################################################################

for (i in 1:length(cidades)) {
  
  
  ####################################################################################################################
  #############################              CITY SELECT              ###############################################
  ####################################################################################################################
  
  
  
  
  cityinit<-cidades[i]
  cityinit<-gsub(" ","",cityinit)
  cityinit<-tolower(cityinit)
  #city<-eval(as.name(paste(cityinit)))
  
  
  
  
  
  
  
  
  
  dadoscity <- select(filter(dataset, cidade == cityinit), colnames(dataset))
  
  
  
  
  ####################################################################################################################
  ####################################################################################################################
  #############################      SEGUNDO LAÇO       ##############################################################
  ####################################################################################################################
  ####################################################################################################################
  ## 
  
  if (nrow(dadoscity)==0) {
    
    totalcasos<-c(totalcasos, 0)
    
    taxapropagacao<-c(taxapropagacao,0)
    
    prevalencia<-c(prevalencia,0)
    
    rsquared<-c(rsquared,0)
    
    pvalue<-c(pvalue,0)
    
  } else {
    
    
    
    
    totalcasos<-c(totalcasos, nrow(dadoscity))
    
    
    ####################################################################################################################
    #############################              NOVAS COLUNAS            ###############################################
    ####################################################################################################################
    
    
    if (nrow(dadoscity) < 1) {numberofrow<-0  } else {
      
      #if (cityinit=="maringa") {dataa<-"2020/05/28" } else {dataa<-atualizado}
      
      
      dadoscity$coleta <- as.Date(dadoscity$coleta)
      #dadosmga$sintomas <- as.Date(dadosmga$sintomas, format="%d/%m/%Y")
      dadoscity<-arrange(dadoscity, coleta)
      a<-dadoscity  %>%  group_by ( coleta ) %>%  count ( coleta )
      a<-data.frame(a)
      time<-seq(a$coleta[1], atualizado1, by="day")
      dadosfinal<-data.frame(time)
      casos<-c()
      for (i in 1:nrow(dadosfinal)) {
        for (j in 1:nrow(a)) {
          aux<-ifelse(dadosfinal$time[i]==a$coleta[j],a$n[j],0)
          if (dadosfinal$time[i]==a$coleta[j]){break}
        }
        casos<-cbind(casos,aux[1])
      }
      casos<-as.vector(casos)
      dadosfinal$casos<-casos
      acumulado<-c()
      for (i in 1:nrow(dadosfinal)) {
        aux<-sum(dadosfinal$casos[1:i])
        acumulado<-cbind(acumulado,aux)
      }
      acumulado<-as.vector(acumulado)
      dadosfinal$acumulado<-acumulado
      fim<-min(10,nrow(dadosfinal))
      if (nrow(dadosfinal)>10) {
        infectados<-dadosfinal$acumulado[1:10]
        for (i in 11:nrow(dadosfinal)) {
          infectados<-c(infectados,(infectados[i-1]+dadosfinal$casos[i]-dadosfinal$casos[i-10]))
        }
      } else {
        infectados<-dadosfinal$acumulado[1:nrow(dadosfinal)]
      }
      
      dadosfinal$infectados<-as.vector(infectados)
      
      numberofrow<-nrow(dadosfinal)
      
      
      
      
      
      
    }
    
    
    
    ####################################################################################################################
    #############################              TAXA DE PROPAGAÇÂO            ###############################################
    ####################################################################################################################
    
    
    
    if (numberofrow < 5) {
      taxapropagacao <- c(taxapropagacao,0)
      rsquared       <- c(rsquared, 0)
      pvalue         <- c(pvalue, 0) 
    } else {
      
      if ( numberofrow < 10) {
        fim<-numberofrow
        
        init<-1
        
        tempo<-seq(1,fim,1)
        
        exponential.model <- lm(log(as.numeric(dadosfinal$acumulado[init:fim]))~ tempo)
        #summary(exponential.model)
        beta <- coef(exponential.model)[2]+0.1 #ae^{beta t}
        acq<-alpha.0 <- exp(coef(exponential.model)[1])
        
        
        taxapropagacao <- c(taxapropagacao,beta)
        rsquared       <- c(rsquared, summary(exponential.model)$adj.r.squared)
        pvalue         <- c(pvalue, anova(exponential.model)$'Pr(>F)'[1])
      } else {
        
        
        
        fim<-ifelse(numberofrow>11,numberofrow-2,numberofrow)
        init<-ifelse(fim < 11, 1, fim - 9)
        
        tempo<-seq(1,fim-init+1,1)
        
        exponential.model <- lm(log(as.numeric(dadosfinal$acumulado[init:fim]))~ tempo)
        #summary(exponential.model)
        beta <- coef(exponential.model)[2]+0.1 #ae^{beta t}
        acq<-alpha.0 <- exp(coef(exponential.model)[1])
        
        
        taxapropagacao <- c(taxapropagacao,beta)
        rsquared       <- c(rsquared, summary(exponential.model)$adj.r.squared)
        pvalue         <- c(pvalue, anova(exponential.model)$'Pr(>F)'[1])
        
      }
    }
    
    
    
    
    ####################################################################################################################
    #############################              PREVALENCIA           ###############################################
    ####################################################################################################################
    
    
    
    if (numberofrow < 1) {
      prevalencia<-c(prevalencia,0)
    } else {
      
      ifelse(numberofrow>11, prevalencia<-c(prevalencia,dadosfinal$infectados[nrow(dadosfinal)-2]), prevalencia<-c(prevalencia,dadosfinal$infectados[nrow(dadosfinal)]))
      
      
      
    }
    
    
    
    ####################################################################################################################
    ####################################################################################################################
    #############################       FIM DO SEGUNDO LAÇO       ##############################################################
    ####################################################################################################################
    ####################################################################################################################
    ## 
    
  }
  
  
  
  ####################################################################################################################
  ####################################################################################################################
  ####################################################################################################################
  #############################       FIM DO LAÇO       ##############################################################
  ####################################################################################################################
  ####################################################################################################################
  ####################################################################################################################
  
}











####################################################################################################################
#############################            RANK  DE RISCO RELATIVO ATUAL            ###############################################
####################################################################################################################


rsquared<-as.numeric(gsub(NaN, 1, rsquared))


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


risco<-as.numeric(as.character((rsquared*prevalencia*exp(10*taxapropagacao))))*1000000/pop
if(!input$scale=="Linear"){ 
  risco <- log10(risco)
  risco <- as.numeric(gsub(-Inf,0,risco))
}


rankrisco <- data.frame(cidades, risco)#, stringsAsFactors = FALSE
rankrisco <- rankrisco[(rankrisco$risco!=0), ]

height    <- max(70*nrow(rankrisco),500)

#rankrisco$cidades <- factor(rankrisco$cidades, levels = unique(rankrisco$cidades)[order(rankrisco$risco, decreasing = FALSE)])


rankrisco <- as_tibble(rankrisco)

rankrisco$cidades <- factor(rankrisco$cidades, levels = unique(rankrisco$cidades)[order(rankrisco$risco, decreasing = FALSE)])

rankrisco %>%
  ggplot(aes(x = reorder(cidades, -risco), y=risco))+
  geom_col() +
  coord_flip()



riscomedio <- (30/(sum(pop)))*5*exp(10*0.12)*1000000

riscoalto  <- (30/(sum(pop)))*20*exp(10*0.2)*1000000

if(!input$scale=="Linear"){ 
  riscomedio <- log10(riscomedio)
  riscomedio <- as.numeric(gsub(-Inf,0,riscomedio))
  riscoalto  <- log10(riscoalto)
  riscoalto  <- as.numeric(gsub(-Inf,0,riscoalto))
}

mid        <- (riscomedio+riscoalto)/2


a<-ggplot(rankrisco, aes(x = reorder(rankrisco$cidades,-rankrisco$risco), y=risco)) +
  geom_bar(aes(fill = risco), stat = "identity") +
  scale_fill_gradient2(low = "orange", mid = "red", high = "#500000", midpoint = mid)+
  coord_flip()+theme(
    axis.ticks = element_blank(),
    legend.position = "none",
    panel.background = element_rect(fill = "transparent", colour = NA),
    plot.background = element_rect(fill = "transparent", colour = NA),
    legend.background = element_rect(fill = "transparent", colour = NA),
    legend.box.background = element_rect(fill = "transparent", colour = NA)
  ) + geom_hline(yintercept = riscomedio, #linetype="dotted",
                 color = mla_palette[4], size=1.5) + geom_hline(yintercept = riscoalto, #linetype="dotted",
                                                       color = mla_palette[5], size=1.5)





fig<-ggplotly(a, height = height) %>% layout(title = "", spikedistance =  -1, hovermode = FALSE, title = list(font = 1), 
                                             xaxis = list(title = "", title = list(font = 25),  showticklabels = FALSE, showgrid = FALSE, zeroline = FALSE, showline = FALSE),#type = "log",
                                             yaxis = list(title = "", showgrid = FALSE, autorange = "reversed"),
                                             autosize = T, margin = list(l=100, r=150, b=100, 
                                                                         t=100, pad=4)) %>% add_annotations(
                                                                           x= riscomedio,
                                                                           y= .3,
                                                                           xref = "x",
                                                                           yref = "y",
                                                                           text = "Faixa de limite entre risco baixo e moderado",
                                                                           showarrow = T,
                                                                           ax = 0,
                                                                           ay = -70
                                                                         ) %>% add_annotations(
                                                                           x= riscoalto,
                                                                           y= .3,
                                                                           xref = "x",
                                                                           yref = "y",
                                                                           text = "Faixa de limite entre risco moderado e alto",
                                                                           showarrow = T,
                                                                           ax = 0,
                                                                           ay = -50
                                                                         ) %>% config(displayModeBar = FALSE) 


plotrankriscorelativo<-fig








####################################################################################################################
#############################            RANK  DE RISCO ATUAL            ###############################################
####################################################################################################################


rsquared<-as.numeric(gsub(NaN, 1, rsquared))


risco<-as.numeric(as.character((rsquared*prevalencia*exp(10*taxapropagacao)*100000)))
if(!input$scale=="Linear"){ 
  risco <- log10(risco)
  risco <- as.numeric(gsub(-Inf,0,risco))
}


rankrisco <- data.frame(cidades, risco)#, stringsAsFactors = FALSE
rankrisco <- rankrisco[(rankrisco$risco!=0), ]

height    <- max(70*nrow(rankrisco),500)

#rankrisco$cidades <- factor(rankrisco$cidades, levels = unique(rankrisco$cidades)[order(rankrisco$risco, decreasing = FALSE)])


rankrisco <- as_tibble(rankrisco)

rankrisco$cidades <- factor(rankrisco$cidades, levels = unique(rankrisco$cidades)[order(rankrisco$risco, decreasing = FALSE)])

rankrisco %>%
  ggplot(aes(x = reorder(cidades, -risco), y=risco))+
  geom_col() +
  coord_flip()



riscomedio2 <- 5*exp(10*0.12)*100000

riscoalto2  <- 20*exp(10*0.2)*100000

if(!input$scale=="Linear"){ 
  riscomedio2 <- log10(riscomedio2)
  riscomedio2 <- as.numeric(gsub(-Inf,0,riscomedio2))
  riscoalto2  <- log10(riscoalto2)
  riscoalto2  <- as.numeric(gsub(-Inf,0,riscoalto2))
}

mid2        <- (riscomedio2+riscoalto2)/2


a<-ggplot(rankrisco, aes(x = reorder(rankrisco$cidades,-rankrisco$risco), y=risco)) +
  geom_bar(aes(fill = risco), stat = "identity") +
  scale_fill_gradient2(low = "orange", mid = "red", high = "#500000", midpoint = mid2)+
  coord_flip()+theme(
    axis.ticks = element_blank(),
    legend.position = "none",
    panel.background = element_rect(fill = "transparent", colour = NA),
    plot.background = element_rect(fill = "transparent", colour = NA),
    legend.background = element_rect(fill = "transparent", colour = NA),
    legend.box.background = element_rect(fill = "transparent", colour = NA)
  ) + geom_hline(yintercept = riscomedio2, #linetype="dotted",
                 color = mla_palette[4], size=1.5) + geom_hline(yintercept = riscoalto2, #linetype="dotted",
                                                       color = mla_palette[5], size=1.5)





fig<-ggplotly(a, height = height) %>% layout(title = "", spikedistance =  -1, hovermode = FALSE, title = list(font = 1), 
                                             xaxis = list(title = "", title = list(font = 25),  showticklabels = FALSE, showgrid = FALSE, zeroline = FALSE, showline = FALSE),#type = "log",
                                             yaxis = list(title = "", showgrid = FALSE, autorange = "reversed"),
                                             autosize = T, margin = list(l=100, r=150, b=100, t=100, pad=4) ) %>% add_annotations(
                                               x= riscomedio2,
                                               y= .3,
                                               xref = "x",
                                               yref = "y",
                                               text = "Limite entre risco baixo e moderado",
                                               showarrow = T,
                                               ax = 0,
                                               ay = -70
                                             ) %>% add_annotations(
                                               x= riscoalto2,
                                               y= .3,
                                               xref = "x",
                                               yref = "y",
                                               text = "Limite entre risco moderado e alto",
                                               showarrow = T,
                                               ax = 0,
                                               ay = -50
                                             ) %>% config(displayModeBar = FALSE)


plotrankrisco<-fig









