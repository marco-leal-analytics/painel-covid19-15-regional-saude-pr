################################################################################################################
######################################## MODULO: COMPORTAMENTO INICIAL (UI) ##################################
################################################################################################################

comportamento_inicialUI <- function(id) {
  ns <- NS(id)

  withMathJax()

  tagList(
    mla_hero(
      eyebrow = "15ª REGIONAL DE SAÚDE · COVID-19",
      title   = "Comportamento inicial da epidemia",
      summary = "Simule como o atraso na adoção de medidas de mitigação ou a chegada de pessoas expostas afeta o crescimento inicial da epidemia em uma cidade escolhida da 15ª Regional de Saúde."
    ),

    div(class = "two-col-row",
      div(class = "two-col-item", style = "flex: 1",
        ui_card(title = "Escolha uma cidade",
          selectInput(ns("cidade2"), "",
                      list(`15ª REGIONAL` = list("ANGULO","ASTORGA","ATALAIA",
                                              "COLORADO","DOUTOR CAMARGO", "FLORAI",
                                              "FLORESTA","FLORIDA","IGUARACU",
                                              "ITAGUAJE","ITAMBE","IVATUBA",
                                              "LOBATO","MANDAGUACU","MANDAGUARI",
                                              "MARIALVA","MARINGA","MUNHOZ DE MELO",
                                              "NOSSA SENHORA DAS GRACAS","NOVA ESPERANCA","OURIZONA",
                                              "PAICANDU","PARANACITY","PRESIDENTE CASTELO BRANCO",
                                              "SANTA FE","SANTA INES","SANTO INACIO",
                                              "SAO JORGE DO IVAI","SARANDI","UNIFLOR")))
        ),
        br(),
        callout("Como interpretar as simulações",
          tags$p(
            "Não temos como prever se a chegada de poucas pessoas infectadas (ou expostas) será suficiente ",
            "para dar início a um surto ou epidemia na cidade. Muitos fatores podem influenciar nisto e destacamos ",
            "aqui que medidas de prevenção (tomadas pela população) e de acompanhamento de pessoas infectadas ",
            "ou que possam ter sido expostas (por parte do poder público) desempenham um papel decisivo."
          ),
          tags$p(
            "Nas projeções apresentadas ao lado estamos considerando que inicialmente a falta de medidas de mitigação ",
            "fazem com que haja a propagação da infecção."
          )
        ),
        br(),
        callout("Atraso nas medidas de mitigação",
          tags$p(
            "O principal objetivo da aba 'Atraso nas medidas de mitigação' é mostrar a importância de que medidas de mitigação sejam ",
            "tomadas o mais rápido possível a fim de evitar que o aumento do número de casos saia do controle."
          )
        ),
        br(),
        callout("Chegada de pessoas expostas",
          tags$p(
            "A aba 'Chegada de pessoas expostas' ilustra o risco do fluxo de pessoas infectadas chegando em uma cidade e/ou pessoas suscetíveis ",
            "indo para outras cidades com maior disseminação do vírus e se tornarem expostas."
          )
        )
      ),

      div(class = "two-col-item", style = "flex: 2",
        navset_card_tab(
          nav_panel("Estimativas",
            tags$h3("Quanto tempo você quer ficar sem tomar medidas após os primeiros casos?"),
            tags$p(
              "Consideramos que nos primeiros dias (sendo 15, 30, 45 ou 60 de acordo com as abas abaixo) ",
              "o número de reprodução é", "\\(R_0=3\\)", "e após este período serão tomadas medidas de mitigação ",
              "suficientes para reduzir o número de reprodução", "\\(R_0\\)", "de", "\\(3\\)", "para", "\\(1.2\\)",
              ". Para se ter uma redução tão grande de", "\\(R_0\\)", "é necessário um conjunto amplo de medidas de mitigação."
            ),
            tags$p(class = "section-small", tags$em("São considerados 2 infectados e 3 expostos no início.")),
            navset_card_tab(
              nav_panel("15 dias", plotlyOutput(ns("atraso15"))),
              nav_panel("30 dias", plotlyOutput(ns("atraso30"))),
              nav_panel("45 dias", plotlyOutput(ns("atraso45"))),
              nav_panel("60 dias", plotlyOutput(ns("atraso60")))
            )
          ),
          nav_panel("Chegada de pessoas expostas",
            tags$h3("Qual o risco do fluxo de pessoas entre as cidades?"),
            tags$p(
              "Nestas simulações estamos considerados que uma (ou três ou cinco ou 10) pessoa se tornará ",
              "exposta, isto é, uma pessoa infectada, mas ainda no período de incubação, após viajar para outra ",
              "cidade ou por ter contato com uma pessoa infectada que passou um curto perído de tempo na cidade ",
              "(por exemplo pessoas que vão fazer compras em shoppings de outras cidades)."
            ),
            tags$p(
              "Supomos que nos 30 primeiros dias o número de reprodução é", "\\(R_0=3\\)", "e um número fixo de pessoas (a ser selecionado nas abas abaixo) ",
              "se tornará exposta ao ter contato com pessoas de outras cidades. Após este período supomos que não ",
              "haverá mais esta influência de pessoas de outras cidades e, além disso, serão tomadas medidas de mitigação ",
              "suficientes para reduzir o número de reprodução", "\\(R_0\\)", "de", "\\(3\\)", "para", "\\(1.2\\)",
              ". Para se ter uma redução tão grande de", "\\(R_0\\)", "é necessário um conjunto amplo de medidas de mitigação."
            ),
            tags$p(class = "section-small", tags$em("São considerados 0 infectados e 0 expostos no início.")),
            navset_card_tab(
              nav_panel("1 exposto por dia", plotlyOutput(ns("espostos1"))),
              nav_panel("3 expostos por dia", plotlyOutput(ns("espostos3"))),
              nav_panel("5 expostos por dia", plotlyOutput(ns("espostos5"))),
              nav_panel("10 expostos por dia", plotlyOutput(ns("espostos10")))
            )
          )
        )
      )
    )
  )
}
