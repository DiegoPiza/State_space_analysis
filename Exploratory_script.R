

# Import Libraries --------------------------------------------------------
library(tidyverse)
library(rhdf5)

# Importing TFR  --------------------------------------------------------

# Define the file path
file_path <- "C:/Users/Data Acquistion/OneDrive - The University of Western Ontario/PhD_Projects/Phase_reset/Results/TFR/Celestine/20190508/TFR_wavelet.mat"

# Inspect the file structure
#h5ls(file_path)

# Read pre-computed wavelet Time frequency representation for example session
data_structure <- h5read(file_path, "TFRwavelet")

# Parsing and visualizing  --------------------------------------------------------
TFR<- data_structure$powspctrm
Freq<- data_structure$



