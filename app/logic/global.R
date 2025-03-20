box::use(
  shiny[h3,
        HTML,
        tags]
)

#' @export
brasil <- readRDS("app/data/br_uf_shape.Rds")

#' @export
opcoes <- readRDS("app/data/opcoes.Rds")

#' @export
dados_p <- readRDS("app/data/dados_p.rds")

#' @export
pop1 <- 400000

#' @export
titulo_mapa <- tags$div(
  h3("Taxa de resposta (%), por Departamento Regional, PNAES 2024", 
     style = " color: black;
    font-weight: bold;
    font-size: 28px;")
)  

#' @export
cor_p <- "#010e67"

#' @export
cor_s <- "#8853c3"

#' @export
cor_s1 <- "#7bd0f0"

#' @export
cor_s2 <- "#e4e0e0"

#' @export
cor_extra <- "#A7CBDC"

#'@export
cor_tabela <- "#7982E5"

#' @export
palheta_mapa <- c("#000D66", "#4B6AA9", "#7AD0F0", "#B5D8E8", "#E4DFDF")

#' @export
preenchimento_valuebox <- "#e4e0e0"

#' @export
preenchimento_card <- c("#010E67", "#2647B2", "#4D85E5", "#7BD0F0")