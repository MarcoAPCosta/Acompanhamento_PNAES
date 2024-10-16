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
    card(style = "margin-top: 20px",
      card_header("População e cadastro",
                  style = "font-size: 24px;
                  text-align: center;
                  background-color: #ffa32a;
                  color: white;
                  "),
      card_body(style = "background-color: #002a54;
                         color: white;",
                layout_columns(
                  col_widths = c(3, 3, 3, 3),
                  select_DR$ui(ns("selecao")),
                  
                  value_box(style = "background-color: #8aa8ff;
                             color: white;
                             text-align: center",
                            title = "População Alvo:",
                            value = textOutput(ns("popalvo"))
                  ),
                  value_box(style = "background-color: #8aa8ff;
                             color: white;
                             text-align: center",
                            title = "População de Pesquisa:",
                            value = textOutput(ns("poppesq"))
                  ),
                  value_box(style = "background-color: #8aa8ff;
                             color: white;
                             text-align: center",
                            title = "Taxa de Cobertura:",
                            value = textOutput(ns("taxacob"))
                  )
                )
      )
    ),
    hr(),
    #ui2
    card(
      card_header("Informações do acesso ao questionário",
                  style = "font-size: 24px;
                  text-align: center;
                  background-color: #ffa32a;
                  color: white;
                  "),
      card_body(style = "background-color: #002a54;
                         color: white;",
                layout_columns(
                  col_widths = c(2, 6, 4),
                  # header$ui(ns("titulo2"),
                  #           "Informações do acesso ao questionário"),
                  layout_columns(
                    col_widths = c(12,12,12),
                    value_box(style = "background-color: #8aa8ff;
                           color: white",
                              title = "Total de Acessos:",
                              value = textOutput(ns("acessos"))
                    ),
                    value_box(style = "background-color: #8aa8ff;
                           color: white",
                              title = "Tempo médio de resposta:",
                              value = textOutput(ns("medio"))
                    ),
                    value_box(style = "background-color: #8aa8ff;
                           color: white",
                              title = "Tempo mediano de resposta:",
                              value = textOutput(ns("mediana"))
                    )
                  ),
                  card(
                    full_screen = TRUE,
                    # card_header("Total de acessos por dia, ANQP 2024 ",
                    #             style = "font-size: 24px;
                    #          text-align: center;
                    #          background-color: #8aa8ff;
                    #          color: white;"),
                    card_body(
                      grafico_taxa$ui(ns("taxa"))
                    )
                  ),
                  
                  card(
                    full_screen = TRUE,
                    # card_header("Distribuição dos válidos, por tipo de aparelho utilizado, ANQP 2024",
                    #             style = "font-size: 24px;
                    #          text-align: center;
                    #          background-color: #8aa8ff;
                    #          color: white;"),
                    card_body(
                      tp_aparelho$ui(ns("tp"))
                    )
                    
                  )
                )
      )
    ),
    hr(),
    #ui3
    card(
      # card_header("Taxa de resposta e questionário valido",
      #             style = "font-size: 24px;
      #             text-align: center;
      #             background-color: #8aa8ff;
      #             color: white;
      #             "),
      card_body(style = "background-color: #002a54;
                         color: white;",
                layout_columns(
                  col_widths = c(6,6),
                  # header$ui(ns("titulo3"),
                  #           "Taxa de resposta e questionário valido"),
                  card(
                    full_screen = TRUE,
                    card_header("Válidos",
                                style = "font-size: 24px; 
                 text-align: center;
                 background-color: #ffa32a;
                 color: white;
                 "),
                    card_body(
                      tabela$ui(ns("tabela"))
                    )
                  ),
                  card(
                    full_screen = TRUE,
                    card_header("Taxa de resposta (%), por Departamento Regional, ANQP 2024",
                                style = "font-size: 24px;
                             text-align: center;
                             background-color: #ffa32a;
                             color: white;
                             "),
                    card_body(style = "background-color: 	#dddddd;",
                              mapa$ui(ns("mapa"))
                    )
                  )
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
    
    
    dados2_filtrado <- reactive({req(selecao())
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
      dados1_filtrado()$pop_a[1] %>% formatar_numero(ndigitos = 0)
    })
    
    output$poppesq <- renderText({
      dados1_filtrado()$pop_p[1] %>% formatar_numero(ndigitos = 0)
    })
    
    output$taxacob <- renderText({
      dados1_filtrado()$tx[1] %>% formatar_numero(percent = T)
    })
    
    output$acessos <- renderText({
      dados2_filtrado() %>% count() %>% pull(n) %>% formatar_numero
    })
    
    output$medio <- renderText({
      dados2_filtrado() %>%
        summarise(media = round(mean(tempo), 2)) %>% 
        pull(media) %>%
        formatar_numero() %>% 
        paste("mins")
    })
    
    output$mediana <- renderText({
      dados2_filtrado() %>% 
        summarise(mediana = round(median(tempo), 2)) %>%
        pull(mediana) %>%
        formatar_numero %>% 
        paste("mins")
    })
    
    return(selecao)
    
  })
}
