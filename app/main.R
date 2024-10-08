box::use(
  shiny[moduleServer,
        NS,
        reactive],
  bslib[page_fluid,
        nav_panel,
        navset_tab],
)

box::use(
  app/view/relatorio,
  app/view/dados,
  app/view/header,
)


#' @export
ui <- function(id) {
  ns <- NS(id)
  
  page_fluid(
    title = "Painel de Acompanhamento ANQP",
    navset_tab(
      id = ns("rede"),
      nav_panel(title = "Rede Presencial",
                value = "presencial",
                relatorio$ui(ns("presencial"))
      ),
      nav_panel(title = "Rede EAD",
                value = "ead",
                relatorio$ui(ns("ead")))
    )
  )
    
  
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    rede_tab <- reactive({
      x <- ifelse(input$rede == "ead", 1, 0)
      return(x)
    })
    
    dados <- dados$server("asdas", rede_tab)
    
    relatorio$server("presencial", dados)
    
    relatorio$server("ead", dados)
    
    
    
    
  })
}
