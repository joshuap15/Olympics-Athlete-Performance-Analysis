# Loading Libraries
library(ggplot2)
library(dplyr)
install.packages("cluster")
library(cluster)
# Data Loading and Initial Exploration
file_path <- "C:\\Users\\Admin\\Downloads\\athlete_events.csv" 
olympicgames=read.csv(file_path)
print(dim(olympicgames)) # Dataset dimensions
print(head(olympicgames, n=15)) # First 15 rows of the dataset

# Data Transformation and Cleaning
olympicgames$Weight <- as.integer(olympicgames$Weight)
olympicgames$Sex <- factor(olympicgames$Sex)
View(olympicgames)
# Define Medal as a factor with "No Medal" as an additional level
olympicgames$Medal <- factor(olympicgames$Medal, levels = c('Bronze', 'Silver', 'Gold', 'No Medal'), ordered = TRUE)

# Handling Missing Values
# Replace NA in Age with mean age, excluding NAs
olympicgames$Age <- ifelse(is.na(olympicgames$Age), mean(olympicgames$Age, na.rm = TRUE), olympicgames$Age)

# Remove rows where Height or Weight is NA (but keep rows with NA in Medal)
olympicgames <- olympicgames[!is.na(olympicgames$Height) & !is.na(olympicgames$Weight),]

# Replace NA in Medal with 'No Medal'
olympicgames$Medal[is.na(olympicgames$Medal)] <- 'No Medal'

# View the modified data frame
View(olympicgames)

####### Exploratory Data Analysis (EDA)##############
# Gender Distribution
olympics_female_data <- olympicgames[olympicgames$Sex == 'F',]
olympics_male_data <- olympicgames[olympicgames$Sex == 'M',]
no_of_female_participants <- length(unique(olympics_female_data$Name))
no_of_male_participants <- length(unique(olympics_male_data$Name))

# Adjust margins
par(mar=c(4, 4, 2, 2)) 

# Create bar plot
barplot(c(no_of_male_participants, no_of_female_participants), 
        main = "Male vs Female Participants",
        xlab = "Gender",
        ylab = "Count",
        names.arg = c("Male","Female"))

# Medals Analysis
gold_winners <- olympicgames[olympicgames$Medal=='Gold',]
silver_winners <- olympicgames[olympicgames$Medal=='Silver',]
bronze_winners <- olympicgames[olympicgames$Medal=='Bronze',]

# Gold Medals by Country - Top20
gold_data_top50 <- olympicgames %>%
  filter(Medal == "Gold") %>%
  group_by(Team) %>%
  summarize(gold_count = n(), .groups = 'drop') %>%
  top_n(20, gold_count) %>%
  arrange(desc(gold_count))

