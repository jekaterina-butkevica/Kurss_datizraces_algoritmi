# Pakotnes ----
if (!require("readxl")) install.packages("readxl"); library(readxl)
if (!require("dplyr")) install.packages("dplyr"); library(dplyr)
if (!require("tidyr")) install.packages("tidyr"); library(tidyr)
if (!require("ggplot2")) install.packages("ggplot2"); library(ggplot2)
if (!require("here")) install.packages("here"); library(here)

# Data ----
pirmie_dati <- read.csv(here("datizrace_kapos", "Morticd10_part1.csv"))

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




# Pirmais uzdevums ---------
# 1. Definē vecuma intervālus un to vidējos punktus
vecuma_kolonnas <- c("Vec65_69","Vec70_74","Vec75_79","Vec80_84","Vec85_89","Vec90_94")
vidus_vecums <- c(67,72,77,82,87,92)  # vidējie vecumi katrai grupai


# 2. Aprēķina vidējo atlikušās dzīves ilgumu katram dzimumam
rezultats1 <- apvienoti_dati %>%
  rowwise() %>%
  mutate(
    kop_65_plus = sum(c_across(all_of(vecuma_kolonnas))),
    suma_vidus = sum(c_across(all_of(vecuma_kolonnas)) * vidus_vecums),
    vid_pec_65 = (suma_vidus - 65 * kop_65_plus)/kop_65_plus
  ) %>%
  select(Sex, vid_pec_65)

rezultats1




# Otrais uzdevums ---------

# 1. Summējam pa dzimumiem
dati_kopa <- apvienoti_dati %>%
  select(-Sex) %>%       # atmet dzimumu
  summarise(across(everything(), sum, na.rm = TRUE))



# 2. Aprēķinam kopējo mirušo skaitu
total <- sum(dati_kopa)

# 3. Pārvēršam datus "long" formā
proporcijas <- dati_kopa %>%
  pivot_longer(cols = everything(),
               names_to = "Vecuma_grupa",
               values_to = "Skaits") %>%
  mutate(Proporcija = Skaits / total * 100)
proporcijas



proporcijas <- proporcijas %>%
  mutate(Vecuma_grupa = factor(Vecuma_grupa,
                               levels = c("Vec0_4", "Vec5_9", "Vec10_14",
                                          "Vec15_19", "Vec20_24", "Vec25_29",
                                          "Vec30_34", "Vec35_39", "Vec40_44",
                                          "Vec45_49", "Vec50_54", "Vec55_59",
                                          "Vec60_64", "Vec65_69", "Vec70_74",
                                          "Vec75_79", "Vec80_84", "Vec85_89",
                                          "Vec90_94")))

ggplot(proporcijas, aes(x = Vecuma_grupa, y = Proporcija)) +
  geom_col(fill = "skyblue") +
  labs(
    title = "Mirušo sadalījums pa vecuma grupām (Graunta stilā)",
    x = "Vecuma grupa",
    y = "No 100 cilvēkiem mirušie"
  ) +
  theme_minimal(base_size = 14)






# trešais uzdevums -----
iedziv_spektrs <- proporcijas %>%
  mutate(Proporcija = Proporcija) %>%
  arrange(Vecuma_grupa) %>%
  # 2. Aprēķinām kumulatīvo summu (cik nomirst līdz attiecīgajam vecumam)
  mutate(Kumul_mirušie = cumsum(Proporcija),
         Dzīvi = 100 - Kumul_mirušie)

iedziv_spektrs




# Pieņemsim, ka tev jau ir aprēķināta tabula 'iedziv_spektrs'
# ar kolonnu Vecuma_grupa un Dzīvi (procenti no 100)

# Sakārto Vecuma_grupa kā faktoru, lai secība būtu pareiza
iedziv_spektrs$Vecuma_grupa <- factor(iedziv_spektrs$Vecuma_grupa, 
                                      levels = iedziv_spektrs$Vecuma_grupa)

# Zīmējam histogrammu
ggplot(iedziv_spektrs, aes(x = Vecuma_grupa, y = Dzīvi)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Iedzīvotāju vecuma spektrs",
       x = "Vecuma grupa",
       y = "Dzīvo (% no 100)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))




