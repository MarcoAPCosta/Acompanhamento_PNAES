box::use(
  shiny[...],
  dplyr[...],
)


#' @export
ui <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(
      ns("dr"),
        "Escolha o departamento regional:",
        choices = NULL
      )
    )
  

}

#' @export
server <- function(id, dados) {
  moduleServer(id, function(input, output, session) {
    observe({
      opcoes <-  dados()$DR %>% unique() %>% sort()
      updateSelectInput(session, "dr", choices = c("BR", opcoes))
    })
    
    saida <- reactive({
      input$dr
    })
    
    return(saida)

  })
}
