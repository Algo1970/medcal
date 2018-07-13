# Ccr_Cockcroft_Gault

library(shiny)
library(shinythemes)
library(dplyr)

# function----
create_Ccr <- function(gender, age, BW, Cr){
  if (gender == 1 | gender == "male"){
    Ccr <- round( ((140 - age) * BW)/(72 * Cr) ,1)
  }else if (gender==2 | gender=="female"){
    Ccr <- round( (0.85 * (140 - age) * BW)/(72 * Cr) ,1)
  }
  invisible(Ccr)
}

# create_Ccr(1,69,64.7,0.8) %>% print()

ui <-   fluidPage(theme = shinytheme("flatly"),
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
                    column(2,
                           numericInput("Cr", label = h4("血清Cr値(mg/dL):"), value = 0.8,step=0.01)
                    ),
                    
                    
                    column(12,
                           verbatimTextOutput("Ccr")
                    )
                  )
)

server <- function(input, output){
  output$Ccr <- renderText({
    Ccr = create_Ccr(as.numeric(input$gender), as.numeric(input$age), as.numeric(input$BW), as.numeric(input$Cr))
    Ccr = paste("クレアチンクリアランス推算値：", Ccr ,"mL/min")
  })
}

shinyApp(ui = ui, server = server)