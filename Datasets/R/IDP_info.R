IDPs = read.csv("Displaced People 2010-2021.csv", check.names = F)
names(IDPs)[names(IDPs) == "IDPs"] = "Internally Displaced People"
names(IDPs)[2:3] = c("Refugees", "Asylum Seekers")

library(tidyverse)

IDPs = IDPs %>% pivot_longer(cols = 2:4, names_to = "DP type", values_to = "Value")

IDPs
write.csv(IDPs, file = "Displaced People 2010-2021 transformed.csv", row.names = F)
