
library(shiny)
library(dplyr)

server <- function(input, output) {
  output$JLST_prognosis_prediction <- renderText({
    
    lambda = -4.333 + 1.2739 * log(as.numeric(input$Tbil)) + 4.4880 * log(as.numeric(input$AST)/as.numeric(input$ALT))
    lambda
    
    Mortality_6m = (1/(1 + exp(1) ^ (-lambda))) * 100
    paste("6ヶ月後の死亡確率 = ",round(Mortality_6m, 0),"%" )
    
  })
}