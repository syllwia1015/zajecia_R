library(dplyr)
library(rvest)
library(glue)
library(purrr)
library(xml2)



wektorLinkowolx<-c()
for(str in 1:2) {
  newUrl<- glue("https://www.olx.pl/sport-hobby/rowery/q-rower-szosowy/?page={str}")
  page<-read_html(newUrl)
  result<-page%>%html_nodes(xpath="//h3[@class='lheight22 margintop5']/a")
  wektorLinkowolx<-c(wektorLinkowolx, xml_attr(result,"href"))
} 



get_article_details <- function(art_url) {
  # próbujemy pobrać stronę
  page <- read_html(art_url)
  
  # tytuł
  tytul <- page %>%
    html_node(xpath = "//h1[@class='css-1oarkq2-Text eu5v0x0']") %>%
    html_text() %>%
    trimws()
  
  # cena
  price <- page %>%
    html_node(xpath = "//h3[@class='css-8kqr5l-Text eu5v0x0']") %>%
    html_text() %>%
    str_replace_all(., "zł", "") %>%
    #str_extract(regex('[0-9]+')) %>%
    trimws()
  
  data <- page %>%
    html_node(xpath = "//span[@class='css-19yf5ek']") %>%
    html_text() %>%
    trimws()
  
  rodzaj <- page %>%
    html_node(xpath = "//p[@class='css-xl6fe0-Text eu5v0x0']") %>%
    html_text() %>%
    trimws()
  
  
  
  opis <- page %>%
    html_node(xpath = "//div[@class='css-g5mtbi-Text']") %>%
    html_text() %>%
    trimws()
  
  ID <- page %>%
    html_node(xpath = "//div[@class='css-1v2fuie']//span") %>%
    html_text() %>%
    trimws()
  
  # pakujemy to w 1-wierszowa tabele
  articles1 <- tibble(www = art_url, date = data , ID = ID, title = tytul,cena = price, rodzaj = rodzaj, opis = opis  )
  
  return(articles1)
  return(page)
}

# articles1 <- wektorLinkowolx %>%
#   map_df(get_article_details)


View(articles1)