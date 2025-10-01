library(arules)
library(foreign)


## Apriori

data("Groceries")

m <- as(Groceries, "matrix")  # 9835 rindas × 169 kolonnas
head(m[,1:10])                # skatīt pirmās kolonnas

m_num <- ifelse(m, 1, 0)


set.seed(124)                       # lai rezultāts reproducētos
m_num_small <- m_num[sample(nrow(m_num), nrow(m_num) *0.5),]

set.seed(344)  # reproducējamība
cols_keep <- sample(ncol(m_num_small), 25)
m_num_small <- m_num_small[, cols_keep]

# Pārveido katru kolonnu par faktoru
m_fact <- as.data.frame(lapply(as.data.frame(m_num_small), factor))


write.arff(m_fact, file = "./02_asociacijas/Data/Groceries_05_25.arff")



# FPGrowth
fact <- as.data.frame(lapply(as.data.frame(m_num), factor))
write.arff(fact, file = "./02_asociacijas/Data/Groceries_full.arff")
