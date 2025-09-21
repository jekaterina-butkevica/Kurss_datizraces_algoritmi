# Ja nepieciešams, uzinstalē
library(here)
library(foreign)

# Nolasām .data (vai .csv) failu
# header=TRUE, ja failā jau ir kolonnu nosaukumi
# Teksta faila nolasīšana
zoo <- read.csv("./02_asociacijas/Data/zoo.data", 
                header = FALSE)


write.arff(zoo, file = "mans_fails.arff")
head(zoo)

colnames(zoo) <- c("animal","hair","feathers","eggs","milk",
                   "airborne","aquatic","predator","toothed",
                   "backbone","breathes","venomous","fins",
                   "legs","tail","domestic","catsize","type")

write.arff(zoo, file = "./02_asociacijas/Data/zoo.arff")
