library(arules)
library(foreign)

data("Groceries")

m <- as(Groceries, "matrix")  # 9835 rindas × 169 kolonnas
head(m[,1:10])                # skatīt pirmās kolonnas

m_num <- ifelse(m, 1, 0)

# Pārveido katru kolonnu par faktoru
m_fact <- as.data.frame(lapply(as.data.frame(m_num), factor))


write.arff(m_fact, file = "./02_asociacijas/Data/Groceries.arff")