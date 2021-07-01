library(tidyverse)

"""
# geom_point() – wykres punktowy
# geom_histogram() – histogram
# geom_line() – wykres liniowy
# geom_smooth() – wykres wygładzony
# geom_bar() – wykres słupkowy
# geom_boxplot() – wykres pudełkowy (skrzynkowy)
# geom_violin() – wykres skrzypcowy

# facet_wrap() – dzieli na panele według jednej wybranej zmiennej
#     np. facet_wrap(~class, nrow = 2)
# facet_grid() – dzieli na panele według dwóch zmiennych
#     np. facet_grid(drv ~ cyl)

# Wykresy można umieszczać w różnych układach współrzędnych.
#   coord_flip() – przełącza osie x i y
#   coord_quickmap() – ustawia poprawny współczynnik proporcji map
#   coord_polar() wykorzystuje współrzędne biegunowe



Ogólny szablon działania pakietu ggplot2 wygląda następująco:
  
  ggplot(data = <DANE>) +
  <FUNKCJA_GEOMETRYCZNA>(
    mapping = aes(<MAPOWANIA>)),
stat = <PRZEKSZTAŁCENIE_STATYSTYCZNE>,
position = <POZYCJA>
  ) +
  <FUNKCJA_WSPÓŁRZĘDNYCH> +
  <FUNKCJA_PANELI>
  
  
  
alpha - przezroczystosc 

"""

?mpg

ggplot(data = mpg)+
  geom_point(mapping = aes(x = displ, y = cty))

ggplot(data = mpg)+
  geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg)

###
## cwiczenie 1 -----------------------------------------------------------------------------------------------------------------
###

# 1. Co widzimy po wywołaniu polecenia ggplot(data = mpg)
ggplot(data = mpg) 
# Widzimy puste pole, niezbedne jest zdefiniowanie x i y do utworzenia wykresu


# 2. Ile wierszy i kolumn znajduje się w zbiorze danych mtcars?
nrow(mtcars) # 32 wiersze 
ncol(mtcars) # 11 kolumn


# 3. Czym jest zmienna drv z ramki danych mpg?
?mpg
# dry - the type of drive train, where f = front-wheel drive, r = rear wheel drive, 4 = 4wd


# 4. Wykonaj wykresy zależności pomiędzy zmiennymi cty i cyl oraz hwy i cyl
ggplot(data = mpg)+
  geom_point(mapping = aes(x = cty, y = cyl))

ggplot(data = mpg)+
  geom_point(mapping = aes(x = hwy, y = cyl))


# 5. Wykonaj wykres punktowy zależności pomiędzy class i drv. Co widzimy?
ggplot(data = mpg)+
  geom_point(mapping = aes(x = class, y = drv))
# Wykres ten jest pomiedzy dwoma zmiennymi o klasie character/kategorycznej.
# Z racji, że nie sa one wartosciami nominalnymi wykres ten przedstawia informacje jakosciowe zamiast ilosciowe.


###
## ---------------------------------------------------------------------------------------------------------
###


ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color =class ))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, alpha =class )) # kontrola przezroczystosci

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape =class )) # roznorodnosc ksztaltow punktorow

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size =class )) # kontrola wielkosci punktorow

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), color = "red")


###
## Cwiczenie 2 -----------------------------------------------------------------------------------------------
###

# 1.W którym miejscu tego kodu znajduje się błąd? Dlaczego punkty nie są zielone?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ,y=cty, color="green"))
# zdefiniowanie kolor punktow powinno byc poza aes, wewnatrz aes mozemy przyipsac zmienna, wedlug ktorej maja zostac zroznicowane kolory
# w tym kroku niewiele sie zadzialo dzieki parametrowi color, poniewaz w tabeli nie ma zmiennej o nazwie green, a punktory nie sa zielone, 
# poniewaz znajduje sie wewnatrz funkcji aes.


# 2.Które zmienne ze zbioru mpg są kategorialne? Które zmienne są ciągłe? (Wskazówka: wpisz ?
# mpg, aby przeczytać dokumentację tego zbioru danych).
str(mpg)
# zmienne numeryczne: displ, year, cyl, cty, hwy, 
# zmiene stringowe: manufacturer, model, trans, drv, fl, class


