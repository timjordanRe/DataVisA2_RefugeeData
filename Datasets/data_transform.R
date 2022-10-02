ref2021 = read.csv("clean_refugee_data.csv")
sort(unique(ref2021$Year))
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
head(copy)
write.csv(copy, file="clean_refugee_coords.csv", row.names = F, quote = F)

clean_records = copy

# sudan refugees ----------------------------------------------------------

head(copy)
sudan_refugees = copy[copy$`Country of Origin` == "Sudan",]
head(sudan_refugees)
copy = aggregate(sudan_refugees[4:5], by=sudan_refugees[c(1,2,6,7,8,9,10,11)], sum)
head(copy,1)
sudan_refugees = copy
write.csv(sudan_refugees, file="sudan_refugees.csv", row.names = F, quote = F)


# cleaning data -----------------------------------------------------------

clean_records

refugees_only = clean_records[clean_records$Refugees != 0,]
asylum_seekers_only = clean_records[clean_records$`Asylum Seekers` != 0,]
write.csv(refugees_only, file="yearly_refugees_only.csv", row.names = F, quote = F)
write.csv(asylum_seekers_only, file="yearly_asylumseekers_only.csv", row.names = F, quote = F)
refugees_only

copy = read.csv("yearly_refugees_only.csv", check.names = FALSE)
names(copy)


copy = data.frame(aggregate(copy[c(4,5)], copy[c(1,3,7,10,11)] , FUN = sum),
                   check.names = FALSE)
year2016 = copy[copy$Year == 2016,]
head(year2016)
rank(year2016$Refugees, ties.method = "first")
year2016 = year2016[order(year2016$Refugees),]
year2016[nrow(year2016), ]
names(year2016)
