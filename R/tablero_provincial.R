#' Carga tablero Shiny provincial 
#' 
#' La función se utiliza abrir un tablero dinámico en Shiny.
#' Este tablero se utiliza para analizar la información agregada a nivel provincial
#' 
#' @name tablero_provincial
#' 
#' @return A matrix of the infile
#' @export

tablero_provincial <- function(){
  require(shiny)
  require(dplyr)
  require(ggplot2)
  options(scipen = 999)
  shinyApp(
    # Define UI for application
    ui= fluidPage(
      # Application title
      titlePanel("Datos Abiertos del CEP XXI por Provincia"),
      
      mainPanel(
        selectInput(inputId = 'tabla_dato',
                    label='Provincia: ',
                    choices = c("Puestos provincia y sector", "Salario prom por provincia y sector", "Salario mediano por provincia y sector",
                                "% Muj provincia y sector")),
        selectInput(
          inputId = "tabla_universo",
          label = "Universo:",
          choices = c("Privado", "Total empresas", "Total empleo")
        ),
        selectInput(
          inputId = "tabla_provincia",
          label = "Provincia:",
          choices = c("BUENOS AIRES", "CAPITAL FEDERAL", "CATAMARCA", "CHACO", "CHUBUT", "CORDOBA", "CORRIENTES",
                      "ENTRE RIOS", "FORMOSA", "JUJUY", "LA PAMPA", "LA RIOJA", "MENDOZA", "MISIONES", "NEUQUEN",
                      "RIO NEGRO", "SALTA", "SAN JUAN", "SAN LUIS", "SANTA CRUZ", "SANTA FE", "SANTIAGO DEL ESTERO",
                      "TIERRA DEL FUEGO", "TUCUMAN"),
          multiple = T,
          selected = 'BUENOS AIRES'
        ),
        selectInput(
          inputId = "tabla_deflactar",
          label = "Precios constantes:",
          choices = c("NO", "SI")
        ),
        textInput(
          inputId = 'tabla_mes_base',
          label='Mes base: ',
          value = '2022-12-01'
        ),
        htmlOutput('text_header'),
        br(),
        tabsetPanel(
          tabPanel('Gráfico',
                   plotly::plotlyOutput('plot_da')
          )
        ),
        downloadButton("downloadcsv", "Descargar .csv"),
        downloadButton("downloadxlsx", "Descargar .xlsx")
        
      )
    ),
    server = function(input, output) {
      # Plotear
      output$plot_da <- plotly::renderPlotly({
        tmp <- DatosAbiertosCEP::descarga_DA(tipo=input$tabla_dato,
                                            jurisdiccion = 'Provincia trabajo',
                                            sector = 'NO',
                                            genero = 'NO',
                                            universo = input$tabla_universo,
                                            show_info_DA = F)
        tmp <- dplyr::filter(tmp,zona_prov %in% input$tabla_provincia)
        if(input$tabla_deflactar=='SI'){
          largo_original <- length(tmp)
          tmp <- deflactar_DA(tmp,input$tabla_mes_base)
          if(largo_original < length(tmp)) {
            tmp[,3] <- NULL
          }
        }
        variable <- names(tmp[,3])
        x1 <- tmp[[1]]
        y1 <- tmp[[3]]
        
        plot <- ggplot(tmp,aes(fecha,!!sym(variable))) + 
          geom_line(aes(color = zona_prov)) +
          scale_x_date(date_breaks = "8 months" , date_labels = "%b-%y") +
          xlab('Mes') + 
          ylab('') + 
          theme_bw() + 
          theme(axis.title = element_text(size=12,face='bold'),
                axis.text.x = element_text(angle = 90)) + 
          labs(color='Provincia')
        plotly::ggplotly(plot)
        
      })
      output$downloadcsv <- 
        downloadHandler(
          filename = function() {
            paste(input$tabla_dato, '_', input$tabla_universo, "_", input$tabla_provincia, '_', Sys.Date(), ".csv", sep="")
          },
          content = function(file) {
            tmp <- DatosAbiertosCEP::descarga_DA(tipo=input$tabla_dato,
                                                jurisdiccion = 'Provincia trabajo',
                                                sector = 'NO',
                                                genero = 'NO',
                                                universo = input$tabla_universo,
                                                show_info_DA = F) %>%
              filter(zona_prov %in% input$tabla_provincia)
            if(input$tabla_deflactar=='SI'){
              largo_original <- length(tmp)
              tmp <- deflactar_DA(tmp,input$tabla_mes_base)
              if(largo_original < length(tmp)) {
                tmp[,3] <- NULL
              }
            }
            write.csv(tmp, file)
          })
      
      output$downloadxlsx <- 
        downloadHandler(
          filename = function() {
            paste(input$tabla_dato, '_', input$tabla_universo, "_", input$tabla_provincia, '_', Sys.Date(), ".xlsx", sep="")
          },
          content = function(file) {
            tmp <- DatosAbiertosCEP::descarga_DA(tipo=input$tabla_dato,
                                                jurisdiccion = 'Provincia trabajo',
                                                sector = 'NO',
                                                genero = 'NO',
                                                universo = input$tabla_universo,
                                                show_info_DA = F) %>%
              filter(zona_prov %in% input$tabla_provincia)
            if(input$tabla_deflactar=='SI'){
              largo_original <- length(tmp)
              tmp <- deflactar_DA(tmp,input$tabla_mes_base)
              if(largo_original < length(tmp)) {
                tmp[,3] <- NULL
              }
            }
            openxlsx::write.xlsx(tmp, file)
          })
    }
  ) 
}
