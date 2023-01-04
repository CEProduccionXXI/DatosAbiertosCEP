# Funciones para acceder fácilmente a los Datos Abiertos del CEP XXI

## Descripción
La librería `DatosAbiertosCEP` tiene por objetivo colaborar en el acceso y procesamiento de los datos disponibilizados por el Centro de Estudios para la Producción XXI en la página de Datos Abiertos del Ministerio de Desarrollo Productivo (actualmente perteneciente al Ministerio de Economía).

Se busca facilitar el accceso a los datos mediante el lenguaje de programación [R](https://www.r-project.org/).

El paquete actualmente cuenta con las siguientes funciones: 

- **`descarga_DA()`**: permite la descarga de cada una de las bases disponibilizadas a través de una serie de parámetros; 

- **`DA_cruces_existentes()`**: permite ver las diferentes bases disponibilizadas junto a al nivel de desagregación disponible; 

- **`diccionario_sectores()`**: permite sumar niveles de agregación sectorial a los datos descargados. Por ejemplo, en caso de descargar información a tres dígitos (clae3) con esta función se puede agregar el clae2 y la letra a la que pertenece ese sector, junto con las descripciones de cada desagregación sectorial

- **`dicc_depto_prov()`**: permite agregar fácilmente el departamento y la provincia a la que pertenece cada dato, en caso de estar desagregado a nivel departamental. 

A su vez, el paquete permite acceder rápidamente al diccionario de departamentos y de sectores utilizado. Para ello se deberá escribir `dicc_depto` y `dicc_sector` respectivamente. 

## Autores 
Este paquete surge de un trabajo colectivo del equipo de datos del Centro de Estudios para la Producción XXI, encargado de disponibilizar la información y del armado del paquete. 

El equipo de trabajo está conformado por Pablo Sonzogni, Nicolás Sidicaro, Gisella Pasquariello, Gisel Trebotic, Ignacio Paola y Guido Sanchez.

A su vez, se agradece el acompañamiento y comentarios de Florencia Asef Horno y Daniel Schteingart (directores del CEPXXI que impulsaron la apertura de datos), así como también de Rodrigo Perelsztein y Martín Trombetta (coordinadores del área de datos del CEPXXI). 

## Instalación

El paquete actualmente se encuentra en desarrollo, por lo que se debe instalar mediante github. 

```r

# install.packages('devtools') 
# si no tiene instalado devtools

devtools::install_github("nsidicarocep/DatosAbiertosCEP")

```

## ¿Cómo usarlo? 

Con la función **`DA_cruces_existentes()`** pueden acceder a la información que puede descargarse mediante el paquete. Allí se encuentran todos los tipos de datos disponibilizados y sus distintas desagregaciones, así como un indicador único por base que permite descargarlo más fácilmente. 

```r

# Para ver los posibles cruces: 
View(DA_cruces_existentes())  

# Si se quieren ver los posibles cruces de algún dato
# por ejemplo, los datos disponibles de salario mediano para el universo de empresas privadas: 
View(DatosAbiertosCEP::DA_cruces_existentes(tipo = 'Salario mediano',universo ='Privado'))

# Esta función cuenta con cinco parámetros: 
# tipo: refiere al dato que se quiere descargar; 
# genero: indica si se quiere la base desagregada por sexo biológico o no;
# sector: indica el nivel de desagregación de actividad económica; 
# jurisdiccion: indica los diferentes niveles de desagregación geográfica que tiene el dato;
# universo: refiere al universo de empleadores con el que se quiere trabajar. Se puede escoger por empresas privadas, empresas públicas y privadas, empleadores públicos, total del empleo y NO (para los casos en los que no se indica el universo)

```

Una vez seleccionada la base con la que se quiere trabajar se puede descargar con:

```r

# Se deberán indicar los cruces buscados. Se deben utilizar los cinco parámetros mencionados arriba
# Por ejemplo: 
datos <- descarga_DA(tipo = 'Salario mediano', universo = 'Privado',sector = 'Letra', jurisdiccion = 'NO',genero='NO') 

# Otra opcion para descargar el dato es mediante el index de la base: 
datos2 <- descarga_DA(index_base=32)

# Estos datos serán iguales

# La función cuenta con el parámetro show_info_DA para facilitar el ingreso a la metodología de la base. 
# Este parámetro por default es verdadero, pero pueden desactivarlo llegado el caso. 

```

Cuando los datos se hayan descargado podrán añadir información referida al sector y a la desagregación geográfica, si es que el dataset descargado incluye dicho dato. 

```r 
# Añadir sector 
datos <- diccionario_sectores(datos, # Nombre de la base a la que se quiere añadir la información
                                                agregacion = 'letra', # Nivel de agregación que se quiere sumar datos 
                                                descripciones=T) # Indicar si se quiere sumar la descripción o no
                                                
# Añadir departamento 
test <- descarga_DA(index_base = 19) # Para descargar alguna base que tenga departamento 
test <- dicc_depto_prov(test) # Nombre de la base a la que se quiere añadir la información

```

## Aportes 
El paquete actualmente se encuentra en desarrollo, por lo que se irá actualizando con el correr de los meses. 
Si encuentran algún error o quieren proponer alguna funcionalidad que no fue tenida en cuenta se agradecerán los comentarios mediante esta plataforma. 






