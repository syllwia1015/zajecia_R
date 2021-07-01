# WCZYTYWANIE DUZYCH ZESTAWOW DANYCH


konta <- read.csv('../Cw03_2021_04_24/konta.csv')

srednia<- function(filepath,columnname,size,sep=",",header=TRUE){
  # size to jest tylko liczba wierszy ktora wczytujemy w jednej porcji czytania pliku
  # robimy to w momencie gdy jest duzy zestaw danych 
  # dzieki temu oszczedzamy RAM
  
      # nie laczymy sie bezposrednio z plikiem read.csv tylko tworzymy fileConnection
      fileConnection<- file(description = filepath,open="r")
      suma<-0
      counter<-0
      data<-read.table(fileConnection,nrows=size,header = header,fill=TRUE,sep=sep)
      columnsNames<-names(data)
      repeat{
        # print(suma/counter)
        #print(suma)
        if (nrow(data)==0){
          close(fileConnection)
          break
        }
        data<-na.omit(data)
        counter<-counter+ nrow(data)
        suma<-suma+sum(data[[columnname]])
        data<-read.table(fileConnection,nrows=size,col.names =columnsNames ,fill=TRUE,sep=sep)
      }
      suma/counter
}


mean(konta$saldo)
srednia('../Cw03_2021_04_24/konta.csv',"saldo",10000)



lengthOfFile<- function(filepath,systemLinuxUnix=FALSE){
  #if(.Platform$OS.type == "unix" )
  if ( systemLinuxUnix){
    l <- try(system(paste("wc -l",filepath),intern=TRUE))
    l<-strsplit(l,split=" ")
    l<-as.numeric(l[[1]])
    l
  }
  else{
    l<-length(count.fields(filepath))
    l
  }
}


lengthOfFile(konta)

########################
# ZAPISYWANIE DANYCH DO BAZY DANYCH W PLIKU

library(DBI)
library(RSQLite)

readToBase<-function(filepath,dbpath,tablename,size,sep=",",header=TRUE,delete=TRUE){
  ap<-!delete
  ov<-delete
  fileConnection<- file(description = filepath,open="r")
  dbConn<-dbConnect(SQLite(),dbpath)
  data<-read.table(fileConnection,nrows=size,header = header,fill=TRUE,sep=sep)
  columnsNames<-names(data)
  dbWriteTable(conn = dbConn,name=tablename,data,append=ap,overwrite=ov)
  repeat{
    if(nrow(data)==0){
      close(fileConnection)
      dbDisconnect(dbConn)
      break
    }
    data<-read.table(fileConnection,nrows=size,col.names=columnsNames,fill=TRUE,sep=sep)
    dbWriteTable(conn = dbConn,name=tablename,data,append=TRUE,overwrite=FALSE)
  }
}


readToBase('konta.csv', 'konta.sqlite', 'konta', 1000)


dbpath <- 'konta.sqlite'
con <- dbConnect(SQLite(), dbpath)
# to powinno zliczyc i poprawnie zapisac i wczytac do naszej bazy konta.csv
dbGetQuery(con, "SELECT COUNT(*) FROM konta")
dbDisconnect(con)




###
## POLACZENIE Z ZEWNETRZNA BAZA, POZA PLIKIEM, POZA LOCALHOST
###

library(rstudioapi)
library(RPostgres)

# utworzenie konta na elephantsql.com
connectMe<-function(typ=Postgres(),dbname="zwxfmuml",host="rogue.db.elephantsql.com",user="zwxfmuml"){
  con<-dbConnect(
    typ,
    dbname=dbname,
    host=host,
    user=user,
    password=askForPassword("database pass"))
}
connectMe()

con<-connectMe()
dbGetInfo(con)
dbListTables(con)


# wrzucenia tabeli do bazy SQL

readToBase<-function(filepath,dbConn,tablename,size,sep=",",header=TRUE,delete=TRUE){
  ap<-!delete
  ov<-delete
  fileConnection<- file(description = filepath,open="r")
  data<-read.table(fileConnection,nrows=size,header = header,fill=TRUE,sep=sep)
  columnsNames<-names(data)
  dbWriteTable(conn = dbConn,name=tablename,data,append=ap,overwrite=ov)
  repeat{
    if(nrow(data)==0){
      close(fileConnection)
      dbDisconnect(dbConn)
      break
    }
    data<-read.table(fileConnection,nrows=size,col.names=columnsNames,fill=TRUE,sep=sep)
    dbWriteTable(conn = dbConn,name=tablename,data,append=TRUE,overwrite=FALSE)
  }
}

readToBase("pjatk_su.csv",con,"suicides",10000)
readToBase("konta.csv",con,"konta",10000)
dbGetQuery(con, "SELECT COUNT(*) FROM suicides")
dbDisconnect(con)
###
##
###

library(tidyverse)
con<-connectMe()
# to jest lista naszego polaczenia  a nie sama tabelka
suicideTable <- tbl(con, 'suicides')
suicideTable %>% select(country, year, age, generation)
# lazy query - funkcja ktora jest tlumaczona na sql ale jest wykonywana wtedy gdy zbieramy wynik (collectem) naszego zapytania
# i wykonujemy obliczenia

# to jest ta sama tabelka ktra jest w naszej bazie, ale jest zapisana jako obiekt w naszym srodowisku
# robiac rzeczy na tabelce w bazie danych 
# collect jest tylko do baz danych
tableR <- suicideTable%>%select(everything())%>%collect()
tableR%>%select(country, year, age, generation)

# dbListTables(con)
