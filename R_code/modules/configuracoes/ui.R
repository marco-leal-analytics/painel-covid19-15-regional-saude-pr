################################################################################################################
######################################## MODULO: CONFIGURACOES (UI) ##########################################
################################################################################################################

configuracoesUI <- function(id) {
  ns <- NS(id)

  tabPanel(value = 'cog',title = tags$div(HTML('<i class="fa fa-cog"style = "color:#0072B2;font-size:30px"></i>'
                                                   #<b style = "padding-left:10px;color:#000000;font-size:16px">CASOS POR DIA</b>'
  )),
                            fluidRow(
                              box_card(title= tags$div(HTML('<i class="fas fa-cog" style = "color:#0072B2;font-size:50px"></i>
                                                       <b style = "padding-left:25px;color:#000000;font-size:30px">CONFIGURAÇÕES</b>')),

                                  width = 12),
                              box_card(title= tags$div(HTML('<i class="fas fa-cog" style = "color:#0072B2;font-size:50px"></i>
                                                       <b style = "padding-left:25px;color:#000000;font-size:30px">DADOS</b>')),

                                  width = 12),

                              dataTableOutput(ns("dados_casos"),height = "650"),
                              box_card(title= fluidRow(column(width=2,HTML('<i class="fas fa-cog" style = "color:#0072B2;font-size:50px"></i>')),
                                                  column(width=10,
                                                       strong(textOutput(ns("dadosselecttext")), style = "padding-left:25px;color:#000000;font-size:30px"))),
                                            width = 12),
                              pickerInput(
                                inputId = ns("select_dadoscasos"),
                                label = "Selecione qual informação deseja :",
                                choices = c("Casos Por Dia", "Casos Acumulados", "Incidências")),

                              dataTableOutput(ns("tabela_qtdcasos"),height = "650"),
                              # box(title= tags$div(HTML('<i class="fas fa-cog" style = "color:#0072B2;font-size:50px"></i>
                              #                          <b style = "padding-left:25px;color:#000000;font-size:30px">ÓBITOS</b>')),
                              #
                              #     width = 12),
                              # fluidRow(column(width=12,align="center",
                              # dataTableOutput("obitos",height = "150"))),
                              box_card(title= tags$div(HTML('<i class="fas fa-cog" style = "color:#0072B2;font-size:50px"></i>
                                                       <b style = "padding-left:25px;color:#000000;font-size:30px">POPULAÇÃO</b>')),

                                  width = 12),
                              fluidRow(column(width=12,align="center",
                              dataTableOutput(ns("pop_cog"),height = "400")))
                              )
  )
}
