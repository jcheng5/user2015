library(shiny)

# Helper function to present Shiny controls in a dialog-like layout
dialogPage <- function(outputControl, padding = 10) {
  bootstrapPage(
    tags$style(paste0("
      html, body { width: 100%; height: 100%; overflow: none; }
      #dialogMainOutput { position: absolute; top: ", padding, "px; left: ", padding, "px; right: ", padding, "px; bottom: 40px; }
      #dialogControls {
        position: absolute; bottom: 0px; left: 0px; right: 0px; height: 40px;
        padding: 10px 10px 0 10px;
        background-color: #444; color: white;
      }")),
    tags$div(id = "dialogMainOutput", outputControl),
    tags$div(id = "dialogControls",
      textOutput("msg", inline = TRUE),
      actionButton("done", "Done", class = "btn btn-primary btn-xs pull-right")
    )
  )
}
