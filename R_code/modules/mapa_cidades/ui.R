################################################################################################################
######################################## MODULO: MAPA DE CIDADES (UI) ########################################
################################################################################################################

# Painel exibido no modal (show_alert) quando o usuário clica numa cidade no
# mapa. Fica separado de mapa_cidadesUI() porque é construído a partir do
# server (dentro do observeEvent de clique), mas precisa do mesmo `ns()` do
# módulo para os outputs baterem certo.
mapa_cidades_panelUI <- function(id) {
  ns <- NS(id)

  sobre1 <- tags$details(
    tags$summary("Sobre o número de reprodução"),
    withMathJax(),
    div("Da biologia temos a definição de um número usualmente denotado por",
        withMathJax(),"\\(R_0\\)",". De forma simples," ,withMathJax(),"\\(R_0\\)",
        "é o número aproximado de pessoas que uma pessoa infectada pode contaminar ao longo do período infeccioso.",br(),br(),
    "Na modelagem matemática, trabalhamos com o modelo SEIR (Suscetíveis-Expostos-Infectados-Recuperados):",br(),br(),
    "Suscetíveis: São todas as pessoas que podem, em algum momento, ser infectadas",br(),br(),
    "Expostos: São todas as pessoas que já se contaminaram, mas a doença está no período de incubação.",br(),br(),
    "Infectados: Este grupo é formado pelas pessoas infectadas que estão no período infeccioso, ou seja, são capazes de transmitir a doença.",br(),br(),
    "Recuperados: Aqui temos que tomar um cuidado com a nomenclatura. Ao se usar a palavra recuperados dá-se a entender que as pessoas
    deste grupo se recuperaram da infecção. No entanto, o modelo
    visa estudar o comportamento da infecção e neste sentido toda pessoa que foi infectada e não é mais capaz de transmitir a
    infecção entra neste grupo, ou seja, o grupo dos recuperados é formado pelas pessoas que foram curadas
    e também por pessoas que venham a falecer em decorrência dela.",br(),br(),
    "No modelo SEIR","\\(R_0=\\beta/\\gamma\\)", "onde",
    "\\(\\beta\\)", "é a taxa de propagação (para algumas cidades é possível obter uma estimativa desta taxa na aba ao lado) e",
    "\\(\\gamma\\)", "é a taxa de recuperação dada por", "\\(1/t\\)", "onde ", "\\(t\\)",
    "é o tempo médio em que uma pessoa infectada é capaz de infectar outras pessoas (período infeccioso). Artigos científicos comprovam
    que este tempo é em torno de 10 dias, por este motivo consideramos","\\(\\gamma=0,1\\).", style='overflow-y: scroll;height:400px;font-size:16px;text-align:justify')
  )

  numero_reproducao <- nav_panel("Número de reprodução",
    fluidRow(column(width = 12, align = "right", sobre1)),
    ui_card(title = "Número de reprodução atual", valueBoxOutput(ns("rzero"))),
    ui_card(title = "Evolução do número de reprodução", plotlyOutput(ns("rzerov")))
  )

  taxa_propagacao <- nav_panel("Taxa de propagação",
    ui_card(title = "Taxa de propagação",
      div(class = "kpi-grid",
          valueBoxOutput(ns("beta")),
          valueBoxOutput(ns("rsquared")),
          valueBoxOutput(ns("pvalue"))
      )
    ),
    navset_card_tab(
      nav_panel("Ajuste exponencial", plotlyOutput(ns("ajuste"))),
      nav_panel("Evolução da taxa de propagação", plotlyOutput(ns("betav")))
    )
  )

  evolucao_n_infec <- nav_panel("Evolução dos infectados",
    ui_card(
      title = "Evolução do número de infectados",
      subtitle = "Nesta aba apresentamos o número estimado de pessoas infectadas. Nesta estimativa estamos supondo que cada pessoa infectada se recupera em exatamente 10 dias.",
      plotlyOutput(ns("infectados"))
    )
  )

  tagList(
    fluidRow(column(width = 12, align = "center", tags$h3(strong(textOutput(ns("painel_text")))))),
    navset_card_tab(id = ns("tabset"),
      nav_panel("Casos confirmados acumulados", plotlyOutput(ns("plot_gcidades"))),
      nav_panel("Casos por dia", plotlyOutput(ns("plot_por_dia_municipio"))),
      nav_panel("Casos com viagem", uiOutput(ns("u1"))),
      nav_panel("Incidência", plotlyOutput(ns("plot_incidencia_municipios"))),
      nav_panel("Faixa etária", plotlyOutput(ns("plot_por_faixaetaria_municipio"))),
      nav_panel("Sexo", uiOutput(ns("plot_sexo_municipio"))),
      numero_reproducao,
      taxa_propagacao,
      evolucao_n_infec
    )
  )
}

mapa_cidadesUI <- function(id) {
  ns <- NS(id)

  tagList(
    mla_hero(
      eyebrow = "15ª REGIONAL DE SAÚDE · COVID-19",
      title   = "Mapa de cidades",
      summary = "Mapa interativo com os casos confirmados de COVID-19 por município da 15ª Regional de Saúde do Paraná. Clique em uma cidade para ver o painel detalhado com séries, incidência, faixa etária e outros indicadores.",
      tag_list = c("Mapa interativo", "Casos por município", "Incidência")
    ),

    tags$div(class = "section",
      tags$div(class = "section-title", "Panorama por cidades da 15ª Regional do Estado do Paraná"),
      ui_card(
        leafletOutput(ns("map"), height = 500)
      )
    ),

    tags$head(tags$style(HTML('#panel_cidades {background-color: rgba(255,255,255,0.7);}
                              #eval {background-color: rgba(255,255,255,0.0);}
                                        ')))
  )
}
