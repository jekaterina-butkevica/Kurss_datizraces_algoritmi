library(foreign)
data <- read.arff("speeddating.arff")
colnames(data)


library(CORElearn) # Relief algoritms
library(rpart)       # Lēmumu koki
library(rpart.plot)


# Izvēlamies būtiskākās kolonnas (lai nesarežģītu modeli)
df_subset <- data[, c("gender", "age", "d_age", "samerace", "importance_same_race",
                  "field", "pref_o_attractive", "pref_o_sincere", 
                  "pref_o_intelligence", "pref_o_funny", "pref_o_ambitious",
                  "pref_o_shared_interests", "attractive_o", "sinsere_o",
                  "intelligence_o", "funny_o", "ambitous_o", "shared_interests_o",
                  "d_attractive_o", "d_sinsere_o", "d_intelligence_o", 
                  "d_funny_o", "d_ambitous_o", "d_shared_interests_o", 
                  "attractive_important", "sincere_important", "intellicence_important",
                  "funny_important", "ambtition_important", "shared_interests_important",
                  "d_attractive_important", "d_sincere_important", 
                  "d_intellicence_important", "d_funny_important", "d_ambtition_important",
                  "d_shared_interests_important", "attractive", "sincere", "intelligence",
                  "funny", "ambition", "d_attractive", "d_sincere", "d_intelligence",
                  "d_funny", "d_ambition", "attractive_partner", "sincere_partner",
                  "intelligence_partner", "funny_partner", "ambition_partner",
                  "shared_interests_partner", "d_attractive_partner", "d_sincere_partner",
                  "d_intelligence_partner", "d_funny_partner", "d_ambition_partner",
                  "d_shared_interests_partner", "like", "guess_prob_liked", "d_like",
                  "d_guess_prob_liked", "met", "match")]

write.arff(df_subset, file = "speeddating_short.arff")
