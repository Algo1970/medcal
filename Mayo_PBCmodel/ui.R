library(shiny)
library(shinythemes)

fluidPage(theme = shinytheme("flatly"),
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
