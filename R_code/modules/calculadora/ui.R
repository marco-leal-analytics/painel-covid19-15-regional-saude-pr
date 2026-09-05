################################################################################################################
######################################## MODULO: CALCULADORA SEIR (UI) #######################################
################################################################################################################

calculadora_seirUI <- function(id) {
  ns <- NS(id)

  withMathJax()

  parametros <- tagList(
    chooseSliderSkin(
      skin = "Modern",
      color = "#112446"),
    div(class = "three-col-row",
      div(class = "three-col-item",
             sliderInput(inputId = ns("N"), label = strong("POPULAÇÃO (N)"), value = 423666, min = 100000, max = 700000, step = 100),
             bsTooltip(ns("N"), "Defina o tamanho total da população de estudo.",placement = "right", trigger = "hover",options = NULL),
             sliderInput(inputId = ns("t"), label = strong("PERÍODO DE TEMPO (t)"), value = 200, step=1, min = 1, max = 365,
                         animate = animationOptions(interval = 100, loop = FALSE)),
             bsTooltip(ns("t"), "Defina o número de dias a ser considerado na simulação.",placement = "right", trigger = "hover",options = NULL)),
      div(class = "three-col-item",
             withMathJax(),
             sliderInput(inputId = ns("beta"), label =  strong('TAXA DE PROPAGAÇÃO \\( \\beta \\)'), value = 0.3, min = 0.05, max = 0.45, step = 0.001),
             bsTooltip(ns("beta"), "Esta é a taxa de propagação da infecção (COVID-19).",placement = "right", trigger = "hover",options = NULL),
             sliderInput(inputId = ns("sigma"), label =strong("TAXA DE INCUBAÇÃO \\( \\sigma \\) "), value = 0.2, min = 0.00, max = 1, step = 0.01),
             bsTooltip(ns("sigma"), "É dada por 1/t, onde t é o tempo médio de incubação.",placement = "right", trigger = "hover",options = NULL),
             sliderInput(inputId = ns("gamma"), label =strong("TAXA DE RECUPERAÇÃO \\( \\gamma \\)"), value = 0.1, min = 0.00, max = 1, step = 0.01),
             bsTooltip(ns("gamma"), "É dada por 1/t, onde t é o tempo médio de recuperação.",placement = "right", trigger = "hover",options = NULL)),
      div(class = "three-col-item",
             sliderInput(inputId = ns("S"), label =strong("SUCCETÍVEIS (S)"), value = 423661, min = 100000, max = 700000, step = 100),
             bsTooltip(ns("S"), "Defina a quantidade inicial de pessoas suscetíveis à infecção.",placement = "right", trigger = "hover",
                 options = NULL),
             sliderInput(inputId = ns("E"), label =strong("EXPOSTOS (E)"), value = 3, min = 0, max = 50, step = 1),
             bsTooltip(ns("E"), "Defina a quantidade inicial de pessoas expostas à infe.cção",placement = "right", trigger = "hover",options = NULL),
             sliderInput(inputId = ns("I"), label =strong("INFECTADOS (I)"), value = 2, min = 0, max = 50, step = 1),
             bsTooltip(ns("I"), "Defina a quantidade inicial de pessoas infectadas à infecção.",placement = "right", trigger = "hover",options = NULL),
             sliderInput(inputId = ns("R"), label =strong("RECUPERADOS (R)"), value = 0, min = 0, max = 50, step = 1),
             bsTooltip(ns("R"), "Defina a quantidade inicial de pessoas recuperadas da infecção.",placement = "right", trigger = "hover", options = NULL))
      )
  )

  tagList(
    mla_hero(
      eyebrow = "15ª REGIONAL DE SAÚDE · COVID-19",
      title = "Calculadora SEIR",
      summary = "Simule a evolução da epidemia de COVID-19 com o modelo SEIR (Suscetíveis-Expostos-Infectados-Recuperados), ajustando população, taxas de propagação, incubação e recuperação, e os valores iniciais de cada compartimento."
    ),

    ui_card(title = "Parâmetros do modelo", parametros),

    tags$div(class = "section",
      tags$div(class = "section-title", "Simulação"),
      ui_card(plotlyOutput(ns("plotseir"), width = "auto"))
    )
  )
}
