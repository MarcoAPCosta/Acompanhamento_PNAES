box::use(
  shiny[moduleServer, NS, tags]
)

#' @export
ui <- function(id, nome) {
  ns <- NS(id)
  
  tags$div(
    class = "caixa-valores",
    tags$h2(
      id = "titulo",
      nome
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    
  })
}
