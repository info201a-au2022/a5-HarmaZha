#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# Run the application 

library(shiny)
library(plotly)

# Define UI for application that draws a histogram

  # Application title

  
introduction_panel <- tabPanel(
  "Introduction",
  titlePanel("Introduction"),
  p("The application is just a line graph of the Co2 data, of countries around 
    the world, from: “https://github.com/owid/co2-data/”. Our visualization 
    focuses on  multiple trends of a single (user selected) country: 
    Cumulative amount of Co2, Amount of Co2 produced from coal, Amount of Co2 
    produced from flaring, Amount of Co2 produced from gasses, Amount of Co2 
    produced from land-use, Amount of Co2 produced from oil, and Amount of Co2 
    produced from other means. They will all be displayed on a line graph on the
    second page; x axis will be the amount of Co2 (measured in millions tonnes) 
    and the y axis will be the year (started whenever they started to record for
    that country) that the amount of Co2 was measured."),
  textOutput("values")
)

user_input_panel<- sidebarPanel(
  uiOutput("graphOptions"),
  uiOutput("countryInput")
)

chart_main_panel <- mainPanel(
  plotlyOutput("buildChart"),
  p(em("Figure 1."), "The cumulative amount of Co2 that the selected country has emited.
    The source of the Co2 comes from whatever the selected source is.")
)

chart_panel <- tabPanel(
  "Interactive visualization",
  titlePanel("Interactive visualization"),
  user_input_panel,
  chart_main_panel
)


individuals_panel <- tabPanel(
  "Taking Action",
  titlePanel("What Could I do to Help?"),
  
  p("With the US having the largest cumulative amount of Co2 emissions, here are some
    simple tasks Americans can do in their day to day to reduce the global impact."),
  
  p(em("1.)"), "Turn off the lights when natural light is sufficient and when you leave the room
    can help reduce the use of electricity generated from fossil fuels."),
  
  p(em("2.)"), "Keep your temperature system on a moderate setting for the same reason as above."),
  
  p(em("3.)"), "Car pooling to wherever you go or using public transportation will reduce the need
    for the buring of gasoline"),
  
  p(em("4.)"), "Similarly, although it is expensive, the purchasing of an electric car will help
    reduce the buring of gasoline"),

  p(em("5.)"), "Use your windows wisely. If your climate control system is on, shut them…if 
  you need a little fresh air, turn off the heat or AC."),

  p(em("6.)"), "Cut down the number of appliances you are running and you will save big on 
  energy. For example, share your minifridge with roomates and minimize the 
  number of printers in your office."),
  
  p(em("7.)"), "Power your computer down when you’re away. A computer turned off uses at 
  least 65% less energy than a computer left on or idle on a screen saver."),

  p(em("8.)"), "Try to take shorter showers. The less hot water you use, the less energy is 
  needed to heat the water."),

  p(em("9.)"), "Compact fluorescent light bulbs (CFLs) use 75% less energy than incandescent 
  and last up to 10 times longer.")
)
  
    
  
shinyui <- fluidPage(
  navbarPage(
    "Co2 Emissions",
    introduction_panel,
    chart_panel,
    individuals_panel
  )
)
  
shinyUI(shinyui)
