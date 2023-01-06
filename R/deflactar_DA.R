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
  tmp <- dplyr::filter(ipc_base_2016,fecha == mes_base)
  data <- dplyr::mutate(data,indice_mes_base = tmp$indice)
  data <- dplyr::left_join(data,ipc_base_2016,by='fecha')
  data <- dplyr::mutate(data,indice_mes_base = indice_mes_base / indice)
  data <- mutate(data,precio_constante = !!sym(variable_actual)*indice_mes_base)
  data <- data %>% select(variables_base,precio_constante)
  return(data)
}
