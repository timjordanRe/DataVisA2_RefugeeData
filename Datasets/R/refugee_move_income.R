ref = read.csv("refugee_data.csv", check.names = F)
incomes = read.csv("countries_income_group.csv", check.names = F)

former_names = c("Libyan Arab Jamahiriya", "Congo (Brazzaville)", "Palestinian Territory, Occupied",
                 "Côte d'Ivoire", "Congo (Kinshasa)", "Macedonia, the former Yugoslav Republic of",
                 "Moldova, Republic of", "Holy See (Vatican City State)",
                 "Hong Kong S.A.R., China", "Korea, Democratic People's Republic of",
                 "Syrian Arab Rep.", "Venezuela (Bolivarian Republic of)", "China, Hong Kong SAR",
                 "Iran (Islamic Rep. of)", "Türkiye", "United States of America",
                 "Dem. Rep. of the Congo", "United Kingdom of Great Britain and Northern Ireland")
new_names = c("Libya", "Republic of the Congo", "Palestine","Ivory Coast",
              "Democratic Republic of the Congo", "North Macedonia", "Moldova",
              "Holy See (Vatican City)", "Hong Kong S.A.R.","North Korea",
              "Syrian Arab Republic", "Venezuela", "Hong Kong",
              "Iran", "Turkey", "USA", "United Kingdom")

former_names = c("Serbia and Kosovo: S/RES/1244 (1999)", "Venezuela (Bolivarian Republic of)",
                 "Cote d'Ivoire", "Iran (Islamic Rep. of)", "T�rkiye", "China, Hong Kong SAR",
                 "Bolivia (Plurinational State of)", "United States of America",
                 "United Kingdom of Great Britain and Northern Ireland",
                 "Syrian Arab Rep.")

new_names = c("Kosovo and Serbia", "Venezuela", "Ivory Coast", "Iran", "Turkey", "Hong Kong",
              "Bolivia", "USA", "United Kingdom", 'Syrian Arab Republic')


ref$FDP = ref$`Refugees under UNHCR's mandate`+ ref$`Asylum-seekers`

ref = aggregate(ref[10], ref[c(2,4,5)], sum)

rename_country = function (data, former_names, new_names)
{
  if (length(former_names) != length(new_names)) {
    print("list names are not same length")
  }
  for (i in 1:length(former_names))
  {
    f_name = former_names[i]
    n_name = new_names[i]
    print(c(f_name, n_name))
    bool1 = (data$`Country of origin` == f_name)
    
    bool2 = (data$`Country of asylum` == f_name)
    
    
    if (sum(bool1) > 0) {
      data[bool1, ]$`Country of origin` = n_name
    }
    if (sum(bool2) > 0) {
      data[bool2, ]$`Country of asylum` = n_name
    }
  }
  return(data)
}
rename_country(ref, former_names, new_names)
ref = rename_country(ref, former_names, new_names)

origins = c('Syrian Arab Republic','Venezuela','Afghanistan','South Sudan','Myanmar')
bool = ref$`Country of origin` %in% origins
ref = ref[bool,]
nrow(ref)
unique(ref$`Country of asylum`)
ref = ref[order(-ref$FDP),]


ref$rank = row(ref)[,1]
copy = merge(ref, incomes, by.x = "Country of asylum (ISO)", by.y = "Code")
copy$`Country of asylum (ISO)` = NULL
copy$Var.6 = NULL
copy$Economy = NULL
names(copy)[names(copy) == "rank"] = "overall rank"

igs = unique(copy$`Income group`)
copy1 = copy[copy$`Income group` == igs[1],]
copy1 = copy1[order(-copy1$FDP),]
head(copy1)
order(copy$FDP)
for (i in 1:4)
{
  ig = unique(copy$`Income group`)[i]
  if (i == 1) {
    final = copy[copy$`Income group` == ig,]
    
  }
  final = final[order(-final$FDP), ]
}

ref = copy

write.csv(ref, file = "FDP_movement.csv", row.names = F)
