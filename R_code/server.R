################################################################################################################
######################################## CASCA DA APLICAÇÃO (SERVER) #########################################
################################################################################################################
# Inicia um módulo de servidor para cada aba exposta pelo page_navbar acima.
# O login por usuário/senha foi removido: todas as abas ficam sempre visíveis.

server <- function(input, output, session) {
  panorama_geralServer("panorama")
  mapa_cidadesServer("mapa")
  nivel_riscoServer("nivel_risco")
  comportamento_inicialServer("comportamento_inicial")
  calculadora_seirServer("calculadora")
  colaboradoresServer("colaboradores")
  sobreServer("sobre")
}
