credentials <-  list(
  mleal=list(username="mleal",pass="mleal",name="Marco Aurelio Valles Leal"),
  dctgranzotto=list(username="dctgranzotto",pass="covid19dctgranzotto",name="Daniele Cristina Tita Granzotto "),
  morabreu=list(username="morabreu",pass="covid19morabreu",name="Marcelo Osnar Rodrigues de Abreu"),
  angulo=list(username="angulo",pass="covid19angulo",name="Ângulo"),
  astorga=list(username="astorga",pass="covid19astorga",name="Astorga"),
  atalaia=list(username="atalaia",pass="covid19atalaia",name="Atalaia"),
  colorado=list(username="colorado",pass="covid19colorado",name="Colorado"),
  doutorcamargo=list(username="doutorcamargo",pass="covid19doutorcamargo",name="Doutor Camargo"),
  florai=list(username="florai",pass="covid19florai",name="Florai"),
  floresta=list(username="floresta",pass="covid19floresta",name="Floresta"),
  florida=list(username="florida",pass="covid19florida",name="Flórida"),
  iguaracu=list(username="iguaracu",pass="covid19iguaracu",name="Iguaraçu"),
  itaguaje=list(username="itaguaje",pass="covid19itaguaje",name="Iguajé"),
  itambe=list(username="itambe",pass="covid19itambe",name="Itambé"),
  ivatuba=list(username="ivatuba",pass="covid19ivatuba",name="Ivatuba"),
  lobato=list(username="lobato",pass="covid19lobato",name="Lobato"),
  mandaguacu=list(username="mandaguacu",pass="covid19mandaguacu",name="Mandaguaçu"),
  mandaguari=list(username="mandaguari",pass="covid19mandaguari",name="Mandaguari"),
  marialva=list(username="marialva",pass="covid19marialva",name="Marialva"),
  maringa=list(username="maringa",pass="covid19maringa",name="Maringá"),
  munhozdemelo=list(username="munhozdemelo",pass="covid19munhozdemelo",name="Munhoz de Melo"),
  nossasenhoradasgracas=list(username="nossasenhoradasgracas",pass="covid19nossasenhoradasgracas",name="Nossa Senhora das Graças"),
  novaesperanca=list(username="novaesperanca",pass="covid19novaesperanca",name="Nova Esperança"),
  ourizona=list(username="ourizona",pass="covid19ourizona",name="Ourizona"),
  paicandu=list(username="paicandu",pass="covid19paicandu",name="Paiçandu"),
  paranacity=list(username="paranacity",pass="covid19paranacity",name="Paranacity"),
  presidentecastelobranco=list(username="presidentecastelobranco",pass="covid19castelobranco",name="Presidente Castelo Branco"),
  santafe=list(username="santafe",pass="covid19santafe",name="Santa Fé"),
  santaines=list(username="santaines",pass="covid19santaines",name="Santa Inês"),
  santoinacio=list(username="santoinacio",pass="covid19santoinacio",name="Santo Inácio"),
  saojorgedoivai=list(username="saojorgedoivai",pass="covid19saojorgeivai",name="São Jorge do Ivaí"),
  sarandi=list(username="sarandi",pass="covid19sarandi",name="Sarandi"),
  uniflor=list(username="uniflor",pass="covid19uniflor",name="Uniflor"),
  regional=list(username="regional",pass="covid1915regional",name="15ª Regional"),
  cresems=list(username="cresems",pass="covid19cresems",name="CRESEMS")
)

# token       <-  drop_auth()
# saveRDS(token, "droptoken.rds")

#plot_gifs()



textsize <- 14

mytheme <- theme(legend.position = "top",
                 axis.title = element_text(size = textsize + 2),
                 axis.text = element_text(size = textsize),
                 legend.title = element_text(size = textsize + 2),
                 legend.text = element_text(size = textsize))

label_faixa_etaria <- c("0 - 09","10 - 18","19 - 40","41 - 60","61 - 80","81+" )


cbPalette <- c("#09557f","#FF3333")

axis_theme <- theme_bw() + mytheme +
  theme(
    legend.position = "none",
    axis.text.x = element_text(angle = 45,hjust = 1,face = "bold",size = 30),
    axis.text.y = element_text(angle = 0,hjust = 1,face = "bold",size = 30),
    legend.background = element_rect(fill = "transparent", colour = NA,size = 2),
    panel.background = element_rect(fill = "transparent", colour = NA),
    plot.background = element_rect(fill = "white", colour = NA),
    axis.title.x = element_text(colour = "black",size = 30,face = "bold"),
    axis.title.y = element_text(colour = "black",size = 30,face = "bold"),
    legend.title = element_text(colour = "black",size = 30),
    legend.text = element_text(colour = "black",size = 30,face = "bold"),
    panel.grid = element_line(linetype="dashed"),
    panel.grid.major = element_line(colour = "gray"),
    axis.title = element_text(color="#000000", face="bold", size=20,
                              hjust = 0.5,lineheight = 2))

