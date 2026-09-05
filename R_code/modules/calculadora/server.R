################################################################################################################
######################################## MODULO: CALCULADORA SEIR (SERVER) ###################################
################################################################################################################

calculadora_seirServer <- function(id) {
  moduleServer(id, function(input, output, session) {

    output$plotseir <- renderPlotly({

      a<-SEIR(pars = c(mu = 0, beta = input$beta, sigma = input$sigma, gamma = input$gamma),
              init = c(S = input$S / input$N, E = input$E / input$N, I = input$I / input$N, R = input$R / input$N),
              time = 0:input$t)
      #b<-data.frame(a$results$S[1:length(a$results$S)], a$results$E[1:length(a$results$S)], a$results$I[1:length(a$results$S)], a$results$R[1:length(a$results$S)])
      #colnames(b)<-c("S","E","I","R")


      fig<-plot_ly(x = ~ 1:nrow(a$results), y = ~input$N*a$results$S, mode = 'lines', type="scatter",
                   text = "neste dia", line = list(color = 'rgb(8,48,107)', width = 4), name = 'Suscetíveis')
      fig<-fig %>% add_trace(y = ~ input$N*a$results$E, mode = 'lines+markers', name = 'Expostos',
                             line = list(color = 'orange', width = 4))
      fig<-fig %>% add_trace(y = ~ input$N*a$results$I, mode = 'lines+markers', name = 'Infectados',
                             line = list(color = 'red', width = 4), color = I("red"))
      fig<-fig %>% add_trace(y = ~ input$N*a$results$R, mode = 'lines', name = 'Recuperados', #dash = 'dash','dot'
                             line = list(color = 'green', width = 4))
      fig <- fig %>% layout(title = "<b>MODELO SEIR</b>", hovermode = TRUE, spikedistance =  -1,
                            xaxis = list(title = "<b>DIAS</b>", showspikes = TRUE, titlefont = list(size = 24),
                                         spikemode  = 'across', #toaxis, across, marker
                                         spikesnap = 'cursor',  ticks = "outside",tickangle = -45,
                                         showline=TRUE,tickfont = list(size = 24),
                                         showgrid=TRUE),
                            yaxis = list (title = "<b>NÚMERO DE PESSOAS</b>",
                                          spikemode  = 'across', #toaxis, across, marker
                                          spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),
                                          showline=TRUE,tickfont = list(size = 24),
                                          showgrid=TRUE),
                            height= 450

      )




      fig




    })

  })
}
