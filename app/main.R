box::use(
  shiny[moduleServer,
        NS,
        reactive,
        tags],
  bslib[bs_theme,
        page_fluid,
        nav_panel,
        navset_tab],
  glue[glue]
)

box::use(
  app/view/relatorio,
  app/view/dados,
  app/view/header,
  app/view/dados1,
)

box::use(
  app/logic/global[...]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  
  page_fluid(
    title = "Painel de Acompanhamento PNAES",
     header$ui(ns("titulo"), 
               "Painel de Acompanhamento",
               "xxx-large"),
     tags$head(tags$style(glue("
                            
 body {{
   background:{cor_p};
 }}
 "))),
    relatorio$ui(ns("presencial"))
  )
  
  
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    
    dados <- dados$server("asdas")
    
    dados1 <- dados1$server("asdasd")
    
    relatorio$server("presencial", dados, dados1)
    
    
    
  })
}
