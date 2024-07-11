source('logic.R')

server <- function(input, output) {

  output$kpi1 <- renderPlot({kpi1})
  output$kpi2 <- renderPlot({kpi2})
  output$kpi3 <- renderPlot({kpi3})
  output$kpi4 <- renderPlot({kpi4})
  output$kpi5 <- renderPlot({kpi5})
  output$kpi6 <- renderPlot({kpi6})
  output$kpi7 <- renderPlot({kpi7})
  output$kpi8 <- renderPlot({kpi8})
  
  }
