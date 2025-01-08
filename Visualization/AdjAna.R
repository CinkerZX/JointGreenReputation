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
# Load the dataset
setwd("../Pre-exp/Data/N100")
Alpha = "025"
K = "025"
n = 100
fileName = paste0("N100Alpha", Alpha, "k", K, "_dynamicAdjMatrix.xlsx")
adj <- read_excel(fileName, col_names = FALSE)

terminationTime = nrow(adj)/(100*20) # 51
repeatTime = 20

# When reaching the stable state, adj fixed;
# Idea: Compare the initial distribution (t=1) with the final distribution
#       Order the degree of each type decrementally, and get the average of exps
#       Write the organized data in a CSV and visualize it

# ----- data praperation -----
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

# Output: write the summarized results into csv file
write.csv(df_ordered_t1_ave, "df_AdjAna_AveDegree_t1.csv", row.names = FALSE)
write.csv(df_ordered_T_ave, "df_AdjAna_AveDegree_T.csv", row.names = FALSE)

# ----- data visualization -----
# read the data
df_ordered_t1_ave <- read.csv("df_AdjAna_AveDegree_t1.csv", header = TRUE)
df_ordered_T_ave <- read.csv("df_AdjAna_AveDegree_T.csv", header = TRUE)


# Helper function: Frequency counting
countFreq <- function(df){
  mydf = df
  # Create bins for the degrees
  mydf$degree_bins <- cut(mydf$avg_ordered_degree,
                          breaks = seq(0,
                                       max(mydf$avg_ordered_degree)+3,
                                       by = 3),
                          right = FALSE)
  
  
  # Summarize the data
  degree_freq_df <- mydf %>%
    group_by(degree_bins, role) %>%
    summarise(frequency = n())
  
  # Create a new column for facet panels
  degree_freq_df <- degree_freq_df %>%
    mutate(panel = ifelse(role == "Manufacturer", "Panel 2", "Panel 1"))
  
  # Reorder the levels of the role factor
  degree_freq_df$role <- factor(degree_freq_df$role,
                                levels = c("Supplier", "Retailer", "Manufacturer"))
  
  
  return(degree_freq_df)
}

# Helper function to 

# define helper function to draw bar plot


library(wesanderson)
# Create the bar plot
ggplot(degree_freq_df, aes(x = degree_bins,
                           y = frequency,
                           fill = role)) +
  geom_bar(stat = "identity", position = "dodge") +
  # scale_fill_brewer(palette = "Set1") +
  scale_fill_manual(values=wes_palette(n=3, "GrandBudapest1"),
                    name = "Role")+
  labs(title = "Degree Distribution", x = "Degree Interval", y = "Frequency") +
  facet_wrap(~ panel)




























