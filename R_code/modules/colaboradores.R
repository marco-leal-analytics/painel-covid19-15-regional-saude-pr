
withMathJax()

colaboradores <<- tabPanel(value = 'col',title = tags$div(HTML('<i class="fa fa-users"style = "color:#0072B2;font-size:30px"></i>')),
                           fluidRow(
                             box(title= tags$div(HTML('<i class="fa fa-users"style = "color:#0072B2;font-size:50px"></i>
                                         <b style = "padding-left:25px;color:#000000;font-size:30px"> COLABORADORES </b>')),
                                 tags$head(tags$style(HTML("hr {border-top: 5px solid;}"))),width = 12),
                             column(4, 
                                    box(title= tags$div(HTML('<i class="fa fa-id-card"style = "color:#0072B2;font-size:50px"></i>
                                         <b style = "padding-left:25px;color:#000000;font-size:30px">15ª  REGIONAL DE SAÚDE </b>')),
                                        tags$head(tags$style(HTML("hr {border-top: 5px solid;}"))),width = 12),
                                    tags$li(" Ederlei Ribeiro Alkamim - Diretor"),
                                    tags$li(" Sandra Ap. Barboza da Silva - Epidemiologia"),
                                    tags$li(" Rosana Baldasso - Epidemiologia"),
                                    tags$li(" Valentim Sala Junior - Epidemiologia"),
                                    tags$li(" Greicy Cezar do Amaral - Educação Permanente"),
                                    tags$li(" Fabiano Batista - DVVGS"),
                                    box(title= tags$div(HTML('<i class="fa fa-id-card"style = "color:#0072B2;font-size:50px"></i>
                                                             <b style = "padding-left:25px;color:#000000;font-size:30px">CRESEMS</b>')),
                                        tags$head(tags$style(HTML("hr {border-top: 5px solid;}"))), width = 12) ),
                             column(4,
                                    box(title= tags$div(HTML('<i class="fa fa-id-card"style = "color:#0072B2;font-size:50px"></i>
                                         <b style = "padding-left:25px;color:#000000;font-size:30px"> 
                                                             DEPARTAMENTO DE ESTATÍSTICA (DES-UEM) </b>')),
                                        tags$head(tags$style(HTML("hr {border-top: 5px solid;}"))),width = 12),
                                    tags$li("Daniele Cristina Tita Granzotto - Coordenadora"),
                                    tags$li("Marco Aurelio Valles Leal")),
                             column(4,
                                    box(title= tags$div(HTML('<i class="fa fa-id-card"style = "color:#0072B2;font-size:50px"></i>
                                         <b style = "padding-left:25px;color:#000000;font-size:30px">
                                                             DEPARTAMENTO DE MATEMÁTICA (DMA-UEM) </b>')),
                                        tags$head(tags$style(HTML("hr {border-top: 5px solid;}"))),width =12),
                                    tags$li("Ednei Aparecido Santulo Júnior"),
                                    tags$li(" Eduardo de Amorim Neves"),
                                    tags$li(" Francisco Nogueira Calmon Sobral"),
                                    tags$li(" Gilberto Aparecido Tenani (IFMS)"),
                                    tags$li(" Marcelo Osnar Rodrigues de Abreu - Coordenador"),
                                    tags$li(" Marcos Vinicius Fagundes Padilha"),
                                    tags$li(" Thiago Fanelli Ferraiol"))),
                                    # HTML('<div style="text-align:center;">Virus Icon made by <a href="https://www.flaticon.com/authors/freepik"
                                    #      title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">
                                    #      www.flaticon.com</a></div>')
                           )
