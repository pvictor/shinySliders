#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyWidgets)
library(htmltools)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Old Faithful Geyser Data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      uiOutput("custom_slider")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  # create reactiveVal to store dependencies
  temp <- reactiveValues(dep = NULL)
  
  # show an alert to select the slider css
  observe({
    if (is.null(input$slider_skin)) {
      sendSweetAlert(
        session = session,
        type = "warning",
        title = "Choose a slider skin",
        text =  column(width = 6, align = "center",
          selectInput(
            inputId = "slider_skin", 
            label = "",
            choices = c(
              "",
              "Shiny",
              "Flat", 
              "Modern", 
              "Nice",
              "Simple",
              "HTML5",
              "Round",
              "Square"
            )
          )
        )
      )
    }
  })
  
  # create a dependency as in the original shiny code
  observeEvent(input$slider_skin,{
    temp$dep <- list(
      htmlDependency(
        "ionrangeslider", "2.1.6", c(href="shared/ionrangeslider"),
        script = "js/ion.rangeSlider.min.js",
        # ion.rangeSlider also needs normalize.css, which is already included in
        # Bootstrap.
        stylesheet = c(
          "css/ion.rangeSlider.css",
           paste0("css/ion.rangeSlider.skin", input$slider_skin,".css")
        )
      )
    )
  })
  
  # create custom skin slider Input
  output$custom_slider <- renderUI({
    req(input$slider_skin)
    print(temp$dep)
    # attach the newly created dependency to the sliderInput
    attachDependencies(
      sliderInput(
        inputId = "bins",
        label = "Number of bins:",
        min = 1,
        max = 50,
        value = 30
      ),
      temp$dep,
      append = FALSE
    )
  })
  
  output$distPlot <- renderPlot({
    req(input$bins)
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2] 
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

