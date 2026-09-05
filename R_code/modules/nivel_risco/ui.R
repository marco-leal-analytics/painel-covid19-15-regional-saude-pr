################################################################################################################
######################################## MODULO: NIVEL DE RISCO (UI) #########################################
################################################################################################################

library(shinyWidgets)
withMathJax()
atualizado1 <- gsub("-","/",atualizado1)
#atualizado1 <- format("%Y/%m/%d",x = atualizado1)

nivel_riscoUI <- function(id) {
  ns <- NS(id)

  tabPanel(title = tags$div(HTML('<i class="fa fa-thermometer-three-quarters"style = "color:#0072B2;font-size:30px"></i>')),

                           fluidRow(
                             box_card(title= tags$div(HTML('<i class="fa fa-thermometer-three-quarters"style = "color:#0072B2;font-size:50px"></i>
                                                      <b style = "padding-left:25px;color:#000000;font-size:30px"> NÍVEL DE RISCO </b>')),
                                 tags$head(tags$style(HTML("hr {border-top: 5px solid;}"))),width = 12),
                             sidebarLayout(
                               sidebarPanel("",br(),
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
                                            ),br(),
                                            h2("Escolha uma escala:"),
                                            radioGroupButtons(
                                              inputId = ns("scale"),
                                              label = "",
                                              choices = c("Linear", "Logarítmica"),
                                              status = "primary"
                                            ),br(),br(),
                                            fluidRow(column(9,h2("Aviso importante")),column(2, icon("exclamation-triangle",  "fa-4x"))),br(),br(),
                                            "O fato de uma cidade não estar na faixa de risco alto ou moderado não pode ser um critério determinante
                                  na tomada de decisão para se encerrar ou afrouxar as medidas de mitigação que por ventura estejam
                                  sendo promovidas/impostas pelo poder público.",br(),br(), "Tais medidas, caso estejam sendo tomadas, estão
                                  justamente contribuindo para que o risco seja menor.",br(),br(),
                                            fluidRow(column(9,h3("O que representa estes rankings")),column(2, icon("question-circle",  "fa-4x"))),br(),br(),
                                            "Os rankings 'Risco estimado do aumento de casos' e 'Risco estimado do aumento de casos relativo ao tamanho da população'
                                  foram construídos baseando-se na prevalência das infecções de covid-19
                                  nas cidades em conjunto com a taxa de propagação estimada, ajuste do modelo e tamanho da população.", br(), br(), "A ponderação em relação ao tamanho
                                  da população de cada cidade visa dimensionar o impacto do aumento de casos. Por exemplo: 10 novos casos em Floresta representam um risco maior do que 10 novos casos em Maringá.", br(),br(),

                                            " As linhas verticais servem para referenciar se o risco é baixo, moderado ou alto. Risco baixo, moderado e alto são considerados
                                  para uma fase inicial da epidemia. Caso o número de casos aumente significativamente em um curto período de tempo, o que caracterizaria
                                  uma epidemia estabelecida nas cidades, novas linhas descrevendo faixas de maior risco serão
                                  adicionadas.",br(),br(),

                                            "As cidades que não possuem nenhum caso confirmado nos últimos 10 dias não estão inclusas nestes
                                  rankings."
                               ),
                               mainPanel(

                                 tabBox(width = "700px",

                                        tabPanel("Risco estimado do aumento de casos",
                                                 fluidRow(align="right",column(11,actionBttn(
                                                   inputId = ns("Id113"),
                                                   label = "Precisa de ajuda?",
                                                   style = "jelly",
                                                   color = "primary")),column(1)),
                                                 plotlyOutput(ns("rankrisco"))),

                                        tabPanel("Risco estimado do aumento de casos relativo ao tamanho da população", plotlyOutput(ns("rankriscorelativo")))))))
  )
}
