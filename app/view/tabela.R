box::use(
  shiny[moduleServer, NS, reactive, req, strong, span, em, HTML, br, tags],
  bslib[card_header, card_body,
        tooltip],
  dplyr[...],
  tidyr[starts_with],
 reactable[...]
)


box::use(
  app/logic/global[opcoes, cor_tabela]
)


#' @export
ui <- function(id) {
  ns <- NS(id)
      
      reactableOutput(ns("tbl_dr"),
               width = "100%")
    

}

#' @export
server <- function(id, dados) {
  moduleServer(id, function(input, output, session) {
    
    output$tbl_dr <- renderReactable({
      trad <- data.frame(Nomes = opcoes %>% names,
                         DR = unname(opcoes),
                         stringsAsFactors = FALSE)
      
      dados_t <- dados() %>%
        left_join(trad, by = c("DR")) %>%
        filter(!is.na(valido)) %>% 
        mutate(DR = Nomes,
               .keep = "unused") %>% 
        group_by(DR) %>%
        filter(DR != "SG") %>%
        summarise(Validos = sum(valido == "valido"),
                  Total = unique(Total),
                  Taxa = (Validos/Total))
     
                  
      
      reactable(dados_t,
                pagination = FALSE,
                filterable = FALSE,
                highlight = TRUE,
                bordered = TRUE,
                striped = FALSE,
                height = 750,
                defaultColDef = colDef(format = colFormat(separators = TRUE,
                                                          locales = "pt-BR")),
                theme = reactableTheme(
                  borderColor = "#010e67",
                  color = "black",
                  highlightColor = "#e4e0e0",
                  headerStyle = list(
                    color = "white",
                    fontWeight = "bold",
                    backgroundColor = cor_tabela,
                    fontSize = "18px"
                                     )
                ),
                columns = list(
                  ead = colDef(
                    show = FALSE
                  ),
                  DR = colDef(
                    name = "Departamento Regional"
                  ),
                  Validos = colDef(
                    filterable = FALSE,
                    name = "Total de questionários válidos",
                    align = "center",
                    style = list(
                      fontSize = "16px"
                      
                    )
                                      ),
                  Total = colDef(
                    name = "População Alvo",
                    align = "center"
                  ),
                  Taxa = colDef(
                    name = "Taxa de resposta (%)",
                    filterable = FALSE,
                    format = colFormat(separators = TRUE,
                                       percent = TRUE,
                                       digits = 2),
                    align = "center",
                    style = list(
                      fontSize = "16px"
                    )
                  )
                )
                
                )
                
      
        
    })
    
  })
  }
    
