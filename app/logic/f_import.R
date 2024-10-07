box::use(
  dplyr[`%>%`, as_tibble,
        bind_rows, mutate, case_when]
)

#' @export
f_importar <- function(){
  
 
  
  dados <- #readRDS("app/data/dados.Rds") %>%
    #bind_rows(readRDS("app/data/dados2.Rds") %>%
    #            mutate(semestre = 2)) %>%
    #NÂO COLOCA O DIRETORIO !!!!!!!
    #readRDS("C:/Users/marco.costa/Servico Nacional de Aprendizagem Comercial/GerProspecAvalEducacional - 03 - Pesquisas/02. QP/2024/6. Programas/2. Pesquisa/Acompanhamento/app/data/dados.rds") %>%
    readRDS("app/data/dados.Rds") %>% 
    as_tibble() %>%
    mutate(DR2 = case_when(DR == "AC" ~ "12",
                           DR == "AL" ~ "27",
                           DR == "AM" ~ "13",
                           DR == "AP" ~ "16",
                           DR == "BA" ~ "29",
                           DR == "CE" ~ "23",
                           DR == "DF" ~ "53",
                           DR == "ES" ~ "32",
                           DR == "GO" ~ "52",
                           DR == "MA" ~ "21",
                           DR == "MG" ~ "31",
                           DR == "MS" ~ "50",
                           DR == "MT" ~ "51",
                           DR == "PA" ~ "15",
                           DR == "PB" ~ "25",
                           DR == "PE" ~ "26",
                           DR == "PI" ~ "22",
                           DR == "PR" ~ "41",
                           DR == "RJ" ~ "33",
                           DR == "RN" ~ "24",
                           DR == "RO" ~ "11",
                           DR == "RR" ~ "14",
                           DR == "RS" ~ "43",
                           DR == "SC" ~ "42",
                           DR == "SE" ~ "28",
                           DR == "SP" ~ "35",
                           DR == "TO" ~ "17",
                           .default = NA_character_))
  return(dados)
}