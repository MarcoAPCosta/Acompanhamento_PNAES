box::use(
  shiny[moduleServer, NS],
  dplyr[`%>%`]
)


#' @export
formatar_numero <- function(x) {
  saida <- x %>%
    format(big.mark = ".",
           decimal.mark = ",")
  
  return(saida)
}
