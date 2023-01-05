#' Funciones para generar Diccionario de datos para bajar 
#' 
#' Esta funcion sirve para cargar los posibles cruces que pueden
#' realizarse con la informacion disponible en Datos Abiertos.
#' Todos los datos fueron provistos por el Centro de Estudios para la Produccion XXI
#' 
#' @name DA_cruces_existentes
#' 
#' @param genero Puede tomar valor SI o NO
#' @param jurisdiccion Puede tomar los siguientes valores: NO, Departamento vivienda, Provincia trabajo, Departamento fiscal, Provincia vivienda
#' @param universo Puede tomar los siguientes valores: NO, Privado, Total empresas, Público, Total empleo
#' @param sector Puede tomar los siguientes valores: NO, Letra, CLAE2, CLAE3, CLAE6
#' @param tipo Puede tomar los siguientes valores: Percentil Salario, Salario Mediano, Salario prom por depto y sector, Puestos provincia y sector, Salario mediano por provincia y sector, Var. mediana facturación, Cant empleadoras, Puestos depto, Salario promedio, Salario mediano por depto y sector, Salario prom por provincia y sector, % Muj provincia y sector, Puestos por sector, % Muj por sector
#' @return A matrix of the infile
#' @export


#Cargar URLs
load(url('https://github.com/nsidicarocep/DatosAbiertosCEP/blob/main/data/da_urls.rda?raw=true'))

# Armar listados por tipo de datos 
nombre_dato <- unique(da_urls$Dato)
genero_posible <- unique(da_urls$Genero)
jurisdiccion_posible <- unique(da_urls$Jurisdiccion)
universo_posible <- unique(da_urls$Universo)
sector_posible <- unique(da_urls$Sector)

# Armar diccionario de datos posibles de descargar 
DA_cruces_existentes <- function(tipo,genero,jurisdiccion,universo,sector){
  if(missing(tipo)){
    tipo <- nombre_dato
  }
  if(missing(genero)){
    genero <- genero_posible
  }
  if(missing(jurisdiccion)){
    jurisdiccion <- jurisdiccion_posible
  }
  if(missing(universo)){
    universo <- universo_posible
  }
  if(missing(sector)){
    sector <- sector_posible
  }
  tmp <- dplyr::filter(
    da_urls,Dato %in%c(tipo),
    Genero %in% c(genero),
    Jurisdiccion %in% c(jurisdiccion),
    Universo %in% (universo),
    Sector %in% c(sector)
  )
  tmp$Link.de.descarga <-NULL
  tmp <- dplyr::select(tmp,index,Dato,Universo,Sector,Jurisdiccion,Genero,Fecha_inicio,Fecha_final)
  # tmp <- tmp %>% 
  #   select(Dato,everything())
  # #View(tmp)
  return(tmp)
}


