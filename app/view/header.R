box::use(
  shiny[moduleServer, NS, tags],
  glue[glue]
)

#' @export
ui <- function(id, nome, tamanho = "xx-large") {
  ns <- NS(id)
  
  tags$div(
    class = "caixa-valores",
    tags$h2(
      id = "titulo",
      nome,
      style = glue("
    background: url('static/images/header.svg');
    background-position: center right;
    background-size: 100%;
    font-size:{tamanho}
      ")
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    
  })
}
