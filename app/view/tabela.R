box::use(
  shiny[moduleServer, NS, reactive, req, strong, span, em, HTML, br, tags],
  bslib[card_header, card_body,
        tooltip],
  dplyr[`%>%`,
        filter,
        pull,
        slice,
        summarise,
        group_by,
        n,
        ungroup,
        mutate,
        bind_rows],
  tidyr[starts_with],
 reactable[...],
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
      dados_t <- dados() %>%
        group_by(DR, ead) %>%
        filter(DR != "SG") %>%
        summarise(Validos = sum(valido == "valido"),
                  Total = n(),
                  Taxa = (Validos/Total))
     
                  
      
      reactable(dados_t,
                pagination = FALSE,
                filterable = FALSE,
                highlight = TRUE,
                bordered = TRUE,
                striped = TRUE,
                height = 750,
                defaultColDef = colDef(format = colFormat(separators = TRUE,
                                                          locales = "pt-BR")),
                columns = list(
                  ead = colDef(
                    show = FALSE
                  ),
                  Validos = colDef(
                    filterable = FALSE,
                    name = "Válidos",
                    align = "right"
                  ),
                  Total = colDef(
                    show = FALSE
                  ),
                  Taxa = colDef(
                    filterable = FALSE,
                    align = "right",
                    format = colFormat(separators = TRUE,
                                       percent = TRUE,
                                       digits = 1)
                  )
                )
                
                )
                
      
        
    })
    
  })
  }
    
