'''
Zadania1



1. Napisz funkcję sprawdzająca czy 1 liczba jest podzielna przez druga użyj - %%


'''

czy_podzielne <- function(liczba1, liczba2){
  if (liczba1%%liczba2 == 0){
    answer <- paste0(liczba1, ' JEST podzielne przez ', liczba2)
  } else{
    answer <- paste0(liczba1, ' NIE JEST podzielne przez ', liczba2)
  }
  return(answer)
}


# checking
czy_podzielne(5,7)


'''
 2. Pociąg z Lublina do Warszawy przejechał połowę drogi ze średnią prędkością 120 km/h.
    Drugą połowę przejechał ze średnią prędkością 90 km/h.
    Jaka była średnia prędkość pociągu.


'''

srednia_predkosc_ALL <- function(sr_predkosc1, sr_predkosc2){

  solution <- 2/((1/sr_predkosc1) + (1/sr_predkosc2))
  
  return(solution)
  
}

srednia_predkosc_ALL(120, 90)




###
## 3. Utwórz funkcję obliczającą współczynnik korelacji r Pearsona dla 2 wektorów o tej samej długości.
##    Wczytaj dane plik dane.csv i oblicz współczynnik dla wagi i wzrostu. W komentarzu napisz co oznacza wynik.
###


dane <- read.csv(file = 'dane.csv', sep = ';')
summary(dane)
anyNA(dane)



korelacja <- function(wektor1, wektor2, interpretacja = TRUE){
  
  
  # ckecks
  if (length(wektor1) != length(wektor2))
    stop("Dwa wektory sa roznej dlugosci! ", call. = TRUE)

  
  # count a correlation
  kor <- cor.test(wektor1, wektor2, method = 'pearson')

  #interpretation
  if(isTRUE(interpretacja)){
    if(kor$estimate == 0 ){
      relacja <- paste0('Brak korelacji miedzy dwoma zmienymi.')
    }else if(kor$estimate > 0){
      relacja <- paste0('Korelacja dodatnia miedzy dwiema zmiennymi, czyli wartosc zmiennej X rosnie wraz z wartoscia Y.')
    }else if(kor$estimate < 0){
      relacja <- paste0('Korelacja ujemna miedzy dwiema zmiennymi, czyli gdy wartosc zmiennej X rosnie, maleje wartosc zmiennej Y.')  
    }
    
    
    return(relacja)
    
  } else{
    return(kor$estimate)
  }
}

korelacja(dane$wzrost, dane$wzrost)



'''
4. Napisz funkcję zwracającą ramke danych z danych podanych przez użytkownika 
    stworzDataFrame <- function(ile=1)
    W pierwszym wierszu użytkownik podaje nazwy kolumn. w kolejnych wierszach zawartość wierszy ramki danych 
    (tyle wierszy ile podaliśmy w argumencie ile. ile=1 oznacza, że gdy użytkownik nie poda żadnej wartości jako parametr, domyślna wartością będzie 1)
    
'''


stworz_Data_Frame <- function(ile = 1, nazwy_kolumn, zawartosc_ramki = list()){
  
  # checks
  if (class(zawartosc_ramki) != "list")
    stop("Zmienna 'zawartosc_ramki' musi być lista", call. = TRUE)

  
  if (length(nazwy_kolumn) != unique(sapply(zawartosc_ramki, length)) | ile != length(zawartosc_ramki) )
    stop("Zmienne sa roznej dlugosci!", call. = TRUE)
  
  
  
  # load needed packages
  packages <- 'data.table'

  for(package in packages){
    if(!require(package, character.only = T, quietly = T)){
      install.packages(package, repos="http://cran.us.r-project.org")
      library(package, character.only = T)
    }
    library(package, character.only = T)
  }
  
  # creating the data frame
  my_dt <- data.table()
  my_dt <- rbind(my_dt,do.call(rbind,zawartosc_ramki))
  my_dt <- as.data.frame(my_dt)
  colnames(my_dt) <- nazwy_kolumn


  return(my_dt)
}

stworz_Data_Frame(ile =2, nazwy_kolumn = c('imie', 'wiek'),zawartosc_ramki = list(c('Sylwia', 26), c('Piotr', 29)))





'''
5 Napisz funkcję , która pobiera sciezkeKatalogu, nazweKolumny, jakaFunkcje, DlaIluPlikow i liczy: 
#mean, median,min,max w zależności od podanej nazwy funkcji w argumencie, z katologu który podaliśmy i z tylu plików ilu podaliśmy dla wybranej nazwy kolumny. 
                                                               
'''



liczZplikow <- function(sciezka,jakaFunkcja="mean",DlaIluPlikow=1){ 
  

  # checks
  if (!(jakaFunkcja %in% c('mean', 'max', 'min', 'median')))
    stop("Blednie uzupelniony parametr 'jakaFunkcja'", call. = TRUE)
  
  # load needed packages
  packages <- 'stringr'
  
  for(package in packages){
    if(!require(package, character.only = T, quietly = T)){
      install.packages(package, repos="http://cran.us.r-project.org")
      library(package, character.only = T)
    }
    library(package, character.only = T)
  }
  
  
  #select all files
  files <- list.files(sciezka, full.names = T)[1: DlaIluPlikow]
  
  #creating data.table with data
  my_dt <- lapply(files, fread)
  my_dt <- rbindlist(my_dt)
  colnames(my_dt)
  
  
  # removing empty columns
  cols <- sapply(my_dt, function (k) all(!is.na(k)))
  my_dt2 <- my_dt[, ..cols]
  
  #selecting the columns 
  print(colnames(my_dt2))
  nazwaKolumny <-  as.vector(readline(paste0('Select the columns: ')))
  
  
  nn <- as.vector(unlist(strsplit(nazwaKolumny, '"')))
  nn <- str_split(nn, ' ')
  nn <- nn[nn != '']
  nn <- unlist(nn[seq(1, length(nn), 2)])
  
  new_dt22 <- my_dt2[, ..nn]
  
  # counting the results
  results <- data.table(zmienna = paste0(nn, '_mean'),arythmetic=lapply(new_dt22, jakaFunkcja))
  
  return(results)
}



liczZplikow(sciezka = '../smogKrakow/smogKrakow/', jakaFunkcja="mean",DlaIluPlikow=2)
