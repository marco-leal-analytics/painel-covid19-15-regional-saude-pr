################################################################################################################
######################################## MODULO: CONFIGURACOES (SERVER) ######################################
################################################################################################################
# Aba visivel apenas para o usuario 'mleal', anexada dinamicamente via
# appendTab(inputId = "navbar", configuracoesUI("configuracoes")) dentro do
# observeEvent(input$login) em R_code/server.R.

configuracoesServer <- function(id) {
  moduleServer(id, function(input, output, session) {

    dados_table <- data_casos
    observeEvent(input$select_dadoscasos, {
      output$dadosselecttext <- renderText({

        as.character(input$select_dadoscasos)

      })

      if(as.character(input$select_dadoscasos) == 'Casos Por Dia'){

        dados_table <- data_casos[,c(1,which(apply(data_casos[2:32],2,sum) > 0)+1)]
        sum(dados_table$ATALAIA)

      }else if (as.character(input$select_dadoscasos) == 'Incidências'){


        dados_table <- incidencias[,c(1,which(apply(incidencias[2:32],2,sum) > 0)+1)]



      }else if (as.character(input$select_dadoscasos) == 'Casos Acumulados'){

        dados_table <- as.data.frame(apply(data_casos[,2:32],2,cumsum))
        dados_table <- dados_table[,which(apply(dados_table,2,sum) > 0)]
        dados_table <- data.frame(DATAS=data_casos[,1],dados_table)


      }

      output$tabela_qtdcasos <- renderDataTable(as.data.frame(dados_table),
                                                options = list(
                                                  pageLength = 10,
                                                  scrollX=TRUE,
                                                  searching = FALSE,
                                                  autoWidth = TRUE


                                                )
      )




    })

    output$obitos <- renderDataTable(as.data.frame(obitos_mun[,obitos_mun[1,]>0]),
                                     options = list(
                                       pageLength = 10,
                                       scrollX=TRUE,
                                       searching = FALSE,
                                       autoWidth = TRUE)
    )



    output$pop_cog <- renderDataTable(as.data.frame(cbind(populacao_municipio[1:16,],populacao_municipio[17:32,])),
                                      options = list(
                                        pageLength = 16,
                                        scrollX=TRUE,
                                        searching = FALSE,
                                        autoWidth = TRUE


                                      )
    )

    output$dados_casos <- renderDataTable(as.data.frame(dados2),
                                          options = list(
                                            pageLength = 10,
                                            scrollX=TRUE,
                                            searching = FALSE,
                                            autoWidth = TRUE,
                                            columnDefs = list(list(targets=c(0), visible=TRUE, width='20'),
                                                              list(targets=c(1), visible=TRUE, width='50'),
                                                              list(targets=c(2), visible=TRUE, width='100'),
                                                              list(targets=c(3), visible=TRUE, width='250'),
                                                              list(targets=c(4), visible=TRUE, width='35'),
                                                              list(targets=c(5), visible=TRUE, width='35'),
                                                              list(targets=c(6), visible=TRUE, width='35'),
                                                              list(targets=c(7), visible=TRUE, width='35'),
                                                              list(targets=c(8), visible=TRUE, width='35'),
                                                              list(targets=c(9), visible=TRUE, width='35'),

                                                              list(targets='_all', visible=FALSE))

                                          )
    )

  })
}
