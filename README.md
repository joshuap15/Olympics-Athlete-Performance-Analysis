# Olympics Athlete Performance Analysis

This repository contains the work done for the MGSC 661 final project. The project involves a predictive analysis to identify clusters of athletes based on body composition, focusing on weight and height, and to develop a logistic regression classification model to predict an athlete's success based on these factors.

## Project Description

This project uses historical data from the Olympic Games, spanning from Athens 1896 to Rio 2016, to analyze and predict athletic performance. The analysis involves exploratory data analysis (EDA), clustering using the K-means algorithm, and logistic regression for classification.

## Project Structure

- `docs/`: Contains documentation and the final project report.
  - `Final_poozhikala_joshua.pdf`: The final project report detailing the analysis and results.
- `scripts/`: Contains R scripts used for data analysis and modeling.
  - `MGSC661-FinalExaminationFinalCopy.R`: R script for the final examination analysis.
  - `MGSC661-FinalExaminationFinalCopyLogisticRegression.R`: R script for logistic regression analysis.

## Dataset

The dataset used in this project is from Kaggle and contains historical information on Olympic athletes. Due to its large size, the dataset is not included in this repository. You can download the dataset from the following link:

[Olympics Dataset on Kaggle](https://www.kaggle.com/datasets/heesoo37/120-years-of-olympic-history-athletes-and-results)

### Data Description

The dataset (`athlete_events.csv`) contains historical information on Olympic athletes, with 271,116 rows and 15 columns. Key variables include:
- `ID`: Unique identifier for each athlete
- `Name`: Athlete's name
- `Sex`: Male or Female
- `Age`: Age of the athlete
- `Height`: Height in centimeters
- `Weight`: Weight in kilograms
- `NOC`: National Olympic Committee code
- `Team`: Country the athlete is competing for
- `Games`: Year and season of the Olympics
- `Year`: Year of the Olympics
- `Season`: Summer or Winter
- `City`: Host city
- `Sport`: Sport in which the athlete competed
- `Event`: Specific event the athlete competed in
- `Medal`: Gold, Silver, Bronze, or NA (no medal)

## Methodology

1. **Exploratory Data Analysis (EDA):**
   - Understand the structure and distribution of the dataset.
   - Handle missing values and preprocess data for modeling.

2. **Clustering Analysis:**
   - Use K-means clustering to group athletes based on height and weight.
   - Determine the optimal number of clusters using the Elbow method.
   - Analyze clustering results for both male and female athletes across summer and winter sports.

3. **Logistic Regression Classification:**
   - Develop a logistic regression model to classify whether an athlete wins a medal based on age, sex, height, and weight.
   - Split the dataset into training (70%) and testing (30%) sets.
   - Evaluate the model's performance using metrics such as accuracy, precision, recall, and confusion matrix.

## Results

- **Clustering Analysis:**
  - Identified distinct clusters of athletes with similar body compositions.
  - Clusters correlated with specific sports disciplines, indicating different physical requirements for different sports.

- **Logistic Regression Classification:**
  - The model achieved an overall accuracy of 85.39% but struggled to predict medal winners effectively.
  - Identified issues with class imbalance and model bias towards predicting 'no medal'.

## Learning Experience

The project involved challenges such as handling a large dataset, addressing class imbalance in the classification model, and interpreting clustering results. Key learnings included the importance of data preprocessing, the application of clustering techniques, and the evaluation of classification models.

