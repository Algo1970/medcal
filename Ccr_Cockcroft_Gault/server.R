library(shiny)
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

server <- function(input, output) {
  output$Ccr <- renderText({
    Ccr = create_Ccr(as.numeric(input$gender), as.numeric(input$age), as.numeric(input$BW), as.numeric(input$Cr))
    Ccr = paste("クレアチンクリアランス推算値：", Ccr ,"mL/min")
  })
}

