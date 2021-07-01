library(tidyverse)

"""
filter - wybieranie obserwacji na podstawie wartości.
arrange - zmiana kolejności
select - wybieranie zmiennych na podstawie nazw
mutate - tworzenie nowych zmiennych przekształcając stare.
summarize – podsumowanie wielu wartości (zwijanie).
group_by – zmienia zakres działania funkcji tak aby zamiast na całym zbiorze działały na grupach.

"""

library(nycflights13)

drugiGrudnia <- filter(flights,month=="12", day==2)

flights$month <- factor(flights$month,
                        levels=c(1,2,3,4,5,6,7,8,9,10,11,12),
                        labels=c("January","February","March","April","May","June","July","August",
                                 "September","October","November","December"))

drugiGrudnia <- filter(flights,month=="December",day==2)

daneZwakacji <- filter(flights,flights$month %in% c("July","August","September"))


"""
Zadanie 0:
a)Połączyć się z serwerem MySQL,
b)Przetestować polecenie select dla tabeli flights.
c) Pobrać tabelę z serwera bazy danych mysql jako tibble.
d)skopiować tabelę z R do bazy SQLITE

"""

# A) 
library(rstudioapi)
library(RPostgres)

connectMe <- function(typ=Postgres(),dbname="zwxfmuml",host="rogue.db.elephantsql.com",user="zwxfmuml"){
  con<-dbConnect(
    typ,
    dbname=dbname,
    host=host,
    user=user,
    password=askForPassword("database pass"))
}

con<-connectMe()

# B)

head(flights)
colnames(flights)

flights %>% select(month)
flights %>% select(arr_time, carrier , flight)
flights %>% select(arr_time : flight)
flights %>% select(!(arr_time : flight))
flights %>% select(!ends_with("time"))
flights %>% select(starts_with("arr") | ends_with("delay"))

flights %>% select(ends_with("time"))


# C)
dbListTables(con)
suicideTable <- tbl(con, 'suicides')

# D)
dbWriteTable(con, "flights", flights)


"""
Ćwiczenia1
1.Znajdź wszystkie loty, które:
a)Były opóźnione podczas przylotu co najmniej o dwie godziny.
b)Leciały do Houston (IAH lub HOU).
c)Były obsługiwane przez linie United, American lub Delta.
d)Odlatywały latem (w lipcu, sierpniu i wrześniu)
e)Przyleciały z ponad dwugodzinnym opóźnieniem, ale nie odleciały opóźnione.
f)Były opóźnione o co najmniej godzinę, ale zrekompensowały opóźnienie o ponad 30 minut
podczas lotu.
g)Wyruszyły między północą a 6 rano (włącznie).

"""

# 1A
flights %>% filter(dep_delay >= 120 | arr_delay >=120)

# 1B
Houston <- flights %>% filter(dest %in% c("IAH","HOU"))

# 1C
flights %>% filter(carrier %in% c("AA","UA", 'DL'))

# 1D 
flights %>% filter(month %in% c("July","August", 'September'))

# 1E
flights %>% filter(arr_delay >= 120 & dep_delay ==0)

# 1F
flights %>% filter(dep_delay >=60 & arr_delay <= 30)

# 1G
flights %>% filter(dep_time == 2400 | dep_time <= 600 )


#-----------------------------------------------------------------------------------------------------------------------------------

arrange(flights,month,day)

# Możemy też sortować malejąco:
arrange(flights,month,desc(day))


"""
Ćwiczenia2
1.Jak za pomocą funkcji arrange() posortować wszystkie brakujące wartości, tak aby znalazły się na
początku? (Wskazówka: użyj funkcji is.na()).
2.Posortuj dane flights, aby znaleźć najbardziej opóźnione loty. Znajdź te, które odleciały najwcześniej.
3.Posortuj dane flights, aby znaleźć najszybsze loty.
4.Które loty trwały najdłużej? Które najkrócej?
"""
# 2.1
flights %>% 
  arrange(desc(is.na(dep_time)),
          desc(is.na(dep_delay)),
          desc(is.na(arr_time)), 
          desc(is.na(arr_delay)),
          desc(is.na(tailnum)),
          desc(is.na(air_time)))

# 2.2
arrange(flights, desc(arr_delay),dep_time )

# 2.3
arrange(flights,desc(distance), air_time )

# 2.4
arrange(flights,air_time )
arrange(flights, desc(air_time) )



# --------------------------------------------------------------------------------------------------

select(flights,month,day,dep_time,dep_delay,arr_time,arr_delay,tailnum)
select(flights, month:tailnum)
select(flights, -(year:day))

'''
Funkcje pomocnicze funkcji select():
starts_with("abc") wybiera nazwy rozpoczynające się od „abc”.
ends_with("xyz") wybiera nazwy kończące się na „xyz”.
contains("abc") wybiera nazwy zawierające „abc”.
matches("”) wybiera zmienne pasujące do wyrażenia regularnego
num_range("x", 1:3) pasuje do x1, x2 i x3.
'''

select(flights, dep_time,arr_time,everything())



'''
Ćwiczenia3
1.Wybierz wartości zmiennych dep_time, dep_delay, arr_time i arr_delay ze zbioru danych flights.
2.Co się stanie, gdy w wywołaniu select() kilkakrotnie wpiszesz nazwę tej samej zmiennej?
3.Do czego służy funkcja one_of()? Dlaczego może się okazać przydatna razem z tym wektorem?
vars <- c("year", "month", "day", "dep_delay", "arr_delay")

'''

