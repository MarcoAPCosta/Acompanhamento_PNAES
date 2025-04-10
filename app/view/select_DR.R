box::use(
  shiny[...],
  dplyr[...],
)

box::use(
  app/logic/global[opcoes]
)


#' @export
ui <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(
      ns("dr"),
      "Escolha o Departamento Regional:",
      choices = c("Brasil" = "BR", opcoes)
    )
    
    )
  

}

#' @export
server <- function(id, dados) {
  moduleServer(id, function(input, output, session) {
    
    
    saida <- reactive({
      input$dr
    })
    
    return(saida)

  })
}
