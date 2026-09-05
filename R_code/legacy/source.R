

cityinit<-rm_accent(message)
cityinit<-gsub(" ","",cityinit)
cityinit<-tolower(cityinit)
atualizado <- data_fim
dataset <- dataset1


dadoscity <- select(filter(dataset, cidade == cityinit), colnames(dataset))
totalcasos<-nrow(dadoscity)



if (nrow(dadoscity) < 1) {numberofrow<-0  } else {
  
  ####################################################################################################################
  #############################              NOVAS COLUNAS            ###############################################
  ####################################################################################################################
  
  
  
  viajem15<- function(cidade){
    if (as.character(cidade) == "MARINGA") {
      dadoscity$coleta <- as.Date(dadoscity$coleta, format="%d/%m/%Y")
      
      dadoscity<-arrange(dadoscity, coleta)
      b<-dadoscity  %>%  group_by ( coleta ) %>%  count ( viajem )
      sim <- select(filter(b, viajem == "SIM"), colnames(b))
      nao <- select(filter(b, viajem == "NAO"), colnames(b))
      datas<-seq(dadoscity$coleta[1], as.Date(dadoscity$coleta[nrow(dadoscity)]), by=1)
      viajem<-data.frame(datas)
      viajou<-c()
      for (i in 1:nrow(viajem)) {
        for (j in 1:nrow(sim)) {
          aux<-ifelse(viajem$datas[i]==sim$coleta[j],sim$n[j],0)
          if (viajem$datas[i]==sim$coleta[j]){break}
        }
        viajou<-cbind(viajou,aux[1])
      }
      viajou<-as.vector(viajou)
      viajem$viajou<-viajou
      
      naoviajou<-c()
      for (i in 1:nrow(viajem)) {
        for (j in 1:nrow(nao)) {
          aux<-ifelse(viajem$datas[i]==nao$coleta[j],nao$n[j],0)
          if (viajem$datas[i]==nao$coleta[j]){break}
        }
        naoviajou<-cbind(naoviajou,aux[1])
      }
      naoviajou<-as.vector(naoviajou)
      viajem$naoviajou<-naoviajou
      
      
      
      
      fig <- plot_ly(viajem, x = ~ viajem$datas, y = ~ viajem$naoviajou, type = 'bar', name = 'Não Viajou', marker = list(color = 'rgb(8,48,107)'))
      fig <- fig %>% add_trace(y = ~ viajem$viajou, name = 'Viajou', marker = list(color = 'rgb(58,200,225)'))#cor verde da página #18BC9C
      fig <- fig %>%  layout(hovermode = TRUE, spikedistance =  -1, barmode = 'stack',height= 340,
                             xaxis = list(title = "<b>DIA DA COLETA DO EXAME</b>", showspikes = TRUE, titlefont = list(size = 24),
                                          spikemode  = 'across', #toaxis, across, marker
                                          spikesnap = 'cursor',  ticks = "outside",tickangle = -45,
                                          showline=TRUE,tickfont = list(size = 24),type = 'date',
                                          tickformat = "%d/%m",   fixedrange=TRUE,
                                          showgrid=TRUE), 
                             yaxis = list (title = "<b>NÚMERO DE CASOS</b>",
                                           spikemode  = 'across', #toaxis, across, marker
                                           spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),
                                           showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                                           showgrid=TRUE),
                             plot_bgcolor  = "rgba(0, 0, 0, 0)",
                             paper_bgcolor = "rgba(0, 0, 0, 0)") %>% 
        config(displayModeBar = FALSE)
      
      
      
      
      
    }
    return(fig)
  }
  
  
  
  viajem15<- function(cidade){
    
    
    
    dadoscity$coleta <- as.Date(dadoscity$coleta, format="%d/%m/%Y")
    
    dadoscity<-arrange(dadoscity, coleta)
    dadoscity$viajem<-tolower(dadoscity$viajem)
    
    if (cityinit == "astorga") {dadoscity$viajem <- gsub("n", "nao", dadoscity$viajem)}
    
    for (i in 1:nrow(dadoscity)) {
      aux <- ifelse(i %in% grep("nao", dadoscity$viajem), "NAO", "SIM")
      dadoscity$viajem[i] <- aux
    }
    
    
    
    
    b<-dadoscity  %>%  group_by ( coleta ) %>%  count ( viajem )
    sim <- select(filter(b, viajem != "NAO"), colnames(b))
    nao <- select(filter(b, viajem == "NAO"), colnames(b))
    datas<-seq(dadoscity$coleta[1], as.Date(dadoscity$coleta[nrow(dadoscity)]), by=1)
    viajem<-data.frame(datas)
    if (nrow(sim)==0) {viajem$viajou <-rep(0, nrow(viajem)) } else {
      viajou<-c()
      for (i in 1:nrow(viajem)) {
        for (j in 1:nrow(sim)) {
          aux<-ifelse(viajem$datas[i]==sim$coleta[j],sim$n[j],0)
          if (viajem$datas[i]==sim$coleta[j]){break}
        }
        viajou<-cbind(viajou,aux[1])
      }
      viajou<-as.vector(viajou)
      viajem$viajou<-viajou
      
    }
    
    if (nrow(nao)==0) {viajem$naoviajou <-rep(0, nrow(viajem)) } else {
      naoviajou<-c()
      for (i in 1:nrow(viajem)) {
        for (j in 1:nrow(nao)) {
          aux<-ifelse(viajem$datas[i]==nao$coleta[j],nao$n[j],0)
          if (viajem$datas[i]==nao$coleta[j]){break}
        }
        naoviajou<-cbind(naoviajou,aux[1])
      }
      naoviajou<-as.vector(naoviajou)
      viajem$naoviajou<-naoviajou
    }
    
    
    
    
    fig <- plot_ly(viajem, x = ~ viajem$datas, y = ~ viajem$naoviajou, type = 'bar', name = 'Não Viajou', marker = list(color = 'rgb(8,48,107)'),height= 340)
    fig <- fig %>% add_trace(y = ~ viajem$viajou, name = 'Viajou ou teve contato', marker = list(color = 'rgb(58,200,225)'))
    fig <- fig %>% layout(hovermode = TRUE, spikedistance =  -1, barmode = 'stack',
                          xaxis = list(title = "<b>DIA DA COLETA DO EXAME</b>", showspikes = TRUE, titlefont = list(size = 24),
                                       spikemode  = 'across', #toaxis, across, marker
                                       spikesnap = 'cursor',  ticks = "outside",tickangle = -45,
                                       showline=TRUE,tickfont = list(size = 24),type = 'date',
                                       tickformat = "%d/%m",   fixedrange=TRUE,
                                       showgrid=TRUE), 
                          yaxis = list (title = "<b>NÚMERO DE CASOS</b>",
                                        spikemode  = 'across', #toaxis, across, marker
                                        spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),
                                        showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                                        showgrid=TRUE),
                          
                          plot_bgcolor  = "rgba(0, 0, 0, 0)",
                          paper_bgcolor = "rgba(0, 0, 0, 0)") %>%
      config(displayModeBar = FALSE)
    
    
    
    
    return(fig)
  }
  
  
  
  
  #dadoscity$coleta <- as.Date(dadoscity$coleta, format="%d/%m/%Y")
  dadoscity$coleta <- dadoscity$coleta
  #dadosmga$sintomas <- as.Date(dadosmga$sintomas, format="%d/%m/%Y")
  dadoscity<-arrange(dadoscity, coleta)
  a<-dadoscity  %>%  group_by ( coleta ) %>%  count ( coleta )
  a<-data.frame(a)
  #time<-seq(a$coleta[1], as.Date(a$coleta[nrow(a)]), by=1)
  time<-seq(a$coleta[1], as.Date(strptime(atualizado, "%d/%m/%Y")), by="days")
  
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
#############################              FUNÇÃO TAXA            ###############################################
####################################################################################################################




