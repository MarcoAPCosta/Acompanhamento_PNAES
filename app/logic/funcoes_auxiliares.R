box::use(
  shiny[moduleServer, NS],
  dplyr[`%>%`]
)


#' @export
formatar_numero <- function(x, digitos = 2, ndigitos = 2, percent = F) {
  saida <- x %>%
    format(big.mark = ".",
           decimal.mark = ",",
           nsmall = ndigitos,
           digits = digitos)
  
  if(percent) {
    saida <- x*100
    
    saida <- saida  %>%
      format(big.mark = ".",
             decimal.mark = ",",
             nsmall = ndigitos,
             digits = digitos) %>% 
      paste0("%")
  }
  
  return(saida)
}
