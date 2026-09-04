withMathJax()
sobre1 <-dropdownButton(
  inputId = "mydropdown",
  label = "SOBRE",
  icon = icon("question"),
  status = "primary",
  circle = FALSE,
  fluidRow(column(width=12,align="left",tags$h3(strong("SOBRE")))),
  fluidRow(
    column(width=12,
      withMathJax(),div("Da biologia temos a definição de um número usualmente denotado por",
                        withMathJax(),"\\(R_0\\)",". De forma simples," ,withMathJax(),"\\(R_0\\)", 
                        "é o número aproximado de pessoas que uma pessoa infectada pode contaminar ao longo do período infeccioso.",br(),br(),
      "Na modelagem matemática, trabalhamos com o modelo SEIR (Suscetíveis-Expostos-Infectados-Recuperados):",br(),br(),
      "Suscetíveis: São todas as pessoas que podem, em algum momento, ser infectadas",br(),br(),
      "Expostos: São todas as pessoas que já se contaminaram, mas a doença está no período de incubação.",br(),br(),
      "Infectados: Este grupo é formado pelas pessoas infectadas que estão no período infeccioso, ou seja, são capazes de transmitir a doença.",br(),br(), 
      "Recuperados: Aqui temos que tomar um cuidado com a nomenclatura. Ao se usar a palavra recuperados dá-se a entender que as pessoas 
      deste grupo se recuperaram da infecção. No entanto, o modelo 
      visa estudar o comportamento da infecção e neste sentido toda pessoa que foi infectada e não é mais capaz de transmitir a 
      infecção entra neste grupo, ou seja, o grupo dos recuperados é formado pelas pessoas que foram curadas  
      e também por pessoas que venham a falecer em decorrência dela.",br(),br(),
      "No modelo SEIR","\\(R_0=\\beta/\\gamma\\)", "onde",
      "\\(\\beta\\)", "é a taxa de propagação (para algumas cidades é possível obter uma estimativa desta taxa na aba ao lado) e",
      "\\(\\gamma\\)", "é a taxa de recuperação dada por", "\\(1/t\\)", "onde ", "\\(t\\)",
      "é o tempo médio em que uma pessoa infectada é capaz de infectar outras pessoas (período infeccioso). Artigos científicos comprovam
      que este tempo é em torno de 10 dias, por este motivo consideramos","\\(\\gamma=0,1\\).", style='overflow-y: scroll;height:400px;font-size:16px;text-align:justify')))
)




numero_reproducao <- tabPanel(title =tags$div(HTML('<i class="fa fa-prescription"style = "color:#0072B2;font-size:20px"></i>')),
                              fluidRow(
                                column(width=6,align="left",HTML('<i class="fas fa-prescription" style = "color:#0072B2;font-size:50px"></i>
                                                                 <b style = "padding-left:10px;color:#000000;font-size:30px">NÚMERO DE REPRODUÇÃO</b>')),
                                column(width=6,sobre1)),
                              fluidRow(column(width=12,valueBoxOutput("rzero"))),
                              fluidRow(
                                column(width=12,align="left",
                                tags$div(HTML('<i class="fas fa-prescription" style = "color:#0072B2;font-size:50px"></i>
                                              <b style = "padding-left:25px;color:#000000;font-size:30px">EVOLUÇÃO DO NÚMERO DE REPRODUÇÃO</b>')),
                                plotlyOutput("rzerov")))
                              )


taxa_propagacao <- tabPanel(title = tags$div(HTML('<i class="fa fa-connectdevelop"style = "color:#0072B2;font-size:20px"></i>')),
                            fluidRow(column(width=12,align="left",
                            tags$div(HTML('<i class="fa fa-connectdevelop"style = "color:#0072B2;font-size:50px">
                                          </i><b style = "padding-left:25px;color:#000000;font-size:30px">TAXA DE PROPAGAÇÃO</b>')),
                            valueBoxOutput("beta"), 
                            valueBoxOutput("rsquared"),
                            valueBoxOutput("pvalue"))),
                            tabsetPanel(
                              tabPanel(title = tags$div(HTML('<b style = "padding-left:25px;color:#000000;font-size:20px">AJUSTE EXPONENCIAL</b>')),
                                       plotlyOutput("ajuste")),
                              tabPanel(title = tags$div(HTML('<b style = "padding-left:25px;color:#000000;font-size:20px">EVOLUÇÃO DA TAXA DE PROPAGAÇÃO</b>')),
                                       plotlyOutput("betav")))
                            )


evolucao_n_infec <- tabPanel(title = tags$div(HTML('<i class="fa fa-notes-medical"style = "color:#0072B2;font-size:20px"></i>')),
                             fluidRow(
                             column(width=12,align="left",tags$div(HTML('<i class="fa fa-notes-medical"style = "color:#0072B2;font-size:50px"></i>
                                              <b style = "padding-left:25px;color:#000000;font-size:30px">EVOLUÇÃO DO NÚMERO DE INFECTADOS</b>')))),
                                              div("Nesta aba apresentamos o número estimado de pessoas infectadas. Nesta estimativa 
                                                  estamos supondo que cada pessoa infectada se recupera em exatamente 10 dias.",style="text-align:justify;"),br(),br(),
                                 plotlyOutput("infectados")
                             )


panel_cidades <<-  fluidRow(
  fluidRow(column(width=12,align="center",div(style="text-size:50px;",strong(textOutput("painel_text"))))),
  tags$div(style= "padding-left:50px", tabsetPanel(id = "tabset",type = "tabs",
              tabPanel(title = tags$div(HTML(paste0('<i class="fa fa-calendar-alt" style = "color:#0072B2;font-size:20px"></i>'))),
              fluidRow(column(width=12,align="left",tags$div(HTML('<i class="fa fa-calendar-alt"style = "color:#0072B2;font-size:50px"></i>
                                                                  <b style = "color:#000000;font-size:30px;">
                                                                  CASOS CONFIRMADOS ACUMULADOS </b>')))),
              div( plotlyOutput("plot_gcidades"))
              ),
              tabPanel(title = tags$div(HTML('<i class="fa fa-chart-bar"style = "color:#0072B2;font-size:20px"></i>')),
              fluidRow(column(width=12,align="left",tags$div(HTML('<i class="fa fa-chart-bar"style = "color:#0072B2;font-size:50px"></i>
                                                                  <b style = "padding-left:25px;color:#000000;font-size:30px">
                                                                  CASOS CONFIRMADOS POR DIA </b>')))),
              plotlyOutput("plot_por_dia_municipio")),
              tabPanel(title = tags$div(HTML('<i class="fa fa-suitcase"style = "color:#0072B2;font-size:20px"></i>')),
              fluidRow(column(width=12,align="left",tags$div(HTML('<i class="fa fa-suitcase"style = "color:#0072B2;font-size:50px"></i>
                                                                  <b style = "padding-left:25px;color:#000000;font-size:30px">
                                                                  CASOS QUE REALIZARAM VIAGEM </b>')))),
              uiOutput("u1")),
              tabPanel( title = tags$div(HTML('<i class="fa fa-exclamation-triangle"style = "color:#0072B2;font-size:20px"></i>')),
              fluidRow(column(width=12,align="left",tags$div(HTML('<i class="fa fa-exclamation-triangle"style = "color:#0072B2;font-size:50px"></i>
                                                                  <b style = "padding-left:25px;color:#000000;font-size:30px">
                                                                  INCIDÊNCIA </b>')))),
              plotlyOutput("plot_incidencia_municipios")),
              tabPanel( title = tags$div(HTML('<i class="fa fa-users"style = "color:#0072B2;font-size:20px"></i>')),
              fluidRow(column(width=12,align="left",tags$div(HTML('<i class="fa fa-users"style = "color:#0072B2;font-size:50px"></i>
                                                                  <b style = "padding-left:25px;color:#000000;font-size:30px">
                                                                  FAIXA ETÁRIA </b>')))),
              plotlyOutput("plot_por_faixaetaria_municipio")),
              tabPanel( title = tags$div(HTML('<i class="fa fa-venus-mars"style = "color:#0072B2;font-size:20px"></i>')),
                        div(uiOutput("plot_sexo_municipio"),style="padding-left:20px;")),
              # tabPanel(
              #   tags$div(HTML('<i class="fa fa-map-marked-alt"style = "color:#0072B2;font-size:20px"></i>')),
              #   tags$head(tags$style(HTML("hr {border-top: 5px solid;}"))),
              #   box(
              #     title =  tags$div(HTML('<i class="fa fa-map-marked-alt"style = "color:#0072B2;font-size:50px"></i><b style = "padding-left:25px;color:#000000;font-size:30px"> CASOS NA CIDADE </b>')),
              #     tags$head(tags$style(HTML("hr {border-top: 5px solid;}"))),
              #     width = 12
              #     
              #   ),
              #   div(leafletOutput("map_cidades", height = 450,width=550),style="text-align:center;")),
              numero_reproducao,
              taxa_propagacao,
              evolucao_n_infec
              ))
  )


mapa <<-  tabPanel(title = tags$div(HTML('<i class="fa fa-map-marked-alt"style = "color:#0072B2;font-size:30px"></i>')),
                   
                   fluidRow(
                     fluidRow(
                       column(width=12,
                              box(width = 12,
                                  title = tags$div(HTML('<i class="fa fa-map-marker-alt"style = "color:#0072B2;font-size:50px;padding-left:0px;"></i>
                                                     <b style = "padding-left:25px;color:#000000;font-size:30px;">
                                                     PANORAMA - POR CIDADES DA 15ª  REGIONAL DO ESTADO DO PARANÁ </b>')))))
                   ),
                                              leafletOutput("map", height = 500),
                                              tags$head(tags$style(HTML('#panel_cidades {background-color: rgba(255,255,255,0.7);}
                                              #eval {background-color: rgba(255,255,255,0.0);}
                                                                        ')))
                   )

