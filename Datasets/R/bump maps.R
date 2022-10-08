decisions = read.csv("asylum-decisions.csv", check.names = F)
head(decisions,2)

names(decisions)
copy = aggregate(x = decisions[c(10,11,13)], by = decisions[c(1,4)], sum)

empty_rows = c()
for (i in 1:nrow(copy)) {
  if (copy$`Complementary protection`[i] == 0 &&
      copy$`Rejected decisions`[i] == 0) {
    empty_rows = c(empty_rows,i)
  }
}

copy = copy[-empty_rows,]

rejected_p = data.frame(copy$`Rejected decisions`/copy$`Total decisions` * 100)
copy = cbind(copy, rejected_p)
names(copy)[6] = "Percentage of Rejections"

accepted_p = data.frame(copy$`Complementary protection`/copy$`Total decisions` * 100)
copy = cbind(copy, accepted_p)
names(copy)[7] = "Percentage of Complementary Protection"

bump = copy

year_list = list()
years = unique(copy$Year)

for (i in years) {
  print(i)
  values = copy[copy$Year == i,]
  values = values[values$`Total decisions` > 1000,]
  # a_rank = values[order(-values$`Complementary protection`,
  #                           -values$`Percentage of Complementary Protection`), ]
  a_rank = values[order(-values$`Percentage of Complementary Protection`,
                        -values$`Complementary protection`), ]
  
  a_rank$`Accepted Rank` = NA
  a_rank$`Accepted Rank` = row(a_rank)[,1]
  
  # a_rank = a_rank[order(-a_rank$`Rejected decisions`, -a_rank$`Percentage of Rejections`), ]
  a_rank = a_rank[order(-a_rank$`Percentage of Rejections`, -a_rank$`Rejected decisions`), ]
  a_rank$`Rejected Rank` = NA
  a_rank$`Rejected Rank` = row(a_rank)[,1]
  
  if (i != 2012) {
    final_list = rbind(final_list, a_rank)
  }
  else
  {
    final_list = a_rank
  }
  a_rank = NULL
}
country_acceptance_rejection_rankings = final_list
names(final_list)

head(final_list,1)
year = 2012
year_data = final_list[final_list$Year == year,]
ordered_year = year_data[order(-year_data$`Percentage of Complementary Protection`), ]
head(ordered_year,3)

ordered_year = year_data[order(-year_data$`Percentage of Rejections`), ]
head(ordered_year,3)

write.csv(country_acceptance_rejection_rankings, file = "country_acceptance_rejection_rankings.csv",
          row.names = F, quote = F)


# Revamped ----------------------------------------------------------------

a_rate = read.csv("acceptance rate of refugees by countries.csv", check.names = F)

copy1 = aggregate(x = decision_regions[c(3,4,5)], by = decision_regions[c(1,6)], FUN = sum)
copy1
copy2 = aggregate(x = decision_regions[c(9,10)], by = decision_regions[c(1,6)], FUN = mean)
copy2[c(1,2)] = NULL

copy = cbind(copy1, copy2)

years = unique(copy$Year)

for (i in 1:length(years)) 
{
  print(years[i])
  values = copy[copy$Year == years[i],]
  r_rank = values[order(-values$`Rejection Rate`),]
  r_rank$`Reject Rank` = row(r_rank)[,1]
  
  if (i != 1) {
    final_list = rbind(final_list, r_rank)
  }
  else
  {
    final_list = r_rank
  }
}
year_list = final_list[final_list$Year == 2010,]
year_list[order(-year_list$`Rejection Rate`),]

rejection_rank = final_list

write.csv(rejection_rank, file = "rejection_rank_countries.csv",
          row.names = F, quote = F)
