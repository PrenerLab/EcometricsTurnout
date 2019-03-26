### script for geocoding the voter file

#dependencies

library(dplyr)
library(readr)
library(censusxy) # needs to be installed from github at the moment

## directory is absolute...

vf <- readr::read_csv("data/MO-City-St-Louis-VF.csv")

## filter for least number needed to geocode

#extent of city of STL
vf <- dplyr::filter(vf, registered_fips == 29510)
# unique addresses only, will join to others with same address
vf <- dplyr::filter(vf, !duplicated(registered_address1))

# query and respond with addresses
response <- censusxy::census_prep(vf, address = "registered_address1", city = "registered_city", state = "registered_state", zip = "registered_zip") %>%
  censusxy::census_geo()
