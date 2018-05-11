library(shiny)
library(shinythemes)

fluidPage(theme = shinytheme("flatly"),
          titlePanel("MELD(model for end stage liver disease) score"),
          
          fluidRow(
            column(2,
                   numericInput("Cr", "Cr(mg/dl):", 0.8, step = 0.1)
            ),
            column(2,
                   numericInput("Tbil", "T-Bil(mg/dl):", 1.0, step = 0.1)
            ),
            column(2,
                   numericInput("PT_INR", "PT-INR:", 1.0, step = 0.1)
            ),
            column(8,
                   radioButtons("HD", "血液透析の有無:", c("無し" = "0", "有り" = "1"))
            ),
            column(8,
                   verbatimTextOutput("MELDscore")
            ),
            column(12, h5("MELDscoreが25以上の場合、緊急肝移植の適応とする報告がある。"))
          )
)