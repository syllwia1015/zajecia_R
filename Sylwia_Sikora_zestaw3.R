###
## ZADANIE 1 ----------------------------------------------------------------------------------------
### 

library(tidyverse)
library(data.table)

konta <- read.csv("konta.csv")

head(konta)
unique(konta$occupation)

# dataFrame <- konta
# colName <- 'occupation'
# groupName <- 'KIEROWCA_BUSA'
# valueSort <- 'saldo'
# num <- 15

rankAccount <- function(dataFrame,colName,groupName,valueSort,num){
  
  data <- data.table(filter(select(dataFrame, colName, valueSort), dataFrame[[colName]] == groupName))
  setorderv(data, valueSort, c(-1))

  return(data[1:num,])
  
}

rankAccount(konta, "occupation", "KIEROWCA_BUSA", "saldo", 15)




###
## ZADANIE 2 ----------------------------------------------------------------------------------------
### 

# filename <- 'konta.csv'
# size <- 1000

rankAccountBigDatatoChunk <- function(filename, size, colName, groupName, valueSort, num){
  
  fileConnection <- file(description = filename, open = "r")
  data <- read.table(fileConnection, nrows = size, header=TRUE, fill = TRUE, sep = ",")
  columnsNames <- names(data)
  output <- data.table()
  
  repeat{
    
    if (nrow(data) == 0){
      close(fileConnection)
      break
    }
    
    data <- na.omit(data)
    data <- read.table(fileConnection, nrows = size, col.names = columnsNames, fill = TRUE, sep = ",")
    new_data <- data.table(filter(select(dataFrame, colName, valueSort), dataFrame[[colName]] == groupName))
    output <- rbindlist(list(output,new_data))
  }
  
  setorderv(output, valueSort, c(-1))
  
  return(output[1:num,])
  
}

rankAccountBigDatatoChunk("konta.csv", 1000, "occupation", "KIEROWCA_BUSA", "saldo", 15)




###
## ZADANIE 3 ----------------------------------------------------------------------------------------
### 

library(RSQLite)

tabelaZbazyDanych<-function(filepath, dbpath, tablename, size, sep=",", header=TRUE, delete=TRUE){
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


tabelaZbazyDanych("konta.csv", "konta.sqlite", "konta", 1000)

dbp <- "konta.sqlite"
con <- dbConnect(SQLite(),dbp)

dbGetQuery(con, "SELECT saldo FROM konta WHERE occupation = 'KIEROWCA_BUSA' ORDER BY saldo DESC LIMIT 15;")

dbDisconnect(con)
