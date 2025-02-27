box::use(
  dplyr[`%>%`, pull, summarise],
  stats[median]
)



box::use(
  app/logic/funcoes_auxiliares[formatar_numero]
)


#'@export
mediana <- function(x){
  
  if(nrow(x) > 0){
    saida <- x %>% 
      summarise(mediana = round(median(tempo), 2)) %>%
      pull(mediana) %>%
      formatar_numero %>% 
      paste("mins")
  }
  
  if(nrow(x) == 0) saida <- "0"
  
  return(saida)
}

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