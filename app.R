app_file <- tryCatch(sys.frame(1)$ofile, error = function(e) NULL)
project_root <- if (!is.null(app_file) && nzchar(app_file)) {
  dirname(normalizePath(app_file))
} else {
  normalizePath(getwd())
}
setwd(project_root)

if (file.exists(file.path(project_root, "renv/activate.R"))) {
  source(file.path(project_root, "renv/activate.R"), encoding = "UTF-8")
}

source(file.path(project_root, "R_code/packages.R"), encoding = "UTF-8")
source(file.path(project_root, "R_code/functions.R"), encoding = "UTF-8")
source(file.path(project_root, "R_code/constants.R"), encoding = "UTF-8")
source(file.path(project_root, "R_code/data.R"), encoding = "UTF-8")

source(file.path(project_root, "R_code/modules/panorama_geral.R"), encoding = "UTF-8")
source(file.path(project_root, "R_code/modules/mapa_cidades.R"), encoding = "UTF-8")
source(file.path(project_root, "R_code/modules/nivel_risco.R"), encoding = "UTF-8")
source(file.path(project_root, "R_code/modules/colaboradores.R"), encoding = "UTF-8")
source(file.path(project_root, "R_code/modules/calculadora.R"), encoding = "UTF-8")
source(file.path(project_root, "R_code/modules/configuracoes.R"), encoding = "UTF-8")

source(file.path(project_root, "R_code/ui.R"), encoding = "UTF-8")
source(file.path(project_root, "R_code/server.R"), encoding = "UTF-8")

shinyApp(ui = ui, server = server)
