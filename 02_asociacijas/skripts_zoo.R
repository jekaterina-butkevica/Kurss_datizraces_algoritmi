# Ja nepieciešams, uzinstalē
library(here)
library(foreign)
library(ggplot2)

# Nolasāggplot2# Nolasām .data (vai .csv) failu
# header=TRUE, ja failā jau ir kolonnu nosaukumi
# Teksta faila nolasīšana
zoo <- read.csv("./02_asociacijas/Data/zoo.data", 
                header = FALSE)

zoo <- zoo[ , -c(1, 14, 18)]

nosaukumi <- c("hair","feathers","eggs","milk",
                   "airborne","aquatic","predator","toothed",
                   "backbone","breathes","venomous","fins",
                   "tail","domestic","catsize")

colnames(zoo) <-  nosaukumi

zoo[ , nosaukumi] <- lapply(zoo[ , nosaukumi], as.factor)

write.arff(zoo, file = "./02_asociacijas/Data/zoo.arff")

getwd()
