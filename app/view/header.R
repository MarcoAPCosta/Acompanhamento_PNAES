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
      nome,
      style = "
    background: url('static/images/header.svg');
    background-position: center right;
    background-size: 100%;
      "
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    
  })
}
