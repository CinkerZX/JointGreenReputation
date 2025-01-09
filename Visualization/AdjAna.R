#---------- Load Packages ---------
# Install and load pacman if not already installed
if (!require("pacman")) install.packages("pacman")

# Use pacman to install and load the required packages
pacman::p_load(
  data.table,
  dplyr,
  latex2exp,
  ggplot2,
  gridExtra,
  readxl,
  readr,
  tidyr,
  scales,
  patchwork,
  stringr,
  forstringr,
  wesanderson
)


#----------- Visualize the distribution of the distribution of Adj at t -------
setwd("../Pre-exp/Data/N100")
parameter = c("025", "050", "075")
n = 100
# ------ data praperation -------
for (Alpha in parameter) {
  for (K in parameter) {
    # ----- Step 1: Load the dataset ----
    fileName = paste0("N100Alpha", Alpha, "k", K, "_dynamicAdjMatrix.xlsx")
    adj <- read_excel(fileName, col_names = FALSE)
    
    terminationTime = nrow(adj)/(100*20) # 51
    repeatTime = 20
    
    # When reaching the stable state, adj fixed;
    # Idea: Compare the initial distribution (t=1) with the final distribution
    #       Order the degree of each type decrementally, and get the average of exps
    #       Write the organized data in a CSV and visualize it
    
    # ----- Step2: Calculat the average degree -----
    t_series = seq(1, terminationTime, by = 1)
    exp_series = seq(1, repeatTime, by = 1)
    
    # Convert adj to a dataframe if it's not already one
    adj_df <- as.data.frame(adj)
    
    # Initialize adj_exp_t1 as a dataframe with the correct dimensions
    adj_exp_t1 <- data.frame(matrix(0, nrow = length(exp_series) * n, ncol = ncol(adj_df)))
    adj_exp_T <- data.frame(matrix(0, nrow = length(exp_series) * n, ncol = ncol(adj_df)))
    
    # get the adj_matrix of t=1 over the exps
    for (exp in exp_series) {
      adj_start = (exp-1)*terminationTime*n
      adj_exp_t1[(n*(exp-1)+1):(n*exp),] = adj_df[(adj_start+1):(adj_start+n),]
    }
    
    # get the adj_matrix of t=terminationTime over the exps
    for (exp in exp_series) {
      adj_end = exp*terminationTime*n
      adj_exp_T[(n*(exp-1)+1):(n*exp),] = adj_df[(adj_end-n+1):adj_end,]
    }
    
    # Order the degree of each type decrementally, and get the average of exps
    exp_id = rep(c(1:repeatTime), each = n)
    # agent_id = rep(c(1:n), times = repeatTime)
    role = rep(c("Supplier", "Manufacturer", "Retailer"), each = round(n/3))
    role = c(role, rep(c("Retailer"), times = n-(round(n/3))*3))
    role = rep(role, times = repeatTime)
    degree_t1 = rowSums(adj_exp_t1)
    degree_T = rowSums(adj_exp_T)
    df_degree_t1 = data.frame(degree_t1, exp_id, role)
    df_degree_T = data.frame(degree_T, exp_id, role)
    
    # order the degree at t=1
    df_ordered_t1 <- df_degree_t1 %>%
      group_by(exp_id, role) %>%
      arrange(desc(degree_t1), .by_group = TRUE) %>%
      mutate(degree_order = row_number())
    
    # Calculat the average degree of the repeated exp
    df_ordered_t1_ave <- df_ordered_t1 %>%
      group_by(role, degree_order) %>%
      summarize(avg_ordered_degree = mean(degree_t1))
    
    # order the degree at t=T
    df_ordered_T <- df_degree_T %>%
      group_by(exp_id, role) %>% 
      arrange(desc(degree_T), .by_group = TRUE) %>%
      mutate(degree_order = row_number())
    
    # Calculat the average degree of the repeated exp
    df_ordered_T_ave <- df_ordered_T %>%
      group_by(role, degree_order) %>%
      summarize(avg_ordered_degree = mean(degree_T))
    
    # ----- Step3: Output: write the summarized results into csv file -----
    fileNameOutput_t1 = paste0("df_AdjAna_AveDegree_t1_N100Alpha",
                               Alpha,
                               "k",
                               K,
                               ".csv")
    fileNameOutput_T = paste0("df_AdjAna_AveDegree_T_N100Alpha",
                              Alpha,
                              "k",
                              K,
                              ".csv")
    write.csv(df_ordered_t1_ave, fileNameOutput_t1, row.names = FALSE)
    write.csv(df_ordered_T_ave, fileNameOutput_T, row.names = FALSE)
  }
}


# ----- data visualization -----
setwd("../../../Visualization/AdjAnaData")

# Helper function: Frequency counting
countFreq <- function(df){
  mydf = df
  
  Interval = 3
  # Create bins for the degrees
  mydf$degree_bins <- cut(mydf$avg_ordered_degree,
                          breaks = seq(0,
                                       max(mydf$avg_ordered_degree)+Interval,
                                       by = Interval),
                          right = FALSE)
  
  # Add the max degree scale column
  mydf <- mydf %>%
    mutate(UpperDegree = ceiling(avg_ordered_degree/Interval)*Interval)
  
  # Summarize the data
  degree_freq_df <- mydf %>%
    group_by(UpperDegree, role) %>%
    summarise(frequency = n())
  
  # degree_freq_df <- mydf %>%
  #   group_by(degree_bins, role) %>%
  #   summarise(frequency = n())
  
  # Create a new column for facet panels
  degree_freq_df <- degree_freq_df %>%
    mutate(panel = ifelse(role == "Manufacturer", "Panel 2", "Panel 1"))
  
  # Reorder the levels of the role factor
  degree_freq_df$role <- factor(degree_freq_df$role,
                                levels = c("Supplier", "Retailer", "Manufacturer"))
  
  return(degree_freq_df)
}

# Helper function: bar plot
visBarplot <- function(df, figureName){
  degree_freq_df = countFreq(df)
  # Create the bar plot
  my_plot <- ggplot(degree_freq_df, aes(x = UpperDegree,
                                        y = frequency,
                                        fill = role)) +
    geom_bar(stat = "identity", position = "dodge") +
    # scale_fill_brewer(palette = "Set1") +
    scale_fill_manual(values=wes_palette(n=3, "GrandBudapest1"),
                      name = "Role")+
    labs(title = "Degree Distribution", x = "Degree Interval", y = "Frequency") +
    facet_wrap(~ panel)+
    theme(legend.position = "bottom")
  
  fileName <- paste0(figureName, ".pdf")
  ggsave(fileName, plot = my_plot, height = 4.2, width = 7)
}

for (Alpha in parameter) {
  for (K in parameter) {
    # ------ step 1: Load the data -----
    figureName_t1 = paste0("AveDegree_t1_N100Alpha",
                           Alpha,
                           "k",
                           K)
    figureName_T = paste0("AveDegree_T_N100Alpha",
                          Alpha,
                          "k",
                          K)
    
    fileName_t1 = paste0("df_AdjAna_", figureName_t1, ".csv")
    fileName_T = paste0("df_AdjAna_", figureName_T, ".csv")
    df_ordered_t1_ave <- read.csv(fileName_t1, header = TRUE)
    df_ordered_T_ave <- read.csv(fileName_T, header = TRUE)
    
    # ------ step 2: Visualize the degree frequency ------
    visBarplot(df_ordered_t1_ave, figureName_t1)
    visBarplot(df_ordered_T_ave, figureName_T)
  }
}



































