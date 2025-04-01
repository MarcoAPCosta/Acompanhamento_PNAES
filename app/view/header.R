box::use(
  shiny[moduleServer, NS, tags],
  glue[glue]
)

#' @export
ui <- function(id, nome, tamanho = "xx-large") {
  ns <- NS(id)
  
  tags$div(
    class = "caixa-valores",
    tags$div(
      id = "titulo",
      style = glue("
        margin-top: 25px;
        padding-left: 25px;
        background: url(static/images/header.svg);
        background-position: center;
        background-repeat: no-repeat;
        background-size: contain; 
        width: 100%;
        height: 200px;
        font-size: {tamanho}") 
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    
  })
}
