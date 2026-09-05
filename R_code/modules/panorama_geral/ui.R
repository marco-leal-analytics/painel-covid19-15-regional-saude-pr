################################################################################################################
######################################## MODULO: PAINEL GERAL (UI) ###########################################
################################################################################################################

panorama_geralUI <- function(id) {
  ns <- NS(id)

  sobre_incidencia <- tags$div(
    tags$p(
      "Número de casos confirmados de COVID-19 por 1.000.000 habitantes, considerando a população residente atual."
    ),
    withMathJax("$$ \\frac{ \\text{Número de casos confirmados}} { \\text{População Total residente}} \\times 1.000.000 $$"),
    tags$p(class = "section-small",
      tags$strong("Fontes: "), "Dados 15ª Regional (planilha eletrônica diária) e dados populacionais do ",
      tags$a(href = "https://www.ibge.gov.br/cidades-e-estados.html?view=municipio", target = "_blank", "IBGE"),
      " (consulta em 02/06/2020)."
    ),
    dataTableOutput(ns("table_populacao"))
  )

  tagList(
    tags$div(class = "mla-hero module-hero",
      tags$div(class = "hero-copy",
        tags$span(class = "eyebrow", "15ª REGIONAL DE SAÚDE · COVID-19"),
        tags$h1("Panorama geral da regional"),
        tags$p(class = "hero-summary",
          "Acompanhamento consolidado dos casos confirmados, óbitos e incidência de COVID-19 nos municípios da 15ª Regional de Saúde do Paraná."
        ),
        tags$div(class = "tag-row",
          tags$span(class = "mla-tag accent", paste0("Atualizado em ", data_fim)),
          tags$span(class = "mla-tag accent", "Casos confirmados"),
          tags$span(class = "mla-tag accent", "Incidência")
        )
      ),
      tags$div(class = "hero-visual hero-mark", tags$span("COVID-19"))
    ),

    div(class = "kpi-grid",
        kpi_card(numero_casos_total[1], "Casos confirmados"),
        kpi_card(obitos[1], "Óbitos confirmados")
    ),

    tags$div(class = "section",
      tags$div(class = "section-title", "Análise descritiva por faixa etária e por sexo"),
      div(class = "kpi-grid",
          ui_card(title = "Distribuição por sexo · Casos", plotlyOutput(ns("plot_pie_sexo"))),
          ui_card(title = "Distribuição por sexo · Óbitos", plotlyOutput(ns("plot_pie_obito_sexo")))
      ),
      ui_card(title = "Casos confirmados por faixa etária", plotlyOutput(ns("plot_faixa_etaria"))),
      ui_card(title = "Casos confirmados por faixa etária e sexo", plotlyOutput(ns("plot_faixa_etaria_sexo")))
    ),

    tags$div(class = "section",
      tags$div(class = "section-title", "Evolução diária de casos confirmados"),
      div(class = "two-col-row",
        div(class = "two-col-item",
            ui_card(title = "Casos confirmados por dia", plotlyOutput(ns("plot_casos_por_dia")))
        ),
        div(class = "two-col-item",
            ui_card(title = "Casos confirmados acumulados", plotlyOutput(ns("plot_casos_acumulados")))
        )
      )
    ),

    tags$div(class = "section",
      tags$div(class = "section-title", "Incidência por milhão de habitante"),
      ui_card(
        plotlyOutput(ns("plot_incidencia_regional"), height = 500),
        footer = tagList(
          tags$details(
            tags$summary("Sobre o coeficiente de incidência"),
            sobre_incidencia
          )
        )
      )
    ),

    tags$div(class = "section",
      tags$div(class = "section-title", "Casos, incidências e evolução"),
      navset_card_tab(
        nav_panel("Casos e incidências",
          div(class = "two-col-row",
            div(class = "two-col-item",
                tags$div(class = "section-subtitle", "Número de casos por cidade"),
                plotlyOutput(ns("plot_numero_casos_cidades"), height = qtd_cidade * 50)
            ),
            div(class = "two-col-item",
                tags$div(class = "section-subtitle", "Incidência por milhão de habitante"),
                plotlyOutput(ns("plot_incidencia_cidades"), height = qtd_cidade * 50)
            )
          ),
          tags$p(class = "section-small",
            tags$strong("Fontes: "), "Dados 15ª Regional (planilha eletrônica diária) e dados populacionais do ",
            tags$a(href = "https://www.ibge.gov.br/cidades-e-estados.html?view=municipio", target = "_blank", "IBGE"),
            " (consulta em 02/06/2020)."
          )
        ),
        nav_panel("Evolução dos casos",
          tags$img(class = "img-fluid", src = "gganim_casos.gif")
        ),
        nav_panel("Evolução das incidências",
          tags$img(class = "img-fluid", src = "gganim_incidencias.gif")
        )
      )
    )
  )
}
