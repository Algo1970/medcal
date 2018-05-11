library(shiny)
library(shinythemes)

fluidPage(theme = shinytheme("flatly"),
          titlePanel("日本肝移植適応研究会の予後予測式"),
          
          fluidRow(
            
            column(2,
                   numericInput("Tbil", "T-Bil(mg/dl):", 1.0, step = 0.1)
            ),
            column(2,
                   numericInput("AST", "AST(U/L):", 30, step = 1)
            ),
            column(2,
                   numericInput("ALT", "ALT(U/L):", 30, step = 1)
            ),
            
            column(8,
                   verbatimTextOutput("JLST_prognosis_prediction")
            ),
            column(12, h5("6ヶ月後の死亡確率、50％以上になったときが肝移植の適応時期とされている。"))
          )
)