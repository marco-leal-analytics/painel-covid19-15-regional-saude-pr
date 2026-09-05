################################################################################################################
######################################## COMPONENTES DE UI (padrão do portfólio) #############################
################################################################################################################
# Helpers compartilhados por app.R e pelos módulos para manter o mesmo padrão
# visual (hero, cards, kpis) usado no projeto de portfólio pessoal.

`%||%` <- function(a, b) if (is.null(a) || length(a) == 0 || (is.character(a) && !nzchar(a))) b else a

# Fontes usadas pelo tema (mesma família do portfólio).
use_app_fonts <- function() {
  tags$link(
    rel = "stylesheet",
    href = "https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Merriweather:wght@700;900&display=swap"
  )
}

# Bloco de destaque no topo de cada módulo (padrão .mla-hero do portfólio).
mla_hero <- function(eyebrow, title, summary, tag_list = NULL, mark = NULL) {
  tags$div(class = "mla-hero module-hero",
    tags$div(class = "hero-copy",
      tags$span(class = "eyebrow", eyebrow),
      tags$h1(title),
      tags$p(class = "hero-summary", summary),
      if (!is.null(tag_list)) {
        tags$div(class = "tag-row",
                 lapply(tag_list, function(t) tags$span(class = "mla-tag accent", t)))
      }
    ),
    tags$div(class = "hero-visual hero-mark", tags$span(mark %||% toupper(title)))
  )
}

# Cartão de indicador (padrão .kpi-card do portfólio).
kpi_card <- function(value, label, subtitle = NULL) {
  tags$div(class = "kpi-card",
    tags$strong(value),
    tags$div(class = "kpi-label", label),
    if (!is.null(subtitle)) tags$div(class = "kpi-sub", subtitle)
  )
}

# Cartão genérico de conteúdo (padrão .ui-card do portfólio).
ui_card <- function(title = NULL, subtitle = NULL, ..., footer = NULL, image = NULL) {
  tags$div(class = "ui-card",
    if (!is.null(image)) tags$div(class = "card-image", image),
    tags$div(class = "card-body",
      if (!is.null(title)) tags$h4(title),
      if (!is.null(subtitle)) tags$p(class = "muted", subtitle),
      ...
    ),
    if (!is.null(footer)) tags$div(class = "card-footer", footer)
  )
}

# Bloco de destaque leve (padrão .callout-success do portfólio).
callout <- function(title, ..., success = TRUE) {
  tags$div(class = if (success) "callout-success" else "callout",
    tags$h2(title),
    ...
  )
}

# Aplica um tema escuro consistente aos gráficos plotly (fundo transparente,
# texto/grid claros) para não conflitar com o fundo escuro do app.
dark_plotly <- function(fig) {
  fig %>% plotly::layout(
    paper_bgcolor = "rgba(0,0,0,0)",
    plot_bgcolor  = "rgba(0,0,0,0)",
    font  = list(color = "#E6EEF8", family = "Inter, sans-serif"),
    xaxis = list(gridcolor = "rgba(230,238,248,.12)", zerolinecolor = "rgba(230,238,248,.18)", linecolor = "rgba(230,238,248,.25)"),
    yaxis = list(gridcolor = "rgba(230,238,248,.12)", zerolinecolor = "rgba(230,238,248,.18)", linecolor = "rgba(230,238,248,.25)"),
    legend = list(orientation = "h", x = 0.5, xanchor = "center", y = 1.15, yanchor = "bottom", font = list(color = "#E6EEF8"))
  )
}

# Paleta de cores compartilhada pelos gráficos (alinhada ao tema do app).
mla_palette <- c("#58A6FF", "#7DD3FC", "#2BD4A7", "#F59E0B", "#F85149", "#7C3AED")
