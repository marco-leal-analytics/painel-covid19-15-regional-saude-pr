################################################################################################################
######################################## TEMA GLOBAL (bslib) #################################################
################################################################################################################
# Tokens espelhados de assets/sass/_variables.scss (design system pessoal do autor)

app_theme <- bslib::bs_theme(
  version     = 5,
  bg          = "#0B1220",
  fg          = "#E6EEF8",
  primary     = "#3B82F6",
  secondary   = "#7C3AED",
  success     = "#10B981",
  warning     = "#F59E0B",
  danger      = "#EF4444",
  info        = "#06B6D4",
  base_font   = bslib::font_google("Inter"),
  heading_font = bslib::font_google("Merriweather"),
  "border-radius" = "10px"
)

app_theme <- bslib::bs_add_rules(app_theme, sass::sass_file(file.path(getwd(), "assets/sass/main.scss")))