# 3.Zmapuj zmienną ciągłą na estetykę color, size i shape. Na czym polega różnica w zachowaniu
# tych estetyk w przypadku zmiennych kategorialnych i ciągłych?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ,y=cty, color=cyl)) 
# dzieki zmienej numerycznej, jako parametr rozroznienia elementow na wykresie - tworzy sie autmatycznie skala barwna ciagla zamiast
# skali rozbiezne w przypadku uzycia zmiennej kategorycznej

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ,y=cty, size=cyl))
# uzycie zmiennej numerycznej w parametrze size rozroznia elementy na bazie rozmiaru punktora 

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ,y=cty, shape=cyl))
# rozorznienie zmiennej numerycznej na podstawie ksztaltu jest niemozliwe


# 4.Co się stanie, jeśli zmapujesz tę samą zmienną na wiele estetyk?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ,y=cty, size=cyl, color = cyl))
# utworzone zostana dwie legendy z dwoma wlasciwosciami wizualnymi przedstawienia parametru cyl


# 5.Do czego służy estetyka stroke? Z jakimi kształtami można jej użyć? (Wskazówka: skorzystaj z
# polecenia ?geom_point).
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ,y=cty, stroke=cyl))
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ,y=cty, stroke=class))
# parametr stroke jest wykorzystywany jedynie przy zmiennych numerycznych, stosowany do modyfikacji szerokosci krawedzi punktow


# 6.Co się stanie, jeśli zmapujesz estetykę na coś innego niż nazwa zmiennej, jak na przykład aes(color = displ < 4)?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ ,y=cty, color=displ < 4)) 
# nasze wartosci zostana pogrupowane na wartosci powyzej 4 i ponizej , co na legedzie bedzie oznaczone jako FALSE/TRUE 

###
## ----------------------------------------------------------------------------------------------------------------------------
###


ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = cty)) +
  facet_wrap(~ class, nrow=3)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ cyl)



###
## Cwiczenie 3 ------------------------------------------------------------------------------------------------------------------
###
# 1. Co się stanie jeżeli podzielimy wykres na panele używając zmiennej ciągłej?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = cty)) +
  facet_wrap(~ cyl, nrow=3)
# dla kazdej wartosci numerycznej zostanie utworzony oddzielny panel 


# 2. Co oznaczają puste komórki na wykresie:
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ cyl)
# puste komorki oznaczaja ze jest brak obserwacji kotre posiadalyby przykladowo wartosc 5 w kolumnie cyl i jednoczesnie wartosc 4 i r 
# w kolumnie drv


ggplot(data = mpg) +
  geom_point(mapping = aes(x = drv, y = cyl))
# ten wykres pokazuje zaleznosci pomiedzy dwiema zmiennymi. Dzieki niemu mozemy pozyskac informacje jakosciowe, czyli wystepowaie wartosci 
# zmiennej cyl i jedoczesnie wartosci drv 


# 3. Jakie wykresy powstaną po uruchomieniu polecenia poniżej? Do czego służy znak „.”?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)
# w zaleznosci od zdefiniowania facet_gris matrix panel okreslony kolumnowo badz wierszowo


# 4 Jakie korzyści daje używanie paneli zamiast estetyk?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 2)
# bardziej przejrzysta analiza danych


# 5. Do czego służ argument nrow ? Ncol ? Jakie inne opcje kontrolują układ poszczególnych paneli?
# nrow sluzy do okreslenia wymiaru panelu matrixa w postaci liczby wierszy, natomiast ncol - liczby kolumn
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 1)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, ncol = 5)


###
## -----------------------------------------------------------------------------------------------------------------------------
###


ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_smooth(mapping = aes ( x = displ, y = hwy, linetype = drv ))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy,color=drv))+
  geom_point(mapping=aes(x=displ,y=hwy,color=drv))

ggplot(data = mpg, mapping = aes ( x = displ, y = hwy,color=drv ))+
  geom_point()+
  geom_smooth()

ggplot(data = mpg, mapping = aes ( x = displ, y = hwy,color=drv,shape=drv , linetype = drv ))+
  # linetype - rozroznienie stylu linii
  geom_point()+
  geom_smooth()

