rm(list= ls())
require(dplyr)
require(data.table)
require(jsonlite)
library(httr)


d<-c(2,3,4,5,6)
d[2]


delimiter <- "?api_key="
delimiter2 <- "&api_key="
key<-c("RGAPI-930921c2-541c-4eca-9c04-1dabc4be81ca")

summoner<-c("Draric")
ur<-modify_url("https://euw1.api.riotgames.com/",path = c("lol","summoner","v4","summoners","by-name",summoner))
ur
g<-GET(paste0(ur,delimiter,key))
g1<-fromJSON(rawToChar(g$content))
puid<-g1$puuid
sumid<-g1$id
puid
m<-GET(paste0("https://europe.api.riotgames.com/tft/match/v1/matches/by-puuid/",puid,"/ids?count=200","&api_key=",key))
mm<-GET(paste0("https://europe.api.riotgames.com/tft/match/v1/matches/by-puuid/",puid,"/ids","?count=20","&beginIndex=2",delimiter2,key))
mm1<-fromJSON(rawToChar(mm$content))
mm1

m1==mm1


m1<-fromJSON(rawToChar(m$content))
m1

paste0("https://europe.api.riotgames.com/tft/match/v1/matches/",m1[1],delimiter,key)
t<-GET(paste0("https://europe.api.riotgames.com/tft/match/v1/matches/",m1[1],delimiter,key))
t1<-fromJSON(rawToChar(t$content))
t1$metadata
tt<-as.data.frame(t1$info)
tt[tt$participants.puuid==puid]
tt$participants.puuid==puid
puid
tt1<-filter(tt,tt$participants.puuid==puid)
tt1<-as.data.frame(filter(tt,tt$participants.puuid==puid))
length(tt1)


z<-GET(paste0("https://euw1.api.riotgames.com/tft/league/v1/entries/by-summoner/",sumid,delimiter,key))
z1<-fromJSON(rawToChar(z$content))


delimiter <- "?api_key="
delimiter2 <- "&api_key="
key<-c("RGAPI-0b9873ef-d7b7-4d64-9194-0548d9c01063")
summoner<-c("Gyroum")
ur<-modify_url("https://euw1.api.riotgames.com/",path = c("lol","summoner","v4","summoners","by-name",summoner))
g<-GET(paste0(ur,delimiter,key))
g1<-fromJSON(rawToChar(g$content))
puid<-g1$puuid
sumid<-g1$id
m<-GET(paste0("https://europe.api.riotgames.com/tft/match/v1/matches/by-puuid/",puid,"/ids?count=500",delimiter2,key))
m1<-fromJSON(rawToChar(m$content))


tt1<-list()
name<-c()
for (i in 1:length(m1)) {
  t<-GET(paste0("https://europe.api.riotgames.com/tft/match/v1/matches/",m1[i],delimiter,key))
  t1<-fromJSON(rawToChar(t$content))
  tt<-as.data.frame(t1$info)
  tt$participants.partner_group_id<-NULL
  tt$participants.augments<-NULL
  tt1[[i]]<-filter(tt,tt$participants.puuid==puid)
  name[i]<-summoner
  if (length(tt1[[i]])==0){
    print("pause")
    print(i)
    Sys.sleep(130)
    t<-GET(paste0("https://europe.api.riotgames.com/tft/match/v1/matches/",m1[i],delimiter,key))
    t1<-fromJSON(rawToChar(t$content))
    tt<-as.data.frame(t1$info)
    tt$participants.partner_group_id<-NULL
    tt$participants.augments<-NULL
    tt1[[i]]<-filter(tt,tt$participants.puuid==puid)
    
  }
 
}

matches<-tt1[[1]]
matches<-matches[-c(1),]


for (o in 1:length(tt1) ) {
  matches<-rbind(matches,tt1[[o]])
  
}

rbind(tt1[[1]],tt1[[2]])
length(tt1[[1]])
length(tt1[[4]])
colnames(tt1[[60]])==colnames(tt1[[2]])
colnames(tt1[[60]])
length(tt1)
cf<-tt1[[6]]

for (i in 1:length(tt1)){
  tz[i]<-length(tt1[[i]])
}
tz
tz[81]
m1[81]
uwu<-GET(paste0("https://europe.api.riotgames.com/tft/match/v1/matches/",m1[200],delimiter,key))
det<-rawToChar(uwu$content)


riot_api_fetching <- function(x) {
  key <- "RGAPI-0b9873ef-d7b7-4d64-9194-0548d9c01063"
  url <- paste0(x, key)
  json <- GET(url = url)
  raw <- rawToChar(json$content)
  fromJSON(raw)
}



accounts_per_divison <- 100

combinations_df <- expand.grid(division, tier)
combinations_list <- list()
for (i in seq_len(nrow(combinations_df))) {
  combinations_list[[i]] <- combinations_df[i, ]
}


accounts <- lapply(combinations_list, function(x) {
  Sys.sleep(1.3)
  division <- x[1, 1]
  tier <- x[1, 2]
  print(x)
  return(riot_api_fetching(
    paste0("https://euw1.api.riotgames.com/lol/league/v4/entries/RANKED_SOLO_5x5/", tier, "/",  division, "?page=1", delimiter2)))
})
