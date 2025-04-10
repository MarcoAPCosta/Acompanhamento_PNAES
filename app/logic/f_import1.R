box::use(
  dplyr[`%>%`,
        as_tibble,
        bind_rows, 
        case_when,
        filter,
        mutate,
        rename]
)


f_importar <- function(){
  
  
  
  dados1 <- readRDS("app/data/dados_p.rds") %>% 
    as_tibble() %>% 
    rename(DR = DR2)
  return(dados1)
}