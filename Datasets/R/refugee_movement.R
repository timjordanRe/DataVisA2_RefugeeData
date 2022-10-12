ref = read.csv("refugee_data.csv", check.names = F)

former_names = c("Libyan Arab Jamahiriya", "Congo (Brazzaville)", "Palestinian Territory, Occupied",
                 "Côte d'Ivoire", "Congo (Kinshasa)", "Macedonia, the former Yugoslav Republic of",
                 "Moldova, Republic of", "Holy See (Vatican City State)",
                 "Hong Kong S.A.R., China", "Korea, Democratic People's Republic of",
                 "Syrian Arab Rep.", "Venezuela (Bolivarian Republic of)")
new_names = c("Libya", "Republic of the Congo", "Palestine","Ivory Coast",
              "Democratic Republic of the Congo", "North Macedonia", "Moldova",
              "Holy See (Vatican City)", "Hong Kong S.A.R.","North Korea",
              "Syrian Arab Republic", "Venezuela")

ref = ref[ref$Year == 2021,]
ref = ref[c(1,2,4,6,7)]

ref$FDP = ref$`Refugees under UNHCR's mandate`+ ref$`Asylum-seekers`
ref[c(4,5)] = NULL

a = unique(ref$`Country of origin`)
write.csv(a, "info.txt")

rename_country = function (data, former_names, new_names)
{
  for (i in 1:length(former_names))
  {
    f_name = former_names[i]
    n_name = new_names[i]
    print(c(f_name, n_name))
    
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

nrow(ref)
ref = rename_country(ref, former_names, new_names)
nrow(ref)

origins = c('Syrian Arab Republic','Venezuela','Afghanistan','South Sudan','Myanmar')
bool = ref$`Country of origin` %in% origins
ref = ref[bool,]
nrow(ref)
unique(ref$`Country of asylum`)

write.csv(ref, file = "FDP_movement.csv", row.names = F, quote = F)
