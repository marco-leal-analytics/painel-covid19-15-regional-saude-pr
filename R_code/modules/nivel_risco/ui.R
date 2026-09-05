################################################################################################################
######################################## MODULO: NIVEL DE RISCO (UI) #########################################
################################################################################################################

library(shinyWidgets)
withMathJax()
atualizado1 <- gsub("-","/",atualizado1)
#atualizado1 <- format("%Y/%m/%d",x = atualizado1)

nivel_riscoUI <- function(id) {
  ns <- NS(id)

  tagList(
    mla_hero(
      eyebrow = "15ª REGIONAL DE SAÚDE · COVID-19",
      title   = "Nível de risco",
      summary = "Ranking das cidades da 15ª Regional de Saúde segundo o risco estimado de aumento de casos de COVID-19, calculado a partir da prevalência das infecções, da taxa de propagação estimada e do tamanho da população."
    ),

    div(class = "two-col-row",
      div(class = "two-col-item",
        ui_card(title = "Filtros",
          h2("Escolha uma data:"),
          airDatepickerInput(
            inputId = ns("calendar"),
            label = NULL,
            value = atualizado1,
            multiple = FALSE,
            range = FALSE,
            timepicker = FALSE,
            separator = " - ",
            placeholder = "Escolha data",
            dateFormat = "dd/mm/yyyy",
            minDate = "2020/03/16",
            maxDate = atualizado1,
            disabledDates = NULL,
            view = c("days", "months", "years"),
            startView = TRUE,
            minView = c("days", "months", "years"),
            monthsField = c("monthsShort", "months"),
            clearButton = FALSE,
            todayButton = TRUE,
            autoClose = TRUE,
            timepickerOpts = timepickerOptions(),
            position = NULL,
            update_on = c("change", "close"),
            addon = c("right", "left", "none"),
            language = "pt-BR",
            inline = FALSE,
            width = NULL
          ),
          br(),
          h2("Escolha uma escala:"),
          radioGroupButtons(
            inputId = ns("scale"),
            label = "",
            choices = c("Linear", "Logarítmica"),
            status = "primary"
          )
        )
      ),
      div(class = "two-col-item",
        callout(
          tags$span(icon("exclamation-triangle"), "Aviso importante"),
          tags$p(
            "O fato de uma cidade não estar na faixa de risco alto ou moderado não pode ser um critério determinante ",
            "na tomada de decisão para se encerrar ou afrouxar as medidas de mitigação que por ventura estejam ",
            "sendo promovidas/impostas pelo poder público."
          ),
          tags$p(
            "Tais medidas, caso estejam sendo tomadas, estão justamente contribuindo para que o risco seja menor."
          ),
          success = FALSE
        ),
        br(),
        callout(
          tags$span(icon("question-circle"), "O que representa estes rankings"),
          tags$p(
            "Os rankings \"Risco estimado do aumento de casos\" e \"Risco estimado do aumento de casos relativo ao tamanho da população\" ",
            "foram construídos baseando-se na prevalência das infecções de covid-19 nas cidades em conjunto com a taxa de propagação ",
            "estimada, ajuste do modelo e tamanho da população."
          ),
          tags$p(
            "A ponderação em relação ao tamanho da população de cada cidade visa dimensionar o impacto do aumento de casos. Por exemplo: ",
            "10 novos casos em Floresta representam um risco maior do que 10 novos casos em Maringá."
          ),
          tags$p(
            "As linhas verticais servem para referenciar se o risco é baixo, moderado ou alto. Risco baixo, moderado e alto são ",
            "considerados para uma fase inicial da epidemia. Caso o número de casos aumente significativamente em um curto período de ",
            "tempo, o que caracterizaria uma epidemia estabelecida nas cidades, novas linhas descrevendo faixas de maior risco serão ",
            "adicionadas."
          ),
          tags$p(
            "As cidades que não possuem nenhum caso confirmado nos últimos 10 dias não estão inclusas nestes rankings."
          )
        )
      )
    ),

    tags$div(class = "section",
      tags$div(class = "section-title", "Rankings de risco"),
      navset_card_tab(
        nav_panel("Risco estimado do aumento de casos",
          fluidRow(align = "right",
            column(11,
              actionBttn(
                inputId = ns("Id113"),
                label = "Precisa de ajuda?",
                style = "jelly",
                color = "primary"
              )
            ),
            column(1)
          ),
          plotlyOutput(ns("rankrisco"))
        ),
        nav_panel("Risco relativo ao tamanho da população",
          plotlyOutput(ns("rankriscorelativo"))
        )
      )
    )
  )
}
