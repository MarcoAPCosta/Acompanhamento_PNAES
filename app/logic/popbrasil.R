box::use(
  dplyr[`%>%`, filter]
)


#'@export
validos_brasil <- function(x){
  
    x %>% filter(!is.na(valido)) %>% 
    filter(valido==1) %>% 
    nrow()
  
}