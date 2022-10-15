ref = read.csv("refugee_data.csv", check.names = F)
incomes = read.csv("countries_income_group.csv", check.names = F)

ref = ref[ref$Year == 2021,]
former_names = c("Serbia and Kosovo: S/RES/1244 (1999)", "Venezuela (Bolivarian Republic of)",
                 "Cote d'Ivoire", "Iran (Islamic Rep. of)", "Türkiye", "China, Hong Kong SAR",
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


ref = merge(ref, incomes, by.x = "Country of asylum (ISO)", by.y = "Code")
ref$`Country of asylum (ISO)` = NULL
ref$Var.5 = NULL
ref$Economy = NULL
ref[ref$`Country of origin` == "Afghanistan",]
ref[ref$`Country of origin` == "Syrian Arab Republic",]
ref[ref$`Country of origin` == "Myanmar",]
ref[ref$`Country of origin` == "South Sudan",]
ref[ref$`Country of origin` == "Venezuela",]
origins = list("Afghanistian" = ref[ref$`Country of origin` == "Afghanistan",],
               "Syria" = ref[ref$`Country of origin` == "Syrian Arab Republic",],
               "Myanmar" = ref[ref$`Country of origin` == "Myanmar",],
               "Sudan" = ref[ref$`Country of origin` == "South Sudan",],
               "Venezuela" = ref[ref$`Country of origin` == "Venezuela",])
origins$Afghanistian = origins$Afghanistian[order(-origins$Afghanistian$FDP),]
origins$Afghanistian$rank = row(origins$Afghanistian)[,1]

origins$Syria = origins$Syria[order(-origins$Syria$FDP),]
origins$Syria$rank = row(origins$Syria)[,1]

origins$Myanmar = origins$Myanmar[order(-origins$Myanmar$FDP),]
origins$Myanmar$rank = row(origins$Myanmar)[,1]

origins$Sudan = origins$Sudan[order(-origins$Sudan$FDP),]
origins$Sudan$rank = row(origins$Sudan)[,1]

origins$Venezuela = origins$Venezuela[order(-origins$Venezuela$FDP),]
origins$Venezuela$rank = row(origins$Venezuela)[,1]


nrow(origins$Afghanistian)
head(origins$Afghanistian)
nrow(origins$Syria)
head(origins$Syria)
nrow(origins$Myanmar)
head(origins$Myanmar)
nrow(origins$Sudan)
head(origins$Sudan)
nrow(origins$Venezuela)
head(origins$Venezuela)

names(a)
igs = unique(copy$`Income group`)
copy1 = copy[copy$`Income group` == igs[1],]
copy1 = copy1[order(-copy1$FDP),]
head(copy1)
order(copy$FDP)

nrow(ref)
unique(ref$`Country of asylum`)
ref = ref[order(-ref$FDP),]
ref$rank = row(ref)[,1]

ref = copy

write.csv(ref, file = "FDP_movement.csv", row.names = F)
