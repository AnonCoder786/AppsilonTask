

header <- dashboardHeader(title = p("Appsilon Task"),
                          titleWidth = 400)

body <- dashboardBody(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")),
  fluidRow(
    column(width = 6,
           box(width = NULL, solidHeader = TRUE,
               leafletOutput('Map',height = 500)%>%
                 withSpinner()),
           box(width = NULL, 
               timevisOutput("timeline")%>%
                 withSpinner()
           )
           
    ),
    column(width = 6,
           box(width = NULL, title =tagList(shiny::icon("filter",class = 'fa-lg'), "Filter Data") ,
               solidHeader = T, collapsible = T, status = 'primary',
               selectizeInput('vernacularName','Vernacular Name', choices = c("select all",unique( poland_data$vernacularName)), width = 380,
                              selected = character(0)),
               
               selectizeInput('scientificName','Scientific Name', width = 380,
                              choices = c("select all",unique( poland_data$scientificName)),
                              selected = character(0)),
               
               actionButton("filter", "Filter",icon =icon('filter'))
           ),
           box(width = NULL, title =tagList(shiny::icon("table",class = 'fa-lg'), "Data") ,
               solidHeader = T, collapsible = T, status = 'primary',
               
               DTOutput('table') %>%
                 withSpinner()
           ),
           box(width = NULL,title = tagList(shiny::icon("info-circle",class = 'fa-lg'), "About this app"), solidHeader = T, collapsible = T, status = 'info',
               "This is an interactive map built on shiny which allows you to select
                         vernacular and Scientific Name to filter out the records . The",em("Data"),
               "Table allow to select specific data and see details on the map also able to see timeline of the event and modified time. The data is from", a('here.', href = 'https://drive.google.com/file/d/1l1ymMg-K_xLriFv1b8MgddH851d6n2sU/view', target = "_blank")
           ),
           box(width = NULL,
               icon('link', class = 'fa-lg'), a('shinyapps.io link', href = 'https://hassan-abbas.shinyapps.io/AppsilonTask/', target = "_blank"),
               br(),
               br(),
               icon('github', class = 'fa-lg'), a('Source Code', href = 'https://github.com/AnonCoder786/AppsilonTask/', target = "_blank"),
               br(),
               br(),
               icon('github-alt', class = 'fa-lg'), a('My Github Page', href = 'https://github.com/AnonCoder786/', target = "_blank"),
               br(),
               br(),
               icon('linkedin', class = 'fa-lg'), a('My Linkedin Page', href = 'https://pk.linkedin.com/in/hassan-abbas-a54231130', target = "_blank"))
           
    )
  )
)

ui <- dashboardPage(skin = 'purple',
                    title = "Appsilon Task",
                    header,
                    dashboardSidebar(disable = T),
                    body
)
