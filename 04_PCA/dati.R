library(foreign)
library(palmerpenguins)
library(tidyverse)

data("USArrests")

colnames(dati)[1] <- "Valsts"
head(USArrests)

USArrests <- cbind(State = rownames(USArrests), USArrests)
rownames(USArrests) <- NULL
head(USArrests)

USArrests$State <- as.factor(USArrests$State)

write.arff(USArrests, file = "./04_PCA/USArrests.arff")



pingvini <- penguins


pingvini_f <- pingvini %>%
  mutate(across(everything(),
                ~ if (is.numeric(.x)) .x else as.factor(.x)))


write.arff(pingvini_f, file = "./04_PCA/pingvini_full.arff")


