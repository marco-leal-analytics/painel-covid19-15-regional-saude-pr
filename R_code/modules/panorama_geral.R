
jscode <- "shinyjs.toTop = function() {document.body.scrollTop = 0;}"

# sobretaxa <-dropdownButton(
#   inputId = "mydropdown",
#   label = "SOBRE",
#   icon = icon("question"),
#   status = "primary",
#   circle = FALSE,
#   tooltip =  tooltipOptions(title = "Clique para ver informações sobre este painel !"),
#   fluidRow(column(width=12,
#                   tags$h3(strong("SOBRE")))),
#   withMathJax(),fluidRow(
#     column(width=12,
#            "Da biologia temos a definição de um número usualmente denotado
#            por",' \\( R_0 \\) ',". De forma simples," ,' \\( R_0 \\) ',
#            "Suscetíveis: São todas as pessoas que podem, em algum momento, ser infectadas",br(),br(),
#            "Expostos: São todas as pessoas que já se contaminaram, mas a doença está no período de incubação.",br(),br(),
#            "Infectados: Este grupo é formado pelas pessoas infectadas que estão no período infeccioso, ou seja, são capazes de transmitir a doença.",br(),br(), 
#            "Recuperados: Aqui temos que tomar um cuidado com a nomenclatura. Ao se usar a palavra recuperados dá-se a entender que as pessoas 
#            deste grupo se recuperaram da infecção. No entanto, o modelo visa estudar o comportamento da infecção e neste sentido toda pessoa que foi infectada e não é mais capaz de transmitir a 
#            infecção entra neste grupo, ou seja, o grupo dos recuperados é formado pelas pessoas que foram curadas e também por pessoas que venham a falecer em decorrência dela.",br(),br(),
#            "No modelo SEIR","\\(R_0=\\beta/\\gamma\\)", "onde",
#            "\\(\\beta\\)", "é a taxa de propagação (para algumas cidades é possível obter uma estimativa desta taxa na aba ao lado) e",
#            "\\(\\gamma\\)", "é a taxa de recuperação dada por", "\\(1/t\\)", "onde ", "\\(t\\)",
#            "é o tempo médio em que uma pessoa infectada é capaz de infectar outras pessoas (período infeccioso). Artigos científicos comprovam
#             que este tempo é em torno de 10 dias, por este motivo consideramos","\\(\\gamma=0,1\\)."))
# )



