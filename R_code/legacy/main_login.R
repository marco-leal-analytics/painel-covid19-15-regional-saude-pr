
# show_alert(
#   
#   title = NULL,
#   btn_labels = NA,
#   showCloseButton = TRUE,
#   text = fluidRow(column(width=12, info_alert,espaco_html(4))),
#   html = TRUE,
#   width = "90%")  




login <<- navbarPage(title = div(img(class="logo", src="virus.png" , width="40px",height="40px"),strong("COVID-19",style = "padding-left:10px;color:#0072B2;font-size:24px;")),
           windowTitle = "COVID-19",id = 'navbar',
           theme = shinytheme("yeti"),
           header = div(
             fluidRow(
               column(width=9),
               # div(style="padding-left:25px;",informacao)),
               column(width=3,align="right",
                      div(style="padding-left:25px;",dropdown( box( title= tags$div(HTML('<i class="fa fa-user"style = "color:#0072B2;font-size:50px"></i>
                                               <b style = "padding-left:25px;color:#000000;font-size:30px">
                                               PAINEL DO USUÁRIO </b>')),width = 12 ),
                                                               espaco_html(2),
                                                               fluidRow(column(width=12,align="center",
                                                                               strong(credentials[[input$username]]$"name"))),
                                                               fluidRow(column(width=12,align="left",
                                                                               uiOutput("buttons"))),
                                                               espaco_html(2),
                                                               actionBttn(
                                                                 inputId = "logout",
                                                                 label = "Sair",
                                                                 color = "primary",
                                                                 style = "jelly",
                                                                 block = TRUE,
                                                                 icon = icon("sign-out")),
                                                               style = "jelly", icon = icon("user",'fa-2x'),
                                                               status = "primary", width = "auto",tooltip =  tooltipOptions(title = "Clique para ver o painel !",placement = "left"),
                                                               animate = animateOptions(
                                                                 enter = animations$fading_entrances$fadeInRightBig,duration = 0.25,
                                                                 exit = animations$fading_exits$fadeOutRightBig))))
               
               
               
             ),espaco_html(2)),
           collapsible = T,
           inverse = FALSE,
           informe,
           mapa,
           nivel_risco,
           colaboradores,
           
           mais,
           footer =  box(
             fixedRow(
               div(img( class="logo_p",src="sec_saude.png", width="75", height="75"),
                   img( class="logo_p",src="logo_uem.png", width="100", height="75"),
                   style="text-align:center;")), width = 12)
)