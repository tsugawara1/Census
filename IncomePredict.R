library(ggplot2)
library(plyr)
library(dplyr)
library(class)
library(tree)
library(randomForest)
library(ROCR)

adult<- read.csv("~/Library/Mobile Documents/com~apple~CloudDocs/Desktop/Projects/census/adult.data")

adult.names <- c("Age",
                 "Workingclass",
                 "Final_Weight",
                 "Education",
                 "Education_num",
                 "Marital_Status",
                 "Occupation",
                 "Relationship",
                 "Race",
                 "Sex",
                 "Capital_gain",
                 "Capital_loss",
                 "Hours_per_week",
                 "Native_country",
                 "Income")
colnames(adult) <- adult.names
str(adult) #info about dataset 

contrasts(adult$Income)
#Remove education_num and Native_country #Unecessary data
adult <- subset(adult, select = -c(Native_country))
adult<- subset(adult, select= -c(Final_Weight))


#Since missing data is denoted by ?. We need to change it to na so they can actually be removed/altered.
adult[adult == "?"] <- NA

#Check for missing data and remove it
is.na(adult) 
adult <- na.omit(adult)
data.frame(adult)



#How many exactly are <=50k
table(adult$Income)
7841/(24719+7841)
#24 percent of people make less than 50k 

#Okay now lets go through each predictor and visualize the relationship to income
ggplot(adult,aes(x= Age, fill = Income))+
  xlab("Age")+
  ylab ("Count")+
  geom_bar()+
  ggtitle("Age to Income")+
  labs(fill = "Income")
#Most people that make >50k are in there 30s-50s

# predictor working class?
ggplot(adult,aes(x= Workingclass, fill = Income))+
  xlab("Workingclass")+
  ylab ("Count")+
  geom_bar()+
  ggtitle("Working class to Income")+
  labs(fill = "Income")
#We can tell that rate of people that make <=50k is much greater than >50k
#This is to be expected considering the average income in U.S. is around that number
#We can also tell that most people are in private sector
#Doesnt seem like Working class matters much when determing income, Test this more later

levels(adult$Workingclass)[1] <- 'Unknown'
# combine into Government job
adult$Workingclass <- gsub('Federal-gov', 'Government', adult$Workingclass)
adult$Workingclass <- gsub('Local-gov', 'Government', adult$Workingclass)
adult$Workingclass <- gsub('State-gov', 'Government', adult$Workingclass) 

# combine into Sele-Employed job
adult$Workingclass <- gsub('Self-emp-inc', 'Self-Employed', adult$Workingclass)
adult$Workingclass <- gsub('Self-emp-not-inc', 'Self-Employed', adult$Workingclass)

# combine into Other/Unknown
adult$Workingclass <- gsub('Never-worked', 'Other/Unknown', adult$Workingclass)
adult$Workingclass <- gsub('Without-pay', 'Other/Unknown', adult$Workingclass)
adult$Workingclass <- as.factor(adult$Workingclass)

ggplot(adult,aes(x= Education, fill = Income))+
  xlab("Education")+
  ylab ("Count")+
  geom_bar(position = position_stack(reverse = TRUE))+
  ggtitle("Education to Income")+
  labs(fill = "Income")+
  theme(axis.text=element_text(size=4),
        axis.title=element_text(size=10,face="bold"))
#People with Highler level degrees such as bachelors, masters and phds tend to have
#higher income

#Lets see if education number agrees with this 
ggplot(adult,aes(x= Education_num, fill = Income))+
  xlab("Years of education")+
  ylab ("Count")+
  geom_bar(position = position_stack(reverse = TRUE))+
  ggtitle("Education to Income")+
  labs(fill = "Income")+
  theme(axis.text=element_text(size=4),
        axis.title=element_text(size=10,face="bold"))
#Agrees with education level so will remove education level for simplicity
adult <- subset(adult, select = -c(Education))



ggplot(adult,aes(x= Marital_Status, fill = Income))+
  xlab("Marital Status")+
  ylab ("Count")+
  geom_bar(position = position_stack(reverse = TRUE))+
  ggtitle("Marital Status to Income")+
  labs(fill = "Income")+
  theme(axis.text=element_text(size=4),
        axis.title=element_text(size=10,face="bold"))
#People that are married and together have higher chance of >50k
#Looks like husband/wifes will make money 
#Everyone else has low chance

#Oragnize married-categorys better
adult$Marital_Status <- gsub('Married-AF-spouse', 'Married', adult$Marital_Status)
adult$Marital_Status <- gsub('Married-civ-spouse', 'Married', adult$Marital_Status)
adult$Marital_Status <- gsub('Married-spouse-absent', 'Married', adult$Marital_Status)
adult$Marital_Status <- gsub('Never-married', 'Single', adult$Marital_Status)
adult$Marital_Status <- as.factor(adult$Marital_Status)
summary(adult$Marital_Status)

