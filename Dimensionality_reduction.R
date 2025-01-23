

# Import Libraries --------------------------------------------------------
library(tidyverse)
library(rhdf5)
library(ggplot2)
library(gapminder) # dataset
library(finalfit)
library(plotly)
library(R.matlab)

# Importing TFR and LFP  --------------------------------------------------------

# Define the file path for TFR
file_path <- "C:/Users/Data Acquistion/OneDrive - The University of Western Ontario/PhD_Projects/Phase_reset/Results/TFR/Celestine/20190508/TFR_wavelet.mat"

# Inspect the file structure
#h5ls(file_path)

# Read pre-computed wavelet Time frequency representation for example session
data_structure <- h5read(file_path, "TFRwavelet")

#Define LFP path
LFP_file_path <-"0508_NSP_corrected.mat"
#read LFP .mat
mat_data <- readMat(LFP_file_path)
LFP=mat_data[["NS2"]][[2]]
# Parsing and visualizing  --------------------------------------------------------
TFR<- data_structure$powspctrm
Freq<- data_structure$freq
Time<- data_structure$time
glimpse(TFR)

#Plotting parameters
time_plot_range=1:10000 # in seconds
channel=1
Frequency=5
p <- plot_ly(x=Time[time_plot_range],y = TFR[channel,Frequency,time_plot_range], type = 'scatter', mode = 'markers')
p

