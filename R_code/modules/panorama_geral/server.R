################################################################################################################
######################################## MODULO: PAINEL GERAL (SERVER) #######################################
################################################################################################################

panorama_geralServer <- function(id) {
  moduleServer(id, function(input, output, session) {

    output$table_populacao <- renderDataTable(as.data.frame(populacao_municipio,row.names = F),
                                              options = list(
                                                pageLength = 10,
                                                scrollX=TRUE,
                                                searching = FALSE,
                                                autoWidth = TRUE,
                                                columnDefs = list(list(targets=c(0), visible=TRUE, width='50'),
                                                                  list(targets=c(1), visible=TRUE, width='250'),
                                                                  list(targets=c(2), visible=TRUE, width='75'),
                                                                  list(targets='_all', visible=FALSE))

                                              )
    )

    output$table_populacao2 <- renderDataTable(as.data.frame(populacao_municipio,row.names = F),
                                               options = list(
                                                 pageLength = 10,
                                                 scrollX=TRUE,
                                                 searching = FALSE,
                                                 autoWidth = TRUE,
                                                 columnDefs = list(list(targets=c(0), visible=TRUE, width='50'),
                                                                   list(targets=c(1), visible=TRUE, width='250'),
                                                                   list(targets=c(2), visible=TRUE, width='75'),
                                                                   list(targets='_all', visible=FALSE))

                                               )
    )

    output$plot_pie_sexo <- renderPlotly({

      data_sexo <- data.frame(n = casos_sexo[,1],categorie = c("FEMININO","MASCULINO"))
      fig <- plot_ly(data_sexo, labels = ~categorie, values = ~n, type = 'pie',
                     textposition = 'inside',
                     textinfo = 'label+percent',
                     insidetextfont = list(color = '#FFFFFF'),
                     hoverinfo = 'text',
                     insidetextorientation='horizontal',
                     text = ~paste( n, ' casos'),
                     marker = list(colors = c('red','blue'),
                                   line = list(color = '#FFFFFF', width = 1)),
                     #The 'pull' attribute can also be used to create space between the sectors
                     showlegend = FALSE)
      fig <- fig %>% layout(hovermode = TRUE, spikedistance =  -1,
                            xaxis = list(title = "<b>DATAS</b>", showspikes = TRUE, titlefont = list(size = 24),
                                         spikemode  = 'across', #toaxis, across, marker
                                         spikesnap = 'cursor',  ticks = "outside",tickangle = -45,
                                         showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                                         showgrid=TRUE),
                            yaxis = list (title = "<b>NÚMERO DE CASOS</b>",
                                          spikemode  = 'across', #toaxis, across, marker
                                          spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),fixedrange=TRUE,
                                          showline=TRUE,tickfont = list(size = 24),
                                          showgrid=TRUE))%>%
        config(displayModeBar = FALSE)

      fig

    })


    output$plot_pie_obito_sexo <- renderPlotly({

      data_sexo <- data.frame(n=obitos_sexo,categorie=c("FEMININO","MASCULINO"))

      fig <- plot_ly(data_sexo, labels = ~categorie, values = ~n, type = 'pie',
                     textposition = 'inside',
                     textinfo = 'label+percent',
                     insidetextfont = list(color = '#FFFFFF'),
                     hoverinfo = 'text',
                     insidetextorientation='horizontal',
                     text = ~paste( n, ' óbitos'),
                     marker = list(colors = c('red','blue'),
                                   line = list(color = '#FFFFFF', width = 1)),
                     #The 'pull' attribute can also be used to create space between the sectors
                     showlegend = FALSE)
      fig <- fig %>% layout(hovermode = TRUE, spikedistance =  -1,
                            xaxis = list(title = "<b>DATAS</b>", showspikes = TRUE, titlefont = list(size = 24),
                                         spikemode  = 'across', #toaxis, across, marker
                                         spikesnap = 'cursor',  ticks = "outside",tickangle = -45,
                                         showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                                         showgrid=TRUE),
                            yaxis = list (title = "<b>NÚMERO DE CASOS</b>",
                                          spikemode  = 'across', #toaxis, across, marker
                                          spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),fixedrange=TRUE,
                                          showline=TRUE,tickfont = list(size = 24),
                                          showgrid=TRUE))%>%
        config(displayModeBar = FALSE)

      fig

    })

    output$plot_incidencia_regional <- renderPlotly({
      stack_incidencias           <- stack(incidencias)
      label                       <- rep(datas,length(colnames(incidencias[2:32])))
      stack_incidencias[,"label"] <- label
      stack_incidencias           <- stack_incidencias[stack_incidencias$values>0,]
      pos_reg                     <- which(stack_incidencias$ind == "REGIONAL")
      stack_incidencias           <- stack_incidencias[c(pos_reg),-2]
      stack_incidencias$label     <- as.character(stack_incidencias$label)


      fig<-plot_ly(x = ~ stack_incidencias$label, y = ~ stack_incidencias$values,height= 500, mode = 'lines+markers', type="scatter",
                   text = "", marker=list(color = "#000000", size=10, opacity=0.75),
                   line = list(color = "#09557f", width = 4,opacity= 0.75), name = '15ª REGIONAL')
      fig <- fig %>% layout(hovermode = TRUE, spikedistance =  -1,
                            xaxis = list(title = "<b>DATAS</b>", showspikes = TRUE, titlefont = list(size = 24),
                                         spikemode  = 'across', #toaxis, across, marker
                                         spikesnap = 'cursor',  ticks = "outside",tickangle = -45,
                                         showline=TRUE,tickfont = list(size = 24),type = 'date',
                                         tickformat = "%d/%m",fixedrange=TRUE,


                                         showgrid=TRUE),
                            yaxis = list (title = "<b>INCIDÊNCIA</b>",
                                          spikemode  = 'across', #toaxis, across, marker
                                          spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),
                                          showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                                          showgrid=TRUE)


      ) %>% config(displayModeBar = FALSE)
      fig


    })

    output$plot_numero_casos_cidades <- renderPlotly({
      library(dplyr)
      stack_casos <- as.numeric(apply(data_casos[3:32],2,sum))
      pos <-stack_casos > 0
      label       <- colnames(data_casos[,3:32])[pos];label
      stack_casos <- stack_casos[stack_casos > 0 ];stack_casos

      casos <- data.frame(label=label,freq=stack_casos)
      casos <- casos[order(casos$freq,decreasing = F),]

      m <- list(
        l = 250,
        r = 10,
        b = 10,
        t = 10)

      fig<-plot_ly(x = ~ casos$freq , y = ~ as.character(casos$label), type="bar", orientation = 'H',
                   text = "", marker=list(color = "#09557f", size=10, opacity=0.75),
                   name = 'Suscetíveis')
      fig <- fig %>% layout(hovermode = TRUE, spikedistance =  -1,
                            xaxis = list(title = "<b>NÚMERO DE CASOS</b>", showspikes = TRUE, titlefont = list(size = 24),
                                         spikemode  = 'across', #toaxis, across, marker
                                         spikesnap = 'cursor',  ticks = "outside",tickangle = 0,
                                         showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,


                                         showgrid=TRUE),
                            yaxis = list (title = "<b>CIDADES</b>",
                                          spikemode  = 'across', #toaxis, across, marker
                                          spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),
                                          showline=TRUE,tickfont = list(size = 16),categoryorder = "array",
                                          categoryarray = ~casos$freq,fixedrange=TRUE,
                                          showgrid=TRUE),margin = m,
                            autosize = T) %>% config(displayModeBar = FALSE)
      fig




    })

    output$plot_incidencia_cidades <- renderPlotly({
      library(dplyr)
      stack_casos <- incidencias[length(incidencias[,1]),3:32]
      pos <-stack_casos > 0
      label       <- colnames(data_casos[,3:32])[pos];label
      stack_casos <- stack_casos[stack_casos > 0 ];stack_casos

      casos <- data.frame(label=label,freq=stack_casos)
      casos <- casos[order(casos$freq,decreasing = F),]

      m <- list(
        l = 250,
        r = 10,
        b = 10,
        t = 10)

      fig<-plot_ly(x = ~ casos$freq , y = ~ as.character(casos$label), type="bar", orientation = 'H',
                   text = "", marker=list(color = "#09557f", size=10, opacity=0.75),
                   name = 'Suscetíveis')
      fig <- fig %>% layout(hovermode = TRUE, spikedistance =  -1,
                            xaxis = list(title = "<b>INCIDÊNCIA</b>", showspikes = TRUE, titlefont = list(size = 24),
                                         spikemode  = 'across', #toaxis, across, marker
                                         spikesnap = 'cursor',  ticks = "outside",tickangle = 0,
                                         showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,


                                         showgrid=TRUE),
                            yaxis = list (title = "<b>CIDADES</b>",
                                          spikemode  = 'across', #toaxis, across, marker
                                          spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),
                                          showline=TRUE,tickfont = list(size = 16),categoryorder = "array",
                                          categoryarray = ~casos$freq,fixedrange=TRUE,
                                          showgrid=TRUE),margin = m,
                            autosize = T

      ) %>% config(displayModeBar = FALSE)
      fig




    })

  })
}