# 3.1
select(flights, dep_time, dep_delay, arr_time, arr_delay)

# 3.2
select(flights, dep_time, dep_time)
# w momencie powielenia nazy kolumnny, wydrukuje ja tylko raz w outpucie

# 3.3
vars <- c("year", "month", "day", "dep_delay", "arr_delay")
select(flights, one_of(vars))
# one_of - nie wyrzuca bledu jesli kolumna w dataframe o wpisanej nazwie nie istnieje.
# W powyzszym przykladzie nie jest ona zbyt przydatna poniewaz wszystkie zmienne wpisane w wektor istnieja w data frame - flights



# -------------------------------------------------------------------------------------------------------------------------------

flights_small <- select(flights,ends_with("delay"),distance,air_time)

# Funkcja mutate() pozwala nam na dodawanie nowych zwmiennych ( kolumn) do naszej ramki danych.
mutate(flights_small,gain = arr_delay - dep_delay,speed=distance/air_time*60)

# Operatory arytmetyczne +, -, *, /, ^
# Arytmetyka modulo(%/% i %%)
# %/% (dzielenie całkowite) i %% (reszta), gdzie x == y * (x %/% y) + (x %% y).



'''
Ćwiczenia4
1.na podstawie zmiennej dep_time oblicz hour i minute.
2.Przekształć dep_time i sched_dep_time, wyznaczając liczbę minut, jaka upłynęła od północy.
'''
# 4.1
mutate(flights_small,dep_hour = as.character(dep_time))
# ????????????????????????/


# -------------------------------------------------------------------------------------------------------------------------------
# Funkcja summarize() zawija dane do jednego wiersza.
speedData <- transmute(flights_small,gain = arr_delay - dep_delay,speed=distance/air_time*60)
summarize(speedData,speadmean = mean(speed,na.rm=TRUE))

# Możemy robić podsumowanie dla grupy zamiast dla całego zestawu danych, korzystając z group_by().
by_month <- group_by(flights,month)
summarize(by_month, meanMonthlyDelay=mean(dep_delay,na.rm = TRUE))

by_destination <- group_by(flights,dest)
View(by_destination)

delay <-  summarize(by_destination,count=n(),dist=mean(distance,na.rm=TRUE),delay=mean(arr_delay,na.rm=TRUE))
View(delay)

delays<- flights %>% group_by(dest)%>%summarize(count =n(),dist=mean(distance,na.rm=TRUE),delay=mean(arr_delay,na.rm=TRUE))
View(delays)

opoznione <- flights %>% group_by(tailnum) %>% summarize(opoznienie = mean(arr_delay,na.rm=TRUE),n=n())
opoznione

# Przy małej liczbie lotów opóźnienia bardzo się różnią, co możemy zobaczyć na wykresie:
ggplot(data=opoznione,mapping=aes(x=n,y=opoznienie))+geom_point(alpha=1/8)+xlim(0,800)


flights %>% group_by(dest) %>%summarise(distance_sd=sd(distance,na.rm=TRUE))%>%arrange(desc(distance_sd))

flights %>% group_by(year,month,day) %>% summarize(first = min(dep_time,na.rm=TRUE),last=max(dep_time,na.rm=TRUE))


# Korzystaliśmy już z funkcji n(), która nie przyjmuje argumentów i zwraca rozmiar bieżącej grupy. Aby obliczyć
# liczbę niebrakujących wartości, korzystamy z instrukcji sum(!is.na(x)). Aby sprawdzić liczbę unikatowych
# wartości, możemy skorzystać z funkcji n_distinct(x).

flights %>% group_by(dest) %>%summarize(carriers = n_distinct(carrier,na.rm=TRUE))%>%arrange(desc(carriers))

# suma mil, którą przeleciał każdy samolot:
flights %>%count(tailnum,wt = distance )



'''
Ćwiczenia5
1.Rozważ następujące scenariusze i znajdz loty które:
Lot jest o 15 minut za wcześnie przez 50% czasu, i o 15 minut za późno przez 50% czasu.
Lot jest zawsze opóźniony o 10 minut.
Lot jest o 30 minut za wcześnie przez 50% czasu i jest opóźniony o 30 minut przez 50% czasu.
Przez 99% czasu lot jest zgodny z harmonogramem. Przez 1% czasu jest opóźniony o 2 godziny.
Co jest ważniejsze: opóźnienie przylotu czy odlotu?
Dla ramki bez anulowanych lotów:
not_cancelled <- flights %>%
filter(!is.na(dep_delay), !is.na(arr_delay))
2.Dla każdego samolotu oblicz liczbę lotów przed pierwszym opóźnieniem większym niż jedna godzina.
3.Do czego służy argument sort funkcji count()? Kiedy można z niego skorzystać?
4.Ile było lotów każdego dnia?
5.Ile było lotów każdego miesiąca?

'''
# ????????

# 5.3
flights %>%count(tailnum,wt = distance )
flights %>%count(tailnum,wt = distance, sort = T )
# Gdy sort = TRUE, to pokazuje najliczniejsze grupy jako pierwsze

# 5.4
flights %>% group_by(year, month, day) %>%summarize(number_of_flights = n_distinct(flight, na.rm=T))

# 5.5
flights %>% group_by(year, month) %>%summarize(number_of_flights = n_distinct(flight, na.rm=T))

