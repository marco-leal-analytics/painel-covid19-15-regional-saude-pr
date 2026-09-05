
info_alert <<- fluidRow(espaco_html(2), box(title = tags$div(HTML('<i class="fa fa-info-circle"style = "color:#0072B2;font-size:50px"></i>
                                               <b style = "padding-left:25px;color:#000000;font-size:30px">
                                               INFORMAÇÃO </b>')), width=12    ),
                         hr(style="border-color: gray;opacity:0.5;"),
                         fluidRow(
                           column(width=12,
                                  div(style="font-size:30px;text-align:justify;",
                                      "Não foi possível a atualização dos dados do município de Maringá por problemas no repasse da informação.
           Assim que os dados forem atualizados pelo município, o painel será atualizado! Para os demais municípios, 
           a ultima atualização é válida.")
                           )
                         ))



informacao <<-  dropdown(useShinyjs(),
  info_alert,
  style = "jelly", icon = icon("info-circle","fa-2x"),inputId = "btn1",
    status = "primary", width = "auto",tooltip =  tooltipOptions(title = "Clique para ver informações !"),
    animate = animateOptions(
      enter = animations$fading_entrances$fadeInRightBig,duration = 0.25,
      exit = animations$fading_exits$fadeOutRightBig
    )
  )
  
  
  
mais <<- tabPanel( title = tags$div(HTML('<i class="fa fa-ellipsis-h"style = "color:#0072B2;font-size:30px"></i>')),
                   fluidRow(
                     box( title= tags$div(HTML('<i class="fa fa-ellipsis-h"style = "color:#0072B2;font-size:50px"></i>
                                               <b style = "padding-left:25px;color:#000000;font-size:30px">
                                               VEJA MAIS </b>')),width = 12 ),
                     tabsetPanel(
                       #comportamento_inicialUI("comportamento_inicial"),
                       #calculadora_seirUI("calculadora")
                       )
                     )
                   )






ui <- tagList(
  useShinyjs(),
  tags$head(
  tags$style(HTML(".navbar .navbar-nav {float: left}
                             .navbar .navbar-header {float: left}")
             )
  ),
  tags$head(tags$style(HTML("
  .navbar-nav { float: none !important;}
  .navbar-nav > li:nth-child(6) {
                   float: left;
                   right: 0px;
                   }
  .navbar-nav > li:nth-child(5) {
  float: right;
  right: 0px;
  }
  }"))),
  tags$style(type = "text/css", '.logo{ filter: invert(3);}'),
  fluidPage(theme = app_theme,

            ## Include Google Analytics
            #tags$head(includeHTML(("google-analytics.html"))),

            ## add favicon
            tags$head(tags$link(rel = "icon", href = "favicon.ico")),
            tags$head(
              tags$link(rel = "stylesheet", href = "assets/css/app.css"),
              tags$link(rel = "stylesheet", href = "assets/www/custom.css")
            ),
            
            tagList(
              
              
              fluidRow(
                ## Logo
                column(
                  width = 3,
                  tags$a(
                    #href = "http://est.ufmg.br/covidlp/home/pt/", 
                    tags$img(class="logo",src = "virus.png", title = "COVID-19 / 15ª REGIONAL DE SAÚDE ", 
                             height = "100px", style = "margin-top: 10px; margin-left: 20px")
                  )
                ),
                ## Título
                column(
                  width = 6,
                  h1(
                    strong("15ª REGIONAL DE SAÚDE DO PARANÁ "),
                    style = "text-align: center;color:#FFFFFF;"
                  ),
                  h1(strong("COVID - 19"), style = "text-align: center;color:#FFFFFF;")
                ),
                ## github, webpage, email
                column(
                  width = 3, offset = 0, align="right",
                  br(),
                  #tags$a(icon("globe", "fa-3x"), href = "http://www.des.uem.br/"),
                  #tags$a(icon("globe", "fa-3x"),  href = "http://www.dma.uem.br/")
                  uiOutput("user_panel")
                  
                  
                  
                ),
                style = "
               border-radius: 10px;
               box-shadow: 0 0 4px 0 rgba(69, 69, 69, 0.2);
               margin: 0px 10px 30px 10px; padding: 10px;
               background-image: url(virus.png);
               background-repeat: repeat;
               background-size: 50px 50px;
                background-color:rgba( 19,49,71, 0.95);
                background-blend-mode: lighten;"
              )
            ),
            
            ### Body
            
            uiOutput("body"),
            
            
            
            ## Footer
            fluidRow( 
              includeHTML("www/footer.html"),
              style = "
               border-radius: 10px;
               box-shadow: 0 0 4px 0 rgba(69, 69, 69, 0.2);
               margin: 0px 10px 30px 10px; padding: 10px;
               background-image: url(virus.png);
               background-repeat: repeat;
               background-size: 50px 50px;
                background-color:rgba( 19,49,71, 0.95);
                background-blend-mode: lighten;"
            )
            
  ) 
  
  
)



