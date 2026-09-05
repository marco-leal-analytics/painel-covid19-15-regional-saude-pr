################################################################################################################
######################################## MODULO: CONFIGURACOES (UI) ##########################################
################################################################################################################

configuracoesUI <- function(id) {
  ns <- NS(id)

  tagList(
    tags$div(class = "mla-hero module-hero",
      tags$div(class = "hero-copy",
        tags$span(class = "eyebrow", "15ª REGIONAL DE SAÚDE · COVID-19"),
        tags$h1("Configurações"),
        tags$p(class = "hero-summary",
          "Área de inspeção dos dados que alimentam o painel: tabelas brutas de casos, incidências e população da 15ª Regional de Saúde do Paraná."
        )
      ),
      tags$div(class = "hero-visual hero-mark", tags$span("CONFIGURAÇÕES"))
    ),

    tags$div(class = "section",
      tags$div(class = "section-title", "Dados"),
      ui_card(
        dataTableOutput(ns("dados_casos"), height = "650")
      ),
      ui_card(
        pickerInput(
          inputId = ns("select_dadoscasos"),
          label = "Selecione qual informação deseja :",
          choices = c("Casos Por Dia", "Casos Acumulados", "Incidências")
        ),
        tags$strong(textOutput(ns("dadosselecttext"))),
        dataTableOutput(ns("tabela_qtdcasos"), height = "650")
      )
    ),

    tags$div(class = "section",
      tags$div(class = "section-title", "População"),
      ui_card(
        dataTableOutput(ns("pop_cog"), height = "400")
      )
    )
  )
}
