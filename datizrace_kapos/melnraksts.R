# Pakotnes ----
if (!require("readxl")) install.packages("readxl"); library(readxl)
if (!require("dplyr")) install.packages("dplyr"); library(dplyr)
if (!require("tidyr")) install.packages("tidyr"); library(tidyr)
if (!require("ggplot2")) install.packages("ggplot2"); library(ggplot2)




# Data ----
pirmie_dati <- read.csv("Morticd10_part1")

# Datu atlase
dati <- pirmie_dati[pirmie_dati$Country == 4186,]

 
# Datu pārkārtošana
apvienoti_dati <- dati %>%
  group_by(Sex) %>%         # grupējam pēc dzimuma
  summarise(across(starts_with("Death"), sum, na.rm = TRUE))


apvienoti_dati$Sex <- ifelse(apvienoti_dati$Sex == 1, "Vīrietis", "Sieviete")



# Apvienot 0-4 vienā intervālā
apvienoti_dati$Vec0_4 <- rowSums(apvienoti_dati[, c(
  "Deaths2", "Deaths3", "Deaths4", "Deaths5", "Deaths6"
  )], na.rm = TRUE)

# Izdzest liekas kolonnas
apvienoti_dati <- apvienoti_dati %>%
  select(-Deaths1, -Deaths2, -Deaths3, -Deaths4,
         -Deaths5, -Deaths6,-Deaths25, -Deaths26)


  # Precizēt nosaukumus
apvienoti_dati <- apvienoti_dati %>%
  rename(
    Vec5_9 = Deaths7, Vec10_14 = Deaths8, Vec15_19 = Deaths9,
    Vec20_24 = Deaths10, Vec25_29 = Deaths11, Vec30_34 = Deaths12,
    Vec35_39 = Deaths13, Vec40_44 = Deaths14, Vec45_49 = Deaths15,
    Vec50_54 = Deaths16, Vec55_59 = Deaths17, Vec60_64 = Deaths18,
    Vec65_69 = Deaths19, Vec70_74 = Deaths20, Vec75_79 = Deaths21,
    Vec80_84 = Deaths22, Vec85_89 = Deaths23, Vec90_94 = Deaths24
  )



# Pareizā kolonnu secība 
apvienoti_dati <- apvienoti_dati %>%
  relocate(Vec0_4, .after = 1)  # 2 nozīmē, ka novieto pēc 2. kolonnas

head(apvienoti_dati)

