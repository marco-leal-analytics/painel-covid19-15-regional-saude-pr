################################################################################################################
######################################## MODULO: MAPA DE CIDADES (SERVER) ####################################
################################################################################################################

mapa_cidadesServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$map2 <- renderLeaflet({


      leaflet(regional_maps,
              options = list(zoomControl = FALSE,
                             #center = c(-23.2,-53.06396),
                             zoom = 9,minZoom = 9, maxZoom = 9,
                             maxBounds = list(list(-23.15,-51.9113), list(-23.15,-51.9113))
              )) %>%
        addTiles() %>%
        #addMouseCoordinates() %>%
        setView(lng = -51.9113, lat = -23.17824, zoom=9) %>%
        addCircleMarkers(data = objeto_sf[objeto_sf$casos>0,],fillColor = "red",color = "red",weight = 30,

                         popup = objeto_sf$name[objeto_sf$casos>0],label = objeto_sf$name[objeto_sf$casos>0],
                         labelOptions = labelOptions(noHide = F, textOnly = T,textsize = 30),

                         layerId = ~objeto_sf$uid[objeto_sf$casos>0])  %>%
        addPolygons(
          weight = 2,
          opacity = 0.1,
          color = "gray",
          dashArray = "3",
          fillOpacity = 0.1,
          highlight = highlightOptions(
            weight = 5,
            color = "#666",
            dashArray = "",
            fillOpacity = 0.1,
            bringToFront = TRUE),
          label = labels_map,
          labelOptions = labelOptions(
            style = list("font-weight" = "normal", padding = "3px 8px"),
            textsize = "15px",
            direction = "auto"))

    })

    ## RENDER MAPA-------
    n_casos   <- apply(data_casos[,3:(length(lista_cidade_upper)+2)], MARGIN = 2,sum)
    setview <- data.frame(lng=-51.9113,lat = -23.15)

    output$map <- renderLeaflet({

      leaflet(
              options = list(zoomControl = FALSE,
                             #center = c(-23.2,-53.06396),
                             zoom = 9,minZoom = 9, maxZoom = 9,
                             maxBounds = list(setview+c(1,-1), setview+c(-1,+1))
              )) %>%
        addTiles() %>%
        setView(lng = setview[[1]], lat = setview[[2]], zoom=9) %>%
        addMarkers(data = objeto_sf,
                   popup = labels_map,
                   layerId = ~uid)   %>%
        addPolygons(
          data = regional_maps,
          fillColor = ~pal(incidencia),
          weight = 2,
          opacity = 1,
          color = "white",
          dashArray = "3",
          fillOpacity = 0.7,
          highlight = highlightOptions(
            weight = 5,
            color = "#666",
            dashArray = "",
            fillOpacity = 0.7,
            bringToFront = TRUE),
          label = labels_map[seq_len(nrow(regional_maps))],
          labelOptions = labelOptions(
            style = list("font-weight" = "normal", padding = "3px 8px"),
            textsize = "15px",
            direction = "auto")) %>%
        addLegend(pal = pal, values = as.numeric(regional_maps$incidencia),
              opacity = 0.7, title = NULL,
                  position = "topleft")


    })



    observeEvent(input$map_marker_click,{
      event          <- input$map_marker_click
      message        <- event$id

      if (is.null(event)){

        show_alert(title ="Esta cidade não possui casos confirmados." )

      }else if(n_casos[which(names(n_casos) == message)] == 0){

        show_alert(title ="Esta cidade não possui casos confirmados." )

      }else{

        show_alert(

          title = NULL,
          btn_labels = NA,
          showCloseButton = TRUE,
          text = fluidRow(column(width=12, mapa_cidades_panelUI(id))),
          html = TRUE,
          width = "80%")
      }

    })




    # #RENDER GRAFICOS ----

    observe({

      event          <- input$map_marker_click
      message        <- event$id

      output$painel_text <- renderText({
        event          <- input$map_marker_click
        if(is.null(event)){
          texto <- "   PAINEL DE VISUALIZAÇÃO    "
        }else if(n_casos[which(names(n_casos) == message)] == 0){
          texto <- paste0(message," - ", "NÃO POSSUI CASOS CONFIRMADOS")
        }else{
          texto <- paste0(message," - ",n_casos[which(names(n_casos) == message)]," CASOS CONFIRMADOS - ",obitos_mun[,message]," ÓBITOS")
        }
        texto
      })


      if(is.null(event)){return()}

      i=as.numeric(which(lista_cidade_upper %in% event$id))

      ## RENDER INFORMAÇÃO/GRAFICOS DOS CASOS ACUMULADOS POR MUNICIPIO-------

      output$plot_gcidades <- renderPlotly({

        if(n_casos[which(names(n_casos) == message)] == 0){
          return()
        }else{
          stack_casos <- stack(data_casos)
          label <- rep(datas,length(colnames(data_casos[2:32])))

          stack_casos[,"label"] <- label
          stack_casos <- stack_casos[stack_casos$values>0,]
          pos_reg <- which(stack_casos$ind == "REGIONAL")
          stack_casos <- stack_casos[c(which(stack_casos$ind == message)),]

          fig<-plot_ly(x = ~ stack_casos$label, y = ~ cumsum(stack_casos$values),height=460, mode = 'lines+markers',
                       type="scatter",
                       text = "", marker=list(color = mla_palette[1], size=9, opacity=0.75),
                       line = list(color = mla_palette[1], width = 4,opacity= 0.75))
          fig <- fig %>% layout(hovermode = TRUE, spikedistance =  -1,
                                xaxis = list(title = "<b>DATAS</b>", showspikes = TRUE, titlefont = list(size = 24),
                                             spikemode  = 'across', #toaxis, across, marker
                                             spikesnap = 'cursor',  ticks = "outside",tickangle = -45,
                                             showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                                             showgrid=TRUE),
                                yaxis = list (title = "<b>NÚMERO DE CASOS</b>",
                                              spikemode  = 'across', #toaxis, across, marker
                                              spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),
                                              showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                                              showgrid=TRUE),

                                plot_bgcolor  = "rgba(0, 0, 0, 0)",
                                paper_bgcolor = "rgba(0, 0, 0, 0)") %>%
            dark_plotly() %>%
            config(displayModeBar = FALSE)
          fig
        }
      })



      ## RENDER INFORMAÇÃO/GRAFICOS DOS CASOS POR DI DOS MUNICIPIO-------
      output$plot_por_dia_municipio <- renderPlotly({
        if(n_casos[which(names(n_casos) == message)] == 0){
          return()
        }else{
          stack_casos <- stack(data_casos)
          label <- rep(datas,length(colnames(data_casos[2:32])))
          stack_casos[,"label"] <- label
          stack_casos <- stack_casos[stack_casos$values>0,]
          pos_reg <- which(stack_casos$ind == "REGIONAL")
          stack_casos <- stack_casos[c(which(stack_casos$ind == message)),]

          media_movel_7d <- as.numeric(stats::filter(data_casos[[message]], filter = rep(1 / 7, 7), sides = 1))

          fig<-plot_ly(x = ~ stack_casos$label, y = ~ stack_casos$values, type="bar",height= 460,
                       text = "", marker=list(color = mla_palette[2], size=10, opacity=0.75),
                       name = "Casos confirmados")
          fig <- fig %>% add_trace(x = ~ data_casos$label_datas, y = ~ media_movel_7d, type = "scatter",
                                   mode = "lines", line = list(color = mla_palette[5], width = 3),
                                   marker = NULL, name = "Média móvel (7 dias)")
          fig <- fig %>% layout(hovermode = TRUE, spikedistance =  -1,
                                xaxis = list(title = "<b>DATAS</b>", showspikes = TRUE, titlefont = list(size = 24),
                                             spikemode  = 'across', #toaxis, across, marker
                                             spikesnap = 'cursor',  ticks = "outside",tickangle = -45,
                                             showline=TRUE,tickfont = list(size = 24),type = 'date',fixedrange=TRUE,
                                             tickformat = "%d/%m",


                                             showgrid=TRUE),
                                yaxis = list (title = "<b>NÚMERO DE CASOS</b>",
                                              spikemode  = 'across', #toaxis, across, marker
                                              spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),
                                              showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                                              showgrid=TRUE),
                                autosize = T,
                                plot_bgcolor  = "rgba(0, 0, 0, 0)",
                                paper_bgcolor = "rgba(0, 0, 0, 0)") %>%
            dark_plotly() %>%
            config(displayModeBar = FALSE)
          fig



        }
      })
      #
      #           ## RENDER INFORMAÇÃO/GRAFICOS DAS INCIDENCIAS POR MUNICIPIO-------
      output$plot_incidencia_municipios <- renderPlotly({
        if(n_casos[which(names(n_casos) == message)] == 0){
          return()
        }else{


          stack_incidencias <- incidencias
          stack_incidencias <- stack_incidencias[,c("label_datas","REGIONAL", message)]



          fig<-plot_ly(x = ~ stack_incidencias[,1], y = ~ stack_incidencias[,2], mode = 'lines+markers', type="scatter",height= 460,
                       text = "", marker=list(color = mla_palette[1], size=9, opacity=0.75),
                       line = list(color = mla_palette[1], width = 4,opacity= 0.75), name = colnames(stack_incidencias)[2]) %>%
            add_trace(y = ~stack_incidencias[,3], name = colnames(stack_incidencias)[3], line = list(color = mla_palette[5], width = 4),
                      marker=list(color = mla_palette[5], size=9, opacity=0.75) )
          fig <- fig %>% layout(hovermode = TRUE, spikedistance =  -1,
                                xaxis = list(title = "<b>DATAS</b>", showspikes = TRUE, titlefont = list(size = 24),
                                             spikemode  = 'across', #toaxis, across, marker
                                             spikesnap = 'cursor',  ticks = "outside",tickangle = -45,
                                             showline=TRUE,tickfont = list(size = 24),type = 'date',
                                             tickformat = "%d/%m",   fixedrange=TRUE,
                                             showgrid=TRUE),
                                yaxis = list (title = "<b>INCIDÊNCIA</b>",
                                              spikemode  = 'across', #toaxis, across, marker
                                              spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),
                                              showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                                              showgrid=TRUE),

                                plot_bgcolor  = "rgba(0, 0, 0, 0)",
                                paper_bgcolor = "rgba(0, 0, 0, 0)") %>%
            dark_plotly() %>%
            config(displayModeBar = FALSE)
          fig



        }
      })
      #           ## RENDER INFORMAÇÃO/GRAFICOS DOS CASOS POR FAIXA ETARIA DOS MUNICIPIO-------
      output$plot_por_faixaetaria_municipio <- renderPlotly({
        if(n_casos[which(names(n_casos) == message)] == 0){
          return()
        }else{


          x          <- faixa_etaria[,1];x
          y          <- faixa_etaria[,message];y


          fig<-plot_ly( y = ~ x, x = ~ y, type="bar",orientation = 'h',height= 460,
                        text = "", marker=list(color = mla_palette[2], size=10, opacity=0.75),
                        name = 'Suscetíveis')
          fig <- fig %>% layout(hovermode = TRUE, spikedistance =  -1,
                                xaxis = list(title = "<b>NÚMERODE CASOS</b>", showspikes = TRUE, titlefont = list(size = 24),
                                             spikemode  = 'across', #toaxis, across, marker
                                             spikesnap = 'cursor',  ticks = "outside",tickangle = 0,
                                             showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                                             showgrid=TRUE),
                                yaxis = list (title = "<b>FAIXA ETÁRIA</b>",
                                              spikemode  = 'across', #toaxis, across, marker
                                              spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),
                                              showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                                              showgrid=TRUE),
                                plot_bgcolor  = "rgba(0, 0, 0, 0)",
                                paper_bgcolor = "rgba(0, 0, 0, 0)") %>%
            dark_plotly() %>%
            config(displayModeBar = FALSE)
          fig

        }
      })




      output$plot_sexo_municipio <- renderUI({

        if(n_casos[which(names(n_casos) == message)] == 0){
          return()
        }else if(n_casos[which(names(n_casos) == message)] != 0){

          casos_sexo_municipio <- casos_sexo[,message]
          total_sexo <- sum(casos_sexo_municipio)
          panel <- fluidRow(column(width=12,align="left",tags$div(class = "section-subtitle", "Sexo")),

                            fluidRow(

                              fluidRow(
                                column(width=6,align="left",
                                       valueBox(

                                         value=paste0(casos_sexo_municipio[2]," (",round(((casos_sexo_municipio[2]/total_sexo)*100),2),"%)"),
                                         subtitle = tags$div(HTML('<b style = "padding-left:10px;font-size:16px">MASCULINO</b>')),
                                         width=8,
                                         icon = icon("male", lib = "font-awesome"),
                                         color = "blue")
                                ),
                                column(width=6,align="left",
                                       valueBox(

                                         value=paste0(casos_sexo_municipio[1]," (",round(((casos_sexo_municipio[1]/total_sexo)*100),2),"%)"),
                                         subtitle = tags$div(HTML('<b style = "padding-left:10px;font-size:16px">FEMININO</b>')),
                                         width=8,
                                         icon = icon("female", lib = "font-awesome"),
                                         color = "red")))))

          return(panel)


        }else{

          panel <-  fluidRow(fluidRow(tags$div(class = "section-subtitle", "Sexo")))
          return(panel)
        }
      })


      ###########################################################################
      ########################### SERVER MARCELo ################################
      ###########################################################################

      if(n_casos[which(names(n_casos) == message)] == 0){
        return()
      }else{
        source(file.path(getwd(), "R_code/legacy/source.R"), local=TRUE, encoding="UTF-8")
      }



      ####################################################################################################################
      #############################          NOVOS CASOS POR DIA           ###############################################
      ####################################################################################################################

      output$u1 <- renderUI({


        if (rm_accent( message) == "MARINGA"){

          div(plotlyOutput(ns("regionalNC")),style="padding-left:20px;")

        }else{

          div(strong("INDISPONÍVEL PARA ESTA CIDADE"))
          # div(plotlyOutput(ns("regionalNC")),style="padding-left:20px;")
        }


      })


      output$regionalNC <- renderPlotly({

        if(n_casos[which(names(n_casos) == message)] == 0){
          return()
        }else{


          if (rm_accent( message) == "MARINGA") {
            viajem15(rm_accent( message)) %>% dark_plotly()
          }


        }


      })


      ####################################################################################################################
      #############################          Total de CASOS            ###############################################
      ####################################################################################################################




      output$regionalTC <- renderPlotly({

        #source('source.R', local=TRUE, encoding="UTF-8")
        if(n_casos[which(names(n_casos) == message)] == 0){
          return()
        }else{
          if (numberofrow < 1) {} else {



            fig<-plot_ly(x = ~ dadosfinal$time, y = ~ dadosfinal$acumulado, mode = 'lines+markers', type="scatter",
                         text = "", marker=list(color = mla_palette[5], size=10),
                         line = list(color = mla_palette[5], width = 4), name = 'Suscetíveis')
            fig <- fig %>% layout(title = "Total de casos confirmados", hovermode = TRUE, spikedistance =  -1,
                                  xaxis = list(title = "Dia da coleta do exame", showspikes = TRUE,
                                               spikemode  = 'across', #toaxis, across, marker
                                               spikesnap = 'cursor',  ticks = "outside",
                                               showline=TRUE,
                                               showgrid=TRUE),
                                  yaxis = list (title = "Número de casos",
                                                spikemode  = 'across', #toaxis, across, marker
                                                spikesnap = 'cursor', zeroline=FALSE,
                                                showline=TRUE,
                                                showgrid=TRUE)) %>%
              dark_plotly()
            fig
          }
        }





      })




      ####################################################################################################################
      #############################          TAXA DE PROPAGAÇÂO            ###############################################
      ####################################################################################################################




      output$beta <- renderValueBox({
        if(n_casos[which(names(n_casos) == message)] == 0){
          return()
        }else{
          #source('source.R', local=TRUE, encoding="UTF-8")

          if (numberofrow < 10) {
            valueBox(
              paste0(),"Não é possível obter uma estimativa", icon = icon("list"),
              color = "light-blue"
            )
          } else {



            fim<-numberofrow

            init<-ifelse(fim < 11, 1, fim - 9)

            tempo<-seq(1,fim-init+1,1)

            exponential.model <- lm(log(as.numeric(dadosfinal$acumulado[init:fim]))~ tempo)
            summary(exponential.model)
            beta <- coef(exponential.model)[2]+0.1 #ae^{beta t}
            acq<-alpha.0 <- exp(coef(exponential.model)[1])


            valueBox(
              paste0(round(beta,10)), "Taxa de propagação", icon = icon("list"),
              color = "light-blue"
            )

          }
        }
      })





      ####################################################################################################################
      #############################          AJUSTE TAXA DE PROPAGAÇÂO            ###############################################
      ####################################################################################################################




      output$ajuste <- renderPlotly({

        # source('source.R', local=TRUE, encoding="UTF-8")
        if(n_casos[which(names(n_casos) == message)] == 0){
          return()
        }else{
          if (numberofrow < 10) {

          } else {



            fim<-numberofrow

            init<-ifelse(fim < 11, 1, fim - 9)

            tempo<-seq(1,fim-init+1,1)



            exponential.model <- lm(log(as.numeric(dadosfinal$acumulado[init:fim]))~ tempo)
            summary(exponential.model)
            beta <- coef(exponential.model)[2]+0.1 #ae^{beta t}
            a<- exp(coef(exponential.model)[1])
            beta2<-beta-0.1



            funcao<- function(x){
              #aux<- 0.002921+0.095526*exp(-0.095526*x)
              aux<-  a*exp(beta2*x)
              return(aux)
            }


            y<-funcao(tempo)

            fig<-plot_ly(x = ~ tempo, y = ~ y, mode = 'lines', type="scatter",
                         text = "", color = mla_palette[1], size=10,
                         line = list(color = mla_palette[1], width = 6), name = 'ajuste')
            fig<-fig %>% add_trace(y = ~ dadosfinal$acumulado[init:fim], mode = 'markers',
                                   line = list(width = 0), marker=list(color = mla_palette[5], size=10), name = 'dados observados')


            fig <- fig %>% layout(hovermode = TRUE, spikedistance =  -1,
                                  xaxis = list(showspikes = TRUE, titlefont = list(size = 24),
                                               spikemode  = 'across', #toaxis, across, marker
                                               spikesnap = 'cursor',  ticks = "outside",tickangle = 0,
                                               showline=TRUE,tickfont = list(size = 24),
                                               fixedrange=TRUE,
                                               showgrid=TRUE),
                                  yaxis = list (title = "<b>NÚMERO DE CASOS</b>",
                                                spikemode  = 'across', #toaxis, across, marker
                                                spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),
                                                showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                                                showgrid=TRUE),
                                  height= 460,
                                  plot_bgcolor  = "rgba(0, 0, 0, 0)",
                                  paper_bgcolor = "rgba(0, 0, 0, 0)",
                                  fig_bgcolor   = "rgba(0, 0, 0, 0)") %>%
              dark_plotly() %>%
              config(displayModeBar = FALSE)




            fig


          }

        }

      })



      ####################################################################################################################
      #############################          NUMERO DE REPRODUCAO ATUAL            ###############################################
      ####################################################################################################################




      output$rzero <- renderValueBox({

        #source('source.R', local=TRUE, encoding="UTF-8")

        if (numberofrow < 10) {
          valueBox(
            paste0(),"Não é possível obter uma estimativa", icon = icon("list"),
            color = "light-blue"
          )
        } else {



          fim<-numberofrow

          init<-ifelse(fim < 11, 1, fim - 9)

          tempo<-seq(1,fim-init+1,1)

          exponential.model <- lm(log(as.numeric(dadosfinal$acumulado[init:fim]))~ tempo)
          summary(exponential.model)
          beta <- coef(exponential.model)[2]+0.1 #ae^{beta t}
          acq<-alpha.0 <- exp(coef(exponential.model)[1])

          rzero<-beta / 0.1
          valueBox(
            paste0(round(rzero,10)), "Número de reprodução", icon = icon("list"),
            color = "light-blue"
          )

        }

      })




      output$rsquared <- renderValueBox({


        #source('source.R', local=TRUE, encoding="UTF-8")

        if (numberofrow < 10) {
          valueBox(
            paste0(), "Não é possível obter R²", icon = icon("list"),
            color = "light-blue"
          )
        } else {



          fim<-numberofrow

          init<-ifelse(fim < 11, 1, fim - 9)

          tempo<-seq(1,fim-init+1,1)


          exponential.model <- lm(log(as.numeric(dadosfinal$acumulado[init:fim]))~ tempo)
          rsquared<- summary(exponential.model)$adj.r.squared

          valueBox(
            paste0(round(rsquared,10)), "Este é o valor de R²", icon = icon("list"),
            color = "light-blue"
          )


        }


      })



      output$pvalue <- renderValueBox({


        #source('source.R', local=TRUE, encoding="UTF-8")

        if (numberofrow < 10) {
          valueBox(
            "Não é possível obter p-value", icon = icon("list"),
            color = "light-blue"
          )
        } else {



          fim<-numberofrow

          init<-ifelse(fim < 11, 1, fim - 9)

          tempo<-seq(1,fim-init+1,1)

          exponential.model <- lm(log(as.numeric(dadosfinal$acumulado[init:fim]))~ tempo)
          pvalue<- anova(exponential.model)$'Pr(>F)'[1]

          valueBox(
            format(pvalue,scientific = F), "Este é o valor de p-value", icon = icon("list"),
            color = "light-blue"
          )



        }

      })



      ####################################################################################################################
      #############################          Estimativa do número de infectados            ###############################################
      ####################################################################################################################





      output$infectados <- renderPlotly({

        # source('source.R', local=TRUE, encoding="UTF-8")

        if(n_casos[which(names(n_casos) == message)] == 0){
          return()
        }else{

          if (numberofrow < 1 ) {} else {



            fig<-plot_ly(x = ~ dadosfinal$time, y = ~ dadosfinal$infectados, mode = 'lines+markers', type="scatter",
                         text = "", marker=list(color = mla_palette[5], size=10),
                         line = list(color = mla_palette[5], width = 4), name = 'Suscetíveis')


            fig <- fig %>% layout(hovermode = TRUE, spikedistance =  -1,
                                  xaxis = list(title = "<b>DIA DA COLETA DO EXAME</b>",
                                               showspikes = TRUE, titlefont = list(size = 24),
                                               spikemode  = 'across', #toaxis, across, marker
                                               spikesnap = 'cursor',  ticks = "outside",tickangle = -45,
                                               showline=TRUE,tickfont = list(size = 24),type = 'date',fixedrange=TRUE,
                                               tickformat = "%d/%m",showgrid=TRUE),
                                  yaxis = list (title = "<b>NÚMERO DE CASOS</b>",
                                                spikemode  = 'across', #toaxis, across, marker
                                                spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),
                                                showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                                                showgrid=TRUE),
                                  height= 460,
                                  plot_bgcolor  = "rgba(0, 0, 0, 0)",
                                  paper_bgcolor = "rgba(0, 0, 0, 0)",
                                  fig_bgcolor   = "rgba(0, 0, 0, 0)") %>%
              dark_plotly()

            fig

          }
        }

      })
      ####################################################################################################################
      #############################       EVOLUÇÂO DA TAXA DE PROPAGAÇÂO            ###############################################
      ####################################################################################################################




      output$betav <- renderPlotly({

        #source('source.R', local=TRUE, encoding="UTF-8")

        fig <- taxaevol(1)
        if (is.null(fig)) return(fig)
        fig %>% dark_plotly()

      })

      ####################################################################################################################
      #############################       EVOLUÇÂO DO R0            ###############################################
      ####################################################################################################################




      output$rzerov <- renderPlotly({

        # source('source.R', local=TRUE, encoding="UTF-8")
        fig <- taxaevol(10)
        if (is.null(fig)) return(fig)
        fig %>% dark_plotly()

      })
    })

  })
}
