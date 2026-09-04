

### Retirar acentos e caracteres especiais
rm_accent <- function(str,pattern="all") {
  if(!is.character(str))
    str <- as.character(str)
  pattern <- unique(pattern)
  if(any(pattern=="Ç"))
    pattern[pattern=="Ç"] <- "ç"
  symbols <- c(
    acute = "áéíóúÁÉÍÓÚýÝ",
    grave = "àèìòùÀÈÌÒÙ",
    circunflex = "âêîôûÂÊÎÔÛ",
    tilde = "ãõÃÕñÑ",
    umlaut = "äëïöüÄËÏÖÜÿ",
    cedil = "çÇ"
  )
  nudeSymbols <- c(
    acute = "aeiouAEIOUyY",
    grave = "aeiouAEIOU",
    circunflex = "aeiouAEIOU",
    tilde = "aoAOnN",
    umlaut = "aeiouAEIOUy",
    cedil = "cC"
  )
  accentTypes <- c("´","`","^","~","¨","ç")
  if(any(c("all","al","a","todos","t","to","tod","todo")%in%pattern)) # opcao retirar todos
    return(chartr(paste(symbols, collapse=""), paste(nudeSymbols, collapse=""), str))
  for(i in which(accentTypes%in%pattern))
    str <- chartr(symbols[i],nudeSymbols[i], str)
  return(str)
}


transform_dates     <- function(x){ 
  formats             <- c("%m/%d/%Y", "%d/%m/%Y", "%Y/%m/%d", "%d/%m%Y")
  dates               <- as.Date(rep(NA, length(x)))
  for (fmt in formats) {
    nas        <- is.na(dates)
    dates[nas] <- as.Date(x[nas], format=fmt,origin = "1899-12-30")
  }
  nas        <- is.na(dates);nas
  dates[nas] <- as.Date(as.integer(x[nas]), origin="1899-12-30")
  return(dates)
}




