# Pakotnes ----
library(dplyr)
library(foreign)
library(tidyverse)
library(palmerpenguins)

# Dati
pingvini <- penguins

pingvini <- pingvini %>%
  select(-sex, -year) %>%
  relocate(species, .after = last_col())


pingvini_f <- pingvini %>%
  mutate(across(everything(),
                ~ if (is.numeric(.x)) .x else as.factor(.x)))
                  

write.arff(pingvini_f, file = "./03_lemumu_koki/pingvini.arff")



         
         