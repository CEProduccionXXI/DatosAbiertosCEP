#' Añadir etiquetas a sector
#'
#' Esta función sirve para añadir las etiquetas a los sectores de los datos descargados. 
#' A su vez, permite añadir agregaciones mayores. De esta forma se pueden agregar los datos a otro nivel o bien filtrar la información por algún sector en particular. 
#' Todos los datos fueron provistos por el Centro de Estudios para la Produccion XXI
#'
#' @name diccionario_sectores
#' 
#'
#' @param data Nombre del elemento al que se quiere añadir las etiquetas
#' @param agregacion_deseada Vector con los sectores que se quieren añadir. Posibles opciones: c("clae6","clae3","clae2","letra"). Default = todas las agregaciones
#' @param descripciones Parámetro T/F: se indica si se quieren agregar la descripción de cada sector o no. Default == T
#' @return A matrix of the infile
#' @export

# Armar funcion
diccionario_sectores <- function(data, agregacion_deseada = c('clae6','clae3','clae2','letra'),descripciones=T) {
  # Seleccionar agregacion actual de los datos 
  posibles_agregaciones <- c('clae6','clae3','clae2','letra')
  agregacion_actual <- dplyr::select(data,starts_with(posibles_agregaciones))
  agregacion_actual <- names(agregacion_actual)
  
  # Si los datos tienen alguna agregacion actualmente
  if(length(agregacion_actual) > 0){
    # Armar vector con posibles agregaciones dada la agregacion efectiva de los datos 
    posibles_agregaciones <- c('clae6','clae3','clae2','letra')
    agregacion_deseada <- posibles_agregaciones[posibles_agregaciones %in% agregacion_deseada]
    posibles_agregaciones <- posibles_agregaciones[match(agregacion_actual,posibles_agregaciones):length(posibles_agregaciones)]
    
    #Armar el vector de la agregacion deseada 
    agregacion_deseada <- unique(c(agregacion_actual,agregacion_deseada))
    agregacion_deseada_inicial <- agregacion_deseada
    agregacion_deseada <- agregacion_deseada[agregacion_deseada %in% posibles_agregaciones]
    
    # Seleccionar los datos a agregar 
    if (descripciones ==T) {
      dicc_sector_tmp <- unique(dplyr::select(dicc_sector,starts_with(agregacion_deseada)))
    } else {
      dicc_sector_tmp <- unique(dplyr::select(dicc_sector,starts_with(agregacion_deseada)))
      dicc_sector_tmp <- dplyr::select(dicc_sector_tmp,-contains('desc'))
    }
    
    #Joinear con los datos seleccionados 
    data <- merge(data,dicc_sector_tmp,by=agregacion_actual,all.x=T,sort = F)
    
    # Agregar advertencia si agregacion desesada es mas largo que posibles agregaciones 
    if(length(posibles_agregaciones) < length(agregacion_deseada_inicial)) {
      warning(paste0('La adición de agregaciones sectoriales es posible para categorías más agrupadas de los datos.\nNo es posible añadir una agregación más desagregada que la efectiva de los datos'))
    }
    data <- dplyr::as_tibble(data)
    return(data)
  } else {
    stop(paste0('Los datos solicitados no presentan agregación alguna actualmente, por lo que no es posible añadir nuevas agregaciones.'))
  }
  
}
