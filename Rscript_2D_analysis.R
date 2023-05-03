# Load libraries , if not present then you must install the packages

library(tidyverse)
library(readr)

# Select the working environment so it saves the final .csv file to a known location with the command setwd("Working environment pathway")

# Specify the path where the CSV for a and b files are located.   
path <- "~/DOC/macros/centro_periferia/results_v3"


# Create an empty list to store the data frames
df_list <- list()


# Loop through all the CSV files in "a" directory and read them into data frames
for (file in list.files(path, pattern = ".csv", full.names = TRUE)) {
  # Extract the name of the file
  file_name <- tools::file_path_sans_ext(basename(file))

  # Add the file channel as a new column 
  df_a <- read_csv(file) %>% select(1)
  
  # Add the file name as a new column
  df_a$name <- read_csv(file) %>% select(2)
  
  # Add the file area as a new column
  df_a$RIDc <- read_csv(file) %>% select(28)
  
  df_a$MEANc <- read_csv(file) %>% select(4)
  
  df_a$IDc <- read_csv(file) %>% select(23)
  
  # Add the file area as a new column
  df_a$RIDt <- read_csv(file) %>% select(61)
  
  df_a$MEANt <- read_csv(file) %>% select(37)
  
  df_a$IDt <- read_csv(file) %>% select(56)
  
  # Add the file area as a new column
  df_a$RIDxor <- read_csv(file) %>% select(94)
  
  df_a$MEANxor <- read_csv(file) %>% select(70)
  
  df_a$IDxor <- read_csv(file) %>% select(89)
  
  # Append the data frame to the list
  df_list[[file_name]] <- df_a
}


# Combine all the data frames in the list into a single data frame
final_df <- bind_rows(df_list)

# create a final data frame and calculate the center and periphery accumulation of the fluorescence intensity. Considering the original .ijm script with 1/4 of the cell outline re-scalling. If you change this parameter, you should also change the number 4  in the next line so it correlates with the inverse proportional (if 1/3 , then 3). 

results_df <- data.frame(names = final_df$name,  channel=final_df$...1, centro = final_df$MEANc/final_df$MEANt-1, periferia = final_df$MEANxor/final_df$MEANt-1)


names(results_df)[1] <- "ImgName"
names(results_df)[2] <- "Channel"
names(results_df)[3] <- "Center"
names(results_df)[4] <- "Periphery"


# save the final csv of results 
write.csv(results_df,"results.csv", row.names = FALSE)


results_df2 <- results_df %>%
  gather(key = variable, value = value, -ImgName, -Channel)



ggplot(results_df2, aes(x = Channel, y = value, fill = variable)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_fill_manual(values = c("Center" = "#FF5733", "Periphery" = "#1ABC9C")) +
  labs(x = "Channel", y = "Percentage of fluorescence accumulation", fill = NULL) +
  theme_classic() +
  theme(axis.line = element_line(colour = "black"),
        panel.border = element_blank(),
        legend.position = "bottom",
        legend.background = element_blank(),
        legend.key = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        axis.text = element_text(size = 12, colour = "black"),
        axis.title = element_text(size = 14, face = "bold", colour = "black"),
        legend.text = element_text(size = 12, colour = "black"),
        legend.title = element_blank())


