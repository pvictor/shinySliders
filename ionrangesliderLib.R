ionrangesliderLib <- function (skin = NULL) {
  htmltools::htmlDependency(
    "ionrangesliderSkin", "2.1.6", 
    c(href = "shared/ionrangeslider", 
      file = system.file("www/shared/ionrangeslider", package = "shiny")
    ), 
    script = "js/ionrangeslider.min.js", 
    stylesheet = c(
      "css/ion.rangeSlider.css",
      paste0("css/ion.rangeSlider.skin", skin, ".css"))
  )
}



