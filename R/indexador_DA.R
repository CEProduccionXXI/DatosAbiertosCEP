#' Indexar variables numéricas  
#' 
#' La función tiene por objetivo proveer un mecanismo fácil para indexar las variables numéricas. 
#' Se puede construir la indexación con el mínimo, máximo y con alguna fecha en formato YYYY-MM-DD
#' Todos los datos fueron provistos por el Centro de Estudios para la Produccion XXI
#' 
#' @name indexador_DA
#' 
#' @param data Dataframe que se quiere indexar
#' @param base_indice Indica sobre que valor se quiere indexar el dato: min, max o fecha YYYY-MM-DD
#' @param pisar_datos En caso de ser verdadero se reemplazarán las variables originales por las indexadas. Default FALSE
#' @param variables_datos_abiertos Vector con variables a indexar. Por default se indexan todas las variables posibles. En caso de querer alguna específica indicarlo en la función. 
#' @return A matrix of the infile
#' @export

indexar_DA <- function(data,base_indice,variables_datos_abiertos = c('p10','p25','w_mean','w_median','p75','p90','p99','puestos','share_mujer','var_facturacion','empresas'),variables_agrupar = 'todas',pisar_datos=F){
  #Librerias
  require(dplyr)
  #Guardar largo original de base
  largo_original <- length(data)
  # Elegir variable indexables presente en la base
  variable_actual <- names(data)
  variables_base <- names(data)
  
  # Definir variable con las que se va a agrupar la información
  if(variables_agrupar == 'todas') {
    variables_no_index <- variable_actual[!stringr::str_detect(variable_actual,paste0(c('p10','p25','w_mean','w_median','p75','p90','p99','puestos','share_mujer','var_facturacion','empresas'),collapse='|'))]
    variables_no_index <- variables_no_index[variables_no_index != 'fecha']
    if(purrr::is_empty(variables_no_index)) { 
        variables_no_index <- 'temporal'
        data <- dplyr::mutate(data,temporal = 'temporal')
      }
  } else if (variables_agrupar == 'ninguna') {
    variables_no_index <- 'temporal'
    data <- dplyr::mutate(data,temporal = 'temporal')
  } else {
    variables_no_index <- variables_agrupar
    variables_no_index <- variables_no_index[variables_no_index != 'fecha']
    if(purrr::is_empty(variables_no_index)) { 
      variables_no_index <- 'temporal'
      data <- dplyr::mutate(data,temporal = 'temporal')
    }
  }
  
  # Definir variables que se van a indexar 
  variables_index <- variable_actual[stringr::str_detect(variable_actual,paste0(variables_datos_abiertos,collapse='|'))]

  variables_no_index_originales <- variable_actual[!stringr::str_detect(variable_actual,paste0(variables_datos_abiertos,collapse='|'))]
  
  if(base_indice == 'max'){
    # Indexar contra valor máximo de cada desagregacion
    tmp <- data %>% 
      group_by(across(all_of(variables_no_index))) %>% 
      summarize(across(starts_with(variables_index),
                       ~ max(.x),
                       .names="{.col}_max"
      ))
    #Joinear para agregar los datos buscados de cada variable 
    data <- data %>% 
      left_join(tmp,by=variables_no_index)
    # Calcular el indice sobre cada variable
    for(j in 1:length(variables_index)){
      data <- data %>% 
        mutate(tmp = .data[[variables_index[j]]] *100 / .data[[paste0(variables_index[j],'_max')]] ) 
      new_names <- paste0(variables_index[j],'_index')
      data <- data %>% 
        rename_with(~ new_names, 'tmp')
    }
    #Seleccionar columnas originales y las que tienen index
    data <- data %>% 
      select(fecha,any_of(variables_no_index_originales),any_of(variables_index),ends_with('_index'))
  } else if (base_indice == 'min') {
    tmp <- data %>% 
      group_by(across(all_of(variables_no_index))) %>% 
      summarize(across(starts_with(variables_index),
                       ~ min(.x),
                       .names="{.col}_min"
      ))
    #Joinear para agregar los datos buscados de cada variable 
    data <- data %>% 
      left_join(tmp,by=variables_no_index)
    # Calcular el indice sobre cada variable
    for(j in 1:length(variables_index)){
      data <- data %>% 
        mutate(tmp = .data[[variables_index[j]]] *100 / .data[[paste0(variables_index[j],'_min')]] ) 
      new_names <- paste0(variables_index[j],'_index')
      data <- data %>% 
        rename_with(~ new_names, 'tmp')
    }
    #Seleccionar columnas originales y las que tienen index
    data <- data %>% 
      select(fecha,any_of(variables_no_index_originales),any_of(variables_index),ends_with('_index'))
    
  } else if (stringr::str_detect(base_indice,'[0-9]{4}-[0-9]{2}-[0-9]{2}')) {
    
    tmp <- data %>% 
      filter(fecha == base_indice)
    tmp <- tmp %>% 
      select(any_of(variables_index),any_of(variables_no_index))
    new_names <- paste0(variables_index,'_mes')
    tmp <- tmp %>% 
      rename_with(~ new_names, variables_index)
    tmp$fecha <- NULL
    
    #Joinear para agregar los datos buscados de cada variable 
    data <- data %>% 
      left_join(tmp,by=variables_no_index)
    # Calcular el indice sobre cada variable
    for(j in 1:length(variables_index)){
      data <- data %>% 
        mutate(tmp = .data[[variables_index[j]]] *100 / .data[[paste0(variables_index[j],'_mes')]] ) 
      new_names <- paste0(variables_index[j],'_index')
      data <- data %>% 
        rename_with(~ new_names, 'tmp')
    }
    #Seleccionar columnas originales y las que tienen index
    data <- data %>% 
      select(fecha,any_of(variables_no_index_originales),any_of(variables_index),ends_with('_index'))
    
  } else {
    warning(paste0('No se detectó correctamente la base indicada para generar el índice.\n 
                   Las opciones son: max, min o una fecha en formato YYYY-MM-DD')) 
    return(data)
  }
  if(length(data) > largo_original & pisar_datos == T){
    data <- data %>% 
      select(-any_of(variables_index))
    data <- data %>% 
      rename_with(~variables_index,ends_with('_index'))
  } else {
    return(data)
  }
}
