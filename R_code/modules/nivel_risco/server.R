################################################################################################################
######################################## MODULO: NIVEL DE RISCO (SERVER) #####################################
################################################################################################################

nivel_riscoServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # bsModal (shinyBS) dependia do jQuery/data-toggle do Bootstrap 3-4 e nao
    # abre sob o bs_theme(version = 5) do bslib. Trocado pelo modal nativo do
    # Shiny (showModal/modalDialog), que funciona em qualquer versao do Bootstrap.
    observeEvent(input$Id113, {
      showModal(modalDialog(
        title = "No vídeo abaixo apresentamos uma análise do nível de risco.",
        uiOutput(ns("video")),
        size = "l",
        easyClose = TRUE
      ))
    })

    output$rankrisco <- renderPlotly({

      source(file.path(getwd(), "R_code/legacy/source3.R"), local=TRUE, encoding="UTF-8")

      plotrankrisco

    })

    output$rankriscorelativo <- renderPlotly({

      source(file.path(getwd(), "R_code/legacy/source3.R"), local=TRUE, encoding="UTF-8")

      plotrankriscorelativo

    })

    observeEvent(input$calendar_button, {
      sendSweetAlert(
        session = session,
        title = "Informação",
        text = "Ao escolher uma data será apresentado o nível de risco
        calculado a partir do casos confirmados até a data escolhida. Você pode verificar o nível de risco desde o dia 16/03/2020
        até a data da última atualização do dashboard.",
        type = "info"
      )
    })

    output$video <- renderUI({
      #click <- input$calendar_button
      #if(click==TRUE){
      #link = ""
      HTML(paste0('<iframe width="855" height="500" src="https://www.youtube.com/embed/',link,'" frameborder="0", allowfullscreen></iframe>'))
      #}
    })

  })
}
