box::use(
  shiny[moduleServer, NS, reactiveTimer, reactive, icon, req],
  dplyr[summarise, mutate, filter, `%>%`, across, pull]
)


#'@export
server <- function(id, dados1) {
  moduleServer(id, function(input, output, session) {
    popbrasil <- reactive({
      
      saida <- dados1() %>% 
        summarise(pop_a = sum(pop_a, na.rm = T)) %>% 
        pull(pop_a)
      
      return(saida)
    })
    
   
    
  })}