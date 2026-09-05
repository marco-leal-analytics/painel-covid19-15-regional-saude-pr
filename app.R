app_file <- tryCatch(sys.frame(1)$ofile, error = function(e) NULL)
project_root <- if (!is.null(app_file) && nzchar(app_file)) {
  dirname(normalizePath(app_file))
} else {
  normalizePath(getwd())
}
setwd(project_root)
data_dir <- file.path(project_root, "data")

if (file.exists(file.path(project_root, "renv/activate.R"))) {
  source(file.path(project_root, "renv/activate.R"), encoding = "UTF-8")
}

source(file.path(project_root, "R_code/packages.R"), encoding = "UTF-8")
shiny::addResourcePath("assets", file.path(project_root, "assets"))
shiny::addResourcePath("sobre-document", file.path(project_root, "R_code/modules/sobre"))
source(file.path(project_root, "R_code/functions.R"), encoding = "UTF-8")
source(file.path(project_root, "R_code/constants.R"), encoding = "UTF-8")
source(file.path(project_root, "R_code/theme.R"), encoding = "UTF-8")
source(file.path(project_root, "R_code/components.R"), encoding = "UTF-8")
source(file.path(project_root, "R_code/data.R"), encoding = "UTF-8")

source(file.path(project_root, "R_code/modules/panorama_geral/ui.R"), encoding = "UTF-8")
source(file.path(project_root, "R_code/modules/panorama_geral/server.R"), encoding = "UTF-8")
source(file.path(project_root, "R_code/modules/mapa_cidades/ui.R"), encoding = "UTF-8")
source(file.path(project_root, "R_code/modules/mapa_cidades/server.R"), encoding = "UTF-8")
source(file.path(project_root, "R_code/modules/nivel_risco/ui.R"), encoding = "UTF-8")
source(file.path(project_root, "R_code/modules/nivel_risco/server.R"), encoding = "UTF-8")
source(file.path(project_root, "R_code/modules/colaboradores/ui.R"), encoding = "UTF-8")
source(file.path(project_root, "R_code/modules/colaboradores/server.R"), encoding = "UTF-8")
source(file.path(project_root, "R_code/modules/calculadora/ui.R"), encoding = "UTF-8")
source(file.path(project_root, "R_code/modules/calculadora/server.R"), encoding = "UTF-8")
source(file.path(project_root, "R_code/modules/configuracoes/ui.R"), encoding = "UTF-8")
source(file.path(project_root, "R_code/modules/configuracoes/server.R"), encoding = "UTF-8")
source(file.path(project_root, "R_code/modules/comportamento_inicial/ui.R"), encoding = "UTF-8")
source(file.path(project_root, "R_code/modules/comportamento_inicial/server.R"), encoding = "UTF-8")
source(file.path(project_root, "R_code/modules/sobre/ui.R"), encoding = "UTF-8")
source(file.path(project_root, "R_code/modules/sobre/server.R"), encoding = "UTF-8")

source(file.path(project_root, "R_code/ui.R"), encoding = "UTF-8")
source(file.path(project_root, "R_code/server.R"), encoding = "UTF-8")

shinyApp(ui = ui, server = server)
