library(httr)
library(jsonlite)

restApiKey <- "RESTAPIKEY"
sec <- "SECXXXX"
mbaasAppId <- "1234_5678"
apiKey <- "APIKEY"


readData <- function (dataTable){
  url <- paste0("https://api.kumulos.com/v1/data/", mbaasAppId,"_",dataTable, "?numberPerPage=1000") 
  dataToRead <- fromJSON(content(GET(url, authenticate(restApiKey, "password", type = "basic"), encode = "json"), as = "text"))
  dataToRead
}


insertData <- function(dataTable, listA) {
  url <- paste0("https://api.kumulos.com/v1/data/", mbaasAppId,"_", dataTable)
  insertData1 <- POST(url, authenticate(restApiKey, "password", type = "basic"), body = listA, encode = "json",  verbose())
  insertData1
}
deleteData <- function(dataTable, id) {
  url <- paste0("https://api.kumulos.com/v1/data/", mbaasAppId,"_",dataTable, "/", id) 
  deleteData <- content(DELETE(url, authenticate(restApiKey, "password", type = "basic"), encode = "form"), as = "text")
  deleteData
}

updateData <- function(dataTable, id, listA) {
  url <- paste0("https://api.kumulos.com/v1/data/", mbaasAppId,"_", dataTable, "/", id)
  updateData <- PUT(url, authenticate(restApiKey, "password", type = "basic"), body = listA, encode = "json",  verbose())
  updateData
}

runApiMethod <- function (methodName, parameters){
  url <- paste0("https://api.kumulos.com/b2.2/", apiKey, "/", methodName,".json")
  results <- POST(
    url, 
    authenticate(user = apiKey, password = sec, type = "basic"),
    body = parameters, 
    encode = "multipart")
  return (results)
}



#  apiMethodUsageExample 

  
  kPars <- list(
    parameter1 = par1, 
    parameter2 = par2, 
    parameter3 = par3)
  runApiMethod("apiMethod", kPars)

 
#  insertUsageExample
#  Very useful for bulk loads:

    
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
#  The following delets all rows in the table "events"

events <- readData("events")
lapply(events$eventID, function(x) { deleteData( "events", x)} )
    
#  add random values to a column
randomStrings <- function(n = 5000) {
  a <- do.call(paste0, replicate(3, sample(LETTERS, n, TRUE), FALSE))
  a
}

updateInviteCodes <- function() {
  inviteCodes <- tolower(randomStrings(nrow(dataFromUsers)))
  for (i in 1:length(userIds)){
    updateData("users", userIds[i], list(inviteCode = inviteCodes[i])) 
  }
}
