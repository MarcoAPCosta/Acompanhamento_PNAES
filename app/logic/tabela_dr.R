box::use(dplyr[...],
         tidyr[pivot_wider])
#' @export
egressos <- function(dados){
  saida <- dados() %>%
    summarise(Total = sum(unique(Total)),
              .by = c(ead, DR)) %>%
    pivot_wider(names_from = ead,
                values_from = Total,
                names_glue = "Total_{ead}") %>%
     mutate(Total = rowSums(select(., Total_0, Total_1),
                            na.rm = T)) %>%
            Total_1 = Total_0*2) %>%
     rename(Total_2 = Total_1,
           Total_1 = Total_0) %>%
    arrange(DR)
  
  return(saida)
}

#' @export
validos <- function(dados){
  
  saida <- dados() %>%
    filter(!is.na(valido)) %>%
    summarise(Validos = n(),
              .by = c(ead,DR)) %>%
    pivot_wider(names_from = ead,
                values_from = Validos,
                names_glue = "Validos_{ead}") %>%
    mutate(Validos = rowSums(select(., Validos_0, Validos_1),
                             na.rm = T)) %>%
    rename(Validos_2 = Validos_1,
           Validos_1 = Validos_0)
  
  return(saida)
  
}


#' @export
tabela <- function(egressos, validos){
  saida <- egressos %>%
    left_join(validos) %>%
    mutate(Taxa = Validos/Total)
  
  return(saida)
  
}

#' @export
brasil <- function(tabela){
  saida <- tabela %>%
    summarise(DR = "BR",
              across(where(is.numeric),
                     ~sum(.x))) %>%
    mutate(Taxa = round(Validos/Total*100, 2),
           Taxa = paste0(format(Taxa,
                                big.mark = ".",
                                decimal.mark = ","), "%"),
           across(c(starts_with("Total"),
                    starts_with("Validos")),
                  ~format(.x,
                          big.mark = ".",
                          decimal.mark = ",")))
  
  return(saida)
}