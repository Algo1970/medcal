library(shiny)
library(shinythemes)
library(dplyr)

ui <-   fluidPage(theme = shinytheme("flatly"),
                  titlePanel("Original_Mayo_PBCmodel"),
                  fluidRow(
                    column(2,
                           numericInput("age", "年齢:", 50)
                    ),
                    column(2,
                           numericInput("Tbil", "T-Bil(mg/dl):", 1.0, step = 0.1)
                    ),
                    column(2,
                           numericInput("Alb", "Alb(g/dl):", 3.5, step = 0.1)
                    ),
                    column(2,
                           numericInput("PT", "PT(s):", 12, step = 0.1)
                    ),
                    column(8,
                           #EdemaScore: 0=no edema without diuretics, 1=edema with diuretics ,0.5 = otherwise
                           radioButtons("EdemaScore", "Edema score:", c("no edema without diuretics" = "0",
                                                                        "edema with diuretics" = "1",
                                                                        "otherwise" = "0.5"))
                    ),
                    column(8,
                           verbatimTextOutput("RiskScore"),
                           verbatimTextOutput("Survival_probability")
                    )
                  )
)

server <- function(input, output){
  output$RiskScore <- renderText({
    RiskScore = 0.04 * as.numeric(input$age) + 0.87 * log(as.numeric(input$Tbil)) - 2.53 * log(as.numeric(input$Alb)) + 2.38 * log(as.numeric(input$PT)) + 0.86 * as.numeric(input$EdemaScore)
    RiskScore = round(RiskScore, 2)
    paste("RiskScore :", RiskScore)
  })
  output$Survival_probability <- renderText({
    RiskScore = 0.04 * as.numeric(input$age) + 0.87 * log(as.numeric(input$Tbil)) - 2.53 * log(as.numeric(input$Alb)) + 2.38 * log(as.numeric(input$PT)) + 0.86 * as.numeric(input$EdemaScore)
    RiskScore = round(RiskScore, 2)
    S = c(1, 0.97, 0.94, 0.88, 0.83, 0.77, 0.72, 0.65)
    S0_t = function(x){
      S = c(1, 0.97, 0.94, 0.88, 0.83, 0.77, 0.72, 0.65)
      S[(x+1)]
    }
    
    Survival_probability = function(t){
      S0 = function(x){
        S = c(1, 0.97, 0.94, 0.88, 0.83, 0.77, 0.72, 0.65)
        S[(x+1)]
      }
      S0(t) ^ exp(RiskScore - 5.07)
    }
    Survival_probability(1:7)
    combine(paste(year_list = c("1y:","2y:","3y:","4y:","5y:","6y:","7y:"), round(Survival_probability(1:7), 2)))
  })
}

shinyApp(ui = ui, server = server)

