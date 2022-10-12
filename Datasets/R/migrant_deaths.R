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
mm_copy[mm_copy$`Cause of Death` == "Drowning, Harsh environmental conditions / lack of adequate shelter, food, water",]$`Cause of Death` = "Harsh environmental conditions"
mm_copy[mm_copy$`Cause of Death` == "Harsh environmental conditions / lack of adequate shelter, food, water, Drowning",]$`Cause of Death` = "Harsh environmental conditions"
mm_copy[mm_copy$`Cause of Death` == "Drowning, Vehicle accident / death linked to hazardous transport",]$`Cause of Death` = "Hazardous transport"
mm_copy[mm_copy$`Cause of Death` == "Harsh environmental conditions / lack of adequate shelter, food, water, Sickness / lack of access to adequate healthcare",]$`Cause of Death` = "Lack of access to adequate healthcare"
mm_copy[mm_copy$`Cause of Death` == "Harsh environmental conditions / lack of adequate shelter, food, water, Violence",]$`Cause of Death` = "Harsh environmental conditions"
mm_copy[mm_copy$`Cause of Death` == "Vehicle accident / death linked to hazardous transport, Violence, Mixed or unknown",]$`Cause of Death` = "Violence"
mm_copy[mm_copy$`Cause of Death` == "Drowning, Sickness / lack of access to adequate healthcare",]$`Cause of Death` = "Drowning"

mm_copy = aggregate(mm_copy[8], mm_copy[c(6,7,17)], sum)
head(mm_copy)
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

write.csv(mm, file = "migrant_cause_of_deaths.csv", row.names = F, quote = F)