ggplot(data = mpg, mapping = aes ( x = displ, y = hwy ))+
  geom_point()+
  geom_smooth(mapping = aes (color=drv))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy))+
  geom_point(mapping = aes(color = class))+
  geom_smooth(data = filter(mpg, class=="suv"),se = FALSE)
  # se - wyswietlenie przedzialu ufnosci (jesli TRUE)




###
## Cwiczenie 4 ------------------------------------------------------------------------------------------------------------------
###

# 1. Jakiej geometrii użyjesz, aby narysować wykres liniowy? Wykres pudełkowy? Histogram? Wykres warstwowy?
ggplot(data = mpg, mapping = aes( x = displ, y = hwy, color = drv))+
  geom_line()

ggplot(data = mpg, mapping = aes( x = displ,  color = drv))+
  geom_histogram()

ggplot(data = mpg, mapping = aes( x = displ, y = hwy, color = drv))+
  geom_boxplot()


# 2. Spróbuj przewidzieć działanie polecenia poniżej. Następnie sprawdź czy miałeś rację uruchamiajac je.
ggplot(data = mpg, mapping = aes( x = displ, y = hwy, color = drv))+
  geom_point()+
  geom_smooth(se = FALSE)


# 3.Do czego służy kod show.legend = FALSE?
ggplot(data = mpg, mapping = aes( x = displ, y = hwy, color = drv))+
  geom_point(show.legend = F)+
  geom_smooth(se = FALSE, show.legend = F) 
# usuwa legende na obszarze wykresu


# 4.Do czego służy argument se w funkcji geom_smooth()?
ggplot(data = mpg, mapping = aes( x = displ, y = hwy, color = drv))+
  geom_point()+
  geom_smooth(se = FALSE)

ggplot(data = mpg, mapping = aes( x = displ, y = hwy, color = drv))+
  geom_point()+
  geom_smooth(se = TRUE)
# parametr se decyduje czy przedzial ufnosci zjawiska zostanie przedstawiony na wykresie badz nie


# 5.Czy te dwa wykresy są inne? Dlaczego?
ggplot(data = mpg , mapping = aes( x = displ, y = hwy))+
  geom_point()+
  geom_smooth()
# wykres z przykladu nr 2 oraz powyzszy przyklad roznia sie tym, ze w pierwszym przypadku zdefiniowana jest trzecia zmienna, za pomoca ktorej
# przedstawione dane beda dodatkowo rozrownienie kolorystycznie oraz za pomoca lini trendu (3 oddzielne, dla 3 roznych obserwacji zmiennej drv),
# ale bez przedstawienia przedzialu ufnosci. 
# Natomiast drugi wykres bez zdefiniowanej trzeciej zmiennej przedstawia jedna linie trenu dla calego wykresu wraz z przedzialem ufnosci.
# za pomoca trzeciej zmiennej, przedstawienia 


# 6.Odtwórz kod R potrzebny do wygenerowania następujących wykresów: (obrazek w pdfie)

g1 <- ggplot(data = mpg , mapping = aes( x = displ, y = hwy))+
  geom_point()+
  geom_smooth(se = FALSE)

g2 <- ggplot(data = mpg, mapping = aes( x = displ, y = hwy))+
  geom_point()+
  geom_smooth(mapping = aes(group = drv), se = FALSE)

g3 <- ggplot(data = mpg , mapping = aes( x = displ, y = hwy,  color = drv))+
  geom_point()+
  geom_smooth(se = FALSE)

g4 <- ggplot(data = mpg , mapping = aes( x = displ, y = hwy))+
  geom_point( mapping = aes(color = drv))+
  geom_smooth(se = FALSE)

g5 <- ggplot(data = mpg , mapping = aes( x = displ, y = hwy, linetype = drv))+
  geom_point( mapping = aes(color = drv))+
  geom_smooth(se = FALSE)

g6 <- ggplot(data = mpg , mapping = aes( x = displ, y = hwy, fill = drv))+
  geom_point(colour = 'white', stroke =2, shape = 21)

library(gridExtra)
grid.arrange(g1,g2,g3,g4,g5,g6, ncol = 2)


###
## -----------------------------------------------------------------------------------------------------------------------------
###



