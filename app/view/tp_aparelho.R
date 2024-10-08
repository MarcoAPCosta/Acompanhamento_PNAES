box::use(
  shiny[moduleServer, NS, renderPlot, plotOutput, strong],
  bslib[card_header,card_body],
  dplyr[tibble, `%>%`, count, n, summarise,
        group_by, mutate, filter, case_when],
  echarts4r[e_charts,e_pie,e_title,
            e_brush, e_tooltip,
            echarts4rOutput, renderEcharts4r,
            e_theme_custom, e_legend, e_labels],
  stringr[str_detect],
  htmlwidgets[JS]
  
)

#' @export
ui <- function(id) {
  ns <- NS(id)
      echarts4rOutput(outputId = ns("grafico_dr_1"))
      
    
  
}

#' @export
server <- function(id, dados, filtro) {
  moduleServer(id, function(input, output, session) {
    
    
    output$grafico_dr_1 <- renderEcharts4r({
      if(length(filtro()) < 1){
        linha <- "."
        check <- F
      } else {
        if(filtro() == "BR"){
          linha <- "."
          check <- F
        }else{
          linha <- filtro()
          check <- T
        }
      }
      
      titulo <- case_when(linha == "AC" ~ "Acre",
                          linha == "AL" ~ "Alagoas",
                          linha == "AM" ~ "Amazonas",
                          linha == "AP" ~ "Amapá",
                          linha == "BA" ~ "Bahia",
                          linha == "CE" ~ "Ceará",
                          linha == "DF" ~ "Distrito Federal",
                          linha == "ES" ~ "Espírito Santo",
                          linha == "GO" ~ "Goiás",
                          linha == "MA" ~ "Maranhão",
                          linha == "MG" ~ "Minas Gerais",
                          linha == "MS" ~ "Mato Grosso do Sul",
                          linha == "MT" ~ "Mato Grosso",
                          linha == "PA" ~ "Pará",
                          linha == "PB" ~ "Paraíba",
                          linha == "PE" ~ "Pernambuco",
                          linha == "PI" ~ "Piaúi",
                          linha == "PR" ~ "Paraná",
                          linha == "RJ" ~ "Rio de Janeiro",
                          linha == "RN" ~ "Rio Grande do Norte",
                          linha == "RO" ~ "Rondônia",
                          linha == "RR" ~ "Roraima",
                          linha == "RS" ~ "Rio Grande do Sul",
                          linha == "SC" ~ "Santa Catarina",
                          linha == "SE" ~ "Sergipe",
                          linha == "SP" ~ "São Paulo",
                          linha == "TO" ~ "Tocantins",
                          .default = "Brasil")
      
      
      
      dados() %>%
        filter(!is.na(valido)) %>%
        filter(str_detect(DR, linha)) %>%
        count(tp.aparelho, name = "Quantidade", sort = T) %>%
        e_charts(tp.aparelho) %>%
        e_pie(Quantidade,
              percentPrecision = 1,
              center = c("65%", "50%"),
              itemStyle = list(borderColor = "rgba(0, 0, 0, 0.30)"),
              labelLine = list(show = TRUE,
                               shadowColor = 'rgba(0, 0, 0, 100)',
                               shadowBlur = 2)) %>%
        e_tooltip(valueFormatter = JS("function(value) {
          saida = value.toString().replace(',', '.');
          return saida
        }")) %>%
        e_labels(formatter = JS("function(params) {
          saida = params.percent.toString().replace('.', ',');
          return saida + '%'
        }"),
                 position = "outside",
                 fontSize = 16) %>%
        e_legend(orient = 'vertical',
                 left = "0%",
                 top = "middle",
                 itemStyle = list(borderColor =  "rgba(0, 0, 0, 1)",
                                  borderWidth =  0.5),
                 selectedMode = FALSE) %>%
        e_title(titulo)
    })
    
    
  })
}