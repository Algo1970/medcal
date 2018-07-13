library(shiny)
library(shinythemes)

fluidPage(theme = shinytheme("flatly"),
          titlePanel("クレアチンクリアランス推算式（Cockcroft_Gaultの式）"),
          fluidRow(
            column(2,
                   radioButtons("gender", label = h4("性別:"), c("男性" = "1","女性" = "2"))
            ),
            column(2,
                   numericInput("age", label = h4("年齢(歳):"), 50)
            ),
            column(2,
                   numericInput("BW", label = h4("体重(kg):"), 60)
            ),
            column(3,
                   numericInput("Cr", label = h4("血清Cr値(mg/dL):"), value = 0.8,step=0.01)
            ),
            
            
            column(12,
                   verbatimTextOutput("Ccr")
            )
          )
)
