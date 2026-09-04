


server <- function(input, output, session) {
  USER <- reactiveValues(Logged = FALSE)
  
  
  #####################################################################################################################
  #################################### INICIANDO LOGIN E PAGINA INICIAL ###############################################
  #####################################################################################################################
  
  
  observe({
    if (USER$Logged == TRUE) {
      output$body <- renderUI({
        fluidRow(
          
          div(
            
            fluidRow(HTML('<i class="fas fa-sign-in-alt" style = "color:#0072B2;font-size:50px;padding-left:20px;"></i>
                           <b style = "padding-left:5px;color:#0072B2;font-size:30px">ENTRAR</b>')),    
            espaco_html(1),
            fluidRow(
              
              div(style="display:inline-block",
                  textInput("username",label = HTML('<b style = "padding-left:0px;color:#0072B2;font-size:16px">USUÁRIO : </b>'),width=150)), 
              style="display:center-align"),
          fluidRow(
            div(style="display:inline-block",
                passwordInput("password", label = HTML('<b style = "padding-left:0px;color:#0072B2;font-size:16px">SENHA : </b>'),width = 150)), 
            style="display:center-align"),
          fluidRow(
              div(actionBttn(
                inputId = "login",
                size = "lg",
                label = "Entrar",
                color = "primary",
                style = "jelly",
                block = TRUE,
                icon = icon("sign-in")),
                style = sprintf("text-align:center;padding-left:20px;"))),style="text-align:center"),
          style = "
               border-radius: 10px color:rgba( 19,49,71, 0.8);
               box-shadow: 0 0 50px 0 rgba(69, 69, 69, 0.2);
               margin: 0px 10px 30px 10px; padding: 10px;
               background-repeat: repeat;
               background-size: 50px 50px;
               background-blend-mode: lighten;
          text-align:center")
        #background-image: url(virus.png);
        })
      
      
      
    } else if (USER$Logged == FALSE) {
      
    
      
      output$body <- renderUI({
        
        
        # show_alert(
        #   
        #   title = NULL,
        #   btn_labels = NA,
        #   showCloseButton = TRUE,
        #   text = fluidRow(column(width=12, info_alert,espaco_html(4))),
        #   html = TRUE,
        #   width = "90%")  
       
         fluidRow(
          
          div(
            tabsetPanel(id = 'navbar',
                        informe,
                        mapa,
                        nivel_risco,
                        colaboradores,
                        mais
                        )
            ),
          style = "
               border-radius: 10px color:rgba( 19,49,71, 0.8);
               box-shadow: 0 0 50px 0 rgba(69, 69, 69, 0.2);
               margin: 0px 10px 30px 10px; padding: 10px;
               background-repeat: repeat;
               background-size: 50px 50px;
               background-blend-mode: lighten;")
        
        #background-image: url(virus.png);
        })
      
      
        }
    
  })
 
  dados_table <- data_casos
  observeEvent(input$select_dadoscasos, {
    output$dadosselecttext <- renderText({
      
      as.character(input$select_dadoscasos)
      
    })
    
    if(as.character(input$select_dadoscasos) == 'Casos Por Dia'){
      
      dados_table <- data_casos[,c(1,which(apply(data_casos[2:32],2,sum) > 0)+1)]
      sum(dados_table$ATALAIA)
      
    }else if (as.character(input$select_dadoscasos) == 'Incidências'){
      
      
      dados_table <- incidencias[,c(1,which(apply(incidencias[2:32],2,sum) > 0)+1)]
      
      
      
    }else if (as.character(input$select_dadoscasos) == 'Casos Acumulados'){
      
      dados_table <- as.data.frame(apply(data_casos[,2:32],2,cumsum))
      dados_table <- dados_table[,which(apply(dados_table,2,sum) > 0)]
      dados_table <- data.frame(DATAS=data_casos[,1],dados_table)
      
      
    }
    
    output$tabela_qtdcasos <- renderDataTable(as.data.frame(dados_table),
                                              options = list(
                                                pageLength = 10,
                                                scrollX=TRUE,
                                                searching = FALSE,
                                                autoWidth = TRUE
                                                
                                                
                                              )
    )
    
    
    
    
    
  })
  
  
  observeEvent(list(input$toTop1,input$toTop2,input$toTop3,input$toTop4,input$toTop5,input$toTop6), {
    shinyjs::runjs("window.scrollTo(0, 0)")
  })
  
  
  output$obitos <- renderDataTable(as.data.frame(obitos_mun[,obitos_mun[1,]>0]),
                                   options = list(
                                     pageLength = 10,
                                     scrollX=TRUE,
                                     searching = FALSE,
                                     autoWidth = TRUE)
  )
  
  
  
  output$pop_cog <- renderDataTable(as.data.frame(cbind(populacao_municipio[1:16,],populacao_municipio[17:32,])),
                                    options = list(
                                      pageLength = 16,
                                      scrollX=TRUE,
                                      searching = FALSE,
                                      autoWidth = TRUE
                                      
                                      
                                    )
  )
  
  
  
  observeEvent(input$cog1, {
    
    toggle(selector = "#navbar li a[data-value=cog]",animType = 'fade')
  })
  
  
  observeEvent(input$login, {
    user <- credentials[[input$username]]
    if (!is.null(user) && isTRUE(as.character(user$pass) == as.character(input$password))){
      # dataset                    <- drop_read_csv(file = "data_covid/dataset.csv",sep=";", header=T, stringsAsFactors = F,dtoken = token )
      
      USER$Logged <- TRUE
      
      #updateNavbarPage(session = session,inputId = "nav_bar",selected = 1)
      show_toast(
        title = "Entrando ... ",
        text = "",
        type = "success",
        width = "200px",
        position = "bottom"
      )
      
      
      output$user_panel <- renderUI({
        
        dropdown( box( title= tags$div(HTML('<i class="fa fa-user"style = "color:#0072B2;font-size:40px;text-align:left;"></i>
                                               <b style = "padding-left:0px;color:#000000;font-size:20px;text-align:left;">
                                               PAINEL DO USUÁRIO </b>')),width = 12,
                       espaco_html(2),
                       fluidRow(column(width=12,align="center",
                                       strong(credentials[[input$username]]$"name"))),
                       ),
                  
                  fluidRow(column(width=12,align="left",
                                  uiOutput("buttons"))),
                  espaco_html(2),
                  actionBttn(
                    inputId = "logout",
                    label = "Sair",
                    color = "primary",
                    style = "jelly",
                    block = TRUE,
                    icon = icon("sign-out")),
                  style = "jelly", icon = icon("user",'fa-2x'),
                  status = "primary", width = "auto",tooltip =  tooltipOptions(title = "Clique para ver o painel !",placement = "left"),
                  animate = animateOptions(
                    enter = animations$fading_entrances$fadeInRightBig,duration = 0.25,
                    exit = animations$fading_exits$fadeOutRightBig))
        
        
        
      })
      
      
      output$buttons <- renderUI({
        if ( as.character(credentials[[input$username]]$username) == 'mleal'){
          appendTab(inputId = "navbar",
                    configuracoes
          )
          
          print(credentials[[input$username]])
          actionBttn(
            inputId = "cog1",
            label = "Configurações",
            color = "primary",
            style = "jelly",
            block = TRUE,
            icon = icon("cog"))
        }
        
        
      })
      
      
      
    } else {
      #showNotification(fluidRow(icon("exclamation-triangle"),"Usuário ou Senha Invalidos"))
      show_toast(
        title = "Usuário e ou Senha Invalidos.",
        text = "Verifique!!!",
        type = "error",
        width = "200px",
        position = "bottom"
      )
    }
  })
  
  observeEvent(input$logout, {
    user <- credentials[[input$username]]
    if (!is.null(user) && isTRUE(as.character(user$pass) == as.character(input$password))){
      #USER$Logged <- FALSE
      show_toast(
        title = "",
        text = "Saindo ... ",
        timer=500,
        type = "default",
        width = "200px",
        position = "bottom"
      )
      session$reload()
      
    } 
  })
  
  
  output$dados_casos <- renderDataTable(as.data.frame(dados2),
                                        options = list(
                                          pageLength = 10,
                                          scrollX=TRUE,
                                          searching = FALSE,
                                          autoWidth = TRUE,
                                          columnDefs = list(list(targets=c(0), visible=TRUE, width='20'),
                                                            list(targets=c(1), visible=TRUE, width='50'),
                                                            list(targets=c(2), visible=TRUE, width='100'),
                                                            list(targets=c(3), visible=TRUE, width='250'),
                                                            list(targets=c(4), visible=TRUE, width='35'),
                                                            list(targets=c(5), visible=TRUE, width='35'),
                                                            list(targets=c(6), visible=TRUE, width='35'),
                                                            list(targets=c(7), visible=TRUE, width='35'),
                                                            list(targets=c(8), visible=TRUE, width='35'),
                                                            list(targets=c(9), visible=TRUE, width='35'),
                                                            
                                                            list(targets='_all', visible=FALSE))
                                          
                                        )
  )
  
  
  
  
  output$table_populacao <- renderDataTable(as.data.frame(populacao_municipio,row.names = F),
                                            options = list(
                                              pageLength = 10,
                                              scrollX=TRUE,
                                              searching = FALSE,
                                              autoWidth = TRUE,
                                              columnDefs = list(list(targets=c(0), visible=TRUE, width='50'),
                                                                list(targets=c(1), visible=TRUE, width='250'),
                                                                list(targets=c(2), visible=TRUE, width='75'),
                                                                list(targets='_all', visible=FALSE))
                                              
                                            )
  )
  
  output$table_populacao2 <- renderDataTable(as.data.frame(populacao_municipio,row.names = F),
                                             options = list(
                                               pageLength = 10,
                                               scrollX=TRUE,
                                               searching = FALSE,
                                               autoWidth = TRUE,
                                               columnDefs = list(list(targets=c(0), visible=TRUE, width='50'),
                                                                 list(targets=c(1), visible=TRUE, width='250'),
                                                                 list(targets=c(2), visible=TRUE, width='75'),
                                                                 list(targets='_all', visible=FALSE))
                                               
                                             )
  )
  
  #####################################################################################################################
  #################################### PROCESSANDO LOG-IN E LOG-OUT ###############################################
  #####################################################################################################################
  
  
  
  
  observeEvent(input$sobre1, {
    toggle(id = 'panel_cidades1',anim = TRUE,animType = "fade")
  })
  
  observeEvent(input$toggle_pusuario, {
    toggle(id = 'panel_usuario',anim = TRUE,animType = "fade")
  })
  
  
  
  #####################################################################################################################
  ####################################        RENDERIZANDO PAGINA INICIAL ###############################################
  #################################### GRAFICO DA REGIONAL - CASOS ACUMULADOS POR DIA #####################################################
  output$plot_pie_sexo <- renderPlotly({
    
    data_sexo <- data.frame(n = casos_sexo[,1],categorie = c("FEMININO","MASCULINO"))
    fig <- plot_ly(data_sexo, labels = ~categorie, values = ~n, type = 'pie',
                   textposition = 'inside',
                   textinfo = 'label+percent',
                   insidetextfont = list(color = '#FFFFFF'),
                   hoverinfo = 'text',
                   insidetextorientation='horizontal',
                   text = ~paste( n, ' casos'),
                   marker = list(colors = c('red','blue'),
                                 line = list(color = '#FFFFFF', width = 1)),
                   #The 'pull' attribute can also be used to create space between the sectors
                   showlegend = FALSE)
    fig <- fig %>% layout(hovermode = TRUE, spikedistance =  -1,
                          xaxis = list(title = "<b>DATAS</b>", showspikes = TRUE, titlefont = list(size = 24),
                                       spikemode  = 'across', #toaxis, across, marker
                                       spikesnap = 'cursor',  ticks = "outside",tickangle = -45,
                                       showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                                       showgrid=TRUE), 
                          yaxis = list (title = "<b>NÚMERO DE CASOS</b>",
                                        spikemode  = 'across', #toaxis, across, marker
                                        spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),fixedrange=TRUE,
                                        showline=TRUE,tickfont = list(size = 24),
                                        showgrid=TRUE))%>% 
      config(displayModeBar = FALSE)
    
    fig
    
  })
  
  
  output$plot_pie_obito_sexo <- renderPlotly({
    
    data_sexo <- data.frame(n=obitos_sexo,categorie=c("FEMININO","MASCULINO"))
    
    fig <- plot_ly(data_sexo, labels = ~categorie, values = ~n, type = 'pie',
                   textposition = 'inside',
                   textinfo = 'label+percent',
                   insidetextfont = list(color = '#FFFFFF'),
                   hoverinfo = 'text',
                   insidetextorientation='horizontal',
                   text = ~paste( n, ' óbitos'),
                   marker = list(colors = c('red','blue'),
                                 line = list(color = '#FFFFFF', width = 1)),
                   #The 'pull' attribute can also be used to create space between the sectors
                   showlegend = FALSE)
    fig <- fig %>% layout(hovermode = TRUE, spikedistance =  -1,
                          xaxis = list(title = "<b>DATAS</b>", showspikes = TRUE, titlefont = list(size = 24),
                                       spikemode  = 'across', #toaxis, across, marker
                                       spikesnap = 'cursor',  ticks = "outside",tickangle = -45,
                                       showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                                       showgrid=TRUE), 
                          yaxis = list (title = "<b>NÚMERO DE CASOS</b>",
                                        spikemode  = 'across', #toaxis, across, marker
                                        spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),fixedrange=TRUE,
                                        showline=TRUE,tickfont = list(size = 24),
                                        showgrid=TRUE))%>% 
      config(displayModeBar = FALSE)
    
    fig
    
  })
  # RENDER INFORMAÇÃO/GRAFICOS DOS CASOS ACUMULADOS REGIONAL-------
  output$plot_regional <- renderPlotly({
    
    range(datas)
    stack_casos <- stack(data_casos)
    label <- rep(datas,length(colnames(data_casos[2:32])))
    stack_casos[,"label"] <- label
    stack_casos <- stack_casos[stack_casos$values>0,]
    pos_reg <- which(stack_casos$ind == "REGIONAL")
    stack_casos <- stack_casos[c(pos_reg),]
    
    fig<-plot_ly(x = ~ stack_casos$label, y = ~ cumsum(stack_casos$values), mode = 'lines+markers', type="scatter", 
                 text = "", marker=list(color = "#000000", size=10, opacity=0.75), 
                 line = list(color = "#09557f", width = 4,opacity= 0.75), name = 'Suscetíveis')
    fig <- fig %>% layout(hovermode = TRUE, spikedistance =  -1,
                          xaxis = list(title = "<b>DATAS</b>", showspikes = TRUE, titlefont = list(size = 24),
                                       spikemode  = 'across', #toaxis, across, marker
                                       spikesnap = 'cursor',  ticks = "outside",tickangle = -45,
                                       showline=TRUE,tickfont = list(size = 24),type = 'date',fixedrange=TRUE,
                                       tickformat = "%d/%m", showgrid=TRUE), 
                          yaxis = list (title = "<b>NÚMERO DE CASOS</b>",
                                        spikemode  = 'across', #toaxis, across, marker
                                        spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),fixedrange=TRUE,
                                        showline=TRUE,tickfont = list(size = 24),
                                        showgrid=TRUE))%>% 
      config(displayModeBar = FALSE)
    fig
  })
  #####################################################################################################################
  #################################### GRAFICO REGIONAL CASOS POR DIA ###############################################
  #####################################################################################################################
  output$plot_regional_dia <- renderPlotly({
    
    stack_casos           <- stack(data_casos)
    label                 <- rep(datas,length(colnames(data_casos[2:32])))
    stack_casos[,"label"] <- label
    stack_casos           <- stack_casos[stack_casos$values>0,]
    pos_reg               <- which(stack_casos$ind == "REGIONAL")
    stack_casos           <- stack_casos[c(pos_reg),]
    
    
    
    
    fig<-plot_ly(x = ~ stack_casos$label, y = ~ stack_casos$values, type="bar", height= 500,
                 text = "", marker=list(color = "#09557f", size=10, opacity=0.75), 
                 name = 'Suscetíveis')
    fig <- fig %>% layout(hovermode = TRUE, spikedistance =  -1,
                          xaxis = list(title = "<b>DATAS</b>", showspikes = TRUE, titlefont = list(size = 24),
                                       spikemode  = 'across', #toaxis, across, marker
                                       spikesnap = 'cursor',  ticks = "outside",tickangle = -45,
                                       showline=TRUE,tickfont = list(size = 24),type = 'date',fixedrange=TRUE,
                                       tickformat = "%d/%m",
                                       
                                       
                                       
                                       showgrid=TRUE), 
                          yaxis = list (title = "<b>NÚMERO DE CASOS</b>",
                                        spikemode  = 'across', #toaxis, across, marker
                                        spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),
                                        showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                                        showgrid=TRUE),
                          autosize = T) %>% config(displayModeBar = FALSE)
    
    
    fig
    
    
    
    
  })
  #####################################################################################################################
  #################################### GRAFICO REGIONAL FAIXA ETARIA ###############################################
  #####################################################################################################################
  output$plot_faixa_etaria <- renderPlotly({
    
    x          <- faixa_etaria[,1]
    y          <- faixa_etaria[,2]
    
    
    
    fig<-plot_ly( y = ~ faixa_etaria[,1], x = ~ faixa_etaria[,2], type="bar",orientation = 'h', height= 500,
                  text = "", marker=list(color = "#09557f", size=10, opacity=0.75), 
                  name = 'Suscetíveis')
    fig <- fig %>% layout(hovermode = TRUE, spikedistance =  -1,
                          xaxis = list(title = "<b>NÚMERO DE CASOS</b>", showspikes = TRUE, titlefont = list(size = 24),
                                       spikemode  = 'across', #toaxis, across, marker
                                       spikesnap = 'cursor',  ticks = "outside",tickangle = 0,
                                       showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                                       showgrid=TRUE),
                          yaxis = list (title = "<b>FAIXA ETÁRIA</b>",
                                        spikemode  = 'across', #toaxis, across, marker
                                        spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),
                                        showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                                        showgrid=TRUE)) %>% 
      config(displayModeBar = FALSE)
    fig
    
  })
  #####################################################################################################################
  #################################### GRAFICO REGIONAL INCIDENCIA ###############################################
  #####################################################################################################################
  output$plot_incidencia_regional <- renderPlotly({
    # dados_pr_2                  <- dados_sesa[,c("values","data")]
    # colnames(dados_pr_2)        <- c("values","label")
    # dados_pr_2                  <- dados_pr_2[dados_pr_2$values>0,]
    stack_incidencias           <- stack(incidencias)
    label                       <- rep(datas,length(colnames(incidencias[2:32])))
    stack_incidencias[,"label"] <- label
    stack_incidencias           <- stack_incidencias[stack_incidencias$values>0,]
    pos_reg                     <- which(stack_incidencias$ind == "REGIONAL")
    stack_incidencias           <- stack_incidencias[c(pos_reg),-2]
    stack_incidencias$label     <- as.character(stack_incidencias$label)
    # t1                          <- right_join(x = stack_incidencias,y = dados_pr_2,by=c("label") )
    # pos_na                      <- is.na(t1$values.x)
    # t1$values.x[pos_na]         <- stack_incidencias[length(stack_incidencias$values),1]
    
    
    fig<-plot_ly(x = ~ stack_incidencias$label, y = ~ stack_incidencias$values,height= 500, mode = 'lines+markers', type="scatter", 
                 text = "", marker=list(color = "#000000", size=10, opacity=0.75), 
                 line = list(color = "#09557f", width = 4,opacity= 0.75), name = '15ª REGIONAL') 
    # add_trace(y = ~t1[,3], name = "PR", line = list(color = "#FF0000", width = 4))
    fig <- fig %>% layout(hovermode = TRUE, spikedistance =  -1,
                          xaxis = list(title = "<b>DATAS</b>", showspikes = TRUE, titlefont = list(size = 24),
                                       spikemode  = 'across', #toaxis, across, marker
                                       spikesnap = 'cursor',  ticks = "outside",tickangle = -45,
                                       showline=TRUE,tickfont = list(size = 24),type = 'date',
                                       tickformat = "%d/%m",fixedrange=TRUE,
                                       
                                       
                                       showgrid=TRUE), 
                          yaxis = list (title = "<b>INCIDÊNCIA</b>",
                                        spikemode  = 'across', #toaxis, across, marker
                                        spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),
                                        showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                                        showgrid=TRUE)
                          
                          
    ) %>% config(displayModeBar = FALSE)
    fig
    
    
  })
  #####################################################################################################################
  #################################### GRAFICO REGIONAL NUMERO DE CASOS POR CIDADE ###############################################
  #####################################################################################################################
  
  output$plot_numero_casos_cidades <- renderPlotly({
    library(dplyr)
    stack_casos <- as.numeric(apply(data_casos[3:32],2,sum))
    pos <-stack_casos > 0 
    label       <- colnames(data_casos[,3:32])[pos];label
    stack_casos <- stack_casos[stack_casos > 0 ];stack_casos
    
    casos <- data.frame(label=label,freq=stack_casos)
    casos <- casos[order(casos$freq,decreasing = F),]
    
    m <- list(
      l = 250,
      r = 10,
      b = 10,
      t = 10)
    
    fig<-plot_ly(x = ~ casos$freq , y = ~ as.character(casos$label), type="bar", orientation = 'H', 
                 text = "", marker=list(color = "#09557f", size=10, opacity=0.75), 
                 name = 'Suscetíveis')
    fig <- fig %>% layout(hovermode = TRUE, spikedistance =  -1,
                          xaxis = list(title = "<b>NÚMERO DE CASOS</b>", showspikes = TRUE, titlefont = list(size = 24),
                                       spikemode  = 'across', #toaxis, across, marker
                                       spikesnap = 'cursor',  ticks = "outside",tickangle = 0,
                                       showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                                       
                                       
                                       showgrid=TRUE), 
                          yaxis = list (title = "<b>CIDADES</b>",
                                        spikemode  = 'across', #toaxis, across, marker
                                        spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),
                                        showline=TRUE,tickfont = list(size = 16),categoryorder = "array",
                                        categoryarray = ~casos$freq,fixedrange=TRUE,
                                        showgrid=TRUE),margin = m,
                          autosize = T) %>% config(displayModeBar = FALSE)
    fig
    
    
    
    
  })
  
  #####################################################################################################################
  #################################### GRAFICO REGIONAL INCIDENCIA POR CIDADE ###############################################
  #####################################################################################################################
  
  
  output$plot_incidencia_cidades <- renderPlotly({
    library(dplyr)
    stack_casos <- incidencias[length(incidencias[,1]),3:32]
    pos <-stack_casos > 0 
    label       <- colnames(data_casos[,3:32])[pos];label
    stack_casos <- stack_casos[stack_casos > 0 ];stack_casos
    
    casos <- data.frame(label=label,freq=stack_casos)
    casos <- casos[order(casos$freq,decreasing = F),]
    
    m <- list(
      l = 250,
      r = 10,
      b = 10,
      t = 10)
    
    fig<-plot_ly(x = ~ casos$freq , y = ~ as.character(casos$label), type="bar", orientation = 'H', 
                 text = "", marker=list(color = "#09557f", size=10, opacity=0.75), 
                 name = 'Suscetíveis')
    fig <- fig %>% layout(hovermode = TRUE, spikedistance =  -1,
                          xaxis = list(title = "<b>INCIDÊNCIA</b>", showspikes = TRUE, titlefont = list(size = 24),
                                       spikemode  = 'across', #toaxis, across, marker
                                       spikesnap = 'cursor',  ticks = "outside",tickangle = 0,
                                       showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                                       
                                       
                                       showgrid=TRUE), 
                          yaxis = list (title = "<b>CIDADES</b>",
                                        spikemode  = 'across', #toaxis, across, marker
                                        spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),
                                        showline=TRUE,tickfont = list(size = 16),categoryorder = "array",
                                        categoryarray = ~casos$freq,fixedrange=TRUE,
                                        showgrid=TRUE),margin = m,
                          autosize = T
                          
                          
    ) %>% config(displayModeBar = FALSE)
    fig
    
    
    
    
  })
  #####################################################################################################################
  #################################### MAPA CIDADE COM CASOS CONFIRMADOS ###############################################
  #####################################################################################################################
  
  output$map2 <- renderLeaflet({
    
    
    leaflet(regional_maps,
            options = list(zoomControl = FALSE,
                           #center = c(-23.2,-53.06396),
                           zoom = 9,minZoom = 9, maxZoom = 9,
                           maxBounds = list(list(-23.15,-51.9113), list(-23.15,-51.9113))
            )) %>%
      addTiles() %>%
      #addMouseCoordinates() %>%
      setView(lng = -51.9113, lat = -23.17824, zoom=9) %>%
      addCircleMarkers(data = objeto_sf[objeto_sf$casos>0,],fillColor = "red",color = "red",weight = 30,
                       
                       popup = objeto_sf$name[objeto_sf$casos>0],label = objeto_sf$name[objeto_sf$casos>0],
                       labelOptions = labelOptions(noHide = F, textOnly = T,textsize = 30),
                       
                       layerId = ~objeto_sf$uid[objeto_sf$casos>0])  %>% 
      addPolygons(
        weight = 2,
        opacity = 0.1,
        color = "gray",
        dashArray = "3",
        fillOpacity = 0.1,
        highlight = highlightOptions(
          weight = 5,
          color = "#666",
          dashArray = "",
          fillOpacity = 0.1,
          bringToFront = TRUE),
        label = labels_map,
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto"))
    
  })
  
  #####################################################################################################################
  #################################### GIF ###############################################
  #####################################################################################################################
  
  
  
  
  
  #####################################################################################################################
  #################################### ABA MAPA CIDADES ###############################################
  #####################################################################################################################
  n_casos   <- apply(data_casos[,3:(length(lista_cidade_upper)+2)], MARGIN = 2,sum)
  
  
  ## RENDER MAPA-------
  setview <- data.frame(lng=-51.9113,lat = -23.15)
  # setview <- data.frame(lng=-50.75,lat = -23.15)
  output$map <- renderLeaflet({
    
    leaflet(regional_maps,
            options = list(zoomControl = FALSE,
                           #center = c(-23.2,-53.06396),
                           zoom = 9,minZoom = 9, maxZoom = 9,
                           maxBounds = list(setview+c(1,-1), setview+c(-1,+1))
            )) %>%
      addTiles() %>%
      setView(lng = setview[[1]], lat = setview[[2]], zoom=9) %>%
      addMarkers(data = objeto_sf,
                 popup = labels_map,
                 layerId = ~uid)   %>%
      addPolygons(
        fillColor = pal(as.numeric(incidencia_for_heat[2:31])),
        weight = 2,
        opacity = 1,
        color = "white",
        dashArray = "3",
        fillOpacity = 0.7,
        highlight = highlightOptions(
          weight = 5,
          color = "#666",
          dashArray = "",
          fillOpacity = 0.7,
          bringToFront = TRUE),
        label = labels_map,
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto")) %>%
      addLegend(pal = pal, values = ~density, opacity = 0.7, title = NULL,
                position = "topleft")
    
    
  })
  
  
  
  observeEvent(input$map_marker_click,{
    event          <- input$map_marker_click
    message        <- event$id
    
    if (is.null(event)){
      
      show_alert(title ="Esta cidade não possui casos confirmados." )
      
    }else if(n_casos[which(names(n_casos) == message)] == 0){
      
      show_alert(title ="Esta cidade não possui casos confirmados." )
      
    }else{
      
      show_alert(
        
        title = NULL,
        btn_labels = NA,
        showCloseButton = TRUE,
        text = fluidRow(column(width=12, panel_cidades,espaco_html(4))),
        html = TRUE,
        width = "95%")  
    }
    
  })
  
  
  
  
  # #RENDER GRAFICOS ----
  
  observe({
    
    event          <- input$map_marker_click
    message        <- event$id
    
    output$painel_text <- renderText({
      event          <- input$map_marker_click
      if(is.null(event)){
        texto <- "   PAINEL DE VISUALIZAÇÃO    "
      }else if(n_casos[which(names(n_casos) == message)] == 0){
        texto <- paste0(message," - ", "NÃO POSSUI CASOS CONFIRMADOS")
      }else{
        texto <- paste0(message," - ",n_casos[which(names(n_casos) == message)]," CASOS CONFIRMADOS - ",obitos_mun[,message]," ÓBITOS")
      }
      texto
    })
    
    
    if(is.null(event)){return()}
    
    i=as.numeric(which(lista_cidade_upper %in% event$id))
    
    ## RENDER INFORMAÇÃO/GRAFICOS DOS CASOS ACUMULADOS POR MUNICIPIO-------
    
    output$plot_gcidades <- renderPlotly({
      
      if(n_casos[which(names(n_casos) == message)] == 0){
        return()
      }else{
        stack_casos <- stack(data_casos)
        label <- rep(datas,length(colnames(data_casos[2:32])))
        
        stack_casos[,"label"] <- label
        stack_casos <- stack_casos[stack_casos$values>0,]
        pos_reg <- which(stack_casos$ind == "REGIONAL")
        stack_casos <- stack_casos[c(which(stack_casos$ind == message)),]
        
        fig<-plot_ly(x = ~ stack_casos$label, y = ~ cumsum(stack_casos$values),height=500, mode = 'lines+markers',
                     type="scatter", 
                     text = "", marker=list(color = "#09557f", size=9, opacity=0.75), 
                     line = list(color = "#09557f", width = 4,opacity= 0.75))
        fig <- fig %>% layout(hovermode = TRUE, spikedistance =  -1,
                              xaxis = list(title = "<b>DATAS</b>", showspikes = TRUE, titlefont = list(size = 24),
                                           spikemode  = 'across', #toaxis, across, marker
                                           spikesnap = 'cursor',  ticks = "outside",tickangle = -45,
                                           showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                                           showgrid=TRUE), 
                              yaxis = list (title = "<b>NÚMERO DE CASOS</b>",
                                            spikemode  = 'across', #toaxis, across, marker
                                            spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),
                                            showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                                            showgrid=TRUE),
                              
                              plot_bgcolor  = "rgba(0, 0, 0, 0)",
                              paper_bgcolor = "rgba(0, 0, 0, 0)") %>% config(displayModeBar = FALSE)
        fig
      }
    })
    
    
    
    ## RENDER INFORMAÇÃO/GRAFICOS DOS CASOS POR DI DOS MUNICIPIO-------
    output$plot_por_dia_municipio <- renderPlotly({
      if(n_casos[which(names(n_casos) == message)] == 0){
        return()
      }else{
        stack_casos <- stack(data_casos)
        label <- rep(datas,length(colnames(data_casos[2:32])))
        stack_casos[,"label"] <- label
        stack_casos <- stack_casos[stack_casos$values>0,]
        pos_reg <- which(stack_casos$ind == "REGIONAL")
        stack_casos <- stack_casos[c(which(stack_casos$ind == message)),]
        
        fig<-plot_ly(x = ~ stack_casos$label, y = ~ stack_casos$values, type="bar",height= 500,
                     text = "", marker=list(color = "#09557f", size=10, opacity=0.75))
        fig <- fig %>% layout(hovermode = TRUE, spikedistance =  -1,
                              xaxis = list(title = "<b>DATAS</b>", showspikes = TRUE, titlefont = list(size = 24),
                                           spikemode  = 'across', #toaxis, across, marker
                                           spikesnap = 'cursor',  ticks = "outside",tickangle = -45,
                                           showline=TRUE,tickfont = list(size = 24),type = 'date',fixedrange=TRUE,
                                           tickformat = "%d/%m",
                                           
                                           
                                           showgrid=TRUE),
                              yaxis = list (title = "<b>NÚMERO DE CASOS</b>",
                                            spikemode  = 'across', #toaxis, across, marker
                                            spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),
                                            showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                                            showgrid=TRUE),
                              autosize = T,
                              plot_bgcolor  = "rgba(0, 0, 0, 0)",
                              paper_bgcolor = "rgba(0, 0, 0, 0)") %>% 
          config(displayModeBar = FALSE)
        fig
        
        
        
      }
    })
    #
    #           ## RENDER INFORMAÇÃO/GRAFICOS DAS INCIDENCIAS POR MUNICIPIO-------
    output$plot_incidencia_municipios <- renderPlotly({
      if(n_casos[which(names(n_casos) == message)] == 0){
        return()
      }else{
        
        
        stack_incidencias <- incidencias
        stack_incidencias <- stack_incidencias[,c("label_datas","REGIONAL", message)]
        
        
        
        fig<-plot_ly(x = ~ stack_incidencias[,1], y = ~ stack_incidencias[,2], mode = 'lines+markers', type="scatter",height= 500,
                     text = "", marker=list(color = "#09557f", size=9, opacity=0.75),
                     line = list(color = "#09557f", width = 4,opacity= 0.75), name = colnames(stack_incidencias)[2]) %>%
          add_trace(y = ~stack_incidencias[,3], name = colnames(stack_incidencias)[3], line = list(color = "#FF0000", width = 4),
                    marker=list(color = "#FF0000", size=9, opacity=0.75) )
        fig <- fig %>% layout(hovermode = TRUE, spikedistance =  -1,
                              xaxis = list(title = "<b>DATAS</b>", showspikes = TRUE, titlefont = list(size = 24),
                                           spikemode  = 'across', #toaxis, across, marker
                                           spikesnap = 'cursor',  ticks = "outside",tickangle = -45,
                                           showline=TRUE,tickfont = list(size = 24),type = 'date',
                                           tickformat = "%d/%m",   fixedrange=TRUE,
                                           showgrid=TRUE),
                              yaxis = list (title = "<b>INCIDÊNCIA</b>",
                                            spikemode  = 'across', #toaxis, across, marker
                                            spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),
                                            showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                                            showgrid=TRUE),
                              
                              plot_bgcolor  = "rgba(0, 0, 0, 0)",
                              paper_bgcolor = "rgba(0, 0, 0, 0)") %>%
          config(displayModeBar = FALSE)
        fig
        
        
        
      }
    })
    #           ## RENDER INFORMAÇÃO/GRAFICOS DOS CASOS POR FAIXA ETARIA DOS MUNICIPIO-------
    output$plot_por_faixaetaria_municipio <- renderPlotly({
      if(n_casos[which(names(n_casos) == message)] == 0){
        return()
      }else{
        
        
        x          <- faixa_etaria[,1];x
        y          <- faixa_etaria[,message];y
        
        
        fig<-plot_ly( y = ~ x, x = ~ y, type="bar",orientation = 'h',height= 500,
                      text = "", marker=list(color = "#09557f", size=10, opacity=0.75),
                      name = 'Suscetíveis')
        fig <- fig %>% layout(hovermode = TRUE, spikedistance =  -1,
                              xaxis = list(title = "<b>NÚMERODE CASOS</b>", showspikes = TRUE, titlefont = list(size = 24),
                                           spikemode  = 'across', #toaxis, across, marker
                                           spikesnap = 'cursor',  ticks = "outside",tickangle = 0,
                                           showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                                           showgrid=TRUE),
                              yaxis = list (title = "<b>FAIXA ETÁRIA</b>",
                                            spikemode  = 'across', #toaxis, across, marker
                                            spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),
                                            showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                                            showgrid=TRUE),
                              plot_bgcolor  = "rgba(0, 0, 0, 0)",
                              paper_bgcolor = "rgba(0, 0, 0, 0)") %>% 
          config(displayModeBar = FALSE)
        fig
        
      }
    })
    
    
    
    
    output$plot_sexo_municipio <- renderUI({
      
      if(n_casos[which(names(n_casos) == message)] == 0){
        return()
      }else if(n_casos[which(names(n_casos) == message)] != 0){
        
        casos_sexo_municipio <- casos_sexo[,message]
        total_sexo <- sum(casos_sexo_municipio)
        panel <- fluidRow(column(width=12,align="left",tags$div(HTML('<i class="fa fa-venus-mars"style = "color:#0072B2;font-size:50px"></i>
                                   <b style = "padding-left:0px;color:#000000;font-size:30px"> SEXO </b>'))),
                          
                          fluidRow(
                            
                            fluidRow(
                              column(width=6,align="left",
                                     valueBox(
                                       
                                       value=paste0(casos_sexo_municipio[2]," (",round(((casos_sexo_municipio[2]/total_sexo)*100),2),"%)"),
                                       subtitle = tags$div(HTML('<b style = "padding-left:10px;font-size:16px">MASCULINO</b>')),
                                       width=8,
                                       icon = icon("male", lib = "font-awesome"),
                                       color = "blue")
                              ),
                              column(width=6,align="left",
                                     valueBox(
                                       
                                       value=paste0(casos_sexo_municipio[1]," (",round(((casos_sexo_municipio[1]/total_sexo)*100),2),"%)"),
                                       subtitle = tags$div(HTML('<b style = "padding-left:10px;font-size:16px">FEMININO</b>')),
                                       width=8,
                                       icon = icon("female", lib = "font-awesome"),
                                       color = "red")))))
        
        return(panel)
        
        
      }else{
        
        panel <-  fluidRow(fluidRow(tags$div(HTML('<i class="fa fa-venus-mars"style = "color:#0072B2;font-size:50px"></i>
                                   <b style = "padding-left:0px;color:#000000;font-size:30px"> SEXO </b>'))))
        return(panel)
      }
    })
    
    
    ###########################################################################
    ########################### SERVER MARCELo ################################
    ###########################################################################
    
    if(n_casos[which(names(n_casos) == message)] == 0){
      return()
    }else{
      source('source.R', local=TRUE, encoding="UTF-8")
    }
    
    
    
    ####################################################################################################################
    #############################          NOVOS CASOS POR DIA           ###############################################
    ####################################################################################################################
    
    output$u1 <- renderUI({
      
      
      if (rm_accent( message) == "MARINGA"){
        
        div(plotlyOutput("regionalNC"),style="padding-left:20px;")
        
      }else{
        
        div(strong("INDISPONÍVEL PARA ESTA CIDADE"))
        # div(plotlyOutput("regionalNC"),style="padding-left:20px;")
      }
      
      
    })
    
    
    output$regionalNC <- renderPlotly({
      
      if(n_casos[which(names(n_casos) == message)] == 0){
        return()
      }else{
        
        
        if (rm_accent( message) == "MARINGA") {
          viajem15(rm_accent( message))
        }
        
      }
      
      
    })
    
    
    ####################################################################################################################
    #############################          Total de CASOS            ###############################################
    ####################################################################################################################
    
    
    
    
    output$regionalTC <- renderPlotly({
      
      #source('source.R', local=TRUE, encoding="UTF-8")
      if(n_casos[which(names(n_casos) == message)] == 0){
        return()
      }else{
        if (numberofrow < 1) {} else {
          
          
          
          fig<-plot_ly(x = ~ dadosfinal$time, y = ~ dadosfinal$acumulado, mode = 'lines+markers', type="scatter",
                       text = "", marker=list(color = "red", size=10),
                       line = list(color = 'rgb(255, 0, 0)', width = 4), name = 'Suscetíveis')
          fig <- fig %>% layout(title = "Total de casos confirmados", hovermode = TRUE, spikedistance =  -1,
                                xaxis = list(title = "Dia da coleta do exame", showspikes = TRUE,
                                             spikemode  = 'across', #toaxis, across, marker
                                             spikesnap = 'cursor',  ticks = "outside",
                                             showline=TRUE,
                                             showgrid=TRUE),
                                yaxis = list (title = "Número de casos",
                                              spikemode  = 'across', #toaxis, across, marker
                                              spikesnap = 'cursor', zeroline=FALSE,
                                              showline=TRUE,
                                              showgrid=TRUE))
          fig
        }
      }
      
      
      
      
      
      
    })
    
    
    
    
    ####################################################################################################################
    #############################          TAXA DE PROPAGAÇÂO            ###############################################
    ####################################################################################################################
    
    
    
    
    output$beta <- renderValueBox({
      if(n_casos[which(names(n_casos) == message)] == 0){
        return()
      }else{
        #source('source.R', local=TRUE, encoding="UTF-8")
        
        if (numberofrow < 10) {
          valueBox(
            paste0(),"Não é possível obter uma estimativa", icon = icon("list"),
            color = "light-blue"
          )
        } else {
          
          
          
          fim<-numberofrow
          
          init<-ifelse(fim < 11, 1, fim - 9)
          
          tempo<-seq(1,fim-init+1,1)
          
          exponential.model <- lm(log(as.numeric(dadosfinal$acumulado[init:fim]))~ tempo)
          summary(exponential.model)
          beta <- coef(exponential.model)[2]+0.1 #ae^{beta t}
          acq<-alpha.0 <- exp(coef(exponential.model)[1])
          
          
          valueBox(
            paste0(round(beta,10)), "Taxa de propagação", icon = icon("list"),
            color = "light-blue"
          )
          
        }
      }
    })
    
    
    
    
    
    ####################################################################################################################
    #############################          AJUSTE TAXA DE PROPAGAÇÂO            ###############################################
    ####################################################################################################################
    
    
    
    
    output$ajuste <- renderPlotly({
      
      # source('source.R', local=TRUE, encoding="UTF-8")
      if(n_casos[which(names(n_casos) == message)] == 0){
        return()
      }else{
        if (numberofrow < 10) {
          
        } else {
          
          
          
          fim<-numberofrow
          
          init<-ifelse(fim < 11, 1, fim - 9)
          
          tempo<-seq(1,fim-init+1,1)
          
          
          
          exponential.model <- lm(log(as.numeric(dadosfinal$acumulado[init:fim]))~ tempo)
          summary(exponential.model)
          beta <- coef(exponential.model)[2]+0.1 #ae^{beta t}
          a<- exp(coef(exponential.model)[1])
          beta2<-beta-0.1
          
          
          
          funcao<- function(x){
            #aux<- 0.002921+0.095526*exp(-0.095526*x)
            aux<-  a*exp(beta2*x)
            return(aux)
          }
          
          
          y<-funcao(tempo)
          
          fig<-plot_ly(x = ~ tempo, y = ~ y, mode = 'lines', type="scatter",
                       text = "", color = "blue", size=10,
                       line = list(color = 'rgb(8,48,107)', width = 6), name = 'ajuste')
          fig<-fig %>% add_trace(y = ~ dadosfinal$acumulado[init:fim], mode = 'markers',
                                 line = list(width = 0), marker=list(color = "red", size=10), name = 'dados observados')
          
          
          fig <- fig %>% layout(hovermode = TRUE, spikedistance =  -1,
                                xaxis = list(showspikes = TRUE, titlefont = list(size = 24),
                                             spikemode  = 'across', #toaxis, across, marker
                                             spikesnap = 'cursor',  ticks = "outside",tickangle = 0,
                                             showline=TRUE,tickfont = list(size = 24),
                                             fixedrange=TRUE,
                                             showgrid=TRUE),
                                yaxis = list (title = "<b>NÚMERO DE CASOS</b>",
                                              spikemode  = 'across', #toaxis, across, marker
                                              spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),
                                              showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                                              showgrid=TRUE),
                                height= 500,
                                plot_bgcolor  = "rgba(0, 0, 0, 0)",
                                paper_bgcolor = "rgba(0, 0, 0, 0)",
                                fig_bgcolor   = "rgba(0, 0, 0, 0)") %>% config(displayModeBar = FALSE)
          
          
          
          
          fig
          
          
        }
        
      }
      
    })
    
    
    
    ####################################################################################################################
    #############################          NUMERO DE REPRODUCAO ATUAL            ###############################################
    ####################################################################################################################
    
    
    
    
    output$rzero <- renderValueBox({
      
      #source('source.R', local=TRUE, encoding="UTF-8")
      
      if (numberofrow < 10) {
        valueBox(
          paste0(),"Não é possível obter uma estimativa", icon = icon("list"),
          color = "light-blue"
        )
      } else {
        
        
        
        fim<-numberofrow
        
        init<-ifelse(fim < 11, 1, fim - 9)
        
        tempo<-seq(1,fim-init+1,1)
        
        exponential.model <- lm(log(as.numeric(dadosfinal$acumulado[init:fim]))~ tempo)
        summary(exponential.model)
        beta <- coef(exponential.model)[2]+0.1 #ae^{beta t}
        acq<-alpha.0 <- exp(coef(exponential.model)[1])
        
        rzero<-beta / 0.1
        valueBox(
          paste0(round(rzero,10)), "Número de reprodução", icon = icon("list"),
          color = "light-blue"
        )
        
      }
      
    })
    
    
    
    
    output$rsquared <- renderValueBox({
      
      
      #source('source.R', local=TRUE, encoding="UTF-8")
      
      if (numberofrow < 10) {
        valueBox(
          paste0(), "Não é possível obter R²", icon = icon("list"),
          color = "light-blue"
        )
      } else {
        
        
        
        fim<-numberofrow
        
        init<-ifelse(fim < 11, 1, fim - 9)
        
        tempo<-seq(1,fim-init+1,1)
        
        
        exponential.model <- lm(log(as.numeric(dadosfinal$acumulado[init:fim]))~ tempo)
        rsquared<- summary(exponential.model)$adj.r.squared
        
        valueBox(
          paste0(round(rsquared,10)), "Este é o valor de R²", icon = icon("list"),
          color = "light-blue"
        )
        
        
      }
      
      
    })
    
    
    
    output$pvalue <- renderValueBox({
      
      
      #source('source.R', local=TRUE, encoding="UTF-8")
      
      if (numberofrow < 10) {
        valueBox(
          "Não é possível obter p-value", icon = icon("list"),
          color = "light-blue"
        )
      } else {
        
        
        
        fim<-numberofrow
        
        init<-ifelse(fim < 11, 1, fim - 9)
        
        tempo<-seq(1,fim-init+1,1)
        
        exponential.model <- lm(log(as.numeric(dadosfinal$acumulado[init:fim]))~ tempo)
        pvalue<- anova(exponential.model)$'Pr(>F)'[1]
        
        valueBox(
          format(pvalue,scientific = F), "Este é o valor de p-value", icon = icon("list"),
          color = "light-blue"
        )
        
        
        
      }
      
    })
    
    
    
    ####################################################################################################################
    #############################          Estimativa do número de infectados            ###############################################
    ####################################################################################################################
    
    
    
    
    
    output$infectados <- renderPlotly({
      
      # source('source.R', local=TRUE, encoding="UTF-8")
      
      if(n_casos[which(names(n_casos) == message)] == 0){
        return()
      }else{
        
        if (numberofrow < 1 ) {} else {
          
          
          
          fig<-plot_ly(x = ~ dadosfinal$time, y = ~ dadosfinal$infectados, mode = 'lines+markers', type="scatter",
                       text = "", marker=list(color = "red", size=10),
                       line = list(color = 'rgb(255, 0, 0)', width = 4), name = 'Suscetíveis')
          
          
          fig <- fig %>% layout(hovermode = TRUE, spikedistance =  -1,
                                xaxis = list(title = "<b>DIA DA COLETA DO EXAME</b>",
                                             showspikes = TRUE, titlefont = list(size = 24),
                                             spikemode  = 'across', #toaxis, across, marker
                                             spikesnap = 'cursor',  ticks = "outside",tickangle = -45,
                                             showline=TRUE,tickfont = list(size = 24),type = 'date',fixedrange=TRUE,
                                             tickformat = "%d/%m",showgrid=TRUE),
                                yaxis = list (title = "<b>NÚMERO DE CASOS</b>",
                                              spikemode  = 'across', #toaxis, across, marker
                                              spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),
                                              showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                                              showgrid=TRUE),
                                height= 500,
                                plot_bgcolor  = "rgba(0, 0, 0, 0)",
                                paper_bgcolor = "rgba(0, 0, 0, 0)",
                                fig_bgcolor   = "rgba(0, 0, 0, 0)")
          
          fig
          
        }
      }
      
    })
    ####################################################################################################################
    #############################       EVOLUÇÂO DA TAXA DE PROPAGAÇÂO            ###############################################
    ####################################################################################################################
    
    
    
    
    output$betav <- renderPlotly({
      
      #source('source.R', local=TRUE, encoding="UTF-8")
      
      
      taxaevol(1)
      
    })
    
    ####################################################################################################################
    #############################       EVOLUÇÂO DO R0            ###############################################
    ####################################################################################################################
    
    
    
    
    output$rzerov <- renderPlotly({
      
      # source('source.R', local=TRUE, encoding="UTF-8")
      taxaevol(10)
      
    })
  }) 
  
  ####################################################################################################################
  #############################          CALCULADORA SEIR          ###############################################
  ####################################################################################################################
  
  
  
  
  output$plotseir <- renderPlotly({
    
    a<-SEIR(pars = c(mu = 0, beta = input$beta, sigma = input$sigma, gamma = input$gamma),
            init = c(S = input$S / input$N, E = input$E / input$N, I = input$I / input$N, R = input$R / input$N),
            time = 0:input$t)
    #b<-data.frame(a$results$S[1:length(a$results$S)], a$results$E[1:length(a$results$S)], a$results$I[1:length(a$results$S)], a$results$R[1:length(a$results$S)])
    #colnames(b)<-c("S","E","I","R")
    
    
    fig<-plot_ly(x = ~ 1:nrow(a$results), y = ~input$N*a$results$S, mode = 'lines', type="scatter",
                 text = "neste dia", line = list(color = 'rgb(8,48,107)', width = 4), name = 'Suscetíveis')
    fig<-fig %>% add_trace(y = ~ input$N*a$results$E, mode = 'lines+markers', name = 'Expostos',
                           line = list(color = 'orange', width = 4))
    fig<-fig %>% add_trace(y = ~ input$N*a$results$I, mode = 'lines+markers', name = 'Infectados',
                           line = list(color = 'red', width = 4), color = I("red"))
    fig<-fig %>% add_trace(y = ~ input$N*a$results$R, mode = 'lines', name = 'Recuperados', #dash = 'dash','dot'
                           line = list(color = 'green', width = 4))
    fig <- fig %>% layout(title = "<b>MODELO SEIR</b>", hovermode = TRUE, spikedistance =  -1,
                          xaxis = list(title = "<b>DIAS</b>", showspikes = TRUE, titlefont = list(size = 24),
                                       spikemode  = 'across', #toaxis, across, marker
                                       spikesnap = 'cursor',  ticks = "outside",tickangle = -45,
                                       showline=TRUE,tickfont = list(size = 24),
                                       showgrid=TRUE),
                          yaxis = list (title = "<b>NÚMERO DE PESSOAS</b>",
                                        spikemode  = 'across', #toaxis, across, marker
                                        spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),
                                        showline=TRUE,tickfont = list(size = 24),
                                        showgrid=TRUE),
                          height= 450
                          
    )
    
    
    
    
    fig
    
    
    
    
  })
  
  
  
  ####################################################################################################################
  #############################          TOTAL DE CASOS           ###############################################
  ####################################################################################################################
  
  
  
  
  
  
  
  
  
  ####################################################################################################################
  #############################          ATRASO DE 15 DIAS            ###############################################
  ####################################################################################################################
  
  #observeEvent(input$cidade2,{
  
  
  
  output$atraso15 <- renderPlotly({
    
    source('source2.R', local=TRUE, encoding="UTF-8")
    
    atraso(15)
    
    
  })
  
  
  
  
  
  
  ####################################################################################################################
  #############################          ATRASO DE 30 DIAS            ###############################################
  ####################################################################################################################
  
  
  
  
  output$atraso30 <- renderPlotly({
    
    
    source('source2.R', local=TRUE, encoding="UTF-8")
    
    atraso(30)
    
  })
  
  
  
  
  
  ####################################################################################################################
  #############################          ATRASO DE 45 DIAS            ###############################################
  ####################################################################################################################
  
  
  
  
  output$atraso45 <- renderPlotly({
    
    
    source('source2.R', local=TRUE, encoding="UTF-8")
    
    atraso(45)
    
    
  })
  
  
  
  
  
  ####################################################################################################################
  #############################          ATRASO DE 60 DIAS            ###############################################
  ####################################################################################################################
  
  
  
  
  output$atraso60 <- renderPlotly({
    
    
    source('source2.R', local=TRUE, encoding="UTF-8")
    
    atraso(60)
    
    
  })
  
  
  
  
  
  ####################################################################################################################
  #############################          CHEGADA DE 1 ExPOSTO            ###############################################
  ####################################################################################################################
  
  
  
  
  output$espostos1 <- renderPlotly({
    
    
    source('source2.R', local=TRUE, encoding="UTF-8")
    
    espostos(1)
    
    
  })
  
  
  
  
  
  
  ####################################################################################################################
  #############################        CHEGADA DE 3 EsPOSTO         ###############################################
  ####################################################################################################################
  
  
  
  
  output$espostos3 <- renderPlotly({
    
    source('source2.R', local=TRUE, encoding="UTF-8")
    
    espostos(3)
    
    
  })
  
  
  
  
  
  ####################################################################################################################
  #############################          CHEGADA DE 5 EsPOSTO            ###############################################
  ####################################################################################################################
  
  
  
  
  output$espostos5 <- renderPlotly({
    
    
    source('source2.R', local=TRUE, encoding="UTF-8")
    
    espostos(5)
    
    
  })
  
  
  
  
  
  ####################################################################################################################
  #############################          CHEGADA DE 10 EsPOSTO            ###############################################
  ####################################################################################################################
  
  
  
  
  output$espostos10 <- renderPlotly({
    
    
    
    source('source2.R', local=TRUE, encoding="UTF-8")
    
    espostos(10)
    
    
  })
  
  
  
  
  
  
  #},ignoreNULL = FALSE,ignoreInit = TRUE)
  
  
  ####################################################################################################################
  #############################            RANK DO RISCO ATUAL            ###############################################
  ####################################################################################################################
  
  
  
  
  output$rankrisco <- renderPlotly({
    
    source('source3.R', local=TRUE, encoding="UTF-8")
    
    plotrankrisco
    
  })
  
  
  
  
  ####################################################################################################################
  #############################            RANK DO RISCO RELATIVO ATUAL            ###############################################
  ####################################################################################################################
  
  
  
  
  output$rankriscorelativo <- renderPlotly({
    
    
    
    source('source3.R', local=TRUE, encoding="UTF-8")
    
    plotrankriscorelativo
    
  })
  
  
  
  observeEvent(input$calendar_button, {
    sendSweetAlert(
      session = session,
      title = "Informação",
      text = "Ao escolher uma data será apresentado o nível de risco
      calculado a partir do casos confirmados até a data escolhida. Você pode verificar o nível de risco desde o dia 16/03/2020
      até a data da última atualização do dashboard.",
      type = "info"
    )
  })
  
  output$video <- renderUI({
    #click <- input$calendar_button
    #if(click==TRUE){
    #link = ""
    HTML(paste0('<iframe width="855" height="500" src="https://www.youtube.com/embed/',link,'" frameborder="0", allowfullscreen></iframe>'))
    #}
  })
  
  
  
  
  
  
}

