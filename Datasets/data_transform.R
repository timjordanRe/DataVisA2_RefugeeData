ref2021 = read.csv("UNHCR refugee population data 2021.csv")

# Remove unneeded coloumns
remove_col = c(8,9,10,11)
ref2021[remove_col] = NULL
names(ref2021)

# remove entries with null iso code values
nrow(ref2021)

filter = ref2021[3] != ""
ref2021= ref2021[filter,]
nrow(ref2021)

filter = ref2021[5] != ""
ref2021= ref2021[filter,]
nrow(ref2021)

# aggregate by year, country of origin, country of asylum
names(ref2021)
head(ref2021)
agg = c(1,3,5)

aggregate(x = ref2021[c], by = iris[5], FUN = mean)
aggregate(x = iris[1:4], by = iris[5], FUN = mean)

