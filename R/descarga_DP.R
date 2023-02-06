#' Funciones para descargar Datos de Datos Productivos 
#' 
#' Esta funcion sirve para cargar los indicadores disponibles en diferentes fuentes de datos relevadas por el CEP
#' Todos los datos fueron relevados por el Centro de Estudios para la Produccion XXI
#' 
#' @name descarga_DP
#' 
#' @param index Valor que toma la columna id en el dataset DPexistentes para la serie requerida
#' @param show_data_info Valor T/F. Muestra el nombre de la base descargada, su descripción y su fuente
#' @return A matrix of the infile
#' @export

descarga_DP <- function(index,show_data_info=T){
  f <- file.path(tempdir(),paste0('/DP - ',index,'.rda'))
  info <- DPexistentes()
  info <- dplyr::filter(info,id == index)
  if(file.exists(f)){
    load(f) 
  } else {
    data <- jsonlite::fromJSON('https://indicadoresargentina.produccion.gob.ar/api/indicadores?nocache=1675634462049')
    data <- dplyr::mutate(data,id = 1:dplyr::n())
    
    # Guardar archivos en temporal
    for(i in 1:length(data$serie)){
      dataset <- data$serie[i]
      dataset_id <- data$id[i]
      tmp <- data$data[[i]]
      tmp <- dplyr::select(tmp,c(p,v,j,ja))
      tmp <- dplyr::rename(tmp,var_mensual=j,
                           periodo = p,
                           var_anual = ja,
                           valor = v)
      tmp <- dplyr::mutate(tmp,serie = dataset,var_mensual = as.double(var_mensual),var_anual = as.double(var_anual),valor = as.double(valor))
      save(tmp,file = paste0(tempdir(),'/DP - ',dataset_id,'.rda'))
    }
    load(f)
  }
  if(show_data_info==T){
    message(paste0('Se descargó la serie: ',unique(info$serie),'\n\nDescripción de la base: ',info$descripcion,'\n\nDato informado: ',info$informa,'\n\nFuente: ',info$fuente,'\n\nUnidad de medida: ',info$um))
  }
  return(tmp)
}