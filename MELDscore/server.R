library(shiny)
# library(shinythemes)
# library(dplyr)

server <- function(input, output) {
  output$MELDscore <- renderText({
    # 透析有りの場合は、Cr=4.0とする。
    HD = as.numeric(input$HD)
    if (HD == 0){
      MELD_score = (0.957 * log(as.numeric(input$Cr)) + 0.378 * log(as.numeric(input$Tbil)) + 1.120 * log(as.numeric(input$PT_INR)) +0.643) * 10
    } else if (HD == 1){
      MELD_score = (0.957 * log(4.0) + 0.378 * log(as.numeric(input$Tbil)) + 1.120 * log(as.numeric(input$PT_INR)) +0.643) * 10
    }
    MELD_score = round(MELD_score, 2)
    paste("MELD_score :", MELD_score)
  })
}