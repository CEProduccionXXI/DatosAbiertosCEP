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
  shinyApp(
    # Define UI for application that draws a histogram
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
                      "TIERRA DEL FUEGO", "TUCUMAN")
        ),
        htmlOutput('text_header'),
        br(),
        tabsetPanel(
          tabPanel('Gráfico',
                   plotly::plotlyOutput('pride_plot')
          )
        ),
        downloadButton("downloadData", "Descargar datos")
      )
    ),
    server = function(input, output) {
      # Plotear
      output$pride_plot <- plotly::renderPlotly({
        bu <- DatosAbiertosCEP::descarga_DA(tipo=input$tabla_dato,
                                            jurisdiccion = 'Provincia trabajo',
                                            sector = 'NO',
                                            genero = 'NO',
                                            universo = input$tabla_universo,
                                            show_info_DA = F)
        bu <- dplyr::filter(bu,zona_prov == input$tabla_provincia)
        
        variable <- names(bu[,3])
        # plotly::plot_ly(
        #   data = bu,
        #   x =  bu$fecha,
        #   y = bu[3],
        #   type='scatter',
        #   mode='lines')
        x1 <- bu[[1]]
        y1 <- bu[[3]]
        
        plotly::plot_ly(bu) %>%
          plotly::add_lines(x = x1, y = y1, name = "Red") 
        
      })
      output$downloadData <- 
        downloadHandler(
          filename = function() {
            paste(input$tabla_dato, '_', input$tabla_universo, "_", input$tabla_provincia, '_', Sys.Date(), ".csv", sep="")
          },
          content = function(file) {
            bu <- DatosAbiertosCEP::descarga_DA(tipo=input$tabla_dato,
                                                jurisdiccion = 'Provincia trabajo',
                                                sector = 'NO',
                                                genero = 'NO',
                                                universo = input$tabla_universo,
                                                show_info_DA = F) %>%
              filter(zona_prov == input$tabla_provincia)
            write.csv(bu, file)
          })
    }
  ) 
}
