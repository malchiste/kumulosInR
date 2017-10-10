# This is a very simple library to make API calls to Kumulos REST API.
library(httr)
library(jsonlite)

# The Rest API Key is the API key to make generic CRUD calls to Kumulos tables.
restApiKey <- "RESTAPIKEY"

# SEC is the API Secret
sec <- "SECXXXX"

# mbaasAppId is the prefix of the tables and API names, it consists of two four digit numbers separated by an underscore.
mbaasAppId <- "1234_5678"

# The API Key is the key to make calls to the deployed API functions created at the MBAAS repository.
apiKey <- "APIKEY"

# readData retrieves the data from a particular table, using the REST API.
# note that it shows only the first 1000 rows.
readData <- function (dataTable){
  url <- paste0("https://api.kumulos.com/v1/data/", mbaasAppId,"_",dataTable, "?numberPerPage=1000") 
  dataToRead <- fromJSON(content(GET(url, authenticate(restApiKey, "password", type = "basic"), encode = "json"), as = "text"))
  dataToRead
}

# insertData allows to insert new data to the Kumulos hosted tables using the REST API.
insertData <- function(dataTable, listA) {
  url <- paste0("https://api.kumulos.com/v1/data/", mbaasAppId,"_", dataTable)
  insertData1 <- POST(url, authenticate(restApiKey, "password", type = "basic"), body = listA, encode = "json",  verbose())
  insertData1
}

# Deletes a single row in the table, based on its primary key, or ID.
deleteData <- function(dataTable, id) {
  url <- paste0("https://api.kumulos.com/v1/data/", mbaasAppId,"_",dataTable, "/", id) 
  deleteData <- content(DELETE(url, authenticate(restApiKey, "password", type = "basic"), encode = "form"), as = "text")
  deleteData
}

# Updates the values of a set of columns of one row based on its primary key.
updateData <- function(dataTable, id, listA) {
  url <- paste0("https://api.kumulos.com/v1/data/", mbaasAppId,"_", dataTable, "/", id)
  updateData <- PUT(url, authenticate(restApiKey, "password", type = "basic"), body = listA, encode = "json",  verbose())
  updateData
}

# Allows calling an API Method.
runApiMethod <- function (methodName, parameters){
  url <- paste0("https://api.kumulos.com/b2.2/", apiKey, "/", methodName,".json")
  results <- POST(
    url, 
    authenticate(user = apiKey, password = sec, type = "basic"),
    body = parameters, 
    encode = "multipart")
  return (results)
}

#### Usage Examples
#  runApiMethod usage example 
  kPars <- list(
    parameter1 = par1, 
    parameter2 = par2, 
    parameter3 = par3)
  runApiMethod("apiMethod", kPars)

#  This example shows how to bulk load data to a table.
zipCodeAdd <- function(zipCode, place) {
  kPars <- list(
    "zipCode" = zipCode,
    name = paste(place, zipCode),
    status = "active"
  )
  insertData("statusZipCodes", listA = kPars)
}
  
zipCodesDenver <- list(80012, 80014, 80110, 80111, 80123, 80202, 80203, 80204, 80205, 80206, 80207, 80209, 80210, 80211, 80212, 80214, 80216, 80218, 80219, 80220, 80221, 80222, 80223, 80224, 80226, 80227, 80230, 80231, 80232, 80235, 80236, 80237, 80238, 80239, 80246, 80247, 80249, 80264, 80290, 80293, 80294)
lapply(zipCodesDenver, function(x) { zipCodeAdd(x, "Denver")})


#  Bulk read and deleteData
#  The following delets all rows in the table "events", one by one.
events <- readData("events")
lapply(events$eventID, function(x) { deleteData( "events", x)} )

