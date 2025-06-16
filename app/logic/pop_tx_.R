box::use(
  dplyr[`%>%`]
)


box::use(
  app/logic/funcoes_auxiliares[formatar_numero]
)

#' @export

pop_b <- function(x){
  saida <- x %>% 
    formatar_numero(ndigitos = 0)
  
  return(saida)
}

#'@export
tx_b <- function(x, y){
  valor <- x
  numerador <- y
  saida <- valor/numerador
  
  saida <- formatar_numero(saida, percent = T)
  
  return(saida)
}