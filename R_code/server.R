


server <- function(input, output, session) {
  USER <- reactiveValues(Logged = FALSE)

  panorama_geralServer("panorama")
  mapa_cidadesServer("mapa")
  nivel_riscoServer("nivel_risco")
  colaboradoresServer("colaboradores")
  calculadora_seirServer("calculadora")
  comportamento_inicialServer("comportamento_inicial")
  configuracoesServer("configuracoes")

  
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
                        panorama_geralUI("panorama"),
                        mapa_cidadesUI("mapa"),
                        nivel_riscoUI("nivel_risco"),
                        colaboradoresUI("colaboradores"),
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
 
  
  
  observeEvent(list(input$toTop1,input$toTop2,input$toTop3,input$toTop4,input$toTop5,input$toTop6), {
    shinyjs::runjs("window.scrollTo(0, 0)")
  })
  
  
  
  
  
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
                    configuracoesUI("configuracoes")
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
  
  ####################################################################################################################
  #############################          TOTAL DE CASOS           ###############################################
  ####################################################################################################################
  
  
  
  
  
  
  
  
  
  
}

