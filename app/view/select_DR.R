box::use(
  shiny[...],
  dplyr[...],
)


#' @export
ui <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(ns("asd"))
    
    )
  

}

#' @export
server <- function(id, dados) {
  moduleServer(id, function(input, output, session) {
    
    ns <- session$ns

    output$asd <- renderUI({
      opcoes <-  dados()$DR %>% unique() %>% sort()
      
      selectInput(
        ns("dr"),
        "Escolha o departamento regional:",
        choices = c("BR", opcoes)
      )
    })
    
    saida <- reactive({
      input$dr
    })
    
    return(saida)

  })
}