ggplot(data = diamonds)+
  geom_bar(mapping = aes(x = cut))

ggplot(data = diamonds) +
  stat_count(mapping = aes(x = cut))

dane <- tribble(
  ~a,~b,
  "b1",66,
  "b2", 33,
  "b3", 11,
  "b4", 6)
ggplot(data = dane)+
  geom_bar(
    mapping = aes(x = a, y = b), stat = "identity" )

# wykres proporcji - super
ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut, y = ..prop.., group =0 ))

#obliczenie sumarycznych wartości y dla każdej unikatowej wartosci x:
ggplot(data = diamonds) + stat_summary(mapping = aes(x = cut, y= depth),
                                       fun.ymin = min,
                                       fun.ymax = max,
                                       fun.y = median )

?stat_bin

###
## Cwiczenie 5 -------------------------------------------------------------------------------------------------------
###

# 1.Która domyślna funkcja geometryczna jest związana z funkcją stat_summary()? Jak można
# przepisać wcześniejszy wykres, aby skorzystać z funkcji geometrycznej zamiast z przekształcenia statystycznego?

#Wczesniejszy wykres mozemy przedstawic za pomoca funkcji geometrycznej - geom_line
ggplot(data = diamonds, aes(cut, depth))+
  geom_line()


# 2.Do czego służy funkcja geom_col()? Czym różni się od funkcji geom_bar()?
ggplot(data = diamonds)+
  geom_col(mapping = aes(x = cut, y = depth))
ggplot(data = diamonds)+
  geom_bar(mapping = aes(x = cut))

# geom_bar - oblicza watosci do wyswietlenia na podstawie jednej zmiennej 
# geom_col - otrzymuje juz obliczone wartosci, zagregowane dane, uzywa dwóch zmiennych


# 3.Większość funkcji geometrycznych i przekształceń statystycznych tworzy pary, które niemal
# zawsze są używane wspólnie. Przeczytaj dokumentację i wykonaj listę tych par. Co mają ze sobą wspólnego?

"""
geom_histogram() == stat_bin()
geom_smooth() == stat_smooth()
geom_line() == stat_summary()
geom_boxplot() == stat_boxplot()
geom_bar() == stat_count()
geom_violin() == stat_ydensity()
geom_hex() == stat_binhex()
geom_freqpoly() == stat_bin()

?wiecej jest??
"""

# 4.Jakie zmienne oblicza funkcja stat_smooth()? Jakie parametry sterują jej zachowaniem?

# przedzial ufnosci obserwacji

# 5.Na naszym wykresie słupkowym proporcji musieliśmy skorzystać z zapisu group = 1.
# Dlaczego? Innymi słowy, na czym polega problem z poniższymi wykresami?

ggplot( data = diamonds) +
  geom_bar(mapping = aes(x = cut, y = ..prop..))

ggplot(data = diamonds) + geom_bar(mapping = aes ( x = cut, fill = color, y =..prop..))

ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut, y = ..prop.., group =0 ))

# grupowanie jest niezbedne aby moc otrzymac prcentowy udzial danej obserwcji w calym zestawie danych, 


###
## -------------------------------------------------------------------------------------------------------------------------------
###

# kolorwanie wykresow
ggplot(data = diamonds)+
  geom_bar(mapping = aes(x = cut, color = cut))

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = cut))

ggplot(data = diamonds)+
  geom_bar(mapping = aes(x = cut, fill = clarity))

"""
W przypadku argumentu position = 'identity' każdy obiekt zostanie umieszczony dokładnie
w tym miejscu, w którym się znajduje w kontekście wykresu. Nie jest to zbyt wygodne w przypadku
słupków, ponieważ prowadzi do ich nakładania się na siebie. Aby zaprezentować ten efekt,
musimy zadbać o niewielką przezroczystość słupków, ustawiając parametr alpha na małą wartość,
lub utworzyć całkowicie przezroczyste słupki, ustawiając fill = NA:

"""

ggplot( data = diamonds, mapping = aes(x = cut, fill = clarity))+
  geom_bar( position = "identity")

ggplot( data = diamonds, mapping = aes(x = cut, fill = clarity))+
  geom_bar(alpha = 1/5 , position = "identity")

