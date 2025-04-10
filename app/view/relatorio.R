box::use(
  shiny[...],
  dplyr[...],
  bslib[card,
        card_body,
        card_header,
        layout_columns,
        value_box,
        value_box_theme],
  bsicons[bs_icon],
  stats[median],
  glue[glue]
)

box::use(
  app/view/select_DR,
  app/view/grafico_taxa,
  app/view/tp_aparelho,
  app/view/mapa,
  app/view/tabela,
  app/view/header,
  app/view/dados1_filtro,
  app/view/dados2_filtro,
  app/view/popbr,
  app/view/validos_br
)

box::use(
  app/logic/global[preenchimento_valuebox, cor_p, cor_s, brasil, preenchimento_card],
  app/logic/funcoes_auxiliares[formatar_numero],
  app/logic/funcoes_calculo[mediana, media],
  app/logic/popbrasil[validos_brasil],
  app/logic/pop_tx_[pop_b, tx_b],
  app/logic/dados_filtro[d1]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  
  list(
    #ui1
    card(
      style = "margin-top: 20px",
      card_header("População e cadastro",
                  style = glue("font-size: 24px;
                            text-align: center;
                            background-color: {cor_s};
                            color: white;")),
      card_body(style = glue("
  background: {cor_p};
  );
  color: white;
"),
                layout_columns(
                  col_widths = c(3, 3, 3, 3),
                  select_DR$ui(ns("selecao")),
                  
                  value_box(
                    title = "População Alvo:",
                    value = textOutput(ns("popalvo")),
                    showcase = bs_icon("people-fill"),
                    theme = value_box_theme(fg = "black",
                                            bg = preenchimento_valuebox)
                  ),
                  value_box(
                    title = "População Alvo com contato:",
                    value = textOutput(ns("poppesq")),
                    showcase = bs_icon("person-check-fill"),
                    theme = value_box_theme(fg = "#000",
                                            bg = preenchimento_valuebox)
                  ),
                  value_box(
                    title = "Taxa de Cobertura:",
                    value = textOutput(ns("taxacob")),
                    showcase = bs_icon("percent"),
                    theme = value_box_theme(fg = "#000",
                                            bg = preenchimento_valuebox)
                  )
                )
      )
    ),
    #ui2
    card(
      card_header("Informações do acesso ao questionário",
                  style =  glue("font-size: 24px;
                            text-align: center;
                            background-color: {cor_s};
                            color: white;")),
      card_body(style = glue("
  background: {cor_p};
  );
  color: white;
"),
                layout_columns(
                  col_widths = c(2, 6, 4),
                  # header$ui(ns("titulo2"),
                  #           "Informações do acesso ao questionário"),
                  layout_columns(
                    col_widths = c(12,12,12),
                    value_box(
                      title = "Total de Acessos:",
                      value = textOutput(ns("acessos")),
                      theme = value_box_theme(fg = "#000",
                                              bg = preenchimento_valuebox)
                    ),
                    value_box(
                      title = "Tempo médio de resposta:",
                      value = textOutput(ns("medio")),
                      theme = value_box_theme(fg = "#000",
                                              bg = preenchimento_valuebox)
                    ),
                    value_box(
                      title = "Tempo mediano de resposta:",
                      value = textOutput(ns("mediana")),
                      theme = value_box_theme(fg = "#000",
                                              bg = preenchimento_valuebox)
                    )
                  ),
                  card(
                    full_screen = TRUE,
                    
                    card_body(
                      grafico_taxa$ui(ns("taxa"))
                    )
                  ),
                  
                  card(
                    full_screen = TRUE,
                    
                    card_body(
                      tp_aparelho$ui(ns("tp"))
                    )
                    
                  )
                )
      )
    ),
    #ui3
    card(
      card_header("Questionários válidos e Taxa de resposta",
                  style = glue("font-size: 24px;
                            text-align: center;
                            background-color: {cor_s};
                            color: white;")),
      
      card_body(style = glue("
  background: {cor_p};
  );
  color: white;
"),
                layout_columns(
                  col_widths = c(4, 4, 4, 6, 6),
                  value_box(
                    title = "População Alvo do Brasil:",
                    value = textOutput(ns("pop_brasil")),
                    showcase = bs_icon("people-fill"),
                    theme = value_box_theme(fg = "#000",
                                            bg = preenchimento_valuebox)
                  ),
                  value_box(
                    title = "Questionários válidos do Brasil:",
                    value = textOutput(ns("val_brasil")),
                    showcase = bs_icon("clipboard-check-fill"),
                    theme = value_box_theme(fg = "#000",
                                            bg = preenchimento_valuebox)
                  ),
                  value_box(
                    title = "Taxa de resposta do Brasil:",
                    value = textOutput(ns("tx_brasil")),
                    showcase = bs_icon("percent"),
                    theme = value_box_theme(fg = "#000",
                                            bg = preenchimento_valuebox)
                  ),
                  tabela$ui(ns("tabela")),
                  mapa$ui(ns("mapa"))
                )
      )
    )
  )
  
}

#' @export
server <- function(id, dados, dados1) {
  moduleServer(id, function(input, output, session) {
    
    selecao <- select_DR$server("selecao", dados)
    observe({
      print(selecao())
    })
    
    dados1_filtrado <- dados1_filtro$server("asdasd", dados1, selecao)
    
    dados2_filtrado <- dados2_filtro$server("asdasda", dados, selecao)
      
    
    grafico_taxa$server("taxa", dados, selecao)
    
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
      x <- dados2_filtrado() %>% count() %>% pull(n) %>% formatar_numero
    })
    
    output$medio <- renderText({
      
      media(dados2_filtrado())
       })
    
    output$mediana <- renderText({
      mediana(dados2_filtrado())
      })
    
    validos_brasil <- validos_br$server("asdasd", dados)
   
    output$val_brasil <- renderText({
      validos_brasil() %>% 
        formatar_numero()
      
    })
    
    popbrasil <- popbr$server("asdasd", dados1)
    
    
    
    output$tx_brasil <- renderText({
      tx_b(validos_brasil(), popbrasil())
      
    })
    
    output$pop_brasil <- renderText({
      pop_b(popbrasil()) 
    })
    

    
  })
}
