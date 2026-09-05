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

      atraso(15)

    })

    output$atraso30 <- renderPlotly({

      source(file.path(getwd(), "R_code/legacy/source2.R"), local=TRUE, encoding="UTF-8")

      atraso(30)

    })

    output$atraso45 <- renderPlotly({

      source(file.path(getwd(), "R_code/legacy/source2.R"), local=TRUE, encoding="UTF-8")

      atraso(45)

    })

    output$atraso60 <- renderPlotly({

      source(file.path(getwd(), "R_code/legacy/source2.R"), local=TRUE, encoding="UTF-8")

      atraso(60)

    })

    output$espostos1 <- renderPlotly({

      source(file.path(getwd(), "R_code/legacy/source2.R"), local=TRUE, encoding="UTF-8")

      espostos(1)

    })

    output$espostos3 <- renderPlotly({

      source(file.path(getwd(), "R_code/legacy/source2.R"), local=TRUE, encoding="UTF-8")

      espostos(3)

    })

    output$espostos5 <- renderPlotly({

      source(file.path(getwd(), "R_code/legacy/source2.R"), local=TRUE, encoding="UTF-8")

      espostos(5)

    })

    output$espostos10 <- renderPlotly({

      source(file.path(getwd(), "R_code/legacy/source2.R"), local=TRUE, encoding="UTF-8")

      espostos(10)

    })

  })
}