"""
position = 'fill' działa podobnie jak kumulowanie wartości, ale każdy zestaw nałożonych na
siebie słupków ma jednakową wysokość (100%). Dzięki temu łatwiej porównywać proporcje w poszczególnych
grupach:

"""

ggplot(data = diamonds)+
  geom_bar(mapping = aes(x = cut, fill=clarity),position="fill")

"""
position = 'dodge' umieszcza nakładające się obiekty bezpośrednio obok siebie. To ułatwia porównywanie
poszczególnych wartości:

"""

ggplot(data = diamonds) +
  geom_bar( mapping = aes( x =cut, fill = clarity), position = "dodge")

# rozdzielenie obserwacji punktowych w celu lepszej/bardziej przejrzystej wizualizacji
ggplot( data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")

# ?position_dodge, ?position_fill, ?position_identity, ?position_jitter i ?position_stack.


###
## Cwiczenie 6 ------------------------------------------------------------------------------------------------
###

#1.Na czym polega problem z tym wykresem? Jak można go poprawić?
ggplot(data = mpg,
 mapping = aes(x = cty, y = hwy )) + geom_point()
#problem nakladania na siebie obserwacji punktowych


# 2.Jakie parametry funkcji geom_jitter() sterują poziomem fluktuacji?
#??


# 3.Porównaj ze sobą funkcje geom_jitter() i geom_count().
ggplot(mpg, aes(cty, hwy)) + geom_count()
# geom_count - wieksza wage kropki wedle potrzeby danych


# 4.Jakie jest domyślne dopasowanie położenia dla geom_boxplot()? Utwórz odpowiednią Wizualizację zestawu danych mpg.
ggplot(mpg, aes(cty)) + geom_boxplot()
# polozenie horyzontalne dla jednej zmiennej


###
## ---------------------------------------------------------------------------------------------------------------
###

ggplot(data = mpg, mapping = aes(x = class, y = hwy ))+ geom_boxplot()

# coord_flip() aby przełączyć osie x i y
bar <- ggplot(data = diamonds)+geom_bar(
  mapping = aes(x = cut, fill = cut ),
  show.legend = FALSE,
  width = 1 ) +
  theme(aspect.ratio = 1)+
  labs(x = NULL, y = NULL)

View(bar)
# coord_polar() wykorzystuje współrzędne biegunowe. - wykres kolowy
bar + coord_polar()


###
## Cwiczenie 7 ----------------------------------------------------------------------------------------------
###

# 1.Przekształć skumulowany wykres słupkowy w wykres kołowy za pomocą funkcji coord_polar().


# 2.Do czego służy funkcja labs()? Przeczytaj dokumentację.
# Do modyfikowania etykiet wykresu na osi x i y 


# 3.Patrząc na poniższy wykres, czego możesz się dowiedzieć o zależności między miastem (cty) a wydajnością zużycia paliwa na
# autostradzie (hwy)? Dlaczego ważne jest wywołanie coord_fixed()? Do czego służy funkcja geom_abline()?

# Na wykresie widac silna  zaleznosc pomiedzy dwiema zmiennymi i wystepuje korelacjia liniowa.

ggplot(data = mpg, aes(x = cty, y = hwy))+ geom_point() + geom_abline() + coord_fixed()
# coord_fixed - zmienia wielkosc obszaru????
# geom_abline - tworzy referencyjna linie pomiedzy dwoma zmiennymi


# 4.Opisz, krótko wykres pudełkowy.
# Wykres pudelkowy przedstawia rozproszenie / rozklad wartosci zmiennych. Dzieki niemu mozemy zaobserwowac zmienne odstajace,
# a takze wartosc mediany wszystkich obserwacji i rozklad kwantyli 


# 5.Pobierz historyczne dzienne dane wybranej spółki giełdowej ze strony: https://stooq.pl/
# ( plik csv) a następnie wyświetl wykres pudełkowy (oś OX – rok, oś OY – cena akcji na
#                                                    zamknięciu) tak jak w przykładzie poniżej.
library(lubridate)
library(data.table)
wig <- data.table(read.csv('wig_w.csv'))
ggplot(data = wig, aes(x = as.factor(year(as.Date(Data))), y = Zamkniecie))+geom_boxplot()
