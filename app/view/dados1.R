box::use(
  shiny[moduleServer, NS, reactiveTimer, reactive, icon],
)

box::use(
  f_importar = app/logic/f_import1[f_importar]
)

#' @export
server <- function(id, selecao) {
  moduleServer(id, function(input, output, session) {
    
    
    dados1 <- reactive({
      x <- selecao()
      saida <- f_importar(x)
      
      return(saida)
      
    })
    
    
    return(dados1)
    
  })
}