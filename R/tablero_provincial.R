#' Carga tablero Shiny provincial 
#' 
#' La función se utiliza para correr el script que abre un tablero dinámico en shiny.
#' 
#' @name tablero_provincial
#' 
#' @return A matrix of the infile
#' @export

tablero_provincial <- function(){
  runApp(r'(R\shiny_app.R)')
}