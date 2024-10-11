box::use(
  shiny[...],
  dplyr[...],
  bslib[card,
        card_body,
        card_header,
        layout_columns,
        value_box],
  stats[median],
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
  app/logic/global[brasil, dados_p, pop1],
  app/logic/funcoes_auxiliares[formatar_numero]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  
  list(
    #ui1
    card(
      card_header("População e cadastro"),
      card_body(
        layout_columns(
          col_widths = c(3, 3, 3, 3),
          # header$ui(ns("titulo1"), 
          #           "População e cadastro"),
          select_DR$ui(ns("selecao")),
          
          value_box(
            title = "População Alvo",
            value = textOutput(ns("popalvo")),
            color = "grey85"
          ),
          value_box(
            title = "População de Pesquisa",
            value = textOutput(ns("poppesq"))
          ),
          value_box(
            title = "Taxa de Cobertura",
            value = textOutput(ns("taxacob"))
          )
        )
      )
    ),
    #ui2
    layout_columns(
      col_widths = c(12, 2, 6, 4),
      header$ui(ns("titulo2"),
                "Informações do acesso ao questionário"),
      layout_columns(
        col_widths = c(12,12,12),
        value_box(
          title = "Total de Acessos",
          value = textOutput(ns("acessos"))
        ),
        value_box(
          title = "Tempo médio de resposta",
          value = textOutput(ns("medio"))
        ),
        value_box(
          title = "Tempo mediano de resposta",
          value = textOutput(ns("mediana"))
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
server <- function(id, dados, dados1, selecao_fora) {
  moduleServer(id, function(input, output, session) {
    
    selecao <- select_DR$server("selecao", dados, selecao_fora)
    
    
    
    ead_valor <- reactive({
      dados() %>%
        pull(ead) %>% 
        unique()
    })
    
    selecao1 <- reactive({req(selecao())
      dados_p |> 
        filter(DR == selecao()) |> 
        filter(ead == ead_valor())
    })
    
    dados1_filtrado <- reactive({req(selecao())
      valor <- selecao()
      if(valor == "BR"){
        saida <- dados1() %>% 
          summarise(across(c(pop_a, pop_p),
                           ~sum(.x))) %>% 
          mutate(tx = pop_p/pop_a)
      }else{
        saida <- dados1() %>%
          filter(DR == selecao())
      }
      return(saida)
    })
    
    
    dados123 <- reactive({req(selecao())
      valor <- selecao()
      if(valor == "BR"){
        saida <- dados()}else{
          saida <- dados() %>%
            filter(DR == selecao())
        }
      return(saida)
    })
    
    grafico_taxa$server("taxa", dados)
    
    tp_aparelho$server("tp", dados, selecao)
    
    mapa$server("mapa", brasil,  dados)
    
    tabela$server("tabela", dados)
    
    output$popalvo <- renderText({
      dados1_filtrado()$pop_a[1] %>% formatar_numero
    })
    
    output$poppesq <- renderText({
      dados1_filtrado()$pop_p[1] %>% formatar_numero
    })
    
    output$taxacob <- renderText({
      dados1_filtrado()$tx[1] %>% formatar_numero
    })
    
    output$acessos <- renderText({
      dados123() %>% count() %>% pull(n) %>% formatar_numero
    })
    
    output$medio <- renderText({
      dados123() %>%
        summarise(media = round(mean(tempo), 2)) %>% 
        pull(media) %>%
        formatar_numero
    })
    
    output$mediana <- renderText({
      dados123() %>% 
        summarise(mediana = round(median(tempo), 2)) %>%
        pull(mediana) %>%
        formatar_numero
    })
    
    return(selecao)
    
  })
}
