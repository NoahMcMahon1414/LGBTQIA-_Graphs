# Load packages
library(ggplot2)
library(plotly)
library(dplyr)

# Load data
cartoons <- read.csv("cartoons.csv")

# First Visualization Data
by_platform <- cartoons %>%
  select(Platform, Role) %>%
  group_by(Platform, Role) %>%
  summarize(num = n())

# Second Visualization Data
number_per_year <- cartoons %>%
  group_by(Year.Released) %>%
  summarise(n = n())

# Third Visualization Data
orientation_counts <- cartoons %>%
  group_by(Orientation) %>%
  summarise(Count = n())

server <- function(input, output) {
  # Visualization 1
  output$viz1_plot <- renderPlotly({
    filtered_df1 <- by_platform %>%
      # Filter for user's platform selection
      filter(Platform %in% input$platform_selection) %>%
      # Filter for user's role selection
      filter(Role %in% input$role_selection)
    
    # Plot for Characters and Role
    viz1_plot <- ggplot(data = filtered_df1) +
      geom_col(aes(x = num, y = Platform, fill = Role)) +
      labs(
        x = "Number of Characters", y = "Platform",
        fill = "Type of Character"
      )
    
    return(viz1_plot)
  })
  
  # Visualization 2
  output$viz2_plot <- renderPlotly({
    filtered_df2 <- number_per_year %>%
      # Filter for user's year selection
      filter(Year.Released >= input$year_selection[1] &
             Year.Released <= input$year_selection[2])
    
    # Plot for Inclusivity over Time
    viz2_plot <- ggplot(data = filtered_df2) +
      geom_line(aes(x = Year.Released, y = n), color = "steelblue") +
      labs(x = "Year",
           y = "Number of Shows")
    
    return(viz2_plot)
  })
  
  # Visualization 3
  output$viz3_plot <- renderPlotly({
    filtered_df3 <- orientation_counts %>%
      # Filter for user's orientation choice
      filter(Orientation %in% input$orientation_selection)
    
    # Plot for Orientation Character Count
    viz3_plot <- ggplot(data = filtered_df3) +
      geom_col(aes(x = Count, y = Orientation, fill = Orientation)) +
      labs(
        x = "Character Count",
        y = "Orientation"
      )
    
    return(viz3_plot)
  })
}