# Classification of 1994 Census Income Data
### Classification of 1994 Census Income Data

## Abstract

In this project, my goal was to find the best model that would predict if an individual makes more than $50,000 a year. I also wanted to find out which predictor variables had the largest impact in determining this. I used Decision Trees, Logistic Regression, and Random Forests in this project. Random Forests ended up being the best model with the highest AUC and lowest misclassification error rate. Variables such as `Education`, `Relationship`, `Marital_status`, and `Occupation` were important predictors when predicting `Income`. In conclusion, this was a successful project that I would like to attempt again with more models and a larger dataset.

## Introduction

The focus of this project is on predicting if an individual makes more than $50,000 a year. The data used in this project was taken from the 1994 Census Database and was provided by the UCI Machine Learning Repository. Income has always been a popular topic and making a lot of money is something that almost everyone has dreamt of at some point in their lives. Growing up, many of my peers and I were told that if we wanted to be successful and get a job that made a lot of money, we would need to go to college. One of the big questions I wanted to answer with this project was how much of an impact does education play in determining an individual's annual income. In addition, I wanted to see what other factors play a role in determining income level and by how much.

This project is done in R and uses the packages `ggplot2`, `plyr`, `dplyr`, `class`, `tree`, `randomForest`, and `ROCR`. I used Decision Trees, Logistic Regression, and Random Forests to perform predictive modeling on the data. The best model was Random Forests, followed by Logistic Regression and then Decision Trees. The models showed that education was indeed a very important predictor in determining whether or not an individual made more than $50,000, as well as Capital Gain, Relationship, Age, and Occupation. Race, Sex, and Working Class were consisitently marked as predictors that had the least amount of impact on income. This report will consist of the step-by-step processes I took to find these conclusions and explanations on the concepts.

## Pre-processing
