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
        title = "15ª Regional de Saúde / CRESEMS",
        tags$ul(class = "competencies-list",
          tags$li("Ederlei Ribeiro Alkamim - Diretor"),
          tags$li("Sandra Ap. Barboza da Silva - Epidemiologia"),
          tags$li("Rosana Baldasso - Epidemiologia"),
          tags$li("Valentim Sala Junior - Epidemiologia"),
          tags$li("Greicy Cezar do Amaral - Educação Permanente"),
          tags$li("Fabiano Batista - DVVGS"),
          tags$li("Adelson Gonçalves dos Santos - Regulação de Leitos")
        )
      ),
      ui_card(
        title = "Departamento de Estatística",
        tags$ul(class = "competencies-list",
          tags$li("Daniele Cristina Tita Granzotto (DES-UEM) - In Memoriam"),
          tags$li("Marco Aurelio Valles Leal (DES-UEM)")
        )
      ),
      ui_card(
        title = "Departamento de Matemática",
        tags$ul(class = "competencies-list",
          tags$li("Ednei Aparecido Santulo Júnior (DMA-UEM)"),
          tags$li("Eduardo de Amorim Neves (DMA-UEM)"),
          tags$li("Francisco Nogueira Calmon Sobral (DMA-UEM)"),
          tags$li("Gilberto Aparecido Tenani (IFMS)"),
          tags$li("Marcelo Osnar Rodrigues de Abreu (DMA-UEM) - Coordenador"),
          tags$li("Marcos Vinicius Fagundes Padilha (DMA-UEM)"),
          tags$li("Thiago Fanelli Ferraiol (DMA-UEM)")
        )
      )
    )
  )
}
