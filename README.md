# Econometrics 871 Dynamic Panels API Exercise

This tutorial demonstrates how to download, clean, and visualise data using an external data source in R. The analysis uses publicly available COVID-19 data to compare trends across countries.

## Data Source

Data are obtained from the Johns Hopkins University (JHU CSSE) COVID-19 dataset:

https://github.com/CSSEGISandData/COVID-19

The dataset provides global time-series data on:
- Confirmed COVID-19 cases
- COVID-19 deaths

The data are accessed directly via raw CSV files hosted on GitHub.

## Countries Included

* South Africa  
* United Kingdom  
* Germany  
* India  
* Brazil  
* Japan  

## Project Structure

```text
.
├── R/
│   └── api_exercise.R        # Main R script for data processing
├── data/
│   └── covid_clean.csv       # The resulting tidy dataset
├── figures/
│   ├── cumulative_cases.png  # Time-series plot of infections
│   └── deaths_vs_cases.png   # Scatter plot of mortality vs. cases
└── README.md                 # Project documentation
```

## How to Reproduce

1. Clone or download this repository.
2. Open the project in RStudio.
3. Run the script:

```r
source("R/api_exercise.R")
```

## The script will:

* Download the data from the online source
* Clean and reshape the data into a tidy format
* Create two plots using ggplot2
* Save the cleaned dataset and figures

## Required packages (installed automatically using pacman):

The script uses the pacman manager to ensure all dependencies are installed and loaded:
* readr, dplyr, tidyr: Data manipulation.
* ggplot2, ggrepel: Advanced data visualisation.
* lubridate: Date-time formatting.

##Plot Interpretation
###Plot 1: Cumulative confirmed cases over time
This plot shows the evolution of total COVID-19 cases across the selected countries from 2020 to 2023.

All countries display a clear upward trend, reflecting the cumulative nature of the data. However, there are important differences in both the timing and magnitude of outbreaks:

India and Brazil experience the largest total case counts, indicating a higher overall spread of the virus.
India shows particularly sharp increases around 2021 and early 2022, suggesting periods of rapid transmission (likely corresponding to major waves).
Germany and the United Kingdom exhibit more gradual but sustained increases, especially during later stages of the pandemic.
Japan shows a delayed but steep increase toward 2022–2023, indicating later waves compared to other countries.
South Africa has significantly lower cumulative cases, reflecting either smaller outbreaks, population differences, or reporting/testing differences.

Overall, the plot highlights heterogeneity in pandemic dynamics across countries, both in scale and in timing of infection waves.

###Plot 2: Deaths vs confirmed cases

This scatter plot compares total deaths and confirmed cases for each country using the most recent available data. It provides a simple cross-country comparison of the severity of outcomes relative to infection levels.

Key observations:

There is a positive relationship between confirmed cases and deaths: countries with more cases tend to have more deaths.
Brazil stands out with relatively high deaths given its case count, suggesting a higher observed mortality burden.
India, despite having the highest number of confirmed cases, has fewer deaths than Brazil, which may reflect differences in demographics, reporting, or healthcare systems.
Germany and Japan show lower deaths relative to their case counts, which could indicate better healthcare capacity or lower case fatality rates.
South Africa lies at the lower end of both cases and deaths, consistent with the time-series plot.

The scatter plot suggests that while case numbers are a key driver of deaths, the relationship is not proportional, indicating cross-country differences in mortality outcomes.