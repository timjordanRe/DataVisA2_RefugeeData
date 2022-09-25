ref2021 = read.csv("clean_refugee_data.csv")
names(ref2021)[c(2,3,4,5,6,7)]  = c("Refugees", "Asylum Seekers","Country of Origin", 
                                    "Country of Origin ISO", "Country of Asylum", 
                                    "Country of Asylum ISO")


coord = read.csv("world_country_and_usa_states_latitude_and_longitude_values.csv")
names(coord)
coord[c(4,5,6,7,8)] = NULL
copy = merge(x = ref2021, y = coord, by.x = "Country of Origin ISO", by.y = "country_code")
names(copy)[c(8,9)] = c("Origin Latitude", "Origin Longitude")
copy = merge(x = copy, y = coord, by.x = "Country of Asylum ISO", by.y = "country_code")
names(copy)[c(10,11)] = c("Asylum Latitude", "Asylum Longitude")
names(copy)
write.csv(copy, file="clean_refugee_coords.csv", row.names = F, quote = F)

