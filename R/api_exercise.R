# =============================================================================
# Econometrics 871 Tutorial 1
# API exercise using JHU CSSE COVID-19 data
#
# This script downloads COVID-19 confirmed cases and deaths data,
# reshapes the data into a tidy format, and creates two plots.
# =============================================================================

# Packages --------------------------------------------------------------------

# Install pacman if needed, then load all required packages
if (!require("pacman")) install.packages("pacman")
pacman::p_load(
  readr,      # read CSV files directly from URLs
  dplyr,      # data cleaning and summarising
  tidyr,      # reshaping data from wide to long format
  ggplot2,    # plotting
  ggrepel,    # clearer country labels on scatter plot
  lubridate   # converting character dates into date format
)

# Download data ---------------------------------------------------------------

# Raw CSV links from the JHU CSSE COVID-19 GitHub repository
confirmed_url <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"
deaths_url <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv"

# Read confirmed cases and deaths data directly from the online source
confirmed_raw <- read_csv(confirmed_url, show_col_types = FALSE)
deaths_raw <- read_csv(deaths_url, show_col_types = FALSE)

# Clean and reshape data ------------------------------------------------------

# Countries selected for the comparison
countries <- c(
  "South Africa",
  "United Kingdom",
  "Germany",
  "India",
  "Brazil",
  "Japan"
)

# The original data are in wide format, with one column for each date.
# This section aggregates provinces/regions to country level, then reshapes
# the data so that each row is one country-date observation.

confirmed <- confirmed_raw %>%
  filter(`Country/Region` %in% countries) %>%
  select(-`Province/State`, -Lat, -Long) %>%
  group_by(`Country/Region`) %>%
  summarise(across(everything(), sum), .groups = "drop") %>%
  pivot_longer(
    cols = -`Country/Region`,
    names_to = "date",
    values_to = "confirmed_cases"
  )

deaths <- deaths_raw %>%
  filter(`Country/Region` %in% countries) %>%
  select(-`Province/State`, -Lat, -Long) %>%
  group_by(`Country/Region`) %>%
  summarise(across(everything(), sum), .groups = "drop") %>%
  pivot_longer(
    cols = -`Country/Region`,
    names_to = "date",
    values_to = "deaths"
  )

# Merge confirmed cases and deaths into one tidy dataset
covid_data <- confirmed %>%
  inner_join(deaths, by = c("Country/Region", "date")) %>%
  rename(country = `Country/Region`) %>%
  mutate(
    date = mdy(date),
    confirmed_cases = as.numeric(confirmed_cases),
    deaths = as.numeric(deaths)
  ) %>%
  arrange(country, date) %>%
  group_by(country) %>%
  mutate(
    new_cases = confirmed_cases - lag(confirmed_cases),
    new_deaths = deaths - lag(deaths)
  ) %>%
  ungroup() %>%
  filter(!is.na(new_cases), new_cases >= 0, new_deaths >= 0)

# Save cleaned data -----------------------------------------------------------

# Create a data folder if it does not already exist
dir.create("data", showWarnings = FALSE)

# Save the cleaned dataset for reproducibility
write_csv(covid_data, "data/covid_clean.csv")

# Plot 1: confirmed cases over time ------------------------------------------

# This plot compares the cumulative number of confirmed COVID-19 cases
# across the selected countries over time.
plot1 <- ggplot(covid_data, aes(x = date, y = confirmed_cases, colour = country)) +
  geom_line() +
  labs(
    title = "Cumulative confirmed COVID-19 cases",
    x = "Date",
    y = "Confirmed cases",
    colour = "Country"
  ) +
  theme_minimal()

# Plot 2: deaths versus confirmed cases --------------------------------------

# Use the latest available observation for each country.
latest_data <- covid_data %>%
  group_by(country) %>%
  filter(date == max(date)) %>%
  ungroup()

# This plot compares the total number of deaths with confirmed cases
# for each country at the end of the sample period.
plot2 <- ggplot(latest_data, aes(x = confirmed_cases, y = deaths, label = country)) +
  geom_point() +
  geom_text_repel(size = 3) +
  labs(
    title = "COVID-19 deaths and confirmed cases",
    x = "Confirmed cases",
    y = "Deaths"
  ) +
  theme_minimal()

# Save figures ---------------------------------------------------------------

# Create a figures folder if it does not already exist
dir.create("figures", showWarnings = FALSE)

# Save both plots as PNG files
ggsave("figures/cumulative_cases.png", plot1, width = 9, height = 5)
ggsave("figures/deaths_vs_cases.png", plot2, width = 8, height = 5)

# Display plots in RStudio
plot1
plot2