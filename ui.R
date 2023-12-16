# Load packages
library(ggplot2)
library(plotly)
library(dplyr)
library(markdown)
library(bslib)

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

# Manually Determine a BootSwatch Theme
my_theme <- bs_theme(
  bg = "#0b3d91", # background color
  fg = "white", # foreground color
  primary = "#FCC780", # primary color
)

# Update BootSwatch Theme
my_theme <- bs_theme_update(my_theme, bootswatch = "quartz")

# Initial Platform Vector
platform_vector <- c("Cartoon Network", "Netflix")

# Widget for Platform
platform_widget <-
  selectInput(
    inputId = "platform_selection",
    label = "Platform",
    choices = by_platform$Platform,
    selectize = TRUE,
    multiple = TRUE,
    selected = platform_vector
  )

# Widget for Role
role_widget <-
  selectInput(
    inputId = "role_selection",
    label = "Role",
    choices = by_platform$Role,
    selectize = TRUE,
    multiple = TRUE,
    selected = "Main Character"
  )

# Widget for Year Released
year_widget <-
  sliderInput(
    inputId = "year_selection",
    label = "Year",
    min = 1983,
    max = 2020,
    value = c(1983, 2020),
    sep = ""
  )

# Widget for Orientation
orientation_widget <-
  selectInput(
    inputId = "orientation_selection",
    label = "Orientation",
    choices = orientation_counts$Orientation,
    selectize = TRUE,
    multiple = TRUE,
    selected = "Gay"
  )

viz1_panel_plot <- mainPanel(
  plotlyOutput(outputId = "viz1_plot")
)

viz2_panel_plot <- mainPanel(
  plotlyOutput(outputId = "viz2_plot")
)

viz3_panel_plot <- mainPanel(
  plotlyOutput(outputId = "viz3_plot")
)

viz1_tab <- tabPanel(
  "Breakdown of LGBTQIA+ Representation by Platform
  and Type of Character",
  sidebarLayout(
    sidebarPanel(
      platform_widget,
      role_widget
    ),
    viz1_panel_plot
  )
)

viz2_tab <- tabPanel(
  "LGBTQIA+ Inclusive Cartoons Over Time",
  sidebarLayout(
    sidebarPanel(
      year_widget
    ),
    viz2_panel_plot
  )
)

viz3_tab <- tabPanel(
  "Character Count by Orientation",
  sidebarLayout(
    sidebarPanel(
      orientation_widget
    ),
    viz3_panel_plot
  )
)

intro_page <- tabPanel(
  "Introduction",
  fluidPage(includeMarkdown("intro.md"))
)

viz1_page <- tabPanel(
  "First Visualization",
  viz1_tab,
  plotlyOutput("viz1"),
  fluidPage(includeMarkdown("chart1.md"))
)

viz2_page <- tabPanel(
  "Second Visualization",
  viz2_tab,
  plotlyOutput("viz2"),
  fluidPage(includeMarkdown("chart2.md"))
)

viz3_page <- tabPanel(
  "Third Visualization",
  viz3_tab,
  plotlyOutput("viz3"),
  fluidPage(includeMarkdown("chart3.md"))
)

conclusion_page <- tabPanel(
  "Conclusion",
  fluidPage(includeMarkdown("conclusion.md"))
)

ui <- navbarPage(
  "LGBTQIA+ Representation in Cartoons",
  theme = my_theme,
  intro_page,
  viz1_page,
  viz2_page,
  viz3_page,
  conclusion_page
)