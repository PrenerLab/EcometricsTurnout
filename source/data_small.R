# this script is used to consolidate the voter file data into the 3 identified time periods so that it is small enough for GitHub


library(readr)
library(dplyr)

VF <- read_csv("~/Desktop/MO-City-St-Louis Voter File/MO-City-St-Louis-VF.csv")
VH <- read_csv("~/Desktop/MO-City-St-Louis Voter File/MO-City-St-Louis-VH.csv")

VF <- VF %>% select(id, state_file_id, registered_address1, registered_city, registered_state, registered_zip, born_at, registered_at, registered_fips) %>%
  filter(registered_fips == 29510) %>% select(-registered_fips)
  
VH <- VH %>% select(id, state_file_id, election_at) %>%
  filter(election_at %in% as.Date(c("2017-04-04", "2016-11-08", "2014-11-04")))

write_csv(VF, path = "data/voter_raw/VF_small.csv")
write_csv(VH, path = "data/voter_raw/VH_small.csv")
