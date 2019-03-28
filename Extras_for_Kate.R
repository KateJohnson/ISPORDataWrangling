library(tidyverse)
library(here)
library(readr)

# Making a few new variables
diabetes$BMI <- ifelse(diabetes$BMI <= 16, "Severely underweight",
                       ifelse(diabetes$BMI > 16 & diabetes$BMI <= 18.5, "Underweight",
                              ifelse(diabetes$BMI > 18.5 & diabetes$BMI <= 25, "Normal",
                                     ifelse(diabetes$BMI > 25 & diabetes$BMI <= 30, "Overweight",
                                            ifelse(diabetes$BMI > 30 & diabetes$BMI <= 45, "Obese",
                                                   ifelse(diabetes$BMI > 45, "Morbidly Obese", 99))))))


diabetes$Pregnancies <- ifelse(diabetes$Pregnancies==0, "0",
                               ifelse(diabetes$Pregnancies >0 & diabetes$Pregnancies <= 3, "1-3",
                                      ifelse(diabetes$Pregnancies >3 & diabetes$Pregnancies <= 6, "4-6",
                                             ifelse(diabetes$Pregnancies >6 & diabetes$Pregnancies <= 9, "7-9",
                                                    ifelse(diabetes$Pregnancies >9, "10+",99)))))


diabetes$ID <- sample(1:768, 768)

# reorder
diabetes <- select(diabetes, ID, Pregnancies:Age, Diabetes=Outcome)
write_csv(diabetes, here("/Data/diabetes.csv"))

# Create a new dataset for joining
diabetes_extra <- diabetes %>% 
                    mutate(Cholesterol=ifelse(diabetes$Diabetes==1, round(rnorm(nrow(diabetes),250,25),0),
                                       ifelse(diabetes$Diabetes==0, round(rnorm(nrow(diabetes),175,25),0), 0))) %>% 
                    mutate(FamilyHistory=ifelse(diabetes$Diabetes==0, sample(0:1,nrow(diabetes),
                                                replace=TRUE, prob=c(0.65,0.35)),
                                          ifelse(diabetes$Diabetes==1, sample(0:1,nrow(diabetes),
                                                 replace=TRUE, prob=c(0.35,0.65)),99))) %>% 
                    mutate(ActivityLevel=ifelse(diabetes$Diabetes==0, sample(1:5,nrow(diabetes),
                                                replace=TRUE, prob=c(0.10,0.20,0.22,0.23,0.25)),
                                          ifelse(diabetes$Diabetes==1, sample(1:5,nrow(diabetes),
                                                 replace=TRUE, prob=c(0.25,0.23,0.22,0.20,0.10)),99)))
removeIDs <- sample(1:768,8)

diabetes_extra <- diabetes_extra %>% 
                      filter(!(ID %in% removeIDs)) %>% 
                        select(ID, Cholesterol, FamilyHistory, ActivityLevel)

write_csv(diabetes_extra, here("/Data/diabetes_extra.csv"))      


