box::use(
  shiny[moduleServer, NS, reactiveTimer, reactive, icon, req],
  dplyr[summarise, mutate, filter, `%>%`, across]
)



#'@export
server <- function(id, dados, selecao) {
  moduleServer(id, function(input, output, session) {
    dados2_filtrado <- reactive({req(selecao())
      valor <- selecao()
      if(valor == "BR"){
        saida <- dados()}else{
          saida <- dados() %>%
            filter(DR == selecao())
        }
      return(saida)
    })

})}
