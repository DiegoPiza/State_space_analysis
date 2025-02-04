# Import Libraries --------------------------------------------------------
library(tidyverse)
library(rhdf5)
library(ggplot2)
library(gapminder) # dataset
library(finalfit)
library(plotly)
library(R.matlab)
library (signal)
# Importing LFP  --------------------------------------------------------
file_path <- "Data/HEU_NA/Subject16/St01_DataSegment_RPHc.mat"


# Read seeg data
data_structure <- readMat(file_path)
ch_index=1:10#index of channels to process

# preprocessing each channel, lowpass & notch (line noise) filter
# Define parameters
filter_order <- 4
Fs <- 2048
lp <- 0

macro_labels<- c("LAHc","LPHc","RAHc","RPHc")


filter_signal_DB <- function(ch_data, Fs, filter_order, lowpass_range, notch1_range, notch2_range) {
  # Calculate time vector
  dt <- 1 / Fs
  T <- length(ch_data) / Fs
  time <- seq(dt, T, by = dt)

  # Step 1: Lowpass filter
  bf_low <- butter(filter_order, lowpass_range / (Fs / 2), type = "pass")
  xw <- filtfilt(bf_low, ch_data)

  # Step 2: Notch filter 60Hz
  bf_notch1 <- butter(filter_order, notch1_range / (Fs / 2), type = "stop")
  xw <- filtfilt(bf_notch1, xw)

  # Step 3: Notch filter Harmonics
  bf_notch2 <- butter(filter_order, notch2_range / (Fs / 2), type = "stop")
  xw <- filtfilt(bf_notch2, xw)

  # Return the filtered signal
  return(xw)
}

processed_data<- list()

for (ii in 1:length(data_structure[["Data"]])) {
  # Access the current field
  macro_data <- data_structure[["Data"]][[ii]]
  electrode_name <- macro_labels[ii]  # Get the current electrode name

  # Initialize a list to store data for the current electrode
  processed_data[[electrode_name]] <- list()

  # Process each channel from macro contact
for (jj in ch_index){
  ch_data <- data_structure[["Data"]][[ii]][[jj]]

  # Store the processed data in the list with the same field name
  filtered_signal <- filter_signal_DB(ch_data, Fs, filter_order, lowpass_range = c(5, 150), notch1_range = c(59, 61), notch2_range = c(119, 121))
  # Store the filtered signal in the processed_data list
  processed_data[[electrode_name]][[paste0("Channel_", jj)]] <- filtered_signal
}
}

save(processed_data, file = "Data/HEU_NA/Subject16/processed_data.RData")



# Inspect filtered data
# Create x-axis as the indices of the vectors
x <- seq_along(ch_data)  # Equivalent to 1:length(ch_data)
plot_ly() %>%
  add_trace(
    x = x, y = ch_data,
    type = 'scatter', mode = 'lines',
    name = 'Original Signal',
    line = list(color = 'blue')  # Set line color to blue
  ) %>%
  add_trace(
    x = x, y = filtered_signal,
    type = 'scatter', mode = 'lines',
    name = 'Filtered Signal',
    line = list(color = 'red')  # Set line color to red
  ) %>%
  layout(
    title = "Original vs Filtered Signal",
    xaxis = list(title = "Index"),
    yaxis = list(title = "Amplitude")
  )


