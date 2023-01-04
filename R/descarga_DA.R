#' Funciones para descargar Datos de Datos Abiertos 
#' 
#' Esta funcion sirve para cargar los posibles cruces que pueden
#' realizarse con la informacion disponible en Datos Abiertos.
#' Todos los datos fueron provistos por el Centro de Estudios para la Produccion XXI
#' 
#' @name descarga_DA
#' 
#' @param index Valor que toma la columna en el dataset que se quiere descargar
#' @param genero Puede tomar valor SI o NO
#' @param jurisdiccion Puede tomar los siguientes valores: NO, Departamento vivienda, Provincia trabajo, Departamento fiscal, Provincia vivienda
#' @param universo Puede tomar los siguientes valores: NO, Privado, Total empresas, Público, Total empleo
#' @param sector Puede tomar los siguientes valores: NO, Letra, CLAE2, CLAE3, CLAE6
#' @param tipo Puede tomar los siguientes valores: Percentil Salario, Salario Mediano, Salario prom por depto y sector, Puestos provincia y sector, Salario mediano por provincia y sector, Var. mediana facturación, Cant empleadoras, Puestos depto, Salario promedio, Salario mediano por depto y sector, Salario prom por provincia y sector, % Muj provincia y sector, Puestos por sector, % Muj por sector
#' @return A matrix of the infile
#' @export


#Cargar URLs
#save(datos, file = "data/Descargar DA - URL - Datasets.rda", version = 2)
load("data/da_urls.rda")

# Armar listados por tipo de datos 
nombre_dato <- unique(datos$Dato)
genero_posible <- unique(datos$Genero)
jurisdiccion_posible <- unique(datos$Jurisdiccion)
universo_posible <- unique(datos$Universo)
sector_posible <- unique(datos$Sector)

# Armar funcion para descargar dato 
descarga_DA <- function(tipo,genero,jurisdiccion,universo,sector,index_base){
  if((missing(sector) | missing(universo) | missing(jurisdiccion) | missing(genero) | missing(tipo)) & missing(index_base)) {
    warning("Indicar todos los parámetros: tipo, genero, jurisdiccion, universo y sector. En caso contrario, indicar valor de index")
  } else if ((missing(sector) | missing(universo) | missing(jurisdiccion) | missing(genero) | missing(tipo)) & !missing(index_base)) {
    tmp <- dplyr::filter(datos,
                         index==index_base)
    tmp <- readr::read_csv(tmp$Link.de.descarga[1],show_col_types = F)
    return(tmp)
  } else {
    tmp <- dplyr::filter(datos,
                         Dato == tipo,
                         Genero == genero,
                         Jurisdiccion == jurisdiccion,
                         Universo == universo,
                         Sector == sector)
    tmp <- readr::read_csv(tmp$Link.de.descarga[1],show_col_types = F)
    return(tmp)
  }
  
}