taxaevol<-function(x){
  
  if (numberofrow < 10) {
    
  } else {
    
    
    
    
    
    k<-numberofrow-9
    
    taxa<-c()
    init<-1
    fim<-10
    for (i in 1:k) {
      
      tempo<-seq(1,fim-init+1,1)
      
      
      exponential.model <- lm(log(as.numeric(dadosfinal$acumulado[init:fim]))~ tempo)
      #summary(exponential.model)
      beta <- as.numeric(coef(exponential.model)[2]+0.1) #ae^{beta t}
      taxa<-c(taxa,beta)
      init<-init+1
      fim<-fim+1
    }
    
    
    taxa<-x*as.vector(taxa)
    
    title<-ifelse(x==1, "Evolução da taxa de propagação", "Evolução do número de reprodução")
    
    
    fig <- plot_ly(
      x = dadosfinal$time[10:nrow(dadosfinal)],height= 340,
      y = taxa,
      type = "scatter",
      mode = "lines+markers",
      name="Taxa de propagação",
      marker=list(color="red", size=10),
      line=list(size=10)
      
      
    )
    fig <- fig %>% layout(hovermode = TRUE, spikedistance =  -1,
                          xaxis = list(title = "<b>DATA</b>", showspikes = TRUE, titlefont = list(size = 24),
                                       spikemode  = 'across', #toaxis, across, marker
                                       spikesnap = 'cursor',  ticks = "outside",tickangle = -45,
                                       showline=TRUE,tickfont = list(size = 24),
                                       fixedrange=TRUE,
                                       showgrid=TRUE),
                          yaxis = list (title = "<b>VALOR DA TAXA</b>",
                                        spikemode  = 'across', #toaxis, across, marker
                                        spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),
                                        showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                                        showgrid=TRUE),
                          
                          plot_bgcolor  = "rgba(0, 0, 0, 0)",
                          paper_bgcolor = "rgba(0, 0, 0, 0)") %>% 
      config(displayModeBar = FALSE)
    
    return(fig)
    
  }
  
  
}
