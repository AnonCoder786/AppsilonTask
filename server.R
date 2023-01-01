

server <- function(input, output, session) {
  
  #render Data Table
  output$table = renderDT( selection = 'single',
                           poland_data, options = list(scrollX = TRUE,iDisplayLength = 5,lengthChange = FALSE)
  )
  #render Leaflet map
  output$Map <- renderLeaflet({
    
    leaflet(poland_data) %>% 
      addTiles() %>%
      fitBounds(~min(longitudeDecimal), ~min(latitudeDecimal), ~max(longitudeDecimal), ~max(latitudeDecimal)) %>% 
      addProviderTiles(providers$JusticeMap.plurality) 
    
  })
  #Render Timevis chart for the Event and Modified Time
  output$timeline <- renderTimevis( {
    
    if (nrow(filteredData$data ) != 0) {
      data <- data.frame(
        id = 1:2,
        start = c(min( filteredData$data$eventDate),min(filteredData$data$modified)),
        end = c(max(  filteredData$data$eventDate) , max(filteredData$data$modified)),
        content = c("Event Time Range" ,"Event Modified Range"),
        title = "EVent and modified time of the species ",
        style = c(' background-color:transparent;border-width: 3px;color:purple; font-weight: bold;','background-color:transparent;border-width: 4px; border-color: red;color:purple;font-weight: bold;')
        
      )
      
      timevis(
        data,
        options = list(editable = TRUE, multiselect = TRUE, align = "center")
      )
    } else {
      timevis(
        data.frame(),
        options = list(editable = TRUE, multiselect = TRUE, align = "center")
      )
    }
    
  }
  
  
  )
  
  #Create reactive value to handle the filteration by scientificName and vernacularName
  filteredData <- reactiveValues(data = poland_data)
  
  #When Filter button Clicked
  observeEvent(input$filter ,{
    isolate({
      #Filter data based on scientific Name and vernacularName
      scientificNameFilter =  input$scientificName
      if (input$scientificName == "select all"){
        scientificNameFilter = unique(poland_data$scientificName )
      }
      vernacularNameFilter = input$vernacularName
      if (input$vernacularName == "select all"){
        vernacularNameFilter =  unique(poland_data$vernacularName )
      }
      
      
      filteredData$data = poland_data[ poland_data$scientificName %in% scientificNameFilter & poland_data$vernacularName %in% vernacularNameFilter,]
      
      #Render Data Table
      output$table = renderDT(selection = 'single',
                              filteredData$data, options = list(scrollX = TRUE,iDisplayLength = 5,lengthChange = FALSE)
      )
      
      
      #Change the view of the map when data is filtered.
      if (nrow( filteredData$data) == 0) {
        leaflet::leafletProxy("Map", data = filteredData$data, session) %>%
          clearMarkers()%>%
          clearShapes()
        
        
      } else {
        leaflet::leafletProxy("Map", data = filteredData$data, session) %>%
          clearMarkers()%>%
          clearShapes() %>%
          
          fitBounds(~min(longitudeDecimal), ~min(latitudeDecimal), ~max(longitudeDecimal), ~max(latitudeDecimal)) 
        
        
        
        
      }
      
    })
    
    
  })
  
  #When Data table row clicked
  observe( {
    
    if(!is.null(input$table_rows_selected))  {
      
      #add circle and marker to the map 
      
      selectedData = filteredData$data[input$table_rows_selected,]
      popup = paste(
        "<b>ID : <a href=",selectedData$occurrenceID,">",selectedData$id,"</a></b>", "<br/>",
        "Scientific Name : " , selectedData$scientificName , "<br/>" ,
        "Vernacular Name : " , selectedData$vernacularName , "<br/>" ,
        "Individual Count : " , selectedData$individualCount , "<br/>" ,
        "Life Stage : " , selectedData$lifeStage , "<br/>" ,
        "Sex : " , selectedData$sex , "<br/>" ,
        "Coordinate Uncertainty (Meters) : " , selectedData$coordinateUncertaintyInMeters , "<br/>" ,
        "Locality : " , selectedData$locality , "<br/>" ,
        "Event Date : " , selectedData$eventDate , "<br/>" ,
        "Last Modified : " ,selectedData$modified , "<br/>" 
      ) 
      leaflet::leafletProxy("Map",data= selectedData,  session) %>%
        clearMarkers()%>%
        clearShapes() %>%
        addMarkers(lng = ~longitudeDecimal, lat = ~latitudeDecimal,
                   label = ~(locality),
                   popup =~(popup)
        ) %>%
        addCircles(lng = ~longitudeDecimal, lat = ~latitudeDecimal, weight = 1,
                   radius = ~50
        ) %>%
        setView(lng =  selectedData$longitudeDecimal, lat =  selectedData$latitudeDecimal, zoom=14)
      
      #Also display selected object event Date and modified Date to the timevis
      output$timeline <- renderTimevis( {
        
        if (nrow(filteredData$data ) != 0) {
          data <- data.frame(
            id = 1:4,
            start = c(min( filteredData$data$eventDate),min(filteredData$data$modified) ,selectedData$eventDate,selectedData$modified),
            end = c(max(  filteredData$data$eventDate) , max(filteredData$data$modified),NA,NA),
            content = c("Event Time Range" ,"Event Modified Range", paste(selectedData$id , "Event Time(",selectedData$eventDate,")"),paste(selectedData$id , "Event Modified(",selectedData$modified,")")),
            style = c(' background-color:transparent;border-width: 3px;color:purple; font-weight: bold;','background-color:transparent;border-width: 4px; border-color: red;color:purple;font-weight: bold;')
            
          )
          
          timevis(
            data,
            options = list(editable = FALSE, multiselect = FALSE, align = "center")
          )
        } else {
          timevis(
            data.frame(),
            options = list(editable = FALSE, multiselect = FALSE, align = "center")
          )
        }
        
      }
      
      
      )
      ##
      
      
    } else {
      leaflet::leafletProxy("Map",data = filteredData$data,  session) %>%
        clearMarkers()%>%
        clearShapes() %>%
        
        fitBounds(~min(longitudeDecimal), ~min(latitudeDecimal), ~max(longitudeDecimal), ~max(latitudeDecimal))
      
      output$timeline <- renderTimevis( {
        
        if (nrow(filteredData$data ) != 0) {
          data <- data.frame(
            id = 1:2,
            start = c(min( filteredData$data$eventDate),min(filteredData$data$modified) ),
            end = c(max(  filteredData$data$eventDate) , max(filteredData$data$modified)),
            content = c("Event Time Range" ,"Event Modified Range" ),
            title = "EVent and modified time of the species ",
            style = c(' background-color:transparent;border-width: 3px;color:purple; font-weight: bold;','background-color:transparent;border-width: 4px; border-color: red;color:purple;font-weight: bold;')
            #style = c("color: red;")
          )
          
          timevis(
            data,
            options = list(editable = TRUE, multiselect = TRUE, align = "center")
          )
        } else {
          timevis(
            data.frame(),
            options = list(editable = TRUE, multiselect = TRUE, align = "center")
          )
        }
        
      }
      
      
      )
    }
    
    
  })
  
  
  
  
  
}