ggplot(data = gold_data_top50, aes(x = Team, y = gold_count)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Top 20 Countries in Gold Medal Count")

# Silver Medals by Country - Top 20
silver_data_top20 <- olympicgames %>%
  filter(Medal == "Silver") %>%
  group_by(Team) %>%
  summarize(silver_count = n(), .groups = 'drop') %>%
  top_n(20, silver_count) %>%
  arrange(desc(silver_count))

ggplot(data = silver_data_top20, aes(x = Team, y = silver_count)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Top 20 Countries in Silver Medal Count")

# Bronze Medals by Country - Top 20
bronze_data_top20 <- olympicgames %>%
  filter(Medal == "Bronze") %>%
  group_by(Team) %>%
  summarize(bronze_count = n(), .groups = 'drop') %>%
  top_n(20, bronze_count) %>%
  arrange(desc(bronze_count))

ggplot(data = bronze_data_top20, aes(x = Team, y = bronze_count)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Top 20 Countries in Bronze Medal Count")

#### Box and Whisker-Plot of Height and Weight Variable##### 
# Boxplot for Height
boxplot(olympicgames$Height,
        main = "Boxplot of Athlete Heights",
        ylab = "Height (cm)",
        col = "lightblue",
        border = "darkblue")

# Boxplot for Weight
boxplot(olympicgames$Weight,
        main = "Boxplot of Athlete Weights",
        ylab = "Weight (kg)",
        col = "lightgreen",
        border = "darkgreen")




######## Clustering Task for Height and Weight Version 1#########
# Splitting the dataset into male and female subsets
olympicgames_male <- olympicgames[olympicgames$Sex == 'M', ]
olympicgames_female <- olympicgames[olympicgames$Sex == 'F', ]
#####USING THE ELBOW METHOD TO DETERMINE OPTIMAL CLUSTERING VALUES########
# Calculating WCSS for male athletes
wcss_male <- sapply(1:10, function(k) {
  kmeans(scale(olympicgames_male[, c("Height", "Weight")]), centers = k, nstart = 20)$tot.withinss
})

# Plotting the Elbow Method for male athletes
plot(1:10, wcss_male, type = "b", 
     xlab = "Number of Clusters", 
     ylab = "Within-Cluster Sum of Squares", 
     main = "Elbow Method for Optimal K (Male Athletes)")
# Calculating WCSS for female athletes
wcss_female <- sapply(1:10, function(k) {
  kmeans(scale(olympicgames_female[, c("Height", "Weight")]), centers = k, nstart = 20)$tot.withinss
})

# Plotting the Elbow Method for female athletes
plot(1:10, wcss_female, type = "b", 
     xlab = "Number of Clusters", 
     ylab = "Within-Cluster Sum of Squares", 
     main = "Elbow Method for Optimal K (Female Athletes)")
#####CLUSTERING MODEL VERSION 1##############
# Clustering for Males
olympicgames_male$Cluster <- kmeans(scale(olympicgames_male[, c("Height", "Weight")]), centers = 3)$cluster

# Clustering for Females
olympicgames_female$Cluster <- kmeans(scale(olympicgames_female[, c("Height", "Weight")]), centers = 3)$cluster



# Plotting for Male Athletes
ggplot(olympicgames_male, aes(x = Height, y = Weight, color = as.factor(Cluster))) +
  geom_point(alpha = 0.5) +
  theme_minimal() +
  labs(title = "K-means Clustering of Male Athletes by Height and Weight",
       x = "Height (cm)",
       y = "Weight (kg)",
       color = "Cluster")

# Plotting for Female Athletes
ggplot(olympicgames_female, aes(x = Height, y = Weight, color = as.factor(Cluster))) +
  geom_point(alpha = 0.5) +
  theme_minimal() +
  labs(title = "K-means Clustering of Female Athletes by Height and Weight",
       x = "Height (cm)",
       y = "Weight (kg)",
       color = "Cluster")


##SUMMARIZING AND PLOTTING RESULTS OF CLUSTERING MODEL VERSION 1#########
# Summarize the sports by cluster for males
sports_by_cluster_male <- olympicgames_male %>%
  group_by(Cluster, Sport) %>%
  summarize(Count = n(), .groups = 'drop') %>%
  arrange(desc(Count))

# Summarize the sports by cluster for females
sports_by_cluster_female <- olympicgames_female %>%
  group_by(Cluster, Sport) %>%
  summarize(Count = n(), .groups = 'drop') %>%
  arrange(desc(Count))

ggplot(sports_by_cluster_male %>% top_n(10,Count), aes(x = reorder(Sport, Count), y = Count, fill = as.factor(Cluster))) +
  geom_bar(stat = "identity") +
  facet_wrap(~ Cluster) +
  coord_flip() +
  labs(title = "Top Sports by Cluster for Male Athletes",
       x = "Sport",
       y = "Count") +
  theme_minimal()

ggplot(sports_by_cluster_female %>% top_n(10, Count), aes(x = reorder(Sport, Count), y = Count, fill = as.factor(Cluster))) +
  geom_bar(stat = "identity") +
  facet_wrap(~ Cluster) +
  coord_flip() +
  labs(title = "Top Sports by Cluster for Female Athletes",
       x = "Sport",
       y = "Count") +
  theme_minimal()

##CLUSTERING FOR HEGIHT AND WEIGHT OF MALE AND FEMALE Athletes in Winter and Summer Olympic Sports########
# Create subsets for male and female athletes in both Summer and Winter Olympics
olympicgames_male_summer <- olympicgames[olympicgames$Sex == 'M' & olympicgames$Season == 'Summer', ]
olympicgames_female_summer <- olympicgames[olympicgames$Sex == 'F' & olympicgames$Season == 'Summer', ]
olympicgames_male_winter <- olympicgames[olympicgames$Sex == 'M' & olympicgames$Season == 'Winter', ]
olympicgames_female_winter <- olympicgames[olympicgames$Sex == 'F' & olympicgames$Season == 'Winter', ]

######ELBOW METHOD FOR LOOKING AT OPTIMAL AMOUNT OF CLUSTERS######
# Function to calculate WCSS for a range of number of clusters
calculate_wcss <- function(data) {
  wcss_values <- numeric(10)
  for (i in 1:10) {
    set.seed(123)  # for reproducibility
    wcss_values[i] <- kmeans(scale(data), centers = i, nstart = 20)$tot.withinss
  }
  return(wcss_values)
}

# Calculate WCSS for each subset
wcss_male_summer <- calculate_wcss(olympicgames_male_summer[, c("Height", "Weight")])
wcss_female_summer <- calculate_wcss(olympicgames_female_summer[, c("Height", "Weight")])
wcss_male_winter <- calculate_wcss(olympicgames_male_winter[, c("Height", "Weight")])
wcss_female_winter <- calculate_wcss(olympicgames_female_winter[, c("Height", "Weight")])

# Plotting the Elbow Method for all subsets
par(mfrow = c(2, 2))  # set plotting area to a 2x2 layout

plot(1:10, wcss_male_summer, type = "b", 
     xlab = "Number of Clusters", 
     ylab = "WCSS",
     main = "Elbow Method for Male Summer Athletes")

plot(1:10, wcss_female_summer, type = "b", 
     xlab = "Number of Clusters", 
     ylab = "WCSS",
     main = "Elbow Method for Female Summer Athletes")

plot(1:10, wcss_male_winter, type = "b", 
     xlab = "Number of Clusters", 
     ylab = "WCSS",
     main = "Elbow Method for Male Winter Athletes")

plot(1:10, wcss_female_winter, type = "b", 
     xlab = "Number of Clusters", 
     ylab = "WCSS",
     main = "Elbow Method for Female Winter Athletes")

par(mfrow = c(1, 1))  # reset to default layout

######PLOTTING THE CLUSTERS########
# Clustering for Male Summer Athletes
set.seed(123)  # Setting seed for reproducibility
optimal_clusters <- 3
olympicgames_male_summer$Cluster <- kmeans(scale(olympicgames_male_summer[, c("Height", "Weight")]), centers = optimal_clusters, nstart = 25)$cluster

# Clustering for Female Summer Athletes
set.seed(123)
olympicgames_female_summer$Cluster <- kmeans(scale(olympicgames_female_summer[, c("Height", "Weight")]), centers = optimal_clusters, nstart = 25)$cluster

# Clustering for Male Winter Athletes
set.seed(123)
olympicgames_male_winter$Cluster <- kmeans(scale(olympicgames_male_winter[, c("Height", "Weight")]), centers = optimal_clusters, nstart = 25)$cluster

# Clustering for Female Winter Athletes
set.seed(123)
olympicgames_female_winter$Cluster <- kmeans(scale(olympicgames_female_winter[, c("Height", "Weight")]), centers = optimal_clusters, nstart = 25)$cluster
library(ggplot2)

# Plot for Male Summer Athletes
ggplot(olympicgames_male_summer, aes(x = Height, y = Weight, color = as.factor(Cluster))) +
  geom_point(alpha = 0.5) +
  theme_minimal() +
  labs(title = "K-means Clustering of Male Summer Athletes by Height and Weight",
       x = "Height (cm)",
       y = "Weight (kg)",
       color = "Cluster")

# Plot for Female Summer Athletes
ggplot(olympicgames_female_summer, aes(x = Height, y = Weight, color = as.factor(Cluster))) +
  geom_point(alpha = 0.5) +
  theme_minimal() +
  labs(title = "K-means Clustering of Female Summer Athletes by Height and Weight",
       x = "Height (cm)",
       y = "Weight (kg)",
       color = "Cluster")

# Plot for Male Winter Athletes
ggplot(olympicgames_male_winter, aes(x = Height, y = Weight, color = as.factor(Cluster))) +
  geom_point(alpha = 0.5) +
  theme_minimal() +
  labs(title = "K-means Clustering of Male Winter Athletes by Height and Weight",
       x = "Height (cm)",
       y = "Weight (kg)",
       color = "Cluster")

# Plot for Female Winter Athletes
ggplot(olympicgames_female_winter, aes(x = Height, y = Weight, color = as.factor(Cluster))) +
  geom_point(alpha = 0.5) +
  theme_minimal() +
  labs(title = "K-means Clustering of Female Winter Athletes by Height and Weight",
       x = "Height (cm)",
       y = "Weight (kg)",
       color = "Cluster")
#####INTERPRETION OF THE CLUSTERING RESULTS######

# Assuming olympicgames_female_winter has a 'Sport' column and 'Cluster' column already assigned from k-means
# Summarize the number of athletes in each sport by cluster
sports_by_cluster <- olympicgames_female_winter %>%
  group_by(Cluster, Sport) %>%
  summarize(Count = n()) %>%
  arrange(Cluster, desc(Count))

# Display the top sports for each cluster
top_sports_by_cluster <- sports_by_cluster %>%
  group_by(Cluster) %>%
  top_n(3, Count) %>%
  ungroup() %>%
  arrange(Cluster, desc(Count))
# Define a function to summarize sports by cluster
summarize_sports_by_cluster <- function(data) {
  return(data %>%
           group_by(Cluster, Sport) %>%
           summarize(Count = n(), .groups = 'drop') %>%
           arrange(Cluster, desc(Count)))
}

# Apply the function to each subset
sports_by_cluster_male_summer <- summarize_sports_by_cluster(olympicgames_male_summer)
sports_by_cluster_female_summer <- summarize_sports_by_cluster(olympicgames_female_summer)
sports_by_cluster_male_winter <- summarize_sports_by_cluster(olympicgames_male_winter)
sports_by_cluster_female_winter <- summarize_sports_by_cluster(olympicgames_female_winter)

# Optionally, print the top sports for the first cluster as an example
print(head(sports_by_cluster_male_summer[sports_by_cluster_male_summer$Cluster == 1,]))
print(head(sports_by_cluster_female_summer[sports_by_cluster_female_summer$Cluster == 1,]))
print(head(sports_by_cluster_male_winter[sports_by_cluster_male_winter$Cluster == 1,]))
print(head(sports_by_cluster_female_winter[sports_by_cluster_female_winter$Cluster == 1,]))
print(head(sports_by_cluster_male_summer[sports_by_cluster_male_summer$Cluster == 2,]))
print(head(sports_by_cluster_female_summer[sports_by_cluster_female_summer$Cluster == 2,]))
print(head(sports_by_cluster_male_winter[sports_by_cluster_male_winter$Cluster == 2,]))
print(head(sports_by_cluster_female_winter[sports_by_cluster_female_winter$Cluster == 2,]))
print(head(sports_by_cluster_male_summer[sports_by_cluster_male_summer$Cluster == 3,]))
print(head(sports_by_cluster_female_summer[sports_by_cluster_female_summer$Cluster == 3,]))
print(head(sports_by_cluster_male_winter[sports_by_cluster_male_winter$Cluster == 3,]))
print(head(sports_by_cluster_female_winter[sports_by_cluster_female_winter$Cluster == 3,]))


