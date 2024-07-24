# Data Loading and Initial Exploration
file_path <- "C:\\Users\\Admin\\Downloads\\athlete_events.csv" 
olympicgames=read.csv(file_path)
print(dim(olympicgames)) # Dataset dimensions
print(head(olympicgames, n=15)) # First 15 rows of the dataset

# Data Transformation and Cleaning
olympicgames$Weight <- as.integer(olympicgames$Weight)
olympicgames$Sex <- factor(olympicgames$Sex)

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

# Logistic Regression Development
olympicgames$Medal <- ifelse(olympicgames$Medal == 'No Medal', 0, 1)

train_index <- sample(1:nrow(olympicgames), nrow(olympicgames)*0.7)
train_data <- olympicgames[train_index, ]
test_data <- olympicgames[-train_index, ]

logit_model <- glm(Medal ~ Age + Sex + Height + Weight, data=train_data, family=binomial())
predictions <- predict(logit_model, test_data, type="response")
predictions <- ifelse(predictions > 0.5, 1, 0)

# Assuming you have 'predictions' and 'test_data$Medal' already defined from previous steps

# Calculate Precision, Recall, and F1 Score
library(caret)
conf_matrix <- confusionMatrix(as.factor(predictions), as.factor(test_data$Medal))
precision <- conf_matrix$byClass['Pos Pred Value']
recall <- conf_matrix$byClass['Sensitivity']
f1 <- 2 * (precision * recall) / (precision + recall)

# Print Precision, Recall, and F1 Score
print(paste("Precision:", precision))
print(paste("Recall:", recall))
print(paste("F1 Score:", f1))
print(paste("Accuracy:", accuracy))
print(conf_matrix)
