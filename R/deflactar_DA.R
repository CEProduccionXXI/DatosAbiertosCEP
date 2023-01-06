#' Llevar a precios constantes las bases 
#' 
#' Se puede inflar o deflactar los datos con la función. 
#' Dados los problemas en la medición de la inflación durante 2007-2015 la base es una construcción propia del CEPXXI
#' Todos los datos fueron provistos por el Centro de Estudios para la Produccion XXI
#' 
#' @name deflactar_DA
#' 
#' @param data Dataframe que se quiere deflactar/inflar
#' @param mes_base Mes que se quiere utilizar como base para inflar/deflactar. Formato: "YYYY-MM-DD"
#' @return A matrix of the infile
#' @export

deflactar_DA <- function(data,mes_base){
  #Librerias
  require(DatosAbiertosCEP)
  require(dplyr)
  load(url('https://github.com/nsidicarocep/DatosAbiertosCEP/blob/main/data/ipc_base_2016.rda?raw=true'))
  # Detectar variables salariales 
  variables_monetarias <- c('p10','p25','w_mean','w_median','p75','p90','p99')
  # Elegir variable monetaria presente en la base actual
  variable_actual <- names(data)
  variables_base <- names(data)
  variable_actual <- variable_actual[variable_actual %in% variables_monetarias]
  # Ver si solo hay una variable monetaria o más de una 
  if(length(variable_actual)==1){
    tmp <- dplyr::filter(ipc_base_2016,fecha == mes_base)
    data <- dplyr::mutate(data,indice_mes_base = tmp$indice)
    data <- dplyr::left_join(data,ipc_base_2016,by='fecha')
    data <- dplyr::mutate(data,indice_mes_base = indice_mes_base / indice)
    data <- data %>% mutate(across(starts_with(variable_actual),
                             ~ .x *indice_mes_base,
                             .names="{.col}_constante"
    ))
    data <- data %>% select(variables_base,precio_constante)
    return(data) 
  } else if (length(variable_actual)>1){
    tmp <- dplyr::filter(ipc_base_2016,fecha == mes_base)
    data <- dplyr::mutate(data,indice_mes_base = tmp$indice)
    data <- dplyr::left_join(data,ipc_base_2016,by='fecha')
    data <- dplyr::mutate(data,indice_mes_base = indice_mes_base / indice)
    data <- data %>% 
      mutate(across(starts_with(variable_actual),
                    ~ .x *indice_mes_base,
                    .names="{.col}_constante"
                    ))
    data <- data %>% 
      select(starts_with(variables_base))
  }
}