ggplot(adult,aes(x= Marital_Status, fill = Income))+
  xlab("Marital Status")+
  ylab ("Count")+
  geom_bar(position = position_stack(reverse = TRUE))+
  ggtitle("Marital Status to Income")+
  labs(fill = "Income")

#Ok what about people that have a child
statementsub <- adult %>%
  filter(grepl("Own", Relationship))
ggplot(statementsub,aes(x= Relationship, fill = Income))+
  facet_wrap(~Marital_Status)+
  xlab("Own-Child")+
  ylab ("Count")+
  geom_bar()+
  ggtitle("Marital Status")+
  labs(fill = "Income")+
  theme(axis.text=element_text(size=4),
        axis.title=element_text(size=10,face="bold"))
#Looks like in general regardless of marital status people that have children will not have higher income


ggplot(adult,aes(x= Occupation, fill = Income))+
  xlab("Occupation")+
  ylab ("Count")+
  geom_bar()+
  ggtitle("Occupation to Income")+
  labs(fill = "Income")+
  theme(axis.text=element_text(size=4),
        axis.title=element_text(size=10,face="bold"))
#Exec-managerial and professionals with a speciality have high rate of >50k

#Lets organize these Occupations into white-collar(managerial,administrative), blue collar(manual work)
#service/pink collar
levels(adult$Occupation)[1] <- 'Unknown'
adult$Occupation <- gsub('Adm-clerical', 'White-Collar', adult$Occupation)
adult$Occupation <- gsub('Craft-repair', 'Blue-Collar', adult$Occupation)
adult$Occupation <- gsub('Exec-managerial', 'White-Collar', adult$Occupation)
adult$Occupation <- gsub('Farming-fishing', 'Blue-Collar', adult$Occupation)
adult$Occupation <- gsub('Handlers-cleaners', 'Blue-Collar', adult$Occupation)
adult$Occupation <- gsub('Machine-op-inspct', 'Blue-Collar', adult$Occupation)
adult$Occupation <- gsub('Other-service', 'Service', adult$Occupation)
adult$Occupation <- gsub('Priv-house-serv', 'Service', adult$Occupation)
adult$Occupation <- gsub('Prof-specialty', 'Professional', adult$Occupation)
adult$Occupation <- gsub('Protective-serv', 'Service', adult$Occupation)
adult$Occupation <- gsub('Tech-support', 'Service', adult$Occupation)
adult$Occupation <- gsub('Transport-moving', 'Blue-Collar', adult$Occupation)
adult$Occupation <- gsub('Unknown', 'Other/Unknown', adult$Occupation)
adult$Occupation <- gsub('Armed-Forces', 'Other/Unknown', adult$Occupation)
adult$Occupation <- as.factor(adult$Occupation)
summary(adult$Occupation)

#Now lets visualize this data
ggplot(adult,aes(x= Occupation, fill = Income))+
  xlab("Occupation")+
  ylab ("Count")+
  geom_bar(position = position_stack(reverse = TRUE))+
  ggtitle("Occupation to Income")+
  labs(fill = "Income")+
  theme(axis.text=element_text(size=4),
        axis.title=element_text(size=10,face="bold"))
#Professional Much higher chance than rest, Then white collar and blue collar

#Ok onto race
ggplot(adult,aes(x= Race, fill = Income))+
  xlab("Race")+
  ylab ("Count")+
  geom_bar(position = position_stack(reverse = TRUE))+
  ggtitle("Race to Income")+
  labs(fill = "Income")+
  theme(axis.text=element_text(size=4),
        axis.title=element_text(size=10,face="bold"))
#Alot more whites than minorities. White maybe tend to earn more?

#Gender?
ggplot(adult,aes(x= Sex, fill = Income))+
  xlab("Gender")+
  ylab ("Count")+
  geom_bar(position = position_stack(reverse = TRUE))+
  ggtitle("Gender to Income")+
  labs(fill = "Income")+
  theme(axis.text=element_text(size=4),
        axis.title=element_text(size=10,face="bold"))
#Statistically males tend to make money


#Add race to visualizaton of sex and income
ggplot(adult,aes(x= Sex, fill = Income))+
  facet_wrap(~Race)+
  xlab("Sex")+
  ylab ("Count")+
  geom_bar(position = position_stack(reverse = TRUE))+
  ggtitle("Race")+
  labs(fill = "Income")+
  theme(axis.text=element_text(size=4),
        axis.title=element_text(size=10,face="bold"))
