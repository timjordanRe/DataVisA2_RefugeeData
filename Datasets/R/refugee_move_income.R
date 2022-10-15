ref = read.csv("refugee_data.csv", check.names = F)
incomes = read.csv("countries_income_group.csv", check.names = F)
pop = read.csv("API_SP.POP.TOTL_DS2_en_csv_v2_4570891.csv", check.names = F)
pop = pop[,c(2,66)]

ref = ref[ref$Year == 2021,]
former_names = c("Serbia and Kosovo: S/RES/1244 (1999)", "Venezuela (Bolivarian Republic of)",
                 "Cote d'Ivoire", "Iran (Islamic Rep. of)", "Türkiye", "China, Hong Kong SAR",
                 "Bolivia (Plurinational State of)", "United States of America",
                 "United Kingdom of Great Britain and Northern Ireland",
                 "Syrian Arab Rep.")

new_names = c("Serbia", "Venezuela", "Ivory Coast", "Iran", "Turkey", "Hong Kong",
              "Bolivia", "United States", "United Kingdom", 'Syria')


ref$FDP = ref$`Refugees under UNHCR's mandate`+ ref$`Asylum-seekers`

ref = aggregate(ref[10], ref[c(2,3,4,5)], sum)

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

origins = c('Syria','Venezuela','Afghanistan','South Sudan','Myanmar')
bool = ref$`Country of origin` %in% origins
ref = ref[bool,]


ref = merge(ref, incomes, by.x = "Country of asylum (ISO)", by.y = "Code")
ref = merge(ref, pop, by.x = "Country of asylum (ISO)", by.y = "Country Code")
ref = ref[complete.cases(ref),]

names(ref)[names(ref) == "2021"] = "population"
ref$Var.5 = NULL
ref$Economy = NULL
ref$Region = NULL

iso = read.csv("wikipedia-iso-country-codes.csv", check.names = F)
iso[iso$`Alpha-3 code` == "SDN",]$`Alpha-3 code` = "SSD"
iso$`ISO 3166-2` = NULL
iso$`Numeric code` = NULL
iso$`English short name lower case` = NULL

iso[iso$`Alpha-3 code` == "SYR",]

coord = read.csv("world_country_and_usa_states_latitude_and_longitude_values.csv", check.names = F)

coord[c(4,5,6,7,8)] = NULL


coord = merge(iso, coord, by.x = "Alpha-2 code", by.y = "country_code")
coord$`Alpha-2 code` = NULL

ref = merge(ref, coord, by.x = "Country of asylum (ISO)", "Alpha-3 code")

ref$Var.6 = NULL
names(ref)[names(ref) == "latitude"] = "asylum latitude"
names(ref)[names(ref) == "longitude"] = "asylum longitude"

ref = merge(ref, coord, by.x = "Country of origin (ISO)", "Alpha-3 code")
names(ref)[names(ref) == "latitude"] = "origin latitude"
names(ref)[names(ref) == "longitude"] = "origin longitude"


ref$`FDP over pop` =  ref$FDP/ref$population * 100000
head(ref[order(-ref$`FDP over pop`),])

ref[ref$`Country of origin` == "Afghanistan",]
ref[ref$`Country of origin` == "Syria",]
ref[ref$`Country of origin` == "Myanmar",]
ref[ref$`Country of origin` == "South Sudan",]
ref[ref$`Country of origin` == "Venezuela",]
origins = list("Afghanistian" = ref[ref$`Country of origin` == "Afghanistan",],
               "Syria" = ref[ref$`Country of origin` == "Syria",],
               "Myanmar" = ref[ref$`Country of origin` == "Myanmar",],
               "Sudan" = ref[ref$`Country of origin` == "South Sudan",],
               "Venezuela" = ref[ref$`Country of origin` == "Venezuela",])


# fdp rank ----------------------------------------------------------------

origins$Afghanistian = origins$Afghanistian[order(-origins$Afghanistian$FDP),]
origins$Afghanistian$fdprank = row(origins$Afghanistian)[,1]

origins$Syria = origins$Syria[order(-origins$Syria$FDP),]
origins$Syria$fdprank = row(origins$Syria)[,1]

origins$Myanmar = origins$Myanmar[order(-origins$Myanmar$FDP),]
origins$Myanmar$fdprank = row(origins$Myanmar)[,1]

origins$Sudan = origins$Sudan[order(-origins$Sudan$FDP),]
origins$Sudan$fdprank = row(origins$Sudan)[,1]

origins$Venezuela = origins$Venezuela[order(-origins$Venezuela$FDP),]
origins$Venezuela$fdprank = row(origins$Venezuela)[,1]


# fdp over pop rank -------------------------------------------------------

origins$Afghanistian = origins$Afghanistian[order(-origins$Afghanistian$`FDP over pop`),]
origins$Afghanistian$rank = row(origins$Afghanistian)[,1]

origins$Syria = origins$Syria[order(-origins$Syria$`FDP over pop`),]
origins$Syria$rank = row(origins$Syria)[,1]

origins$Myanmar = origins$Myanmar[order(-origins$Myanmar$`FDP over pop`),]
origins$Myanmar$rank = row(origins$Myanmar)[,1]

origins$Sudan = origins$Sudan[order(-origins$Sudan$`FDP over pop`),]
origins$Sudan$rank = row(origins$Sudan)[,1]

origins$Venezuela = origins$Venezuela[order(-origins$Venezuela$`FDP over pop`),]
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

copy = rbind(origins$Afghanistian, origins$Syria, origins$Myanmar, origins$Sudan, origins$Venezuela)

all_movements = copy

write.csv(all_movements, file = "big5_move.csv", row.names = F)
write.csv(origins$Afghanistian, file = "Afghanistian_move.csv", row.names = F)
write.csv(origins$Syria, file = "Syria_move.csv", row.names = F)
write.csv(origins$Myanmar, file = "Myanmar_move.csv", row.names = F)
write.csv(origins$Sudan, file = "Sudan_move.csv", row.names = F)
write.csv(origins$Venezuela, file = "Venezuela_move.csv", row.names = F)