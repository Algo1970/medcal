library(shiny)
library(dplyr)

server <- function(input, output){
  output$RiskScore <- renderText({
    RiskScore = 0.04 * as.numeric(input$age) + 0.87 * log(as.numeric(input$Tbil)) - 2.53 * log(as.numeric(input$Alb)) + 2.38 * log(as.numeric(input$PT)) + 0.86 * as.numeric(input$EdemaScore)
    RiskScore = round(RiskScore, 2)
    paste("RiskScore :", RiskScore)
  })
  output$Survival_probability <- renderText({
    RiskScore = 0.04 * as.numeric(input$age) + 0.87 * log(as.numeric(input$Tbil)) - 2.53 * log(as.numeric(input$Alb)) + 2.38 * log(as.numeric(input$PT)) + 0.86 * as.numeric(input$EdemaScore)
    RiskScore = round(RiskScore, 2)
    
    Survival_probability = function(t){
      S0 = function(x){
        S = c(1, 0.97, 0.94, 0.88, 0.83, 0.77, 0.72, 0.65)
        S[(x+1)]
      }
      S0(t) ^ exp(RiskScore - 5.07)
    }
    # combine(paste(year_list = c("1y:","2y:","3y:","4y:","5y:","6y:","7y:"), round(Survival_probability(1:7), 2)))
    combine(paste0(year_list = c("1y:","2y:","3y:","4y:","5y:","6y:","7y:"), round(Survival_probability(1:7)*100, 0), rep("% ", 7)))
  })
}



