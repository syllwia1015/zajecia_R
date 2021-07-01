library(httr)
library(jsonlite)
#json - fajniejszy xml, czytelniejszy, obiekty java scriptu

#czym sie różni library od require - require przy przypisywaniu do zmiennej wyrzuca FALSE, a library blad
# wynik <- library(httr)
# wynik <- require(jsonlite)

endpoint <- "https://api.openweathermap.org/data/2.5/weather?q=Warszawa&appid=1765994b51ed366c506d5dc0d0b07b77"

getWeather <- GET(endpoint)

weatherText <- content(getWeather, as = 'text')
weatherJson <- fromJSON(weatherText, flatten = FALSE)

weatherDT <- as.data.frame(weatherJson)

x <- 124.5

class(x)

is.vector(x)
x <- '123'
x <- c(1,2,3,4,5,6,7,8,9)
y <- as.vector(c(2), mode = 'integer')
x <- as.integer(x)

# komentarz: +,-,*,/
wynik <- x+y
wynik
class(wynik)

wynik <- x/y
class(wynik)

wynik <- x-y
wynik
class(wynik)


wynik <- x%%y
wynik
class(wynik)

wynik <- x%/%y
wynik
class(wynik)



lista <- list(1,2,3,4,5)
lista <- list(1,'2', 3.0, 4,5)
str(lista)

lista <- list(c(1,2,3), c('jeden', 'dwa') )

wartosci <- lista[[2]][lista[[1]] > 1]




xx <- read.csv('dane.csv', sep=';')