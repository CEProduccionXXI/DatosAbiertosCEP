#' Añadir etiquetas a departamento y provincia
#'
#' Esta función sirve para añadir las etiquetas a los departamentos y provincias de los datos descargados. 
#' Todos los datos fueron provistos por el Centro de Estudios para la Produccion XXI
#'
#' @name dicc_depto_prov
#' 
#'
#' @param data Nombre del elemento al que se quiere añadir las etiquetas
#' @return A matrix of the infile
#' @export

dicc_depto_prov <- function(data) {
  
  # Seleccionar agregacion actual de los datos 
  posibles_agregaciones <- c('codigo_departamento_indec')
  agregacion_actual <- dplyr::select(data,starts_with(posibles_agregaciones))
  agregacion_actual <- names(agregacion_actual)
  
  # Si los datos tienen alguna agregacion actualmente
  if(length(agregacion_actual) > 0){
    columnas_agregacion <- names(data)
    columnas_agregacion <- columnas_agregacion[columnas_agregacion %in% c('codigo_departamento_indec','id_provincia_indec')]
    #Joinear con los datos seleccionados 
    data <- merge(data,dicc_depto,by=columnas_agregacion,all.x=T,sort = F)
    data <- as_tibble(data)
    return(data)
  } else {
    stop(paste0('Los datos solicitados no presentan agregación alguna actualmente, por lo que no es posible añadir nuevas agregaciones.'))
  }
  
}