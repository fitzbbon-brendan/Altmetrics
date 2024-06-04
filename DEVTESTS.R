

test <- search_coord(long = c(-101.4656), lat = c(51.81913))

map_quarter(test)

test2 <- search_legal(x = c("NE-1-12-12E1", "NE-11-33-29W1"))


map_quarter(test2)

names(cache_load())

search_legal(x = "NE-2-12-12E")

search_legal(x = "SW-6-35-29W")

test3 <- search_legal(x = c("NW-36-89-11E2", "NW-36-89-11E1"))

map_quarter(test3)

search_legal(x = c("NE-11-33-29W", "SW-20-2-1W"))
