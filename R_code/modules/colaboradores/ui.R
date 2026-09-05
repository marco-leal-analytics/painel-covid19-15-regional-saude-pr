################################################################################################################
######################################## MODULO: COLABORADORES (UI) ##########################################
################################################################################################################

withMathJax()

colaboradoresUI <- function(id) {
  ns <- NS(id)

  tagList(
    mla_hero(
      eyebrow = "15ª REGIONAL DE SAÚDE · COVID-19",
      title   = "Colaboradores",
      summary = "Equipe responsável pelo acompanhamento epidemiológico da 15ª Regional de Saúde e pelo desenvolvimento estatístico e computacional do painel, em parceria com os departamentos de Estatística e Matemática da UEM.",
      tag_list = c("15ª Regional de Saúde", "DES-UEM", "DMA-UEM")
    ),

    tags$div(class = "projects-grid",
      ui_card(
        title = "15ª Regional de Saúde",
        tags$ul(class = "competencies-list",
          tags$li("Ederlei Ribeiro Alkamim - Diretor"),
          tags$li("Sandra Ap. Barboza da Silva - Epidemiologia"),
          tags$li("Rosana Baldasso - Epidemiologia"),
          tags$li("Valentim Sala Junior - Epidemiologia"),
          tags$li("Greicy Cezar do Amaral - Educação Permanente"),
          tags$li("Fabiano Batista - DVVGS")
        )
      ),
      ui_card(
        title = "Departamento de Estatística (DES-UEM)",
        tags$ul(class = "competencies-list",
          tags$li("Daniele Cristina Tita Granzotto - Coordenadora"),
          tags$li("Marco Aurelio Valles Leal")
        )
      ),
      ui_card(
        title = "Departamento de Matemática (DMA-UEM)",
        tags$ul(class = "competencies-list",
          tags$li("Ednei Aparecido Santulo Júnior"),
          tags$li("Eduardo de Amorim Neves"),
          tags$li("Francisco Nogueira Calmon Sobral"),
          tags$li("Gilberto Aparecido Tenani (IFMS)"),
          tags$li("Marcelo Osnar Rodrigues de Abreu - Coordenador"),
          tags$li("Marcos Vinicius Fagundes Padilha"),
          tags$li("Thiago Fanelli Ferraiol")
        )
      ),
      ui_card(title = "CRESEMS")
    )
  )
}
