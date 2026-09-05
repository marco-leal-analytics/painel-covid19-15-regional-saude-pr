################################################################################################################
######################################## MODULO: CALCULADORA SEIR (UI) #######################################
################################################################################################################

calculadora_seirUI <- function(id) {
  ns <- NS(id)

  withMathJax()
  controles <- dropdownButton(
    panel(tags$h3(strong("Parâmetros")),
          chooseSliderSkin(
            skin = "Modern",
            color = "#112446"),
          fluidRow(
            column(width = 4,
                   sliderInput(inputId = ns("N"), label = strong("POPULAÇÃO (N)"), value = 423666, min = 100000, max = 700000, step = 100),
                   bsTooltip(ns("N"), "Defina o tamanho total da população de estudo.",placement = "right", trigger = "hover",options = NULL),
                   sliderInput(inputId = ns("t"), label = strong("PERÍODO DE TEMPO (t)"), value = 200, step=1, min = 1, max = 365,
                               animate = animationOptions(interval = 100, loop = FALSE)),
                   bsTooltip(ns("t"), "Defina o número de dias a ser considerado na simulação.",placement = "right", trigger = "hover",options = NULL)),
            column(width = 4,
                   withMathJax(),
                   sliderInput(inputId = ns("beta"), label =  strong('TAXA DE PROPAGAÇÃO \\( \\beta \\)'), value = 0.3, min = 0.05, max = 0.45, step = 0.001),
                   bsTooltip(ns("beta"), "Esta é a taxa de propagação da infecção (COVID-19).",placement = "right", trigger = "hover",options = NULL),
                   sliderInput(inputId = ns("sigma"), label =strong("TAXA DE INCUBAÇÃO \\( \\sigma \\) "), value = 0.2, min = 0.00, max = 1, step = 0.01),
                   bsTooltip(ns("sigma"), "É dada por 1/t, onde t é o tempo médio de incubação.",placement = "right", trigger = "hover",options = NULL),
                   sliderInput(inputId = ns("gamma"), label =strong("TAXA DE RECUPERAÇÃO \\( \\gamma \\)"), value = 0.1, min = 0.00, max = 1, step = 0.01),
                   bsTooltip(ns("gamma"), "É dada por 1/t, onde t é o tempo médio de recuperação.",placement = "right", trigger = "hover",options = NULL)),
            column(width=4,
                   sliderInput(inputId = ns("S"), label =strong("SUCCETÍVEIS (S)"), value = 423661, min = 100000, max = 700000, step = 100),
                   bsTooltip(ns("S"), "Defina a quantidade inicial de pessoas suscetíveis à infecção.",placement = "right", trigger = "hover",
                       options = NULL),
                   sliderInput(inputId = ns("E"), label =strong("EXPOSTOS (E)"), value = 3, min = 0, max = 50, step = 1),
                   bsTooltip(ns("E"), "Defina a quantidade inicial de pessoas expostas à infe.cção",placement = "right", trigger = "hover",options = NULL),
                   sliderInput(inputId = ns("I"), label =strong("INFECTADOS (I)"), value = 2, min = 0, max = 50, step = 1),
                   bsTooltip(ns("I"), "Defina a quantidade inicial de pessoas infectadas à infecção.",placement = "right", trigger = "hover",options = NULL),
                   sliderInput(inputId = ns("R"), label =strong("RECUPERADOS (R)"), value = 0, min = 0, max = 50, step = 1),
                   bsTooltip(ns("R"), "Defina a quantidade inicial de pessoas recuperadas da infecção.",placement = "right", trigger = "hover", options = NULL))
            )),
    icon = icon("sliders", "fa-2x"),
    width = "1200px",circle= FALSE,label = strong("Parâmetros")
    )

  tabPanel(title = tags$div(HTML('<i class="fa fa-calculator"style = "color:#0072B2;font-size:30px"></i>')),
                                fluidRow(box_card(title= tags$div(HTML('<i class="fa fa-calculator"style = "color:#0072B2;font-size:50px"></i>
                                                                  <b style = "padding-left:25px;color:#000000;font-size:30px">
                                                                  CALCULADORA DO MODELO SEIR </b>')),
                                             tags$head(tags$style(HTML("hr {border-top: 5px solid;}"))),width = 12)),
                                fluidRow(column(width=12,align="left",
                                                controles
                                                )),
                                fluidRow(
                                  column(12,
                                         panel(
                                           plotlyOutput(ns("plotseir"),width = "auto")
                                         )))
                                )
}
