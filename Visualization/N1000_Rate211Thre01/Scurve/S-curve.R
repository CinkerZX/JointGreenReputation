getwd()
setwd('../../../Pre-exp/DataN1000R211Thre01/Data')
# Line 56 also need to update
# Line 130 also need to update

# Package
library(data.table)
library(dplyr)
library(latex2exp)
library(ggplot2)
library(gridExtra)
library(readxl)
library(readr)


# library(facetscales)
library(tidyr)
library(scales)
library(patchwork)
library(latex2exp)
library(stringr)
library(forstringr)

## Step 1: Data Prepare
# Calculate the T2G rate of each category
T2G_rate <- function(T) { # T is the termination step when N=100, T=50
  # load file names
  file_names = get_file_names_helper("dynamicT2G")
  N = get_N_helper(file_names[1])
  
  # Ini
  num_para_set = length(file_names)
  alpha = c(rep(0, num_para_set))
  k = c(rep(0, num_para_set))
  df_T2G <- data.frame(rate = numeric(),
                       role_rep = character(),
                       timeStep_rep = numeric(),
                       expId_rep = numeric())
  
  # read files
  for (i in 1:num_para_set){
    alpha[i] = get_Alpha_helper(file_names[i]) # 1*1
    k[i] = get_K_helper(file_names[i])# 1*1
    T2G_rate = T2G_rate_helper(file_names[i], T, N)
    df_T2G = rbind(df_T2G, T2G_rate)
  }
  
  num_row_in_one_para_set = nrow(df_T2G)/num_para_set
  alpha_rep = rep(alpha, each = num_row_in_one_para_set)
  k_rep = rep(k, each = num_row_in_one_para_set)
  
  # Complete the dataframe
  df_T2G$alpha_rep <- alpha_rep
  df_T2G$k_rep <- k_rep
  
  write.csv(df_T2G, file = "../../../Visualization/N1000_Rate211Thre01/Scurve/Scurvedf_T2G.csv", row.names = FALSE)
}

## helper functions
get_file_names_helper <- function(keywords){
  list.files(path = '.',
             pattern = paste(keywords,".*\\.csv", sep = ""),
             full.names = TRUE)
}

get_N_helper <- function(fullName){
  s = str_extract_part(fullName, pattern = "N", before = FALSE)
  s = str_extract_part(s, before = TRUE, pattern = "Alpha")
  return(as.numeric(s))
}

get_Alpha_helper <- function(fileName){
  s = str_extract_part(fileName, before = FALSE, pattern = "Alpha")
  s = str_extract_part(s, before = TRUE, pattern = "k")
  return(as.numeric(s)/100)
}

get_K_helper <- function(fileName){
  s = str_extract_part(fileName, before = FALSE, pattern = "k")
  s = str_extract_part(s, before = TRUE, pattern = "_")
  return(as.numeric(s)/100)
}

T2G_rate_helper <- function(fileName, T, N){
  # Read the origional table, and return a dataframe
  # \| rate 1 | category 3 | time 50 | repeatTime 20
  # \|        | Supplier/Manufacturer/Retailer | 1, 2, ... 51 | 1, 2, ... 20|
  # This dataframe is 1020 * 4
  fileName <- sub("\\~\\$", "", fileName)
  myDataframe <- read_csv(fileName, col_names = FALSE)
  # myDataframe <- read_csv("N1000Alpha025k005_dynamicJR.csv", col_names = FALSE)
  
  repeatTimes <- nrow(myDataframe)/(T+1)
  
  numSupplier <- round(N/3)
  colIdSupplier <- c(1:numSupplier)
  colIdManufacturer <- c((numSupplier+1) : (numSupplier*2))
  colIdRetailer <- c((numSupplier*2+1):N)
  
  rate <- c()
  for (i in 1:repeatTimes){
    subDataFrame <- myDataframe[((i-1)*(T+1)+1):((T+1)*i),]
    
    T2G_rate_Supplier = rowSums(subDataFrame[,colIdSupplier])/numSupplier
    T2G_rate_Manufacturer = rowSums(subDataFrame[,colIdManufacturer])/numSupplier
    T2G_rate_Retailer = rowSums(subDataFrame[,colIdRetailer])/length(colIdRetailer)
    
    rate <- append(rate, c(T2G_rate_Supplier,
                           T2G_rate_Manufacturer,
                           T2G_rate_Retailer))
  }
  
  role <- c("Supplier", "Manufacturer", "Retailer") # 3
  role_rep <- rep(role, each = T+1, times = repeatTimes) # 3*51*20
  timeStep <- c(1:(T+1)) # 51
  timeStep_rep <- rep(timeStep, times = 3*repeatTimes) # 51*3*20
  expId <- c(1:repeatTimes) # 20
  expId_rep <- rep(expId, each = (T+1)*3) # 20*51*3
  
  T2G_rate <- data.frame(rate, role_rep, timeStep_rep, expId_rep)
  
  return(T2G_rate)
}

