################################################################################################################
######################################## MODULO: COMPORTAMENTO INICIAL (SERVER) ##############################
################################################################################################################
# atraso(k) e espostos(q) sao definidas em R_code/legacy/source2.R, que le
# input$cidade2 diretamente - por isso precisam ser (re)source()adas dentro de
# cada render, com local=TRUE, exatamente como no server.R original.

comportamento_inicialServer <- function(id) {
  moduleServer(id, function(input, output, session) {

    output$atraso15 <- renderPlotly({

      source(file.path(getwd(), "R_code/legacy/source2.R"), local=TRUE, encoding="UTF-8")

      fig <- atraso(15)
      fig %>% dark_plotly()

    })

    output$atraso30 <- renderPlotly({

      source(file.path(getwd(), "R_code/legacy/source2.R"), local=TRUE, encoding="UTF-8")

      fig <- atraso(30)
      fig %>% dark_plotly()

    })

    output$atraso45 <- renderPlotly({

      source(file.path(getwd(), "R_code/legacy/source2.R"), local=TRUE, encoding="UTF-8")

      fig <- atraso(45)
      fig %>% dark_plotly()

    })

    output$atraso60 <- renderPlotly({

      source(file.path(getwd(), "R_code/legacy/source2.R"), local=TRUE, encoding="UTF-8")

      fig <- atraso(60)
      fig %>% dark_plotly()

    })

    output$espostos1 <- renderPlotly({

      source(file.path(getwd(), "R_code/legacy/source2.R"), local=TRUE, encoding="UTF-8")

      fig <- espostos(1)
      fig %>% dark_plotly()

    })

    output$espostos3 <- renderPlotly({

      source(file.path(getwd(), "R_code/legacy/source2.R"), local=TRUE, encoding="UTF-8")

      fig <- espostos(3)
      fig %>% dark_plotly()

    })

    output$espostos5 <- renderPlotly({

      source(file.path(getwd(), "R_code/legacy/source2.R"), local=TRUE, encoding="UTF-8")

      fig <- espostos(5)
      fig %>% dark_plotly()

    })

    output$espostos10 <- renderPlotly({

      source(file.path(getwd(), "R_code/legacy/source2.R"), local=TRUE, encoding="UTF-8")

      fig <- espostos(10)
      fig %>% dark_plotly()

    })

  })
}
