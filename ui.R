library(shiny)
library(shinyjs)
library(shinydashboard)
ui <- bootstrapPage(useShinyjs(), 
                    dashboardPage(
                      dashboardHeader(title = "Dashboard"),
                      dashboardSidebar(
                        sidebarMenu(
                          menuItem("Stores", tabName = "dashboard", icon = icon("dashboard"), 
                                   menuSubItem('A'),
                                   menuSubItem('B'),
                                   menuSubItem('C')),
                          menuItem("Sales", tabName = "widgets", icon = icon("th")),
                          menuItem('Features', tabName = 'features', icon = icon('th'))
                        )
                      ),
                      
                      
                      
                      dashboardBody(
                        tabItems(
                          tabItem(tabName = "dashboard",
                                  h2("Dashboard tab content")
                          ),
                          tabItem(tabName = "features",
                                  h2("features of the stores"),
                                  fluidRow(
                                    box(
                                      title = "Mean Temperature of Stores by Type",
                                      status = "primary",
                                      solidHeader = TRUE,
                                      collapsible = TRUE,
                                      plotOutput("kpi2")
                                    ),
                                    box(
                                      title = "Mean Fuel Price of Stores by Type",
                                      status = "primary",
                                      solidHeader = TRUE,
                                      collapsible = TRUE,
                                      plotOutput("kpi3")
                                    ),
                                    box(
                                      title = "Mean Unemployment Rate of Stores by Type",
                                      status = "primary",
                                      solidHeader = TRUE,
                                      collapsible = TRUE,
                                      plotOutput("kpi4")
                                    ),
                                    box(
                                      title = "Mean CPI of Stores by Type",
                                      status = "primary",
                                      solidHeader = TRUE,
                                      collapsible = TRUE,
                                      plotOutput("kpi5")
                                    )
                                  ),
                                  box(
                                    title = 'Mean size of Stores by Type',
                                    status = 'primary',
                                    solidHeader = TRUE,
                                    collapsible = TRUE,
                                    plotOutput('kpi1')
                                  )
                          )
                        )
                      )
                    )
  
)
