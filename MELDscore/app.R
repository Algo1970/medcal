library(shiny)
library(shinythemes)
library(dplyr)

ui <- fluidPage(theme = shinytheme("flatly"),
                titlePanel("MELD(model for end stage liver disease) score"),
   
                fluidRow(
                  column(2,
                         numericInput("Cr", "Cr(mg/dl):", 0.8, step = 0.1)
                  ),
                  column(2,
                         numericInput("Tbil", "T-Bil(mg/dl):", 1.0, step = 0.1)
                  ),
                  column(2,
                         numericInput("PT_INR", "PT-INR():", 1.2, step = 0.1)
                  ),
                  column(8,
                         radioButtons("HD", "血液透析の有無:", c("無し" = "0", "有り" = "1"))
                  ),
                  column(8,
                         verbatimTextOutput("MELDscore")
                  )
                )
)

server <- function(input, output) {
  output$MELDscore <- renderText({
    # 透析有りの場合は、Cr=4.0とする。
    if (HD == 0){
      MELD_score = (0.957 * log(as.numeric(input$Cr)) + 0.378 * log(as.numeric(input$Tbil)) + 1.120 * log(as.numeric(input$PT_INR)) +0.643) * 10
    } else if (HD == 1){
      MELD_score = (0.957 * log(4.0) + 0.378 * log(as.numeric(input$Tbil)) + 1.120 * log(as.numeric(input$PT_INR)) +0.643) * 10
    }
    MELD_score = round(MELD_score, 2)
    paste("MELD_score :", MELD_score)
  })
}

shinyApp(ui = ui, server = server)

