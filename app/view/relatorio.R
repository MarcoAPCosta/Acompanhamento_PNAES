box::use(
  shiny[bootstrapPage, div, moduleServer, NS, renderUI, tags, uiOutput,selectInput, observeEvent],
  bslib[card,
        card_body,
        card_header,
        layout_columns,
        value_box]
)

box::use(
  app/view/select_DR,
  app/view/grafico_taxa,
  app/view/tp_aparelho,
  app/view/mapa,
  app/view/tabela
)

box::use(
  app/logic/global[brasil]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  
  list(layout_columns(
    col_widths = c(3, 3, 3, 3),
    select_DR$ui(ns("selecao")),
    
    value_box(
      title = "População Alvo",
      value = 1
    ),
    value_box(
      title = "População de Pesquisa",
      value = 14
    ),
    value_box(
      title = "Taxa de Colaboradores",
      value = 1
    )
    
  ),
  layout_columns(
    col_widths = c(4, 4, 4),
    value_box(
      title = "Total de Acessos",
      value = 123
    ),
    card(
      full_screen = TRUE,
      card_header("Taxa de Acessos"),
      card_body(
        grafico_taxa$ui(ns("taxa"))
      )
    ),
    
    card(
      full_screen = TRUE,
      card_header("Tipo de aparelho"),
      card_body(
        tp_aparelho$ui(ns("tp"))
      )
      
    )
    
    
  ),
  layout_columns(
    col_widths = c(6,6),
    card(
      full_screen = TRUE,
      card_header("Total de Válidos e Taxa de Resposta"),
      card_body(
        tabela$ui(ns("tabela"))
      )
    ),
    card(
      full_screen = TRUE,
      card_header("Mapa"),
      card_body(
        mapa$ui(ns("mapa"))
      )
    )
  )
  )
  
}

#' @export
server <- function(id, dados) {
  moduleServer(id, function(input, output, session) {
    
    selecao <- select_DR$server("selecao", dados)
    
    grafico_taxa$server("taxa", dados)
    
    tp_aparelho$server("tp", dados, selecao)
    
    mapa$server("mapa", brasil,  dados)
    
    tabela$server("tabela", dados)
    
    return(selecao)
    
  })
}
