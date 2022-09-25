ref2021 = read.csv("refugee_coordinates.csv")
names(ref2021)
head(ref2021,1)
names(ref2021)[c(1,2,5,6,7,8,9,10,11)]  = c("Country of Asylum ISO", "Country of Origin ISO",
                                            "Asylum Seekers", "Country of Origin",
                                            "Country of Asylum", "Origin Latitude",
                                            "Origin Longitude", "Asylum Latitude",
                                            "Asylum Longitude")

write.csv(ref2021, file="clean_refugee_coords.csv", row.names = F, quote = F)

