box::use(
  shiny[moduleServer, NS, reactiveTimer, reactive, icon, req],
  dplyr[ filter, `%>%`]
)






#'@export
server <- function(id,dados) {
  moduleServer(id, function(input, output, session) {
    validos_brasil <- reactive({
      dados() %>%
        filter(!is.na(valido)) %>% 
        filter(valido=="valido") %>% 
        nrow()
    })
    
    
    
  })}








