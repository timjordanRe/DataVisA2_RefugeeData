library("tidyverse")
library("readxl")
library(stringr)

mm = read_excel("Missing_Migrants_Global_Figures_allData.xlsx")

mm_copy = mm

mm_copy[mm_copy$`Cause of Death` == "Harsh environmental conditions / lack of adequate shelter, food, water",]$`Cause of Death` = "Harsh environmental conditions"
mm_copy[mm_copy$`Cause of Death` == "Vehicle accident / death linked to hazardous transport",]$`Cause of Death` = "Hazardous transport"
mm_copy[mm_copy$`Cause of Death` == "Sickness / lack of access to adequate healthcare",]$`Cause of Death` = "Lack of access to adequate healthcare"
mm_copy[mm_copy$`Cause of Death` == "Mixed or unknown",]$`Cause of Death` = "Unknown"

mm_copy[mm_copy$`Cause of Death` == "Mixed or unknown, Drowning",]$`Cause of Death` = "Drowning"
mm_copy[mm_copy$`Cause of Death` == "Mixed or unknown, Harsh environmental conditions / lack of adequate shelter, food, water",]$`Cause of Death` = "Harsh environmental conditions"
mm_copy[mm_copy$`Cause of Death` == "Drowning, Mixed or unknown",]$`Cause of Death` = "Drowning"
mm_copy[mm_copy$`Cause of Death` == "Drowning, Harsh environmental conditions / lack of adequate shelter, food, water",]$`Cause of Death` = "Drowning"
mm_copy[mm_copy$`Cause of Death` == "Harsh environmental conditions / lack of adequate shelter, food, water, Drowning",]$`Cause of Death` = "Harsh environmental conditions"
mm_copy[mm_copy$`Cause of Death` == "Drowning, Vehicle accident / death linked to hazardous transport",]$`Cause of Death` = "Hazardous transport"
mm_copy[mm_copy$`Cause of Death` == "Harsh environmental conditions / lack of adequate shelter, food, water, Sickness / lack of access to adequate healthcare",]$`Cause of Death` = "Lack of access to adequate healthcare"
mm_copy[mm_copy$`Cause of Death` == "Harsh environmental conditions / lack of adequate shelter, food, water, Violence",]$`Cause of Death` = "Harsh environmental conditions"
mm_copy[mm_copy$`Cause of Death` == "Vehicle accident / death linked to hazardous transport, Violence, Mixed or unknown",]$`Cause of Death` = "Violence"
mm_copy[mm_copy$`Cause of Death` == "Drowning, Sickness / lack of access to adequate healthcare",]$`Cause of Death` = "Drowning"

length(unique(mm_copy$`Region of Incident`))

am_bool = mm_copy$`Region of Incident` %in% c("North America", "Central America","South America")

asia_bool = mm_copy$`Region of Incident` %in% c("South-eastern Asia",
                                                "Southern Asia",
                                                "Central Asia",
                                                "Eastern Asia",
                                                "Western Asia")

af_bool = mm_copy$`Region of Incident` %in% c("Eastern Africa",
                                              "Northern Africa",
                                              "Southern Africa",
                                              "Middle Africa",
                                              "Western Africa")

mm_copy[am_bool,]$`Region of Incident` = "Americas"
mm_copy[asia_bool,]$`Region of Incident` = "Asia"
mm_copy[af_bool,]$`Region of Incident` = "Africa"


mm_copy = aggregate(mm_copy[8], mm_copy[c(4,6,7,17)], sum)

sig_regions = unique(mm_copy[c(2,3,4)])
sig_regions$`Sig Region` = NaN

for (i in 1:nrow(mm_copy)) {
  
  change = FALSE
  death_row = mm_copy$`Number of Dead`[i]
  
  y = mm_copy$`Incident year`[i]
  m = mm_copy$`Reported Month`[i]
  cause = mm_copy$`Cause of Death`[i]
  new_region = mm_copy$`Region of Incident`[i]
  
  cur_region = sig_regions[(sig_regions$`Incident year` == y) &
                      (sig_regions$`Reported Month` == m) &
                      (sig_regions$`Cause of Death` == cause),]$`Sig Region`
  print(cur_region)

  if (is.nan(cur_region) || (cur_region == "NaN")) {
    change = TRUE
  }
  else{
    print("going this way")
    cur_death = mm_copy[(mm_copy$`Incident year` == y) &
                          (mm_copy$`Reported Month` == m) &
                          (mm_copy$`Cause of Death` == cause)&
                          (mm_copy$`Region of Incident` == cur_region),]
    
    if (death_row >= cur_death) {
      change = TRUE
    }
  }
  
  if (change) {
    sig_regions[(sig_regions$`Incident year` == y) &
                  (sig_regions$`Reported Month` == m) &
                  (sig_regions$`Cause of Death` == cause),]$`Sig Region` = new_region
  }
  print(c(cur_region,new_region))
}
unique(sig_regions$`Sig Region`)
names(mm_copy)
mm_copy = aggregate(mm_copy[5], mm_copy[c(2,3,4)], sum)

mm_copy = merge(sig_regions, mm_copy, by=c("Incident year", "Reported Month", "Cause of Death"))

mm_copy = mm_copy[order(-mm_copy$`Incident year`),]
head(mm_copy)
unique(mm_copy$`Cause of Death`)
unique(mm_copy$`Reported Month`)
name_to_number = function(month)
{
  res = 0
  if (month == "January") {
    res = 1
  } else if (month =="February") {
    res = 2
  } else if (month =="March") {
    res = 3
  } else if (month =="April") {
    res = 4
  } else if (month =="May") {
    res = 5
  } else if (month =="June") {
    res = 6
  } else if (month =="July") {
    res = 7
  } else if (month =="August") {
    res = 8
  } else if (month =="September") {
    res = 9
  } else if (month =="October") {
    res = 10
  } else if (month =="November") {
    res = 11
  } else {
    res = 12
  }
  return(res)
}
mm_copy$`Reported Month`
mm_copy[,2]
apply(mm_copy[2], 1, function(x) name_to_number(x))

lapply(mm_copy$`Reported Month`, name_to_number)
mm_copy[2] = apply(mm_copy[2], 1, function(x) name_to_number(x))

mm_copy["Date"] = apply(mm_copy[c(1,2)], 1, function(x) sprintf("%d-%d-01", x[1], x[2]))

mm_copy = mm_copy[order(mm_copy$Date),]

mm = mm_copy

head(mm)
mm[mm$`Cause of Death` == "Lack of access to adequate healthcare",]$`Cause of Death` = "Lack of access to healthcare"

write.csv(mm, file = "migrant_cause_of_deaths.csv", row.names = F, quote = F)
