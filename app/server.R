#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(plotly)

# Total co2 produced (co2_including_luc)

# Anual growth of co2 production (co2_including_luc_growth_abs, co2_including_luc_growth_prct)
# Share_global_c02
# per capita (co2_including_luc_per_capita)
# Cummulative co2 (cumulative_co2)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  data <- read.csv("owid-co2-data.txt")
  
  filtered_data <- data %>% 
                   filter(country != "World" 
                          & country != "High-income countries"
                          & country != "Asia" & country != "Europe"
                          & country != "Upper-middle-income countries"
                          & country != "North America") %>% 
                   select(country, year, cumulative_coal_co2, cumulative_coal_co2,
                          co2_including_luc_growth_prct, cumulative_flaring_co2,
                          cumulative_gas_co2, cumulative_luc_co2,
                          cumulative_oil_co2, cumulative_other_co2, cumulative_co2)
  
  # Cummulative co2 (cumulative_co2) country with highest count co2 as well as number
  highest_cum_co2 <- filtered_data %>% 
    select(country, year, cumulative_co2) %>% 
    group_by(country) %>%
    filter(year == max(year)) %>% 
    ungroup(country) %>% 
    filter(cumulative_co2 == max(cumulative_co2, na.rm = TRUE))
  
  
  # Country with highest average co2 cumulative_co2 as well as number
  highest_avg_co2 <- filtered_data %>% 
    select(country, year, cumulative_co2) %>% 
    group_by(country) %>%
    summarize(cumulative_co2 = mean(cumulative_co2, na.rm = TRUE)) %>% 
    filter(cumulative_co2 == max(cumulative_co2, na.rm = TRUE))
  
  
  # When and where was the co2_including_luc_growth_prct highest
  highest_growth_prct <- filtered_data %>% 
    select(country, year, co2_including_luc_growth_prct) %>% 
    filter(co2_including_luc_growth_prct == max(co2_including_luc_growth_prct, na.rm = TRUE))

  output$values <- renderText({
    paste("Going over the data set more generally, there were three values I thought 
    would be interesting to calculate. First of them is the country with the 
    highest amount of cumulative Co2. The country I calculated with the highest 
    Co2 was ", highest_cum_co2$country, " at ", round(highest_cum_co2$cumulative_co2, digits = 2), ". The second data point I calculated was the
    country highest average Co2 was also ", highest_avg_co2$country, " at ", round(highest_avg_co2$cumulative_co2, digits = 2), ". The third data 
    point I wanted to calculate was when and which country had the highest percent
    growth in a single year; it was ", highest_growth_prct$country, " in ", highest_growth_prct$year, ".")
  })

####################################### Shiny Code #######################################
  
  output$graphOptions <- renderUI({
    trend_names <- c("Cummulative amount of Co2" = "cumulative_co2",
                     "Amount of Co2 produced from coal" = "cumulative_coal_co2",
                     "Amount of Co2 produced from flaring" = "cumulative_flaring_co2",
                     "Amount of Co2 produced from gases" = "cumulative_gas_co2",
                     "Amount of Co2 produced from land-use" = "cumulative_luc_co2",
                     "Amount of Co2 produced from oil" = "cumulative_oil_co2",
                     "Amount of Co2 produced from other means" = "cumulative_other_co2")
    
    selectInput("Trend", label = "Select a trend to Display", choices = trend_names)
  })
  
  output$countryInput <- renderUI({
    selectInput("Countries", 
                label = "Select a Country", 
                choices = unique(filtered_data$country),
                multiple = FALSE)
  })
  

  build_chart <- function(country.var, trend.var) {
    
    data_selected <- filtered_data %>%
      select(country, year, trend.var) %>% 
      filter(country == country.var)
    
    chart <- ggplot(
      data = data_selected,
      aes(x = year, y = get(trend.var), group=1),
      na.rm = TRUE) +
      geom_line(color="#3392FF", linewidth=1.5) +
      labs(x = "Year", y = "Co2 Emission Measured in Million Tones",
           title = paste("Co2 Emmissions", country.var)) +
      scale_y_continuous(labels=function(x) format(x, big.mark = ",", scientific = FALSE)) +
      theme_light()
    return(chart)
  }
  
  output$buildChart <- renderPlotly({
    return(ggplotly(build_chart(input$Countries, input$Trend)))
  })
  

})
