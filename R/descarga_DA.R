#' Funciones para descargar Datos de Datos Abiertos 
#' 
#' Esta funcion sirve para cargar los posibles cruces que pueden
#' realizarse con la informacion disponible en Datos Abiertos.
#' Todos los datos fueron provistos por el Centro de Estudios para la Produccion XXI
#' 
#' @name descarga_DA
#' 
#' @param index_base Valor que toma la columna en el dataset que se quiere descargar
#' @param genero Puede tomar valor SI o NO
#' @param jurisdiccion Puede tomar los siguientes valores: NO, Departamento vivienda, Provincia trabajo, Departamento fiscal, Provincia vivienda
#' @param universo Puede tomar los siguientes valores: NO, Privado, Total empresas, Público, Total empleo
#' @param sector Puede tomar los siguientes valores: NO, Letra, CLAE2, CLAE3, CLAE6
#' @param tipo Puede tomar los siguientes valores: Percentil Salario, Salario Mediano, Salario prom por depto y sector, Puestos provincia y sector, Salario mediano por provincia y sector, Var. mediana facturación, Cant empleadoras, Puestos depto, Salario promedio, Salario mediano por depto y sector, Salario prom por provincia y sector, % Muj provincia y sector, Puestos por sector, % Muj por sector
#' @param show_info_DA Valor T/F. Muestra el nombre de la base descargada, su descripción y el link de acceso a la metodología
#' @return A matrix of the infile
#' @export


#Cargar URLs
#save(datos, file = "data/Descargar DA - URL - Datasets.rda", version = 2)
load("data/da_urls.rda")

# Armar listados por tipo de datos 
nombre_dato <- unique(da_urls$Dato)
genero_posible <- unique(da_urls$Genero)
jurisdiccion_posible <- unique(da_urls$Jurisdiccion)
universo_posible <- unique(da_urls$Universo)
sector_posible <- unique(da_urls$Sector)

# Armar funcion para descargar dato 
descarga_DA <- function(tipo,genero,jurisdiccion,universo,sector,index_base,show_info_DA=T){
  if((missing(sector) | missing(universo) | missing(jurisdiccion) | missing(genero) | missing(tipo)) & missing(index_base)) {
    stop("Indicar todos los parámetros: tipo, genero, jurisdiccion, universo y sector. En caso contrario, indicar valor de index")
  } else if ((missing(sector) | missing(universo) | missing(jurisdiccion) | missing(genero) | missing(tipo)) & !missing(index_base)) {
    tmp <- dplyr::filter(da_urls,
                         index==index_base)
    base_seleccionada <- tmp
    tmp <- readr::read_csv(tmp$Link.de.descarga[1],show_col_types = F)
    if(show_info_DA==T & !is.na(base_seleccionada$Metodologia)){
      message(paste0('Se descargó la base: ',unique(base_seleccionada$titulo_base),'. \nDescripción de la base: ',base_seleccionada$descripcion_base,'\nPuede encontrarse la metodología en: ',base_seleccionada$Metodologia))
    } 
    if(show_info_DA==T & is.na(base_seleccionada$Metodologia)){
      message(paste0('Se descargó la base: ',unique(base_seleccionada$titulo_base),'. \nDescripción de la base: ',base_seleccionada$descripcion_base,'\nEsta base actualmente no cuenta con metodología cargada en la página.'))
    }
    return(tmp)
  } else {
    tmp <- dplyr::filter(da_urls,
                         Dato == tipo,
                         Genero == genero,
                         Jurisdiccion == jurisdiccion,
                         Universo == universo,
                         Sector == sector)
    base_seleccionada <- tmp
    tmp <- readr::read_csv(tmp$Link.de.descarga[1],show_col_types = F)
    if(show_info_DA==T){
      message(paste0('Se descargó la base',unique(base_seleccionada$titulo_base),'. \nDescripción de la base: ',base_seleccionada$descripcion_base,'\nPuede encontrarse la metodología en: ',base_seleccionada$Metodologia))
    }
    return(tmp)
  }
}