coordenadas=as.data.frame(t(cbind(angulo=c(-51.9094976,-23.1958345),
                                 astorga=c(-51.6647074,-23.2350184),
                                 atalaia=c(-52.0529697,-23.1513833),
                                 colorado=c(-51.9730135,-22.8385097),
                                 doutor_camargo=c(-52.2185546,-23.5575611),
                                 florai=c(-52.3009856,-23.3206134),
                                 floresta=c(-52.08180428,-23.61448588),
                                 florida=c(-51.9540843,-23.0861312),
                                 iguaracu=c(-51.8244524,-23.1972911),
                                 itaguaje=c(-51.967351,-22.618282),
                                 itambe=c(-51.9903555,-23.659424),
                                 ivatuba=c(-52.2174491,-23.618722),
                                 lobato=c(-51.9524309,-23.0077055),
                                 mandaguacu=c(-52.0966215,-23.3485076),
                                 mandaguari=c(-51.6787511,-23.5224849),
                                 marialva=c(-51.795788,-23.4820987),
                                 maringa=c(-51.9382078,-23.425269),
                                 munhoz_de_melo=c(-51.7737332,-23.1486583),
                                 nossa_senhora_das_gracas=c(-51.7962681,-22.9138823),
                                 nova_esperanca=c(-52.1999852,-23.1818437),
                                 ourizona=c(-52.1954085,-23.4047001),
                                 paicandu=c(-52.048988,-23.4575884),
                                 paranacity=c(-52.1523164,-22.9304971),
                                 presidente_castelo_branco=c(-52.1528771,-23.2790844),
                                 santa_fe=c(-51.808014,-23.039993),
                                 santa_ines=c(-51.9031333,-22.640225),
                                 santo_inacio=c(-51.792679,-22.6973239),
                                 sao_jorge_do_ivai=c(-52.2924553,-23.4327325),
                                 sarandi=c(-51.876016,-23.444117),
                                 uniflor=c(-52.1584403,-23.0853871)))
)

lista_cidades <- c(nomes=c("Ângulo",
                           "Astorga",
                           "Atalaia",
                           "Colorado",
                           'Doutor Camargo',
                           "Floraí",
                           "Floresta",
                           "Flórida",
                           "Iguaraçu",
                           "Itaguajé",
                           "Itambé",
                           "Ivatuba",
                           "Lobato",
                           "Mandaguaçu",
                           "Mandaguari",
                           "Marialva",
                           "Maringá",
                           "Munhoz de Melo",
                           "Nossa Senhora das Graças",
                           "Nova Esperança",
                           "Ourizona",
                           "Paiçandu",
                           "Paranacity",
                           "Presidente Castelo Branco",
                           "Santa Fé",
                           "Santa Inês",
                           "Santo Inácio",
                           "São Jorge do Ivaí",
                           "Sarandi",
                           "Uniflor"
                           
))
read_excel_allsheets <- function(filename, tibble = FALSE) {
  
  sheets <- readxl::excel_sheets(filename)
  x <- lapply(sheets, function(X) readxl::read_excel(filename, sheet = X))
  if(!tibble) x <- lapply(x, as.data.frame)
  names(x) <- sheets
  x
}
lista_cidade_upper <- toupper(lista_cidades)



title <- tags$a(href='http://www.des.uem.br/',
                "DES/UEM",target="_blank",style = "line-height:0px;padding-top:0px;padding-left:0px;")


shinydashboard_css <<- tags$head(tags$style(HTML('

                                /* body */
                                .content-wrapper, .right-side {
                                background-color: #ffffff;

                                }
                                .box.box-solid.box-primary>.box-header {
  color:#fff;
  background:#666666
                    }

.box.box-solid.box-primary{
border-bottom-color:#666666;
border-left-color:#666666;
border-right-color:#666666;
border-top-color:#666666;
}

                                ')))

espaco<<- div(br(),br(),br(),br(),br(),br(),br(),br())

espaco_html <<- function(n=6){


  return(HTML( rep("<br>",n)))


}

# Helper compartilhado entre módulos: substitui shinydashboard::box() por
# bslib::card(), mantendo a mesma assinatura de chamada (title =, width =
# ignorado, ... = corpo do card). Usado na conversão incremental para bslib.
box_card <<- function(title = NULL, ..., width = NULL) {
  body_content <- list(...)
  card_body_el <- if (length(body_content) > 0) do.call(bslib::card_body, body_content) else NULL
  bslib::card(
    if (!is.null(title)) bslib::card_header(title),
    card_body_el
  )
}

