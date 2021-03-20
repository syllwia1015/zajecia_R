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