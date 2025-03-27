box::use(
  dplyr[`%>%`, filter, summarise, mutate]
)

#'@export
d1 <- function(x){
  valor <- x
  if(valor == "BR"){
    saida <- dados1() %>% 
      summarise(across(c(pop_a, pop_p),
                       ~sum(.x, na.rm =T))) %>% 
      mutate(tx = pop_p/pop_a)
  }else{
    saida <- dados1() %>%
      filter(DR == x)
  }
  return(saida)
}