## GIF
plot_gifs <- function(){
  library(gganimate)
  
    data_casos_acumulados <- data_casos[,-2]
    data_casos_acumulados[,2:length(data_casos_acumulados)] <- apply(data_casos_acumulados[,2:length(data_casos_acumulados)],2, cumsum)
    stack_casos           <- stack(data_casos_acumulados)
    label                 <- rep(datas,length(colnames(data_casos_acumulados[2:31])))
    stack_casos[,"label"] <- label
    stack_casos           <- stack_casos[stack_casos$values>0,]
    stack_casos$dia <- day(stack_casos$label)
    stack_casos$mes <- month(stack_casos$label)
    title='Evolução do Número de Casos : '
    
    anim_table2 <- stack_casos %>%
      dplyr::group_by(label) %>%
      dplyr::mutate(
        rank = rank(-values,ties.method = "first") * 1) %>%
      dplyr::ungroup()
    
    t <-anim_table2[order(anim_table2$mes,anim_table2$dia),]
    ldia <- t$dia[length(t$dia)]
    lm <- t$mes[length(t$mes)]
    te<- t %>% filter(dia==ldia & mes==lm)
    t <- rbind(t,te,te,te,te,te)
    
    staticplot = ggplot(t, aes(rank, group = ind, 
                               fill = as.factor(ind), color = as.factor(ind))) +
      geom_tile(aes(y = values/2,
                    height = values,
                    width = 0.90), alpha = 0.8, color = NA) +
      geom_text(aes(y = 0, label = paste(ind, " ")), hjust = 0.95, size = 10) +
      geom_text(aes(y = values, label = as.character(values)), hjust = -0.2,size = 12) +
      coord_flip(clip = "off", expand = FALSE) +
      scale_y_continuous(labels = scales::comma) +
      scale_x_reverse() +
      guides(color = FALSE, fill = FALSE) +
      theme(axis.line=element_blank(),
            axis.text.x = element_blank(),
            axis.text.y = element_blank(),
            axis.ticks=element_blank(),
            axis.title.x = element_blank(),
            axis.title.y = element_blank(),
            legend.position="none",
            panel.background=element_blank(),
            panel.border=element_blank(),
            panel.grid.major=element_blank(),
            panel.grid.minor=element_blank(),
            panel.grid.major.x = element_line( size=.1, color="grey" ),
            panel.grid.minor.x = element_line( size=.1, color="grey" ),
            plot.title=element_text(size=40, hjust=0.5, face="bold", colour="black", vjust=0),
            plot.subtitle=element_text(size=18, hjust=0.5, face="italic", color="black"),
            plot.caption =element_text(size=8, hjust=0.5, face="italic", color="grey"),
            plot.background=element_blank(),
            plot.margin = margin(0,6, 0, 14, "cm"))
    
    
    anim = staticplot + transition_states(states = label, transition_length = 1, state_length = 1,wrap = FALSE) +
      view_follow(fixed_x = TRUE)  +
      labs(title = paste0(title,'{closest_state}'),  
           subtitle  =  "Cidades da 15ª Regional de Saúde do Paraná com casos confirmados",
           caption  = "15ª Regional de Saúde")
    
   
      url="C:\\Users\\mleal\\Dropbox\\data_covid\\gganim_casos.gif"
   
    animate(anim, 1680/2, fps = 20,  width = 1280, height = 600, end_pause = 50,
            renderer = gifski_renderer(url,loop = TRUE))
    cat("Done!!! GIF:",title," Salvo em :", url, " Com Sucesso!!!")
 ######################################################################################
    
    
    data_incidencias_acumulados <- incidencias[,-2]
    stack_casos           <- stack(data_incidencias_acumulados)
    label                 <- rep(datas,length(colnames(data_incidencias_acumulados[2:31])))
    stack_casos[,"label"] <- label
    stack_casos           <- stack_casos[stack_casos$values>0,]
    stack_casos$dia <- day(stack_casos$label)
    stack_casos$mes <- month(stack_casos$label)
    title='Evolução das Incidências : '
    
  anim_table2 <- stack_casos %>%
    dplyr::group_by(label) %>%
    dplyr::mutate(
      rank = rank(-values,ties.method = "first") * 1) %>%
    dplyr::ungroup()
  
  t <-anim_table2[order(anim_table2$mes,anim_table2$dia),]
  ldia <- t$dia[length(t$dia)]
  lm <- t$mes[length(t$mes)]
  te<- t %>% filter(dia==ldia & mes==lm)
  t <- rbind(t,te,te,te,te,te)
  
  staticplot = ggplot(t, aes(rank, group = ind, 
                             fill = as.factor(ind), color = as.factor(ind))) +
    geom_tile(aes(y = values/2,
                  height = values,
                  width = 0.90), alpha = 0.8, color = NA) +
    geom_text(aes(y = 0, label = paste(ind, " ")), hjust = 0.95, size = 10) +
    geom_text(aes(y = values, label = as.character(values)), hjust = -0.2,size = 12) +
    coord_flip(clip = "off", expand = FALSE) +
    scale_y_continuous(labels = scales::comma) +
    scale_x_reverse() +
    guides(color = FALSE, fill = FALSE) +
    theme(axis.line=element_blank(),
          axis.text.x = element_blank(),
          axis.text.y = element_blank(),
          axis.ticks=element_blank(),
          axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          legend.position="none",
          panel.background=element_blank(),
          panel.border=element_blank(),
          panel.grid.major=element_blank(),
          panel.grid.minor=element_blank(),
          panel.grid.major.x = element_line( size=.1, color="grey" ),
          panel.grid.minor.x = element_line( size=.1, color="grey" ),
          plot.title=element_text(size=40, hjust=0.5, face="bold", colour="black", vjust=0),
          plot.subtitle=element_text(size=18, hjust=0.5, face="italic", color="black"),
          plot.caption =element_text(size=8, hjust=0.5, face="italic", color="grey"),
          plot.background=element_blank(),
          plot.margin = margin(0,6, 0, 14, "cm"))
  
  
  anim = staticplot + transition_states(states = label, transition_length = 1, state_length = 1,wrap = FALSE) +
    view_follow(fixed_x = TRUE)  +
    labs(title = paste0(title,'{closest_state}'),  
         subtitle  =  "Cidades da 15ª Regional de Saúde do Paraná com casos confirmados",
         caption  = "15ª Regional de Saúde")
  
    url="C:\\Users\\mleal\\Dropbox\\data_covid\\gganim_incidencias.gif"
  
  
  animate(p, 1680/2, fps = 20,  width = 1280, height = 600, end_pause = 50,
          renderer = gifski_renderer(url,loop = TRUE))
  cat("Done!!! GIF:",title," Salvo em :", url, " Com Sucesso!!!")
  
}




pu_dia              <- function(datas){
  
  return(range(as.Date(datas),na.rm = TRUE))
}




intervalo_ticks <- function(datas){
  return(round(length(datas)/(round(length(datas))/3)))
}

intervalo_ticks_seq <- function(datas,x){
  if( length(x)> 20){
    
    int = round(length(datas)/(round(length(datas))/3))
    
  }else{
    
    int = 1
  }
  
  
  return(seq(1,length(datas),int))
  
  
}
