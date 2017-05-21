library(shiny)
library(shinythemes)
library(dplyr)

# function----
create_eGFR_direct_input <- function(gender,Cr,age){
  if (gender==1 | gender=="male"){
    eGFR <- round(194*Cr^(-1.094)*age^(-0.287),1)
  }else if (gender==2 | gender=="female"){
    eGFR <- round(194*Cr^(-1.094)*age^(-0.287)*0.739,1)
  }
  invisible(eGFR)
}
create_eGFRcys_direct_input <- function(gender,cys,age){
  if (gender==1){
    eGFRcys <- round(104*cys^(-1.019)*(0.996^age)-8,1)
  }else if (gender==2){
    eGFRcys <- round(104*cys^(-1.019)*(0.996^age)*0.929-8,1)
  }
  invisible(eGFRcys)
}

# server----
shinyServer(
  function(input, output) { 
    output$text_FIB4 <- renderText({ 
      age <- as.numeric(input$age)
      Plt <- as.numeric(input$Plt)
      AST <- as.numeric(input$AST)
      ALT <- as.numeric(input$ALT)
      FIB4index=round((age*AST)/(10*Plt*(ALT^(0.5))),2)
      paste("FIB4index :",FIB4index," ")
    })
    output$text_NFS <- renderText({ 
      age <- as.numeric(input$age)
      BMI <- round(as.numeric(input$BW)/(as.numeric(input$height)/100)^2,1)
      DM  <- as.numeric(input$DM)
      AAR <- round(as.numeric(input$AST)/as.numeric(input$ALT),1)
      Alb <- as.numeric(input$Alb)
      Plt <- as.numeric(input$Plt)
      NFS <- round(-1.675+0.037*age+0.094*BMI+1.13*DM+0.99*AAR-0.013*10*Plt-0.66*Alb,3)
      # NFS : -1.675+0.037*age+0.094*BMI+1.13*IFG/DM(yes=1,no=0)+0.99*AAR-0.013*Plt[10^3/L]-0.66*Alb(g/dl)
      # NFS <- round(-1.675 + 0.037*age + 0.094*BMI + 1.13*IFG_DM + 0.99*AST/ALT -0.013*10*Plt - 0.66*Alb,3) 
      paste("NAFLD fibrosis score :",NFS," ")
    })
    output$text_NAFIC <- renderText({
      NAFIC_list <- as.numeric(input$NAFICscore)
      score <- 0
      if(1 %in% NAFIC_list){
        score <- score+1
      } 
      if(2 %in% NAFIC_list){
        score <- score+1
      } 
      if(3 %in% NAFIC_list){
        score <- score+1
      } 
      if(4 %in% NAFIC_list){
        score <- score+2
      }
      paste("NAFIC score :",score," ")
    })
    output$text_JABHCC <- renderText({ 
      gender <- as.numeric(input$gender)
      if(gender==1){ 
        genderJAB <- 4       # male
      } else if(gender==2){ 
        genderJAB <- 0       #female
      }
      age <- as.numeric(input$age)
      if(age<=44){
        ageJAB <- 0
      } else if(age>=45 & age<= 49){
        ageJAB <- 3
      } else if(age>=50 & age<= 54){
        ageJAB <- 5
      } else if(age>=55){
        ageJAB <- 6
      }
      LCJAB <- as.numeric(input$LC_JAB)
      ALT <- as.numeric(input$ALT)
      if(ALT<45){
        ALTJAB <-0
      } else if(ALT>=45){
        ALTJAB <-1
      }
      AFPJAB <- as.numeric(input$AFP_JAB)
      Plt <- as.numeric(input$Plt)
      if(Plt>=15){
        PltJAB <- 0
      } else if(Plt<15){
        PltJAB <- 2
      }
      HBeAgJAB <- as.numeric(input$HBeAg_JAB)
      HBVDNAJAB <- as.numeric(input$HBVDNA_JAB)
      JAB_score <- genderJAB + ageJAB + LCJAB + ALTJAB + AFPJAB + PltJAB +HBeAgJAB+ HBVDNAJAB
      if(JAB_score<=6){
        comment_JAB <- c("低リスク群：累積10年発癌率  0.6%")
      } else if(JAB_score>=7 & JAB_score<=10){
        comment_JAB <- c("中リスク群：累積10年発癌率  2.2%")
      } else if(JAB_score>=11 & JAB_score<=15){
        comment_JAB <- c("高リスク群：累積10年発癌率 18.8%")
      } else if(JAB_score>=16 & JAB_score<=24){
        comment_JAB <- c("???高リスク群：累積10年発癌率 61.5%")
      }
      paste("JAB_score :",JAB_score,", ",comment_JAB)
    })
    output$text_ChildPugh <- renderText({ 
      score <- as.numeric(input$coma) + as.numeric(input$ascites) + as.numeric(input$Tbil)+ as.numeric(input$Alb)+ as.numeric(input$PT)
      if(score<7){
        grade <- c("A")
      } else if(score>=7 & score<9){
        grade <- c("B")
      } else if(score>=9){
        grade <- c("C")
      }
      paste("Child-Pugh分類：",grade,", score:", score,"points")
    })
    output$text_HOMA_IR <- renderText({ 
      HOMA_IR <- round(as.numeric(input$insulin_HOMA)*as.numeric(input$PG_HOMA)/405,1)
      paste("HOMA-IR : ",HOMA_IR," ")
    })
    output$text_I_Index <- renderText({ 
      I_Index <- round((as.numeric(input$II_I30)-as.numeric(input$II_I0))/(as.numeric(input$II_PG30)-as.numeric(input$II_PG0)),2)
      paste("Insulinogenic Index :",I_Index," ")
    })
    output$text_cr <- renderText({ 
      eGFR <- create_eGFR_direct_input(as.numeric(input$gender),as.numeric(input$Cr),as.numeric(input$age))
      paste("eGFRcreat :",eGFR,"(mL/min/1.73m^2) ")
    })
    output$text_eGFRcys <- renderText({ 
      eGFRcys <- create_eGFRcys_direct_input(as.numeric(input$gender),as.numeric(input$cys),as.numeric(input$age))
      paste("eGFRcys :",eGFRcys,"(mL/min/1.73m^2) ")
    })
    output$text_BMI <- renderText({ 
      BMI <- round(as.numeric(input$BW)/(as.numeric(input$height)/100)^2,1)
      hyoujyunBW <- round(22*(as.numeric(input$height)/100)^2,1)
      paste("BMI : ",BMI,"　標準体重 : ",hyoujyunBW,"(kg)　必要栄養量 : ",round(hyoujyunBW*as.numeric(input$effort)),"(kcal/day)")
    })
    output$text_Wells_score <- renderText({
      Wells_list <- as.numeric(input$Wells_score)
      score <- 0
      if(1 %in% Wells_list){
        score <- score+1
      } 
      if(2 %in% Wells_list){
        score <- score+1
      } 
      if(3 %in% Wells_list){
        score <- score+1
      } 
      if(4 %in% Wells_list){
        score <- score+1
      }
      if(5 %in% Wells_list){
        score <- score+1
      } 
      if(6 %in% Wells_list){
        score <- score+1
      } 
      if(7 %in% Wells_list){
        score <- score+1
      } 
      if(8 %in% Wells_list){
        score <- score+2
      }
      if(9 %in% Wells_list){
        score <- score+1
      } 
      if(10 %in% Wells_list){
        score <- score-2
      }
      
      if(score<=1){
        comment <- c(", risk is low")
      } else if(score>=2 & score <=6){
        comment <- c(", risk is middle")
      } else if(score>=7){
        comment <- c(", risk is high")
      }
      paste("Wells score :",score,comment)
    })
  }
)















