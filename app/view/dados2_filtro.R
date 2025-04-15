box::use(
  shiny[moduleServer, NS, reactiveTimer, reactive, icon, req],
  dplyr[summarise, mutate, filter, `%>%`, across]
)



#'@export
server <- function(id, dados, selecao, sem = 1) {
  moduleServer(id, function(input, output, session) {
    dados2_filtrado <- reactive({req(selecao())
      
      valor <- selecao()
      
      if(valor == "BR"){
        saida <- dados() %>% 
          filter(semestre == sem)}else{
          saida <- dados() %>% 
            filter(semestre == sem) %>% 
            filter(DR == selecao())
        }
      return(saida)
    })

})}
