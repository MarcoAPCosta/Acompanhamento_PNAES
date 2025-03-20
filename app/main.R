box::use(
  shiny[moduleServer,
        NS,
        reactive,
        tags],
  bslib[bs_theme,
        page_fluid,
        nav_panel,
        navset_tab,
        bs_add_rules],
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
               "Painel de acompanhamento da PNAES - 2024",
               "xxx-large"),
     tags$head(tags$style(glue("
                            
 body {{
   background:{cor_s};
 }}
 "))),
    navset_tab(
      id = ns("rede"),
      nav_panel(
        title = "Rede Presencial",
        value = "presencial",
        relatorio$ui(ns("presencial"))
      ),
      nav_panel(
        title = "Rede EAD",
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
    
    dados1 <- dados1$server("asdasd", rede_tab)
    
    selecao_p <- relatorio$server("presencial", dados, dados1, selecao_e)
    
    selecao_e <- relatorio$server("ead", dados, dados1, selecao_p)
    
    
  })
}
