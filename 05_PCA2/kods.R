library(ggplot2)
library(foreign)

dati <- cars

dati$kv_speed <- dati$speed^2

ggplot(dati, aes(kv_speed, dist)) +
  geom_point() +
  geom_smooth(method = "lm", se = TRUE, color = "blue") + 
  geom_smooth(method = "loess", se = TRUE, color = "red")


write.arff(dati, file = "./05_PCA2/cars.arff")

url <- "https://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.data"
wine <- read.csv(url, header = FALSE)

colnames(wine) <- c("Type", "Alcohol", "Malic_Acid", "Ash", "Alcalinity", "Magnesium",
                    "Total_Phenols", "Flavanoids", "Nonflavanoid_Phenols",
                    "Proanthocyanins", "Color_Intensity", "Hue",
                    "OD280_OD315", "Proline")

head(wine)

colnames(wine)

wine$kv_Flavanoids <- wine$Flavanoids^2
wine$kv_Alcohol <- wine$Alcohol^2
wine$kv_Color_Intensity <- wine$Color_Intensity^2

wine$Type <- as.factor(wine$Type)

write.arff(wine, file = "./05_PCA2/vins.arff")

# Skalēšana
wine2 <- data.frame(Type = wine$Type[1:nrow(wine)])

wine2 <- data.frame(Type = wine$Type, scale(wine[ , -1]))
head(wine2)

write.arff(wine2, file = "./05_PCA2/vins2.arff")










