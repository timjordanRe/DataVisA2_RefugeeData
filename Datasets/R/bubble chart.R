rename_country = function (data, former_names, new_names)
{
  for (i in 1:length(former_names))
  {
    print(c(f_name, n_name))
    f_name = former_names[i]
    n_name = new_names[i]
    
    bool1 = data$`Country of Origin` == f_name
    bool2 = data$`Country of Asylum` == f_name
    
    if (sum(bool1) > 0) {
      data[bool1, ]$`Country of Origin` = n_name
    }
    if (sum(bool2) > 0) {
      data[bool2, ]$`Country of Asylum` = n_name
    }
  }
  return(data)
}
former_names = c("Libyan Arab Jamahiriya", "Congo (Brazzaville)", "Palestinian Territory, Occupied",
                 "Côte d'Ivoire", "Congo (Kinshasa)", "Macedonia, the former Yugoslav Republic of",
                 "Moldova, Republic of", "Holy See (Vatican City State)",
                 "Hong Kong S.A.R., China", "Korea, Democratic People's Republic of")
new_names = c("Libya", "Republic of the Congo", "Palestine","Ivory Coast",
              "Democratic Republic of the Congo", "North Macedonia", "Moldova",
              "Holy See (Vatican City)", "Hong Kong S.A.R.","North Korea")

# get asylum --------------------------------------------------------------

decisions = read.csv("asylum-decisions.csv", check.names = F)

decisions = rename_country(decisions, former_names, new_names)


copy = aggregate(x = decisions[c(10,11,13)], by = decisions[c(1,4,5)], sum)

continents = read.csv("countryContinent.csv", check.names = F)
head(continents)
a = unique(continents$country)
continents[c(1,2,4,5,8,9)] = NULL
names(continents)
names(copy)

decision_regions = merge(copy, continents, by.x = "Country of asylum (ISO)", by.y = "code_3")
head(decision_regions)


# format country population -----------------------------------------------

pop = read.csv("API_SP.POP.TOTL_DS2_en_csv_v2_4570891.csv", check.names = F)

pop = pop[,c(2,55:66)]

library(tidyr)

pop = pop %>% pivot_longer(cols = 2:ncol(pop), names_to = "Year", values_to = "Population")

names(decision_regions)

decision_regions = merge(decision_regions, pop, by.x = c("Country of asylum (ISO)", "Year"),
             c("Country Code", "Year"))

decision_regions[1] = NULL
head(decision_regions)
decision_regions$`Acceptance Rate` = decision_regions$`Complementary protection`/
  decision_regions$`Total decisions`
decision_regions$`Rejection Rate` = decision_regions$`Rejected decisions`/
  decision_regions$`Total decisions`

head(decision_regions)
serbia_indices = decision_regions$`Country of asylum` == "Serbia and Kosovo: S/RES/1244 (1999)"
decision_regions[serbia_indices,]$`Country of asylum` = "Serbia"
write.csv(decision_regions, file = "acceptance rate of refugees by countries.csv",
          row.names = F, quote = F)


