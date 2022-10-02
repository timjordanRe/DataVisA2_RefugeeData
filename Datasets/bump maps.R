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

names(final_list)

head(final_list,1)
year = 2012
year_data = final_list[final_list$Year == year,]
ordered_year = year_data[order(-year_data$`Percentage of Complementary Protection`), ]
head(ordered_year,3)

ordered_year = year_data[order(-year_data$`Percentage of Rejections`), ]
head(ordered_year,3)
