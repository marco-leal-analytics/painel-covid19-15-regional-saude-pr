

withMathJax()

comportamento_inicial <<- tabPanel( title = tags$div(HTML('<i class="fa fa-chart-line"style = "color:#0072B2;font-size:30px"></i>')),
fluidRow(box( title= tags$div(HTML('<i class="fas fa-chart-line" style = "color:#0072B2;font-size:50px"></i>
<b style = "padding-left:25px;color:#000000;font-size:30px">
                                   ESTIMATIVAS DO COMPORTAMENTO INICIAL DA EPIDEMIA</b>')),
              tags$head(tags$style(HTML("hr {border-top: 5px solid;}"))), width = 12)),
                                   
                                      sidebarLayout(
                                        sidebarPanel(
                                          box(width="200px", background = "light-blue",titlePanel("Escolha uma cidade"),
                                              selectInput("cidade2", "",
                                                          list(`15ª REGIONAL` = list("ANGULO","ASTORGA","ATALAIA",
                                                                                  "COLORADO","DOUTOR CAMARGO", "FLORAI",
                                                                                  "FLORESTA","FLORIDA","IGUARACU",
                                                                                  "ITAGUAJE","ITAMBE","IVATUBA",
                                                                                  "LOBATO","MANDAGUACU","MANDAGUARI",
                                                                                  "MARIALVA","MARINGA","MUNHOZ DE MELO",
                                                                                  "NOSSA SENHORA DAS GRACAS","NOVA ESPERANCA","OURIZONA",
                                                                                  "PAICANDU","PARANACITY","PRESIDENTE CASTELO BRANCO",
                                                                                  "SANTA FE","SANTA INES","SANTO INACIO",
                                                                                  "SAO JORGE DO IVAI","SARANDI","UNIFLOR")))),
                                          withMathJax(),
                                          div(
                                          "Não temos como prever se a chegada de poucas pessoas infectadas (ou expostas) será suficiente
                                          para dar início a um surto ou epidemia na cidade. Muitos fatores podem influenciar nisto e destacamos
                                          aqui que medidas de prevenção (tomadas pela população) e de acompanhamento de pessoas infectadas
                                          ou que possam ter sido expostas (por parte do poder público) desempenham um papel decisivo.",br(),br(),
                                          "Nas projeções apresentadas ao lado estamos considerando que inicialmente a falta de medidas de mitigação
                                          fazem com que haja a propagação da infecção.",br(),br(),
                                          "O principal objetivo da aba 'Atraso nas medidas de mitigação' é mostrar a importância de que medidas de mitigação sejam 
                                          tomadas o mais rápido possível a fim de evitar que o aumento do número de casos saia do controle.",br(),br(),
                                          "A aba 'Chegada de pessoas expostas' ilustra o risco do fluxo de pessoas infectadas chegando em uma cidade e/ou pessoas suscetíveis
                                          indo para outras cidades com maior disseminação do vírus e se tornarem expostas.",style="text-align:justify")),
                                        mainPanel(
                                          tabsetPanel(
                                          tabPanel(title = tags$div(HTML('<i class="fa fa-chart-line"style = "color:#0072B2;font-size:30px"></i>')),
                                                   fluidRow(box( title= tags$div(HTML('<i class="fas fa-chart-line" style = "color:#0072B2;font-size:50px"></i>
                                                                                      <b style = "padding-left:25px;color:#0072B2;font-size:30px">ESTIMATIVAS</b>')),
                                                                 tags$head(tags$style(HTML("hr {border-top: 5px solid;}"))), width = 12)),
                                                   id = "tabset1", height = "500px", width = "700px",
                                                 h3("Quanto tempo você quer ficar sem tomar medidas após os primeiros casos?"), br(),
                                                 "Consideramos que nos primeiros dias (sendo 15, 30, 45 ou 60 de acordo com as abas abaixo) 
                                                 o número de reprodução é", "\\(R_0=3\\)", "e após este período serão tomadas medidas de mitigação
                                                 suficientes para reduzir o número de reprodução", "\\(R_0\\)", "de", "\\(3\\)", "para", "\\(1.2\\)", ". Para se ter uma redução
                                                 tão grande de", "\\(R_0\\)", "é necessário um conjunto amplo de medidas de mitigação.", br(),br(),
                                          tabBox( title = "São considerados 2 infectados e 3 expostos no início",
                                                  id = "tabset1", height = "500px", width="700px",
                                                  tabPanel("15 dias", plotlyOutput("atraso15")),
                                                  tabPanel("30 dias", plotlyOutput("atraso30")),
                                                  tabPanel("45 dias", plotlyOutput("atraso45")),
                                                  tabPanel("60 dias", plotlyOutput("atraso60")))),
                                          tabPanel(tags$div(HTML('<i class="fa fa-chart-line"style = "color:#000000;font-size:30px"></i>')),
                                                   fluidRow(box( title= tags$div(HTML('<i class="fas fa-chart-line" style = "color:#000000;font-size:50px"></i>
                                                                                      <b style = "padding-left:25px;color:#000000;font-size:30px">CHEGADA DE PESSOAS EXPOSTAS</b>')),
                                                                 tags$head(tags$style(HTML("hr {border-top: 5px solid;}"))), width = 12)), 
                                                   h3("Qual o risco do fluxo de pessoas entre as cidades?"),br(),withMathJax(),
                 "Nestas simulações estamos considerados que uma (ou três ou cinco ou 10) pessoa se tornará
                                                 exposta, isto é, uma pessoa infectada, mas ainda no período de incubação, após viajar para outra 
                                                 cidade ou por ter contato com uma pessoa infectada que passou um curto perído de tempo na cidade
                                                 (por exemplo pessoas que vão fazer compras em shoppings de outras cidades).", br(),br(),
                 "Supomos que nos 30 primeiros dias o número de reprodução é", "\\(R_0=3\\)", "e um número fixo de pessoas (a ser selecionado nas abas abaixo)
                                                 se tornará exposta ao ter contato com pessoas de outras cidades. Após este período supomos que não 
                                                 haverá mais esta influência de pessoas de outras cidades e, além disso, serão tomadas medidas de mitigação
                                                 suficientes para reduzir o número de reprodução", "\\(R_0\\)", "de", "\\(3\\)", "para", "\\(1.2\\)", ". Para se ter uma redução
                                                 tão grande de", "\\(R_0\\)", "é necessário um conjunto amplo de medidas de mitigação.", br(),br(),
                 tabBox(title = "São considerados 0 infectados e 0 expostos no início",
                        id = "tabset1", height = "500px", width="700px",
                        tabPanel("1 exposto por dia", plotlyOutput("espostos1")),
                        tabPanel("3 expostos por dia", plotlyOutput("espostos3")),
                        tabPanel("5 expostos por dia", plotlyOutput("espostos5")),
                        tabPanel("10 expostos por dia", plotlyOutput("espostos10"))))
                 
                                        ))))