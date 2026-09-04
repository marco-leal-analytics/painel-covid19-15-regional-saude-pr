

logoff <<- navbarPage(title = div(img(class="logo", src="virus.png" , width="40px",height="40px"),strong("COVID-19",style = "padding-left:10px;color:#0072B2;font-size:24px;")),
           windowTitle = "COVID-19",
           theme = shinytheme("yeti"),
           selected = 0,collapsible = T,
           
           header = NULL,
           footer =  box(
             fixedRow(
               div(img( class="logo_p",src="sec_saude.png", width="75", height="75"),
                   img( class="logo_p",src="logo_uem.png", width="100", height="75"),
                   style="text-align:center;")),width = 12),
           inverse = FALSE,
           tabPanel(value = 0,title = tags$div(HTML('<i class="fa fa-sign-in"style = "color:#0072B2;font-size:30px"></i>
                                                  <b style = "padding-left:10px;color:#0072B2;font-size:16px">LOGIN</b>')),
                    fluidRow(
                      fluidRow( 
                        column(width = 12,align="center",
                               box(
                                 title= tags$div(HTML('<i class="fas fa-sign-in" style = "color:#0072B2;font-size:50px"></i>
                                                                      <b style = "padding-left:25px;color:#000000;font-size:30px">
                                                                      COVID 19 - 15ª REGIONAL DE SAÚDE DO PARANÁ</b>')),
                                 tags$head(tags$style(HTML("hr {border-top: 5px solid;}"))), width = 12),
                               div(textInput("username",strong("Usuário : "),width=150),style="padding-left:0px;"),
                               br(style="display: block;content: \"\"; margin-top: 0px;"),
                               div( passwordInput("password", strong("Senha:",align="left"),width = 150),style="padding-left:0px;"),
                               fluidRow(
                                 div(actionBttn(
                                   inputId = "login",
                                   label = "Entrar",
                                   color = "primary",
                                   style = "jelly",
                                   block = TRUE,
                                   icon = icon("sign-in")),
                                   style = sprintf("left: 0px;text-align:center;padding-left:0px;")))
                        ))),br(),br(),br(),br(),br())) 