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
  app/view/tabela,
  app/view/header,
)

box::use(
  app/logic/global[brasil]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  
  list(
    #ui1
    layout_columns(
    col_widths = c(12, 3, 3, 3, 3),
    header$ui(ns("titulo1"), 
              "População e cadastro"),
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
  #ui2
  layout_columns(
    col_widths = c(12, 2, 6, 4),
    header$ui(ns("titulo2"),
              "Informações do acesso ao questinário"),
    layout_columns(
      col_widths = c(12,12,12),
    value_box(
      title = "Total de Acessos",
      value = 123
    ),
    value_box(
      title = "Tempo médio de resposta",
      value = 123
    ),
    value_box(
      title = "Tempo mediano de resposta",
      value = 123
    )
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
  #ui3
  layout_columns(
    col_widths = c(12,6,6),
    header$ui(ns("titulo3"),
              "Taxa de resposta e questionário valido"),
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
server <- function(id, dados, selecao_fora) {
  moduleServer(id, function(input, output, session) {
    
    selecao <- select_DR$server("selecao", dados, selecao_fora)
    
    grafico_taxa$server("taxa", dados)
    
    tp_aparelho$server("tp", dados, selecao)
    
    mapa$server("mapa", brasil,  dados)
    
    tabela$server("tabela", dados)
    
    
    
    return(selecao)
    
  })
}
