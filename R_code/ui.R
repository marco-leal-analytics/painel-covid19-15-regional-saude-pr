################################################################################################################
######################################## CASCA DA APLICAÇÃO (UI) #############################################
################################################################################################################
# Estrutura padrão alinhada ao template do portfólio pessoal: page_navbar com
# um nav_panel por módulo, sem imagem no cabeçalho (apenas título + menu) e
# sem tela de login — todas as abas ficam sempre visíveis.

ui <- page_navbar(
  title = "15ª Regional de Saúde - COVID-19",
  window_title = "15ª Regional de Saúde - COVID-19",
  theme = app_theme,
  inverse = FALSE,
  position = "static-top",
  header = tagList(
    use_app_fonts(),
    tags$link(rel = "stylesheet", href = "assets/css/app.css"),
    tags$link(rel = "icon", href = "assets/www/favicon.ico"),
    tags$script(HTML("document.documentElement.setAttribute('data-theme', 'dark')")),
    tags$script(HTML(paste(
      "(function(){",
      "  function ensureBackToTop(){",
      "    var btn = document.getElementById('back-to-top');",
      "    if(!btn){ btn = document.createElement('button'); btn.id='back-to-top'; btn.innerText='↑'; document.body.appendChild(btn);",
      "      btn.addEventListener('click', function(){ window.scrollTo({top:0, behavior:'smooth'}); });",
      "    }",
      "    window.addEventListener('scroll', function(){ if(window.scrollY>400) btn.style.display='block'; else btn.style.display='none'; });",
      "  }",
      "  if(document.readyState==='complete'){ ensureBackToTop(); } else window.addEventListener('load', ensureBackToTop);",
      "})();",
      sep = "\n"
    )))
  ),
  nav_panel("Painel Geral", tags$div(class = "module-shell", panorama_geralUI("panorama"))),
  nav_panel("Mapa de Cidades", tags$div(class = "module-shell", mapa_cidadesUI("mapa"))),
  nav_panel("Nível de Risco", tags$div(class = "module-shell", nivel_riscoUI("nivel_risco"))),
  nav_panel("Comportamento Inicial", tags$div(class = "module-shell", comportamento_inicialUI("comportamento_inicial"))),
  nav_panel("Calculadora SEIR", tags$div(class = "module-shell", calculadora_seirUI("calculadora"))),
  nav_panel("Colaboradores", tags$div(class = "module-shell", colaboradoresUI("colaboradores"))),
  nav_panel("Sobre", sobreUI("sobre"))
)