# Data preparation
T2G_rate(50)


## Step 2: Visualization
setwd("../../../Visualization/N1000_Rate211Thre01/Scurve")
df_T2G <- read_csv("Scurvedf_T2G.csv")

generate_S_Curve <- function(k, df_T2G, x_max, y_min){
  # Step 2.1 read the data as df and Subset k
  df <- df_T2G[df_T2G$k_rep==k, ]
  nrow(df)
  colnames(df) <- c("rate", "role", "timeStep", "expID", "alpha", "k")
  
  # Step 2.2 calculate the average rate among the 20 groups of exp
  avg_data <- df %>%
    group_by(timeStep, role, alpha, k) %>%
    summarize(ave_rate = mean(rate), .groups = "drop")
  # View(avg_data)
  
  # Step 2.2 plot
  df$alpha <- factor(df$alpha,
                     levels = c(0.25, 0.5, 0.75),
                     labels=c('alpha==0.25', 'alpha==0.5', 'alpha==0.75'))
  avg_data$alpha <- factor(avg_data$alpha,
                           levels = c(0.25, 0.5, 0.75),
                           labels=c('alpha==0.25', 'alpha==0.5', 'alpha==0.75'))
  
  df$role <- factor(df$role,
                    levels = c("Supplier", "Manufacturer", "Retailer"))
  
  avg_data$role <- factor(avg_data$role,
                          levels = c("Supplier", "Manufacturer", "Retailer"))
  
  my_plot <- ggplot(df, aes(x = timeStep, y = rate)) +
    geom_line(aes(group = expID), alpha = 0.3) + # Individual curves with transparency
    geom_line(data = avg_data,
              aes(x = timeStep, y = ave_rate),
              color = 'red',
              size = 1) + # Ave curves thicker
    xlim(0, x_max)+
    ylim(y_min, 1)+
    labs(x = "Time Step", y = "T2G Rate")+
    facet_grid(alpha ~ role, labeller = label_parsed)
  
  fileName <- paste0("S-Curve of Transformation K=", as.character(k), ".pdf")
  ggsave(fileName, plot = my_plot, height = 4.2, width = 7)
}

# Helper Function
alpha_labeller <- function(variable){
  print(variable[[1]])
  if (variable[[1]]==0.25 ||variable[[2]]==0.25 ||variable[[3]]==0.25)
  { return(c(expression(alpha = 0.5),
              expression(alpha = 0.5),
              expression(alpha = 0.75)))}
  return(variable)
}

generate_S_Curve(0.25, df_T2G, 50, 0)
generate_S_Curve(0.5, df_T2G, 50, 0.1)
generate_S_Curve(0.75, df_T2G, 50, 0.6)

generate_S_Curve(0.05, df_T2G, 50, 0)
generate_S_Curve(0.1, df_T2G, 50, 0)
generate_S_Curve(0.15, df_T2G, 50, 0)
generate_S_Curve(0.2, df_T2G, 50, 0)

