# Coded by Felipe del Valle for Yuseff Lab / 2023. Load libraries , if not present then you must install the packages

library(tidyverse)
library(readr)
library(tidyr)

# Select the working environment so it saves the final .csv file to a known location with the command setwd("Working environment pathway")

# Specify the path where the CSV for a and b files are located.   
path <- "PASTE YOUR DATA FOLDER PATH HERE"


# Create an empty list to store the data frames
df_list <- list()


# Loop through all the CSV files in "a" directory and read them into data frames This will extract the columns that are necessary for the analysis 
for (file in list.files(path, pattern = ".csv", full.names = TRUE)) {
  # Extract the name of the file
  file_name <- tools::file_path_sans_ext(basename(file))
  
  # Add the file channel as a new column 
  df_a <- read_csv(file) %>% select(1)
  
  # Add the file name as a new column
  df_a$name <- read_csv(file) %>% select(2)
  
  # Add the columns corresponding to the central mean and Intensity Den 
  df_a$RIDc <- read_csv(file) %>% select(28)
  
  df_a$MEANc <- read_csv(file) %>% select(4)
  
  df_a$IDc <- read_csv(file) %>% select(23)
  
  # Add the columns corresponding to the periphery mean and Intensity Den 
  df_a$RIDt <- read_csv(file) %>% select(62)
  
  df_a$MEANt <- read_csv(file) %>% select(38)
  
  df_a$IDt <- read_csv(file) %>% select(57)
  
  # Same as above but for the XoR exclusion area 
  df_a$RIDxor <- read_csv(file) %>% select(96)
  
  df_a$MEANxor <- read_csv(file) %>% select(72)
  
  df_a$IDxor <- read_csv(file) %>% select(91)
  
  # Append the data frame to the list
  df_list[[file_name]] <- df_a
}


# Combine all the data frames in the list into a single data frame
final_df <- bind_rows(df_list)

# create a final data frame and calculate the center and periphery accumulation of the fluorescence intensity.

results_df <- data.frame(names = final_df$name,  channel=final_df$...1, centro = final_df$MEANc/final_df$MEANxor, periferia = final_df$MEANxor/final_df$MEANt-1)


names(results_df)[1] <- "ImgName"
names(results_df)[2] <- "Channel"
names(results_df)[3] <- "Center"
names(results_df)[4] <- "Periphery"


# save the final csv of results, you can rename this file to your liking
write.csv(results_df,"results.csv", row.names = FALSE)

