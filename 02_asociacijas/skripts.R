# Ja nepieciešams, uzinstalē
library(here)
library(foreign)
library(ggplot2)

# Nolasāggplot2# Nolasām .data (vai .csv) failu
# header=TRUE, ja failā jau ir kolonnu nosaukumi
# Teksta faila nolasīšana
zoo <- read.csv("./02_asociacijas/Data/zoo.data", 
                header = FALSE)



head(zoo)

colnames(zoo) <- c("animal","hair","feathers","eggs","milk",
                   "airborne","aquatic","predator","toothed",
                   "backbone","breathes","venomous","fins",
                   "legs","tail","domestic","catsize","type")

cols_to_factor <- c("hair","feathers","eggs","milk","airborne",
                    "aquatic","predator","toothed","backbone",
                    "breathes","venomous", "legs", "fins","tail","domestic","catsize","type")
zoo[ , cols_to_factor] <- lapply(zoo[ , cols_to_factor], as.factor)

write.arff(zoo, file = "./02_asociacijas/Data/zoo.arff")

