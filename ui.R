library(shiny)
library(shinythemes)
library(dplyr)

# ui----
shinyUI(
  fluidPage(theme = shinytheme("flatly"),
            titlePanel("Med.Calc"),
            fluidRow(
              column(2,h3("基本データ"),
                     radioButtons("gender", "性別:", c("男性" = "1","女性" = "2")
                     ),
                     numericInput("age", "年齢:", 50),
                     numericInput("height", "身長(cm):", 165),
                     numericInput("BW", "体重(kg):", 60),
                     verbatimTextOutput("BMI"),
                     verbatimTextOutput("hyoujunBW")
              )
              ,
              column(10,
                     tabsetPanel(
                       tabPanel("肝疾患",
                                fluidRow(
                                  column(6,
                                         fluidRow(
                                           h4("FIB4index"),
                                           h5(" = {(age) x (AST)} / {plt(10^3/μl) x (ALT)^0.5} "),
                                           h5("1.3以下：正常、2.67以上：線維化進行疑い"),
                                           column(4,numericInput("Plt", label = h4("Plt"),value = 25,step=1)),
                                           column(4,numericInput("AST", label = h4("AST"),value = 30,step=1)),
                                           column(4,numericInput("ALT", label = h4("ALT"),value = 35,step=1))
                                         ),
                                         fluidRow(style="background-color:#fafafa;",
                                                  column(12, h4(textOutput("text_FIB4")))
                                         )
                                         
                                  ),
                                  column(6,
                                         fluidRow(
                                           h4("NAFLD fibrosis score"),
                                           h5(" = -1.675 + 0.037 x Age + 0.094 x BMI + 1.13 x IFG/DM(有=1,無=0) + 0.99 x AST/ALT - 0.013 x plt(10^3/μl) - 0.66 x alb(g/dl)"),
                                           column(4,numericInput("Alb", 
                                                                 label = h4("Alb"), 
                                                                 value = 3.5,step=0.1)),
                                           column(4,radioButtons("DM", label = h4("DM/IFG"),
                                                                 choices = list("yes" = 1, "no" = 0),selected = 0))
                                         ),
                                         fluidRow(style="background-color:#fafafa;",
                                                  column(12, h4(textOutput("text_NFS")))
                                         )
                                  )
                                ),
                                fluidRow(
                                  column(6,
                                         fluidRow(
                                           h4("NAFIC score"),
                                           checkboxGroupInput("NAFICscore", label = h5("score >= 2 pointでNASHの可能性有り"), 
                                                              choices = list("フェリチン>=200ng/ml(女性)"="1",
                                                                             "フェリチン>=300ng/ml(男性)"="2",
                                                                             "空腹時インスリン>=10IU/ml"="3",
                                                                             "IV型コラーゲン7S>=5.0ng/ml"="4"),
                                                              selected = 2)
                                         ),
                                         fluidRow(style="background-color:#fafafa;",
                                                  column(12, h4(textOutput("text_NAFIC")))
                                         )
                                  )
                                ),
                                fluidRow(
                                  column(6,
                                         fluidRow(
                                           h4("JAB-HCC(Japanese risk estimations of HBV-related HCC)"),
                                           h5("(gender,age,LC,ALT,AFP,Plt,HBeAg,HBV-DNA)"),
                                           column(6, 
                                                  radioButtons("LC_JAB", 
                                                               label = h4("肝硬変"), 
                                                               choices = list("無し" = 0, "有り" = 4),selected = 0)),
                                           column(6,
                                                  radioButtons("AFP_JAB", label = h4("AFP"), 
                                                               choices = list("20ng/ml未満" = 0, "20mg/ml以上" = 2),selected = 0))
                                         ),
                                         fluidRow(
                                           column(6,
                                                  radioButtons("HBeAg_JAB", label = h4("HBe抗原"),
                                                               choices = list("陰性" = 0, "陽性" = 3),selected = 0)),
                                           column(6,
                                                  radioButtons("HBVDNA_JAB", label = h4("HBV-DNA量"), 
                                                               choices = list("5.0log copies/ml未満" = 0, "5.0log copies/ml以上" = 2),selected = 0))
                                         ),
                                         fluidRow(style="background-color:#fafafa;",
                                                  column(12, h4(textOutput("text_JABHCC")))
                                         )
                                  ),
                                  column(6,
                                         fluidRow(
                                           h4("Chidl-Pugh classification"),
                                           h5("(肝性脳症・腹水・T-Bil・Alb・PT)"),
                                           column(4,radioButtons("coma", label = h4("肝性脳症"),
                                                                 choices = list("無い" = 1, "軽度" = 2,"時々昏睡" = 3),selected = 1)),
                                           column(4,radioButtons("ascites", label = h4("Ascites"),
                                                                 choices = list("無い" = 1, "少量" = 2,"中等量" = 3),selected = 1)),
                                           column(4, radioButtons("Tbil", label = h4("T-bil"),
                                                                  choices = list("2未満" = 1, "2～3" = 2,"3超" = 3),selected = 1)),
                                           column(4, radioButtons("Alb", label = h4("Alb"),
                                                                  choices = list("3.5超" = 1, "2.8～3.5" = 2,"2.8未満" = 3),selected = 1)),
                                           column(4, radioButtons("PT", label = h4("PT(%)"),
                                                                  choices = list("70超" = 1, "40～70" = 2,"40未満" = 3),selected = 1))
                                         ),
                                         fluidRow(style="background-color:#fafafa;",
                                                  column(12, h4(textOutput("text_ChildPugh")))
                                         )
                                         
                                  )
                                )
                                
                       ),
                       tabPanel("糖尿病・内分泌疾患",
                                fluidRow(
                                  column(6, 
                                         fluidRow(
                                           h4("HOMA-IR"),
                                           h5("HOMA-IR=Fasting insulin(microU/ml) X FPG(mg/dL) / 405"),
                                           h5("HOMA-IR<=1.6 is normal ,>=2.5 is Insulin resitance"),
                                           column(6,
                                                  numericInput("insulin_HOMA", 
                                                               label = h4("Fasting insulin"), 
                                                               value = 8,step=0.1)),
                                           column(6, 
                                                  numericInput("PG_HOMA", 
                                                               label = h4("FPG"), 
                                                               value = 80,step=1))
                                         ),
                                         fluidRow(style="background-color:#fafafa;",
                                                  column(12, h4(textOutput("text_HOMA_IR")))
                                         )
                                  ),
                                  column(6, 
                                         fluidRow(
                                           h4("Insulinogenic Index"),
                                           h5("Insulinogenic index =Insulin(30min-0min)(microU/ml) / PG(30min-0min)(mg/dL)"),
                                           h5("DM patient <=0.4"),
                                           column(6,
                                                  numericInput("II_I30", 
                                                               label = h4("Insulin(30min)"), 
                                                               value = 15,step=0.1)),
                                           column(6, 
                                                  numericInput("II_I0", 
                                                               label = h4("Insulin(0min)"), 
                                                               value = 8,step=0.1)),
                                           column(6,
                                                  numericInput("II_PG30", 
                                                               label = h4("PG(30min)"), 
                                                               value = 150,step=1)),
                                           column(6, 
                                                  numericInput("II_PG0", 
                                                               label = h4("PG(0min)"), 
                                                               value = 100,step=1))
                                         ),
                                         fluidRow(style="background-color:#fafafa;",
                                                  column(12, 
                                                         h4(textOutput("text_I_Index"))
                                                  )
                                         )
                                  ),column(6,
                                           fluidRow(
                                             h4("BMI・標準体重・必要栄養量"),
                                             column(12,
                                                    radioButtons("effort", label = h4("Amount of physical activity"),
                                                                 choices = list("Light work" = 25,
                                                                                "Moderate work" = 30,
                                                                                "Heavy work" =35),selected = 25))
                                           ),
                                           fluidRow(style="background-color:#fafafa;",
                                                    column(12, h4(textOutput("text_BMI")))
                                           )
                                  )
                                )
                       ),
                       tabPanel("腎疾患",
                                fluidRow(
                                  column(6,
                                         fluidRow(
                                           h3("eGFRcreat"),
                                           column(6, 
                                                  numericInput("Cr", 
                                                               label = h4("Cr"), 
                                                               value = 0.8,step=0.01))
                                         ),
                                         fluidRow(style="background-color:#fafafa;",
                                                  column(12, h4(textOutput("text_cr")))
                                         )
                                  ),
                                  column(6,
                                         fluidRow(
                                           h3("eGFRcys"),
                                           column(6, 
                                                  numericInput("cys", 
                                                               label = h4("Cys"), 
                                                               value = 0.8,step=0.01))
                                         ),
                                         fluidRow(style="background-color:#fafafa;",
                                                  column(12, h4(textOutput("text_eGFRcys")))
                                         )
                                  )
                                )
                       ),
                       tabPanel("循環器疾患",
                                fluidRow(
                                  column(6,
                                         fluidRow(
                                           h4("深部静脈血栓症予測-Wellsスコア"),
                                           checkboxGroupInput("Wells_score", label = h5("score >= 3で可能性有り"), 
                                                              choices = list("担癌"="1",
                                                                             "3日以上のベット上安静、4週間以内の大手術"="2",
                                                                             "3cm以上の下腿直径差"="3",
                                                                             "患肢の表在性静脈拡張"="4",
                                                                             "下肢全体の腫脹"="5",
                                                                             "深部静脈触診で疼痛"="6",
                                                                             "患肢の圧痕を伴う浮腫"="7",
                                                                             "麻痺、不全麻痺、最近の下肢のギブス固定"="8",
                                                                             "深部静脈血栓症の既往"="9",
                                                                             "他の鑑別疾患がより疑われる場合"="10"),
                                                              selected = 0)
                                         ),
                                         fluidRow(style="background-color:#fafafa;",
                                                  column(12, h4(textOutput("text_Wells_score")))
                                         )
                                  )
                                )
                                )
                     )
              )
            )
  )
)

