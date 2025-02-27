box::use(
  shiny[moduleServer, NS, reactiveTimer, reactive, icon, req],
  dplyr[summarise, mutate, filter, `%>%`, across]
)



#'@export
server <- function(id, dados1, selecao) {
  moduleServer(id, function(input, output, session) {
    dados1_filtrado <- reactive({req(selecao())
      valor <- selecao()
      if(valor == "BR"){
        saida <- dados1() %>% 
          summarise(across(c(pop_a, pop_p),
                           ~sum(.x, na.rm =T))) %>% 
          mutate(tx = pop_p/pop_a)
      }else{
        saida <- dados1() %>%
          filter(DR == selecao())
      }
      return(saida)
    
  })
})
}