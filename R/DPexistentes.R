#' Funciones para conocer las series disponibles en Datos Productivos 
#' 
#' Se carga un dataset con los datos disponibles en Datos Productivos
#' Para conocer los datos y visualizar: https://indicadoresargentina.produccion.gob.ar/inicio
#' Todos los datos fueron relevados por el Centro de Estudios para la Produccion XXI
#' 
#' @name DPexistentes
#' 
#' @return A matrix of the infile
#' @export

DPexistentes <- function(){
  f <- file.path(tempdir(),'/DP - existentes.rda')
  if(file.exists(f)){
    load(f)
  } else {
    dp_existentes <- jsonlite::fromJSON('https://indicadoresargentina.produccion.gob.ar/api/indicadores?nocache=1675634462049')
    dp_existentes$data <- NULL
    dp_existentes <- dplyr::mutate(dp_existentes,id = 1:dplyr::n())
    dp_existentes <- dplyr::select(dp_existentes,-c(crecimientoMejor,rangoNoVariacion,variacionAMostrar,tope))
    save(dp_existentes,file = f,version = 2)
    rm(dp_existentes)
    load(f)
  }
  return(dp_existentes)
}