sobre2 <- dropdown(
  tags$head(tags$style(HTML("hr {border-top: 1px solid #0072B2;}"))),

  fluidRow(column(width=12,tags$h2(strong("SOBRE")))),

  hr(style="border-color: gray;opacity:0.5;"),
  
  fluidRow(column(width = 12, align="left",
                  box(width = 12,
                      title = tags$div(HTML('<i class="fa fa-info-circle"style = "color:#0072B2;font-size:50px;padding-left:0px;"></i>
                                                     <b style = "padding-left:0px;color:#000000;font-size:30px;">
                                                     Coeficiente de Incidência </b>')),
                      withMathJax(),
                      "Número de casos confirmados de COVID-19 por 1.000.000 habitantes, considerando a população residente atual.",withMathJax(),
                      "$$ \\frac{ \\text{Número de casos confirmados}} { \\text{População Total residente}} \\times 1.000.000 $$"
                      
                  )
  ),
  column(width = 12,align="left",
         box(width = 12,
             title = tags$div(HTML('<i class="fa fa-info-circle"style = "color:#0072B2;font-size:50px;padding-left:0px;"></i>
                                                     <b style = "padding-left:0px;color:#000000;font-size:30px;">
                                                     Dados populacionais utilziados nos cálculos de incidência </b>')),
             fluidRow(
               column(width=12,
                      dataTableOutput("table_populacao",width = 550))),
             hr(style="border-color: #0072B2;opacity:0.75;"),
             fluidRow(column(width=12,HTML("<b>Fontes:</b>
  <br><b>Dados 15ª Regional : </b> Disponibilizados diariamente via planilha eletrônica.
  <br><b>Dados populacionais (Data e Hora da última Consulta: 02/06/2020 às 12h59min) :</b><a href='https://www.ibge.gov.br/cidades-e-estados.html?view=municipio'>
    https://www.ibge.gov.br/cidades-e-estados.html?view=municipio</a>")))))),

  style = "jelly", icon = icon("question"),
  status = "primary", width = "auto",tooltip =  tooltipOptions(title = "Clique para ver informações sobre !",placement = "right"),
  animate = animateOptions(
    enter = animations$fading_entrances$fadeInLeftBig,duration = 0.25,
    exit = animations$fading_exits$fadeOutLeftBig
  )
)


sobre3 <- dropdown(
  tags$head(tags$style(HTML("hr {border-top: 1px solid #0072B2;}"))),
  fluidRow(
    column(width=12,tags$h2(strong("SOBRE")))),
  hr(style="border-color: gray;opacity:0.5;"),

  fluidRow(column(width = 12,align="left",
                  box(width = 12,
                      title = tags$div(HTML('<i class="fa fa-info-circle"style = "color:#0072B2;font-size:50px;padding-left:0px;"></i>
                                                     <b style = "padding-left:0px;color:#000000;font-size:30px;">
                                                     Coeficiente de Incidência </b>')),
                      withMathJax(),
                      "Número de casos confirmados de COVID-19 por 1.000.000 habitantes, considerando a população residente atual.",withMathJax(),
                      "$$ \\frac{ \\text{Número de casos confirmados}} { \\text{População Total residente}} \\times 1.000.000 $$"

                  )
  ),
  column(width = 12,align="left",
         box(width = 12,
             title = tags$div(HTML('<i class="fa fa-info-circle"style = "color:#0072B2;font-size:50px;padding-left:0px;"></i>
                                                     <b style = "padding-left:0px;color:#000000;font-size:30px;">
                                                     Dados populacionais utilizados nos cálculos de incidência </b>')),
             fluidRow(
               column(width=12,
                      dataTableOutput("table_populacao2",width = 550))),
             hr(style="border-color: #0072B2;opacity:0.75;"),
             fluidRow(column(width=12,HTML("<b>Fontes:</b>
  <br><b>Dados 15ª Regional : </b> Disponibilizados diariamente via planilha eletrônica.
  <br><b>Dados populacionais (Data e Hora da última Consulta: 02/06/2020 às 12h59min) :</b><a href='https://www.ibge.gov.br/cidades-e-estados.html?view=municipio'>
    https://www.ibge.gov.br/cidades-e-estados.html?view=municipio</a>")))))),
  style = "jelly", icon = icon("question"),
  status = "primary", width = "auto",tooltip =  tooltipOptions(title = "Clique para ver informações sobre !",placement = "right"),
  animate = animateOptions(
    enter = animations$fading_entrances$fadeInLeftBig,duration = 0.25,
    exit = animations$fading_exits$fadeOutLeftBig
  )
)





informe <<- tabPanel(title = tags$div(HTML('<i class="fa fa-clipboard"style = "color:#0072B2;font-size:30px"></i>'
                                           #<b style = "padding-left:10px;color:#000000;font-size:16px">CASOS POR DIA</b>'
)),
fluidRow(
  fluidRow(
    column(width=12,
           box(width = 12,
               title = tags$div(HTML('<i class="fa fa-map-marker-alt"style = "color:#0072B2;font-size:50px;padding-left:0px;"></i>
                                                     <b style = "padding-left:25px;color:#000000;font-size:30px;">
                                                     PANORAMA - 15ª  REGIONAL DO ESTADO DO PARANÁ </b>')))),
    column(width=12,
           box(width = 12, title =fluidRow(
             HTML('<i class="fa fa-calendar-check "style = "color:#0072B2;font-size:50px;padding-left:25px;"></i>'),
             tags$b(paste0("ATUALIZADO EM : \n",data_fim),style = "padding-left:25px;color:#000000;font-size:30px;"))))
    )
  ),

##### Distribuição do Sexo entre casos confirmados e óbitos-------- 
fluidRow(
  column(width = 6,
         box(title = tags$div(HTML('<i class="fa fa-info-circle"style = "color:#0072B2;font-size:50px"></i>'),
                              div(tags$b(paste0(numero_casos_total[1] ," CASOS CONFIRMADOS")),style = "padding-left:0px;color:#000000;font-size:30px;")),
             width = 12),
         box(title =  tags$div(HTML('<i class="fa fa-venus-mars"style = "color:#0072B2;font-size:50px"></i>
                                                        <b style = "padding-left:0px;color:#000000;font-size:30px">SEXO </b>')),
             tags$head(tags$style(HTML("hr {border-top: 5px solid;}"))),width = 12,
             plotlyOutput("plot_pie_sexo")
         ),
         
         
  ),
  column(width = 6,
         box(title = tags$div(HTML('<i class="fa fa-cross"style = "color:#0072B2;font-size:50px"></i>'),
                              div(tags$b(paste0(obitos[1] ," ÓBITOS CONFIRMADOS")),style = "padding-left:0px;color:#000000;font-size:30px;")),
             width = 12
             
         ),
         box(title =  tags$div(HTML('<i class="fa fa-venus-mars"style = "color:#0072B2;font-size:50px">
                                                       </i><b style = "padding-left:0px;color:#000000;font-size:30px">SEXO </b>')),
             tags$head(tags$style(HTML("hr {border-top: 5px solid;}"))),width = 12,
             plotlyOutput("plot_pie_obito_sexo")
         ))
),


### Curva acumulada de casos de COVID-19 (Incidência por milhão de habitante)
  fluidRow(
    column(width=12,
           box(width = 12,
               title = tags$div(HTML('<i class="fa fa-exclamation-triangle"style = "color:#0072B2;font-size:50px"></i>
                                                   <b style = "padding-left:25px;color:#000000;font-size:25px">
                                                   INCIDÊNCIA POR MILHÃO DE HABITANTE </b>')),
               fluidRow(
                 column(width=6,align="left",sobre2),
                        column(width=6,align='right',
                               div(
                                 useShinyjs(),
                                 extendShinyjs(text = jscode, functions = 'toTop'),
                                 
                                 fluidRow(
                                   div(circleButton(
                                     inputId = "toTop1",
                                     size = "sm",
                                     icon = icon("arrow-up"),'fa-2x'),
                                     style = sprintf("text-align:right;padding-left:0px;"))),
                                 bsTooltip('toTop1', "Clique para ir para o topo da página", placement = "left", trigger = "hover",
                                           options = NULL))
                        )),
               espaco_html(1),
               plotlyOutput("plot_incidencia_regional",height=500)
           )
           
           
    ),style='height:550px;text-align:justify'),





fluidRow(
  box(title =  tags$div(HTML('<i class="fa fa-chart-line"style = "color:#0072B2;font-size:50px">
                                                       </i><b style = "padding-left:0px;color:#000000;font-size:30px">CASOS, INCIDÊNCIAS E EVOLUÇÕES </b>')),
      tags$head(tags$style(HTML("hr {border-top: 5px solid;}"))),width = 12,
      fluidRow(column(width=6,align="left",sobre3),
               column(width=6,align='right',
                      div(
                        useShinyjs(),
                        extendShinyjs(text = jscode, functions = 'toTop'),
                        
                        fluidRow(
                          div(circleButton(
                            inputId = "toTop2",
                            size = "sm",
                            icon = icon("arrow-up"),'fa-2x'),
                            style = sprintf("text-align:right;padding-left:0px;"))),
                        bsTooltip('toTop2', "Clique para ir para o topo da página", placement = "left", trigger = "hover",
                                  options = NULL))
               )),
      tabsetPanel(
        tabPanel(title = tags$div(HTML('<i class="fa fa-chart-area"style = "color:#0072B2;font-size:30px"></i>
                                                     <b style = "padding-left:10px;color:#000000;font-size:16px">CASOS E INCIDÊNCIAS</b>'
        )),
        fluidRow(
          column(width=6,
                 tags$div(HTML('<i class="fa fa-calendar-alt"style = "color:#0072B2;font-size:50px"></i>
                                  <b style = "padding-left:25px;color:#000000;font-size:25px;">
                                  NÚMERO DE CASOS POR CIDADE </b>')),
                 espaco_html(2),
                 div(plotlyOutput("plot_numero_casos_cidades",height = qtd_cidade*50),style="padding-left:20px;")),
          column(width=6,
                 tags$div(HTML('<i class="fa fa-calendar-alt"style = "color:#0072B2;font-size:50px"></i>
                                  <b style = "padding-left:25px;color:#000000;font-size:25px;">
                                  INCIDÊNCIA POR MILHÃO DE HABITANTE </b>')),
                 espaco_html(2),
                 div(plotlyOutput("plot_incidencia_cidades",height = qtd_cidade*50),style="padding-left:20px;") )
        ),
        fluidRow(column(width=12,HTML("Fontes: <b>Dados 15ª Regional : 
                    </b> Disponibilizados diariamente via planilha eletrônica. 
                     <b>Dados populacionais :</b><a href='https://www.ibge.gov.br/cidades-e-estados.html?view=municipio'>
                     https://www.ibge.gov.br/cidades-e-estados.html?view=municipio  Data e Hora da última Consulta: 02/06/2020 às 12h59min</a>"))),
        ),
        tabPanel(title = tags$div(HTML('<i class="fa fa-chart-line"style = "color:#0072B2;font-size:30px"></i>
                                                     <b style = "padding-left:10px;color:#000000;font-size:16px">EVOLUÇÃO DOS CASOS</b>'
        )),
        fluidRow(
          column(12, align="center",
                        img(src="gganim_casos.gif", height = '600px'))
                 )),
        tabPanel(title = tags$div(HTML('<i class="fa fa-chart-line"style = "color:#0072B2;font-size:30px"></i>
                                                     <b style = "padding-left:10px;color:#000000;font-size:16px">EVOLUÇÃO DAS INCIDÊNCIAS</b>'
        )),
        fluidRow(
          column(12, align="center",
                        img(src="gganim_incidencias.gif", height = '600px'))
          ),
        ))
      
      
  ))
  
  


)