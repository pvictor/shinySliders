

# Method 1 : choose skin in UI --------------------------------------------

# In this method, we define a skin in the UI
# This apply to all sliders in the app

# Todo : instead of recreating a complete dependency, use shiny's dep since all skins are available
# https://github.com/rstudio/shiny/tree/master/inst/www/shared/ionrangeslider/css




# Fun ---------------------------------------------------------------------


chooseSliderSkin <- function(skin = c("Shiny", "Flat", "Modern", "Nice",
                                      "Simple", "HTML5", "Round", "Square")) {
  skin <- match.arg(arg = skin)
  tagList(
    htmltools::suppressDependencies("ionrangeslider"),
    htmltools::attachDependencies(
      x = tags$div(),
      value = htmltools::htmlDependency(
        "ionrangesliderSkin", "2.1.6", c(href="shared/ionrangeslider"),
        script = "js/ion.rangeSlider.min.js",
        # ion.rangeSlider also needs normalize.css, which is already included in
        # Bootstrap.
        stylesheet = c(
          "css/ion.rangeSlider.css",
          paste0("css/ion.rangeSlider.skin", skin, ".css")
        )
      ), append = FALSE
    )
  )
}




# Demo --------------------------------------------------------------------


ui <- fluidPage(
  chooseSliderSkin("Flat"),
  sliderInput("obs", "Number of observations:",
              min = 0, max = 1000, value = 500
  ),
  plotOutput("distPlot")
)

server <- function(input, output) {
  
  output$distPlot <- renderPlot({
    hist(rnorm(input$obs))
  })
  
}

shinyApp(ui, server)
