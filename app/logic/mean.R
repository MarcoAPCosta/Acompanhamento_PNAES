box::use(
  dplyr[`%>%`, pull, summarise]
)



box::use(
  app/logic/funcoes_auxiliares[formatar_numero]
)


#'@export
media <- function(x){

  if(nrow(x) > 0){
    saida <- x %>%
      summarise(media = round(mean(tempo), 2)) %>% 
      pull(media) %>%
      formatar_numero() %>% 
      paste("mins")
  }
  
  if(nrow(x) == 0) saida <- "0"
  
  return(saida)  

}