#Males tend to make more money across all races

#Alright now what about capital gains/losses?
ggplot(adult,aes(x= Capital_gain, fill = Income))+
  xlab("Capital gains")+
  ylab ("Count")+
  geom_histogram(position = position_stack(reverse = TRUE))+
  ggtitle("Capital gains to Income")+
  labs(fill = "Income")+
  theme(axis.text=element_text(size=4),
        axis.title=element_text(size=10,face="bold"))
#Data for capital gains is heavily skewed towards 0, so hard to make any assertions based on it

ggplot(adult,aes(x= Capital_loss, fill = Income))+
  xlab("Capital losses")+
  ylab ("Count")+
  geom_histogram(position = position_stack(reverse = TRUE))+
  ggtitle("Capital losses to Income")+
  labs(fill = "Income")+
  theme(axis.text=element_text(size=4),
        axis.title=element_text(size=10,face="bold"))
#Very little and heavily skewed towards 0, so can't make any assertions based on this

#Decide to remove capital_gains and capital_loss
adult$Capital_gain<- NULL
adult$Capital_loss<-NULL

#Last variable is Hours worked per week
summary(adult$Hours_per_week)
ggplot(adult,aes(x= Hours_per_week, fill = Income))+
  xlab("Hours worked per week")+
  ylab ("Count")+
  geom_histogram(position = position_stack(reverse = TRUE))+
  ggtitle("Hours worked to Income")+
  labs(fill = "Income")+
  theme(axis.text=element_text(size=4),
        axis.title=element_text(size=10,face="bold"))
#Most people work around 40 hours per week. Generally notice that people that work more tend to earn more
#Almost 50 percent of people that work 50hrs/wk earn >50k 



###Ok now on to exploratory modeling#### 

#Logistic Regression#

#First Divide 80% of data into training set and 20% percent into test set
smp_size <- floor(0.80 * nrow(adult))
set.seed(123)
train_indices<- sample(seq_len(nrow(adult)), size = smp_size)
adult.train <- adult[train_indices, ]
adult.test <- adult[-train_indices, ]

log.adult<-glm(Income~ ., data=adult.train,binomial('logit'))
summary(log.adult)

m_full <- log.adult  # full model is the model just fitted
m_null <- glm(Income ~ 1, data = adult.train, family = binomial('logit'))

# backward selection
step(m_full, trace = F, scope = list(lower=formula(m_null), upper=formula(m_full)),
     direction = 'backward')
# forward selection
step(m_null, trace = F, scope = list(lower=formula(m_null), upper=formula(m_full)),
     direction = 'forward')

# create a data frame to store information regarding deviance residuals
index <- 1:dim(adult.train)[1]
dev_resid <- residuals(log.adult)
income <- adult.train$Income
dff <- data.frame(index, dev_resid, income)

ggplot(dff, aes(x = index, y = dev_resid, color = income)) +
  geom_point() + 
  geom_hline(yintercept = 3, linetype = 'dashed', color = 'blue') +
  geom_hline(yintercept = -3, linetype = 'dashed', color = 'blue')

prob <- predict(log.adult, adult.test, type = 'response')
pred <- rep('<=50K', length(prob))
pred[prob>= .5] <- '>50K'
table(pred, adult.test$Income)
#Model was correct(4552+824)/6512 = 82.56% of the time

logreg.pred<- prediction(prob, adult.test$Income)
auc = performance(logreg.pred, "auc")@y.values
auc


library(nnet)
nn1 <- nnet(income ~ ., data = adult.train, size = 40, maxit = 400)                            
nn1.pred <- predict(nn1, newdata = adult.test, type = "raw")
pred1 <- rep('<=50K', length(nn1.pred))
pred1[nn1.pred>=.5] <- '>50K'
table(pred1, adult.test$Income)

library(rpart)
tree2 <- rpart(income ~ ., data = adult.train, method = 'class', cp = 1e-3)
tree2.pred.prob <- predict(tree2, newdata = adult.test, type = 'prob')
tree2.pred <- predict(tree2, newdata = adult.test, type = 'class')
# confusion matrix 
tb2 <- table(tree2.pred, adult.test$Income)
tb2

library(randomForest)
set.seed(1234)
rf.train.1<- adult.train[1:26048, c("Occupation","Age", "Education_num")]

rf.1<-randomForest(x=rf.train.1, y=adult.train$Income, importance=TRUE, ntree=1000)
rf.1 
varImpPlot(rf.1)
rf.1.preds <- predict(rf.1, adult.test$Income)
table(rf.5.preds)
rf.5.preds