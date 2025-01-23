library(tidyverse)
library(rhdf5)


## Importing TFR and visualizing


# Define the file path
file_path <- "C:/Users/Data Acquistion/OneDrive - The University of Western Ontario/PhD_Projects/Phase_reset/Results/TFR/Celestine/20190508/TFR_wavelet.mat"


# Inspect the file structure
#h5ls(file_path)

# Read a specific dataset
data <- h5read(file_path, "TFRwavelet")



