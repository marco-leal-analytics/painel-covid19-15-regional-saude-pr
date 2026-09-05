################################################################################################################
######################################## MODULO: COLABORADORES (SERVER) ######################################
################################################################################################################
# Aba puramente estatica (lista de colaboradores) - nao ha outputs/inputs
# proprios, mas o moduleServer() e mantido para seguir o mesmo padrao dos
# demais modulos e permitir reatividade futura sem mudar a convocacao.

colaboradoresServer <- function(id) {
  moduleServer(id, function(input, output, session) {
  })
}
