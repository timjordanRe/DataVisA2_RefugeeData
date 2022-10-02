decisions = read.csv("asylum-decisions.csv", check.names = F)
head(decisions)
decisions[c(2,3,6,7,8,9,12)] = NULL
names(decisions)

copy = aggregate(x = decisions[c(10,11,13)], by = decisions[c(1,4,5)], sum)

continents = read.csv("countryContinent.csv", check.names = F)
head(continents)
continents[c(1,2,4,5,8,9)] = NULL
names(continents)
names(copy)

decision_regions = merge(copy, continents, by.x = "Country of asylum (ISO)", by.y = "code_3")
head(decision_regions)

decision_regions$`Acceptance Rate` = decision_regions$`Complementary protection`/
  decision_regions$`Total decisions`
decision_regions$`Rejection Rate` = decision_regions$`Rejected decisions`/
  decision_regions$`Total decisions`

head(decision_regions)
write.csv(decision_regions, file = "acceptance rate of refugees by countries.csv",
          row.names = F, quote = F)
