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