# Funcoes utilitarias do pipeline de dados (bronze -> prata -> ouro).
# Este arquivo nao depende de nada do diretorio R_code/: o pipeline roda
# de forma totalmente externa/independente da aplicacao Shiny.

rm_accent <- function(str, pattern = "all") {
  if (!is.character(str)) str <- as.character(str)
  pattern <- unique(pattern)
  if (any(pattern == "Ç")) pattern[pattern == "Ç"] <- "ç"
  symbols <- c(
    acute = "áéíóúÁÉÍÓÚýÝ",
    grave = "àèìòùÀÈÌÒÙ",
    circunflex = "âêîôûÂÊÎÔÛ",
    tilde = "ãõÃÕñÑ",
    umlaut = "äëïöüÄËÏÖÜÿ",
    cedil = "çÇ"
  )
  nudeSymbols <- c(
    acute = "aeiouAEIOUyY",
    grave = "aeiouAEIOU",
    circunflex = "aeiouAEIOU",
    tilde = "aoAOnN",
    umlaut = "aeiouAEIOUy",
    cedil = "cC"
  )
  if (any(c("all", "al", "a", "todos", "t", "to", "tod", "todo") %in% pattern)) {
    return(chartr(paste(symbols, collapse = ""), paste(nudeSymbols, collapse = ""), str))
  }
  for (i in seq_along(symbols)) str <- chartr(symbols[i], nudeSymbols[i], str)
  str
}

# Chave de comparacao: maiusculas, sem acento, sem espacos extras nas pontas.
normalize_key <- function(x) {
  toupper(trimws(rm_accent(as.character(x))))
}

# Chave "compacta": normalize_key() sem espacos e sem pontuacao, no formato em
# que o sistema de origem grava a coluna `cidade` (ex.: "doutorcamargo").
compact_key <- function(x) {
  gsub("[^A-Z]", "", normalize_key(x))
}

# Lista oficial dos 30 municipios da 15a Regional de Saude do Parana, na mesma
# ordem usada nas planilhas de origem (populacao, coordenadas) e no MESMO
# formato (maiusculas com acento) usado pela aplicacao (R_code/constants.R,
# `lista_cidade_upper`) para nomear colunas/identificar cidades nas telas.
# Mantida aqui (e nao em R_code/constants.R) para que o pipeline seja
# executavel de forma independente da aplicacao.
municipios_15_regional <- toupper(c(
  "Ângulo", "Astorga", "Atalaia", "Colorado", "Doutor Camargo",
  "Floraí", "Floresta", "Flórida", "Iguaraçu", "Itaguajé",
  "Itambé", "Ivatuba", "Lobato", "Mandaguaçu", "Mandaguari", "Marialva",
  "Maringá", "Munhoz de Melo", "Nossa Senhora das Graças",
  "Nova Esperança", "Ourizona", "Paiçandu", "Paranacity",
  "Presidente Castelo Branco", "Santa Fé", "Santa Inês",
  "Santo Inácio", "São Jorge do Ivaí", "Sarandi", "Uniflor"
))

# Alias conhecidos para tokens de cidade que nao sao derivaveis apenas
# removendo acentos/espacos do nome canonico (abreviacoes usadas na origem).
municipio_aliases <- c(PCB = "PRESIDENTE CASTELO BRANCO")

# Mapa raw-token -> nome canonico (com acento), construido a partir da lista
# oficial de municipios + alias conhecidos.
build_municipio_lookup <- function() {
  canon <- municipios_15_regional
  chave <- compact_key(canon)
  lookup <- stats::setNames(canon, chave)

  alias_chave <- compact_key(names(municipio_aliases))
  lookup[alias_chave] <- unname(municipio_aliases)

  lookup
}

# Resolve um vetor de tokens de cidade (como gravados na origem, ex.:
# "doutorcamargo", "pcb") para o nome canonico com acento (ex.:
# "Doutor Camargo", "Presidente Castelo Branco"). Tokens nao reconhecidos sao
# preservados (em maiusculo) para nao descartar registros silenciosamente.
resolve_municipio <- function(x) {
  lookup <- build_municipio_lookup()
  chave <- compact_key(x)
  resolved <- unname(lookup[chave])
  unresolved <- is.na(resolved)
  resolved[unresolved] <- normalize_key(x)[unresolved]
  resolved
}

# Chave compacta (sem acento/espaco) do nome canonico, no mesmo formato usado
# pelas telas da aplicacao para identificar uma cidade (ex.: "saojorgedoivai").
municipio_chave_app <- function(nome_canonico) {
  compact_key(nome_canonico)
}

# Converte datas em formato dd/mm/aaaa (com variações comuns) para Date.
parse_data_br <- function(x) {
  as.Date(x, format = "%d/%m/%Y")
}

# Extrai o primeiro token numerico de um campo de idade potencialmente sujo
# (ex.: "57", "57 anos").
parse_idade <- function(x) {
  primeiro_token <- vapply(strsplit(trimws(as.character(x)), "\\s+"), `[`, character(1), 1)
  suppressWarnings(as.numeric(primeiro_token))
}

# Normaliza sexo para "M", "F" ou NA.
normalize_sexo <- function(x) {
  x <- toupper(trimws(as.character(x)))
  out <- rep(NA_character_, length(x))
  out[grepl("^M", x)] <- "M"
  out[grepl("^F", x)] <- "F"
  out
}

# Normaliza SIM/NAO (obito, etc.) para maiusculas sem espacos nas pontas.
normalize_sim_nao <- function(x) {
  toupper(trimws(as.character(x)))
}

ensure_dir <- function(path) {
  if (!dir.exists(path)) dir.create(path, recursive = TRUE)
  invisible(path)
}

log_step <- function(...) {
  cat(sprintf("[%s] ", format(Sys.time(), "%H:%M:%S")), sprintf(...), "\n", sep = "")
}
