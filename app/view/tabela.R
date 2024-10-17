box::use(
  shiny[moduleServer, NS, reactive, req, strong, span, em, HTML, br, tags],
  bslib[card_header, card_body,
        tooltip],
  dplyr[...],
  tidyr[starts_with],
 reactable[...],
)


box::use(
  app/logic/global[opcoes]
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
                         DR = opcoes,
                         stringsAsFactors = FALSE)
      
      dados_t <- dados() %>%
        left_join(trad, by = c("DR"), ) %>% 
        mutate(DR = Nomes,
               .keep = "unused") %>% 
        group_by(DR, ead) %>%
        filter(DR != "SG") %>%
        summarise(Validos = sum(valido == "1"),
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
                  highlightColor = "#8aa8ff",
                  headerStyle = list(
                    color = "white",
                    fontWeight = "bold",
                    backgroundColor = "#002a54",
                    fontSize = "18px"
                                     )
                ),
                columns = list(
                  ead = colDef(
                    show = FALSE
                  ),
                  Validos = colDef(
                    filterable = FALSE,
                    name = "Válidos",
                    align = "center",
                    style = list(
                      fontSize = "16px"
                      
                    )
                                      ),
                  Total = colDef(
                    show = FALSE
                  ),
                  Taxa = colDef(
                    name = "Taxa (%)",
                    filterable = FALSE,
                    format = colFormat(separators = TRUE,
                                       percent = TRUE,
                                       digits = 1),
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
    
