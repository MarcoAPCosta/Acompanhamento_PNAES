box::use(
  shiny[moduleServer, NS],
  dplyr[`%>%`]
)


#' @export
formatar_numero <- function(x) {
  saida <- x %>%
    format(digits = 2L,
           nsmall = 2L,
           big.mark = ".",
           decimal.mark = ",")
  
  return(saida)
}
