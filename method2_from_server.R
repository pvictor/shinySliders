


# Method 2 : from server --------------------------------------------------

# In this method, we can choose skin from server
# This apply to all sliders in the app

# But you to use a function in UI to initialize the skin and modify the dependencies to be able to modify them

# Todo : instead of recreating a complete dependency, use shiny's dep since all skins are available
# https://github.com/rstudio/shiny/tree/master/inst/www/shared/ionrangeslider/css




# Fun ---------------------------------------------------------------------


updateSliderSkinUi <- function(skin = c("Shiny", "Flat", "Modern", "Nice",
                                      "Simple", "HTML5", "Round", "Square")) {
  skin <- match.arg(arg = skin)
  singleton(
    tags$head(
      suppressDependencies("ionrangeslider"),
      tags$script(src = "shared/ionrangeslider/js/ion.rangeSlider.min.js"),
      tags$link(href = "shared/ionrangeslider/css/ion.rangeSlider.css", rel="stylesheet"),
      tags$link(href = paste0("shared/ionrangeslider/css/ion.rangeSlider.skin", skin, ".css"), rel="stylesheet", id = "skinCss"),
      tags$script(
        "Shiny.addCustomMessageHandler('update-skin', function(message) {
        var css = 'shared/ionrangeslider/css/ion.rangeSlider.skin' + message.skin + '.css';
        $('#skinCss').attr('href', css);
        });"
      )
    )
  )
}

updateSliderSkin <- function(session, skin = c("Shiny", "Flat", "Modern", "Nice",
                                      "Simple", "HTML5", "Round", "Square")) {
  skin <- match.arg(arg = skin)
  session$sendCustomMessage(
    type = "update-skin",
    message = list(skin = skin)
  )
}




# Demo --------------------------------------------------------------------


ui <- fluidPage(
  updateSliderSkinUi("Flat"),
  sliderInput("obs", "Number of observations:",
              min = 0, max = 1000, value = 500
  ),
  plotOutput("distPlot"),
  selectInput(
    inputId = "slider_skin", 
    label = "Choose a skin",
    choices = c(
      "Shiny",
      "Flat", 
      "Modern", 
      "Nice",
      "Simple",
      "HTML5",
      "Round",
      "Square"
    ), selected = "Flat"
  )
)

server <- function(input, output, session) {
  
  output$distPlot <- renderPlot({
    hist(rnorm(input$obs))
  })
  
  observeEvent(input$slider_skin, {
    updateSliderSkin(session, skin = input$slider_skin)
  })
  
}

shinyApp(ui, server)
