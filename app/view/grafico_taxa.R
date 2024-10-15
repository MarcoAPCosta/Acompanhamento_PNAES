box::use(
  shiny[...],
  bslib[card_header,card_body],
  dplyr[`%>%`,
        filter],
  echarts4r[e_chart,
            e_bar,
            e_legend,
            e_tooltip,
            echarts4rOutput,
            renderEcharts4r,
            e_theme_custom,
            e_y_axis,
            e_title],
  htmlwidgets[JS],
  glue[glue]
  
)

box::use(
  grafico_tempo_t = app/logic/grafico_tempo_a[tabela_Geracao],
  titulo_grafico_t = app/logic/titulo_grafico_a[transformar_titulo]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  echarts4rOutput(outputId = ns("chart_tempo_1"))
      
    
  
}

#' @export
server <- function(id, dados) {
  moduleServer(id, function(input, output, session) {
    
    output$chart_tempo_1 <- renderEcharts4r({
      
      dados_aqui <- dados() %>%
        dplyr::filter(dt.conclusao  >= "2024-04-10 00:00:00")
      
      titulo <- transformar_titulo(dados_aqui) %>% round()
      titulo <- paste0("Média de acessos por dia: ", titulo)
      
      tabela <- tabela_Geracao(dados_aqui)
      
      
      grafico <- tabela %>%
        e_chart(Data) %>%
        e_bar(Acessos) %>%
        e_legend(show = FALSE) %>%
        e_tooltip(valueFormatter =  JS('function(value) {
        var fmt = new Intl.NumberFormat("pt-BR",
        {style:"decimal",
        minimumFractionDigits:0,
        maximumFractionDigits:0});
        return fmt.format(value);
      }')) %>%
        e_theme_custom('{"color":["#002a54"]}') %>%
        e_y_axis(formatter = JS('function(value) {
        var fmt = new Intl.NumberFormat("pt-BR",
        {style:"decimal",
        minimumFractionDigits:0,
        maximumFractionDigits:0});
        return fmt.format(value);
      }'),
                 axisLabel = list(fontSize = 14)) %>%
        e_title(text = "Total de acessos por dia, ANQP 2024",
                textStyle = list(fontSize = 18,
                                 fontStyle = "normal"),
                subtext = titulo, 
                subtextStyle = list(fontSize = 14,
                                 fontStyle = "italic"))
      
      
      return(grafico)
      
    })
    
    
  })
}