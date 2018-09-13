# Predicting income using 1994 Census Data
### Predicting income using 1994 Census Data

## Abstract

The goal was to find the best model that would predict if an individual makes more than $50,000 a year. Also want to find out which predictor variables had the largest impact in determining this. Used machine learning alogorithms: Decision Trees, Logistic Regression, and Random Forests. Random Forests ended up being the best model with the highest AUC and lowest misclassification error rate. Variables such as `Education`, `Relationship`, `Marital_status`, and `Occupation` were important predictors when predicting `Income`. 
## Introduction

The focus of this project is on predicting if an individual makes more than $50,000 a year. The data used in this project was taken from the 1994 Census Database and was provided by the UCI Machine Learning Repository. 

This project is done in R and uses the packages `ggplot2`, `plyr`, `dplyr`, `class`, `tree`, `randomForest`, and `ROCR`. The models showed that education was indeed a very important predictor in determining whether or not an individual made more than $50,000, as well as Capital Gain, Relationship, Age, and Occupation. Race, Sex, and Working Class were consisitently marked as predictors that had the least amount of impact on income. 

