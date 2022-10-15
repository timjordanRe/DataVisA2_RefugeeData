ref = read.csv("refugee_data.csv", check.names = F)
head(ref)

ref$`Venezuelans displaced abroad` = NULL
ref$`IDPs of concern to UNHCR` = NULL

iso = read.csv("wikipedia-iso-country-codes.csv", check.names = F)
iso$`ISO 3166-2` = NULL
iso$`Numeric code` = NULL


# receive longitude and latitude ------------------------------------------

names(ref)
names(iso)
copy = merge(x = ref, y = iso, by.x = "Country of origin (ISO)", by.y = "Alpha-3 code")
names(copy)

names(copy)[c(8,9)] = c("Country of Origin", "Country of Origin ISO")
head(copy)
names(copy)
copy = merge(x = copy, y = iso, by.x = "Country of asylum (ISO)", by.y = "Alpha-3 code")

names(copy)[c(10,11)] = c("Country of Asylum", "Country of Asylum ISO")
head(copy)

copy = copy[c(3,6,7,8,9,10,11)]

coord = read.csv("world_country_and_usa_states_latitude_and_longitude_values.csv", check.names = F)
coord[c(5,6,7,8)] = NULL
names(coord)
names(copy)
ref_coord = merge(x = copy, y = coord, by.x = "Country of Origin ISO", by.y = "country_code")
names(ref_coord)[c(8,9,10)] = c("CO latitude", "CO longitude", "Origin country")

ref_coord = merge(x = ref_coord, y = coord, by.x = "Country of Asylum ISO", by.y = "country_code")
names(ref_coord)[c(11,12,13)] = c("CA latitude", "CA longitude", "Asylum country")

names(ref_coord)
ref_coord[c(1,2)] = NULL

names(ref_coord)
ref_coord[c(8,11)] = NULL
names(ref_coord)[c(2,3)] = c("Refugees", "Asylum Seekers")


# renaming to align with JSON file ----------------------------------------

sort(unique(ref_coord$`Country of Asylum`))
sort(unique(ref_coord$`Country of Origin`))

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

new_data = rename_country(ref_coord, former_names, new_names)
head(new_data[copy$`Country of Origin` %in% "Greenland",])


ref_coord = new_data
head(ref_coord)


# countries of asylum -----------------------------------------------------



countries_of_asylum = aggregate(ref_coord[2], by = ref_coord[c(1,5,8,9)], sum)


write.csv(countries_of_asylum, file = "countries_of_asylum_for_refugees.csv", row.names = F, quote = T)

