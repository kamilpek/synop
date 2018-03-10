# ogimet crawler
# Kamil Pek
# 03.2018
# v0.0.1
#
# biblioteki
options(encoding="utf-8")
install.packages("rvest", repos = "http://cran.us.r-project.org")
install.packages("RPostgreSQL", repos = "http://cran.us.r-project.org")
library("rvest")
library("RPostgreSQL")
# funkcje
metar_date <- function(code){
  mes = ""
  wind <- function(x){
    switch(x,
     "0" = "prędkość w m/s (mierzona wiatromierzem Wilda lub szacowana).",
     "1" = "prędkość w m/s (mierzona anemometrem).",
     "3" = "prędkość w węzłach (mierzona wiatromierzem Wilda lub szacowana).",
     "4" = "prędkość w węzłach (mierzona anemometrem).",
     Default = "b/d"
    )
  }
  mes <- paste("Dzień:", substr(code, 1, 2), " Godzina: ", substr(code, 3, 4), sep="")
  mes <- paste("Wskaźnik wiatru:", wind(substr(code, 5, 5)))
  message <<- paste(message, mes, sep="")
}
visibility_horizontal <- function(x){
  if(x<50){
    y = toString(x)
    sprintf("%s.%s km.", substr(x, 1, 1), substr(x, 2, 2))
  } else if((x>54) && (x<60)) {
    sprintf("%s km.", substr(x, 2, 2))
  } else if((x>59) && (x<70)) {
    sprintf("1%s km.", substr(x, 2, 2))
  } else if((x>69) && (x<80)) {
    sprintf("2%s km.", substr(x, 2, 2))
  } else if((x>79)) {
    switch(x,
     "80" = "30 km.",
     "81" = "35 km.",
     "82" = "40 km.",
     "83" = "45 km.",
     "84" = "50 km.",
     "85" = "55 km.",
     "86" = "60 km.",
     "87" = "65 km.",
     "88" = "70 km.",
     "89" = "> 70 km.",
     Default = "b/d"
    )
  }
}
precipations <- function(code){
  mes = ""
  prep_group <- function(x){
    switch(x,
      "0" = "grupa opadowa w rozdziale 1 i 3.",
      "1" = "grupa opadowa tylko w rozdziale 1.",
      "2" = "grupa opadowa tylko w rozdziale 3.",
      "3" = "grupa opadowa pominięta (opady nie wystąpiły).",
      "4" = "grupa opadowa pominięta (nie wykonywano pomiarów opadu).",
      Default = "b/d"
    )
  }
  station <- function(x){
    switch(x,
      "1" = "stacja nieautomatyczna.",
      "2" = "stacja nieautomatyczna.",
      "3" = "stacja nieautomatyczna.",
      "4" = "stacja automatyczna.",
      "5" = "stacja automatyczna.",
      "6" = "stacja automatyczna.",
      Default = "b/d"
    )
  }
  altitude <- function(x){
    switch(x,
       "0" = "0 do 50 m.",
       "1" = "50 do 100 m.",
       "2" = "100 do 200 m.",
       "3" = "200 do 300 m.",
       "4" = "300 do 400 m.",
       "5" = "600 do 1000 m.",
       "6" = "1000 do 1500 m.",
       "7" = "1500 do 2000 m.",
       "8" = "2000 do 2500 m.",
       "9" = "powyżej 2500 m.",
       "/" = "nieznana.",
       Default = "b/d"
    )
  }
  mes <- paste("Wskaźnik grupy opadowej:", prep_group(substr(code, 1, 1)))
  mes <- paste(mes, "Typ stacji:", station(substr(code, 2, 2)))
  mes <- paste(mes, "Wysokość względna podstawy najniższych chmur:", altitude(substr(code, 3, 3)))
  mes <- paste(mes, "Widzialność pozioma:", visibility_horizontal(substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
clouds <- function(code){
  mes =""
  size <- function(x){
    if(x == 0){
      "bezchumrnie."
    } else if((x>0) && (x<8)){
      sprintf("%s/8.", x)
    } else if(x == 9) {
      "niebo niewidoczne."
    } else {
      "brak danych."
    }
  }
  direction <- function(x){
    if(x == "00"){
      "cisza."
    } else if((x>0) && (x<99)) {
      sprintf("ok. %s.", (strtoi(x)*9))
    } else if(x == 99){
      "zmienny lub z wielu kierunków."
    } else {
      "brak danych."
    }
  }
  mes <- paste("Wielkość zachmurzenia ogólnego:", size(substr(code, 1, 1)))
  mes <- paste(mes, "Kierunek wiatru w dziesiątkach stopni:", direction(substr(code, 2, 3)))
  mes <- paste(mes, sprintf("Prędkość wiatru: %s.", substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
first_group <- function(code){
  mes = "[1]Temparatura powietrza:"
  if(substr(code, 2, 2) == 1){
    mes <- paste(mes, "-")
  }
  value = sprintf("%s%s.%s st.C.", substr(code, 3, 3), substr(code, 4,4), substr(code, 5, 5))
  mes <- paste(mes, value)
  message <<- paste(message, mes, sep=" ")
}
second_group <- function(code){
  mes = "[2]Temparatura punktu rosy:"
  if(substr(code, 2, 2) == 1){
    mes <- paste(mes, "-")
  }
  value = sprintf("%s.%s st.C.", substr(code, 3, 4), substr(code, 5, 5))
  mes <- paste(mes, value)
  message <<- paste(message, mes, sep=" ")
}
third_group <- function(code){
  mes = "[3]Ciśnienie atmosferyczne na poziomie stacji:"
  if(substr(code, 2, 2) == 0){
    mes <- paste(mes, sprintf("1%s.%s hPa", substr(code, 2, 4), substr(code, 5, 5)))
  } else {
    mes <- paste(mes, sprintf("%s.%s hPa", substr(code, 2, 4), substr(code, 5, 5)))
  }
  message <<- paste(message, mes, sep=" ")
}
fourth_group <- function(code){
  mes = "[4]Ciśnienie atmosferyczne zredukowane do poziomu morza:"
  if(substr(code, 2, 2) == 0){
    mes <- paste(mes, sprintf("1%s.%s hPa.", substr(code, 2, 4), substr(code, 5, 5)))
  } else {
    mes <- paste(mes, sprintf("%s.%s hPa.", substr(code, 2, 4), substr(code, 5, 5)))
  }
  message <<- paste(message, mes, sep=" ")
}
fifth_group <- function(code){
  mes = ""
  preassure <- function(x){
    switch(x,
     "0" = "wzrost duży, później spadek mały,",
     "1" = "wzrost, później bez zmian,",
     "2" = "wzrost,",
     "3" = "spadek mały, później wzrost duży,",
     "4" = "bez zmian,",
     "5" = "spadek duży, później wzrost mały,",
     "6" = "spadek duży, później bez zmian,",
     "7" = "spadek,",
     "8" = "wzrost mały, później spadek duży,",
     Default = "b/d"
    )
  }
  trend <- function(code){
    if(substr(code, 2, 2) == 0){
      mes <- paste(mes, sprintf("wielkość tendencji 1%s.%s hPa.", substr(code, 2, 4), substr(code, 5, 5)))
    } else {
      mes <- paste(mes, sprintf("wielkość tendencji %s.%s hPa.", substr(code, 2, 4), substr(code, 5, 5)))
    }
  }
  mes <- paste("[5]Tendencja ciśnienia na poziomie stacji w ciągu 3 ostatnich godzin:",
               preassure(substr(code, 2, 2)),
               trend(code))
  message <<- paste(message, mes, sep=" ")
}
sixth_group <- function(code){
  mes = ""
  sum <- function(x){
    if((x>0) && (x<989)){
      sprintf("%s mm.", x)
    } else if(x==990){
      "Ślad."
    } else if((x>990) && (x<1000)){
      sprintf("0.%s mm.", substr(x, 3, 3))
    } else {
      "b/d."
    }
  }
  duration <- function(x){
    switch(x,
     "1" = "6h",
     "2" = "12h",
     "3" = "18h",
     "4" = "24h",
     "5" = "1h",
     "6" = "2h",
     "7" = "3h",
     "8" = "9h",
     "9" = "15h"
     )
  }
  mes <- paste("[6]Suma opadów:", sum(substr(code, 2, 4)))
  mes <- paste(mes, "Czas trwania okresu kończącego się w terminie obserwacji, za który podaje się wysokość opadu:", duration(substr(code, 5, 5)))
  message <<- paste(message, mes, sep=" ")
}
weather <- function(x){
  switch(x,
   "00" = "rozwój chmur nieznany",
   "01" = "chmury znikają lub stają się cieńsze",
   "02" = "stan nie nieba się nie zmienia",
   "03" = "chmury w stadium tworzenia się lub rozwoju",
   "04" = "widzialność zmniejszona przez dym",
   "05" = "zmętnienie",
   "06" = "pył w powietrzu",
   "07" = "pył lub piasek w powietrzu wznoszony przez wiatr",
   "08" = "silnie rozwinięte wiry pyłowe lub piaskowe na stacji lub w pobliżu",
   "09" = "wichura pyłowa lub piaskowa w zasięgu widzenia w czasie obserwacji lub na stacji w ciągu ostatniej godziny",
   "10" = "zamglenie",
   "11" = "cienka warstwa mgły lub mgły lodowej, w płatach",
   "12" = "cienka warstwa mgły lub mgły lodowej, ciągła",
   "13" = "widoczna błyskawica, nie słychać grzmotu",
   "14" = "opad w polu widzenia nie sięgający gruntu",
   "15" = "opad w polu widzenia sięgający gruntu, ponad 5 km od stacji",
   "16" = "opad w polu widzenia sięgający gruntu, w pobliżu stacji lecz nie na stacji",
   "17" = "burza bez opadu w czasie obserwacji",
   "18" = "nawałnica na stacji lub w polu widzenia w czasie obserwacji lub w ciągu ostatniej godziny",
   "19" = "trąba lądowa lub wodna na stacji lub w polu widzenia w czasie obserwacji lub w ciągu ostatniej godziny",
   "20" = "mżawka (nie marznąca) lub śnieg ziarnisty",
   "21" = "deszcz (nie marznący)",
   "22" = "śnieg",
   "23" = "deszcz ze śniegiem lub ziarna lodowe",
   "24" = "mżawka marznąca lub deszcz marznący",
   "25" = "przelotny deszcz",
   "26" = "przelotny śnieg lub przelotny deszcz ze śniegiem",
   "27" = "przelotny grad lub deszcz z gradem lub krupy śnieżne lub krupy lodowe",
   "28" = "mgła lub mgła lodowa",
   "29" = "burza bez opadu lub z opadem",
   "30" = "słaba lub umiarkowana wichura pyłowa lub piaskowa, słabnąca w ciągu ostatniej godziny",
   "31" = "słaba lub umiarkowana wichura pyłowa lub piaskowa, bez zmian w ciągu ostatniej godziny",
   "32" = "słaba lub umiarkowana wichura pyłowa lub piaskowa, zaczynająca się lub wzmagająca w ciągu ostatniej godziny",
   "33" = "silna wichura pyłowa lub piaskowa, słabnąca w ciągu ostatniej godziny",
   "34" = "silna wichura pyłowa lub piaskowa, bez zmian w ciągu ostatniej godziny",
   "35" = "silna wichura pyłowa lub piaskowa, zaczynająca się lub wzmagająca w ciągu ostatniej godziny",
   "36" = "słaba lub umiarkowana zamieć śnieżna niska",
   "37" = "silna zamieć śnieżna niska",
   "38" = "słaba lub umiarkowana zamieć śnieżna wysoka",
   "39" = "silna zamieć śnieżna wysoka",
   "40" = "mgła (mgła lodowa) w pewnej odległości od stacji w czasie obserwacji, sięgająca powyżej poziomu oczu, w ciągu ostatniej godziny mgły na stacji nie było",
   "41" = "mgła (mgła lodowa) w płatach",
   "42" = "mgła (mgła lodowa), niebo widoczne, staje się rzadsza",
   "43" = "mgła (mgła lodowa), niebo niewidoczne, staje się rzadsza",
   "44" = "mgła (mgła lodowa), niebo widoczne, bez zmian w ciągu ostatniej godziny",
   "45" = "mgła (mgła lodowa), niebo niewidoczne, bez zmian w ciągu ostatniej godziny",
   "46" = "mgła (mgła lodowa), niebo widoczne, gęstnieje",
   "47" = "mgła (mgła lodowa), niebo niewidoczne, gęstnieje",
   "48" = "mgła osadzająca szadź, niebo widoczne",
   "49" = "mgła osadzająca szadź, niebo niewidoczne",
   "50" = "słaba, niemarznąca mżawka z przerwami",
   "51" = "słaba, niemarznąca, ciągła mżawka",
   "52" = "umiarkowana, niemarznąca mżawka z przerwami",
   "53" = "umiarkowana, niemarznąca, ciągła mżawka",
   "54" = "intensywna, niemarznąca mżawka z przerwami",
   "55" = "intensywna, niemarznąca, ciągła mżawka",
   "56" = "słaba marznąca mżawka",
   "57" = "umiarkowana lub silna marznąca mżawka",
   "58" = "słaba mżawka z deszczem",
   "59" = "umiarkowana lub silna mżawka z deszczem",
   "60" = "niemarznący, słaby deszcz z przerwami",
   "61" = "niemarznący, słaby, ciągły",
   "62" = "niemarznący, umiarkowany deszcz z przerwami",
   "63" = "niemarznący, umiarkowany, ciągły deszcz",
   "64" = "niemarznący, silny deszcz z przerwami",
   "65" = "niemarznący, silny, ciągły deszcz",
   "66" = "słaby marznący deszcz",
   "67" = "umiarkowany lub silny marznący deszcz",
   "68" = "słaby deszcz ze śniegiem",
   "69" = "umiarkowany lub silny deszcz ze śniegiem",
   "70" = "słaby śnieg z przerwami",
   "71" = "słaby, ciągły śnieg",
   "72" = "umiarkowany śnieg z przerwami",
   "73" = "umiarkowany, ciągły śnieg",
   "74" = "silny śnieg z przerwami",
   "75" = "silny, ciągły śnieg",
   "76" = "pył diamentowy",
   "77" = "śnieg ziarnisty",
   "78" = "oddzielne gwiazdki śniegu",
   "79" = "ziarna lodowe",
   "80" = "słaby przelotny deszcz",
   "81" = "umiarkowany lub silny przelotny deszcz",
   "82" = "gwałtowny przelotny deszcz",
   "83" = "słaby przelotny deszcz ze śniegiem",
   "84" = "umiarkowany lub silny przelotny deszcz ze śniegiem",
   "85" = "słaby przelotny śnieg",
   "86" = "umiarkowany lub silny przelotny śnieg",
   "87" = "słabe przelotne krupy lodowe lub śnieżne",
   "88" = "umiarkowane lub silne, przelotne krupy lodowe lub śnieżne",
   "89" = "słaby przelotny grad",
   "90" = "umiarkowany lub silny przelotny grad",
   "91" = "burza w ciągu ostatniej godziny, w czasie obserwacji lekki deszcz",
   "92" = "burza w ciągu ostatniej godziny, w czasie obserwacji umiarkowany lub silny deszcz",
   "93" = "burza w ciągu ostatniej godziny, w czasie obserwacji lekki śnieg lub deszcz ze śniegiem",
   "94" = "burza w ciągu ostatniej godziny, w czasie obserwacji umiarkowany lub silny śnieg lub deszcz ze śniegiem",
   "95" = "słaba lub umiarkowana burza w czasie obserwacji",
   "96" = "słaba lub umiarkowana burza z gradem w czasie obserwacji",
   "97" = "silna burza",
   "98" = "silna burza z wichurą pyłową lub piaskową",
   "99" = "silna burza z gradem",
   Default = "b/d"
  )
}
seventh_group <- function(code){
  mes = ""
  mes <- paste(mes, "[7]Pogoda bieżąca:", weather(substr(code, 2, 3)))
  message <<- paste(message, mes, sep=" ")
}
thrid_first_group <- function(code){
  mes = "[3.1]Temperatura maksymalna za ostatnie 12 godzin:"
  if(substr(code, 2, 2) == 1){
    mes <- paste(mes, "-")
  }
  value = sprintf("%s%s.%s st.C.", substr(code, 3, 3), substr(code, 4,4), substr(code, 5, 5))
  mes <- paste(mes, value)
  message <<- paste(message, mes, sep=" ")
}
third_second_group <- function(code){
  mes = "[3.2]Temperatura minimalna za ostatnie 12 godzin:"
  if(substr(code, 2, 2) == 1){
    mes <- paste(mes, "-")
  }
  value = sprintf("%s%s.%s st.C.", substr(code, 3, 3), substr(code, 4,4), substr(code, 5, 5))
  mes <- paste(mes, value)
  message <<- paste(message, mes, sep=" ")
}
third_third_group <- function(code){
  mes = ""
  snow <- function(x){
    switch(x,
       "0" = "powierzchnia gruntu sucha",
       "1" = "powierzchnia gruntu wilgotna",
       "2" = "powierzchnia gruntu mokra (woda utrzymuje się na powierzchni i tworzy kałuże)",
       "3" = "grunt podtopiony (wszędzie rozlana woda)",
       "4" = "grunt zamarznięty",
       "5" = "gołoledź",
       "6" = "sypki i suchy pył lub piasek nie pokrywający powierzchni całkowicie",
       "7" = "cienka warstwa sypkiego i suchego pyłu lub piasku pokrywająca grunt całkowicie",
       "8" = "umiarkowana lub gruba warstwa sypkiego pyłu lub piasku pokrywająca grunt całkowicie",
       "9" = "powierzchnia gruntu bardzo sucha z licznymi pęknięciami"
       )
  }
  temperature <- function(x){
    sign = ""
    if(substr(code, 2, 2) == 1){
      sign <- "-"
    }
    value = sprintf("%s%s%s.%s st.C.", sign, substr(code, 3, 3), substr(code, 4,4), substr(code, 5, 5))
  }
  mes <- paste("[3.3]Stan powierzchni gruntu bez śniegu", snow(substr(code, 2, 2)))
  mes <- paste(mes, "minimalna temperatura 5 cm nad powierzchnią gruntu", temperature(substr(code, 3, 4)))
  message <<- paste(message, mes, sep=" ")
}
third_fourth_group <- function(code){
  mes = ""
  snow <- function(x){
    switch(x,
       "0" = "powierzchnia gruntu w większości pokryta lodem.",
       "1" = "zleżały lub mokry śnieg (z lodem lub bez) pokrywający mniej niż połowę gruntu.",
       "2" = "zleżały lub mokry śnieg (z lodem lub bez) pokrywający co najmniej połowę gruntu, lecz nie całkowicie.",
       "3" = "równa warstwa zleżałego lub mokrego śniegu (z lodem lub bez) pokrywająca grunt całkowicie.",
       "4" = "nierówna warstwa zleżałego lub mokrego śniegu (z lodem lub bez) pokrywająca grunt całkowicie.",
       "5" = "suchy i puszysty śnieg pokrywający mniej niż połowę powierzchni gruntu.",
       "6" = "suchy i puszysty śnieg pokrywający co najmniej połowę powierzchni gruntu lecz nie całkowicie.",
       "7" = "równa warstwa suchego i puszystego śniegu pokrywająca grunt całkowicie.",
       "8" = "nierówna warstwa suchego i puszystego śniegu pokrywająca grunt całkowicie.",
       "9" = "liczne wysokie zaspy śniegu pokrywające grunt całkowicie."
    )
  }
  snow_cap <- function(x){
    if((x>0) && (x<997)){
      sprintf("%s cm.", x)
    } else if(x == 997) {
      "mniej niż 0,5 cm."
    } else if(x == 998){
      "płaty."
    } else if(x == 999){
      "pomiar niemożliwy."
    }
  }
  mes <- paste("[3.4]Stan pokrywy śnieżnej:", snow(substr(code, 2, 2)))
  mes <- paste(mes, "Wysokść pokrywy śnieżnej:", snow_cap(substr(code, 3, 5)))
  message <<- paste(message, mes, sep=" ")
}
third_sixth_group <- function(code){
  mes = ""
  sum <- function(x){
    if((x>0) && (x<990)){
      sprintf("%s mm.", x)
    } else if(x == 990){
      "ślad."
    } else if((x>990) && (x<1000)){
      sprintf("0,%s mm.", substr(x, 3, 3))
    } else {
      "b/d."
    }
  }
  mes <- paste("[3.6]Suma opadu:", sum(substr(code, 2, 4)))
  message <<- paste(message, mes, sep=" ")
}
third_seventh_group <- function(code){
  mes = "[3.7]Suma opadu za 24 godziny kończące się w momencie obserwacji w dziesiątych częściach mm"
  mes <- paste(mes, sprintf("%s,%s mm", substr(code, 2, 4), substr(code, 5, 5)))
  message <<- paste(message, mes, sep=" ")
}
clouds_type <- function(x){
  switch(x,
   "0" = "Cirrus (Ci)",
   "1" = "Cirrocumulus (Cc)",
   "2" = "Cirrostratus (Cs)",
   "3" = "Altocumulus (Ac)",
   "4" = "Altostratus (As)",
   "5" = "Nimbostratus (Ns)",
   "6" = "Stratocumulus (Sc)",
   "7" = "Stratus (St)",
   "8" = "Cumulus (Cu)",
   "9" = "Cumulonimbus (Cb)",
   "/" = "chmury niewidoczne"
   )
}
third_eith_group <- function(code){
  mes = ""
  size <- function(x){
    if((x>0) && (x<9)){
      sprintf("%s/8", x)
    } else {
      "b/d."
    }
  }
  height <- function(x){
    if(as.integer(x) == 0){
      "< 30 m (< 100 stóp)."
    } else if((as.integer(x)>0) && (as.integer(x)<50)){
      sprintf("%s0 m (%s0 stóp).", as.integer(x)*(0.3), x)
    } else if((as.integer(x)>55) && (as.integer(x)<60)){
      sprintf("%s0 m. (%s0 stóp)", strtoi(substr(x, 2, 2))*(0.3), substr(x, 2, 2))
    } else if((as.integer(x)>80) && (as.integer(x)<90)){
      switch(x,
       "81" = "10500 m (35000 stóp).",
       "82" = "12000 m (40000 stóp).",
       "83" = "13500 m (4500 stóp).",
       "84" = "15000 m (5000 stóp).",
       "85" = "16500 m (5500 stóp).",
       "86" = "18000 m (6000 stóp).",
       "87" = "19500 m (6500 stóp).",
       "88" = "21000 m (70000 stóp).",
       "89" = "> 21000 m (> 70000 stóp)."
       )
    } else if((as.integer(x)>89)){
      switch(x,
       "90" = "0 do 49 m (0 - 166 stóp).",
       "91" = "50 do 99 m (167 - 333 stóp).",
       "92" = "100 do 199 m (334 - 666 stóp).",
       "93" = "200 do 299 m (667 - 999 stóp).",
       "94" = "300 do 599 m (1000 - 1999 stóp.)",
       "95" = "600 do 999 m (2000 - 3333 stóp).",
       "96" = "1000 do 1499 m (3334 - 4999 stóp).",
       "97" = "1500 do 1999 m (5000 - 6666 stóp).",
       "98" = "2000 do 2499 m (6667 - 8333 stóp).",
       "99" = "> 2500 m (> 8334 stóp)."
       )
    }
  }
  mes <- paste("[3.8]Wielkość zachmurzenia:", size(substr(code, 2, 2)))
  mes <- paste(mes, "Rodzaj chmur:", clouds_type(substr(code, 3, 3)))
  mes <- paste(mes, "Wysokość podstawy chmur:", height(substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_time_group <- function(code){
  mes = ""
  changing <- function(x){
    if(as.integer(x) == 0){
      "w czasie obserwacji."
    } else if((as.integer(x)>0) && (as.integer(x)<60)){
      sprintf("%s min.", as.integer(x)*6)
    } else if((as.integer(x)>60) && (as.integer(x)<100)){
      switch(x,
       "60" = "360 min = 4 h.",
       "61" = "6 do 7 h.",
       "62" = "7 do 8 h.",
       "63" = "8 do 9 h.",
       "64" = "9 do 10 h.",
       "65" = "10 do 11 h.",
       "66" = "11 do 12 h.",
       "67" = "12 do 18 h.",
       "68" = "powyżej 18 h.",
       "69" = "czas nieznany.",
       "70" = "początek w czasie obserwacji.",
       "71" = "koniec w czasie obserwacji.",
       "72" = "początek i koniec w czasie obserwacji.",
       "73" = "istotna zmiana w czasie obserwacji.",
       "74" = "początek po obserwacji.",
       "75" = "koniec po obserwacji.",
       "76" = "na stacji (w otoczeniu).",
       "77" = "nad stacją.",
       "78" = "we wszystkich kierunkach.",
       "79" = "we wszystkich kierunkach, lecz nie nad stacją.",
       "80" = "zbliżające się do stacji.",
       "81" = "oddalające się od stacji.",
       "82" = "przechodzące obok stacji w pewnej odległości.",
       "83" = "widziane w pewnej odległości.",
       "84" = "występujące w pobliżu, lecz nie na stacji.",
       "85" = "uniesione wysoko nad gruntem.",
       "86" = "w pobliżu gruntu.",
       "87" = "sporadyczne, sporadycznie.",
       "88" = "okresowe.",
       "89" = "częste (w częstych przedziałach).",
       "90" = "jednostajne; jednostajne w natężeniu; jednostajnie; bez zmian.",
       "91" = "wzrastające; wzrastające w natężeniu; wzrost.",
       "92" = "zmniejszające się; zmniejszające się w natężeniu; spadek.",
       "93" = "zmienne; zmieniające się.",
       "94" = "ciągłe; ciągle.",
       "95" = "bardzo słabe; znacznie poniżej normy; bardzo cienkie.",
       "96" = "słabe; poniżej normy; cienkie.",
       "97" = "średnie; w normie; średnia grubość; stopniowe.",
       "98" = "silne; groźne; grube; powyżej normy; wyraźne; nagłe.",
       "99" = "bardzo silne; zabijające; bardzo groźne; gęste; znacznie powyżej normy."
       )
    }
  }
  mes <- paste("[3.9.0]Zmienność położenia lub intensywność zjawiska", changing(substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_ending_group <- function(code){
  mes = ""
  mes <- paste("[3.9.1]Czas zakończenia zjawiska podanego pod ww w grupie 7:", sprintf("%s.", substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_starting_group <- function(code){
  mes = ""
  mes <- paste("[3.9.2]Czas rozpoczęcia zjawiska podanego w kolejnej grupie 9:", sprintf("%s.", substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_changing_group <- function(code){
  mes = ""
  mes <- paste("[3.9.3]Zmienność położenia lub intensywność zjawiska podanego w kolejnej grupie 9:", sprintf("%s.", substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_ending_next_group <- function(code){
  mes = ""
  mes <- paste("[3.9.4]Czas zakończenia zjawiska podanego w poprzedzającej grupie 9:", sprintf("%s.", substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_start_next_group <- function(code){
  mes = ""
  mes <- paste("[3.9.5]Czas wystąpienia zjawiska podanego w kolejnej grupie 9:", sprintf("%s.", substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_start_nine_group <- function(code){
  mes = ""
  mes <- paste("[3.9.6]Czas trwania zjawiska niejednostajnego lub czas rozpoczęcia zjawiska jednostajnego podanego w kolejnej grupie 9:", sprintf("%s.", substr(code, 4 ,5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_seventh_group <- function(code){
  mes= ""
  mes <- paste("[3.9.7]Czas trwania okresu odniesienia kończącego się w czasie obserwacji, dla zjawiska podawanego w kolejnej grupie 9:", sprintf("%s.", substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_ninth_group <- function(code){
  mes = ""
  duration <- function(x){
    switch(x,
     "1" = "mniej niż 1 h przed czasem obserwacji.",
     "2" = "1 do 2 h przed czasem obserwacji.",
     "3" = "2 do 3 h przed czasem obserwacji.",
     "4" = "3 do 4 h przed czasem obserwacji.",
     "5" = "4 do 5 h przed czasem obserwacji.",
     "6" = "5 do 6 h przed czasem obserwacji.",
     "7" = "6 do 12 h przed czasem obserwacji.",
     "8" = "> 12 h przed czasem obserwacji.",
     "9" = "nieznany."
     )
  }
  prec_duration <- function(x){
    switch(x,
     "0" = "krótszy niż 1 h.",
     "1" = "od 1 do 3 h.",
     "2" = "od 3 do 6 h.",
     "3" = "powyżej 6 h.",
     "4" = "krótszy niż 1 h.",
     "5" = "od 1 do 3 h.",
     "6" = "od 3 do 6 h.",
     "7" = "powyżej 6 h.",
     "9" = "czas trwania nieznany"
     )
  }
  mes <- paste("[3.9.9]Czas początku lub końca opadu kodowanego przez RRR:", duration(substr(code, 4, 4)))
  mes <- paste(mes, "Czas trwania i rodzaj w/w opadu:", prec_duration(substr(code, 5, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_tenth_group <- function(code){
  mes = ""
  mes <- paste("[3.9.10]Największy poryw wiatru w ciągu 10 minut poprzedzających obserwację:", substr(code, 4, 5))
  message <<- paste(message, mes, sep=" ")
}
ninth_eleven_group <- function(code){
  mes = ""
  mes <- paste("[3.9.11]Największy poryw wiatru:", substr(code, 4, 5))
  message <<- paste(message, mes, sep=" ")
}
ninth_twleve_group <- function(code){
  mes = ""
  mes <- paste("[3.9.12]Największa śr. prędk. wiatru:", substr(code, 4, 5))
  message <<- paste(message, mes, sep=" ")
}
ninth_wind_medium_group <- function(code){
  mes = ""
  mes <- paste("[3.9.13]Średnia prędkość wiatru:", substr(code, 4, 5))
  message <<- paste(message, mes, sep=" ")
}
ninth_wind_minimal_group <- function(code){
  mes = ""
  mes <- paste("[3.9.14]Najmniejsza śr. prędk. wiatru:", substr(code, 4 ,5))
  message <<- paste(message, mes, sep=" ")
}
ninth_wind_drection_group <- function(code){
  mes = ""
  mes <- paste("[3.9.15]Kierunek wiatru w dzięstkach stopni:", substr(code, 4, 5))
  message <<- paste(message, mes, sep=" ")
}
ninth_wind_right_group <- function(code){
  mes = ""
  mes <- paste("[3.9.16]Wyraźna prawoskrętna zmiana kierunku wiatru.")
  message <<- paste(message, mes, sep=" ")
}
ninth_wind_left_group <- function(code){
  mes = ""
  mes <- paste("[3.9.17]Wyraźna lewoskrętna zmiana kierunku wiatru.")
  message <<- paste(message, mes, sep=" ")
}
ninth_storm_group <- function(code){
  mes = ""
  storm_type <- function(x){
    switch(x,
     "0" = "cisza lub słaby wiatr przed nawałnicą.",
     "1" = "cisza lub słaby wiatr przed kolejnymi nawałnicami.",
     "2" = "wiatr porywisty przed nawałnicą.",
     "3" = "wiatr porywisty przed kolejnymi nawałnicami.",
     "4" = "nawałnica przed wiatrem porywistym.",
     "5" = "na ogół wiatr porywisty, między porywami nawałnice.",
     "6" = "nawałnica zbliża się do stacji.",
     "7" = "linia nawałnicy.",
     "8" = "nawałnica z nawiewanym lub przenoszonym pyłem lub piaskiem.",
     "9" = "linia nawałnicy z nawiewanym lub przenoszonym pyłem lub piaskiem."
     )
  }
  storm_direction <- function(x){
    switch(x,
     "0" = "występuje na stacji.",
     "1" = "NE.",
     "2" = "E.",
     "3" = "SE.",
     "4" = "S.",
     "5" = "SW.",
     "6" = "W.",
     "7" = "NW.",
     "8" = "N.",
     "9" = "ze wszystkich kierunków."
     )
  }
  mes <- paste("[3.9.18]Rodzaj nawałnicy:", storm_type(substr(code, 4, 4)))
  mes <- paste(mes, "Kierunek z którego nadchodzi zjawisko:", storm_direction(substr(code, 5, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_sea_twister_group <- function(code){
  mes = ""
  twister_type <- function(x){
    switch(x,
     "0" = "trąba(y) morska(ie) w odległości do 3 km od stacji.",
     "1" = "trąba(y) morska(ie) w odległości powyżej 3 km od stacji.",
     "2" = "trąba(y) lądowa(e) w odległości do 3 km od stacji.",
     "3" = "trąba(y) lądowa(e) w odległości powyżej 3 km od stacji.",
     "4" = "słabe wiry powietrzne.",
     "5" = "umiarkowane wiry powietrzne.",
     "6" = "silne wiry powietrzne.",
     "7" = "słabe wiry pyłowe.",
     "8" = "umiarkowane wiry pyłowe.",
     "9" = "silne wiry pyłowe."
     )
  }
  twister_direction <- function(x){
    switch(x,
     "0" = "występuje na stacji.",
     "1" = "NE.",
     "2" = "E.",
     "3" = "SE.",
     "4" = "S.",
     "5" = "SW.",
     "6" = "W.",
     "7" = "NW.",
     "8" = "N.",
     "9" = "ze wszystkich kierunków."
    )
  }
  mes <- paste("[3.9.19]Rodzaj zjawiska:", twister_type(substr(code, 4, 4)))
  mes <- paste(mes, "Kierunek z którego nadzodzi zjawisko:", twister_direction(substr(code, 5, 5)))
  message <<- paste(message, mes, sep=" ")
}
sea_state <- function(x){
  switch(x,
         "0" = "gładkie, wysokość fal: 0 m.",
         "1" = "zmarszczone, wysokość fal: 0 - 0,1 m.",
         "2" = "lekko sfalowane, wysokość fal: 0,1 - 0,5 m.",
         "3" = "sfalowane, wysokość fal: 0,5 - 1,25 m.",
         "4" = "rozkołysane, wysokość fal: 1,25 - 2,5 m.",
         "5" = "silnie rozkołysane, wysokość fal: 2,5 m - 4 m.",
         "6" = "wzburzone, wysokość fal: 4 m - 6 m.",
         "7" = "silnie wzburzone, wysokość fal: 6 m - 9 m.",
         "8" = "groźne, wysokość fal: 9 m - 14 m.",
         "9" = "rozszalałe (wyjątkowo groźne), wysokość fal: ponad 14 m."
  )
}
ninth_sea_group <- function(code){
  mes = ""
  beaufort <- function(code){
    switch(x,
     "0" = "0 stopni w skali Beauforta.",
     "1" = "1 stopień w skali Beauforta.",
     "2" = "2 stopnie w skali Beauforta.",
     "3" = "3 stopnie w skali Beauforta.",
     "4" = "4 stopnie w skali Beauforta.",
     "5" = "5 stopni w skali Beauforta.",
     "6" = "6 stopni w skali Beauforta.",
     "7" = "7 stopni w skali Beauforta.",
     "8" = "8 stopni w skali Beauforta.",
     "9" = "9 stopni w skali Beauforta."
     )
  }
  mes <- paste("[3.9.20]Stan otwartego morza:", sea_state(substr(code, 4, 4)))
  mes <- paste("Największa prędkość wiatru w stopniach Beauforta:", beaufort(substr(code, 5, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_sea_strong_group <- function(code){
  mes = ""
  beaufort <- function(code){
    sprintf("%s0 w skali Beauforta", substr(code, 2, 2))
  }
  mes <- paste("[3.9.21]Stan otwartego morza:", sea_state(substr(code, 4, 4)))
  mes <- paste(mes, "Największa prędkość wiatru w stopniach Beauforta:", beaufort(substr(code, 5, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_sea_water_group <- function(code){
  mes = ""
  sea_vis <- function(x){
    switch(x,
     "0" = "< 0,05 km.",
     "1" = "0,05 – 0,2 km.",
     "2" = "0,2 – 0,5 km.",
     "3" = "0,5 – 1,0 km.",
     "4" = "1,0 – 2,0 km.",
     "5" = "2,0 – 4,0 km.",
     "6" = "4,0 – 10,0 km.",
     "7" = "10,0 – 20,0 km.",
     "8" = "20,0 – 50,0 km.",
     "9" = "> 50 km."
     )
  }
  mes <- paste("[3.9.22]Stan powierzchni wodowiska dla hydroplanów:", sea_state(substr(code, 4, 4)))
  mes <- paste(mes, "Widzialność pozioma nad powierzchnią wodowiska dla hydroplanów:", sea_vis(substr(code, 5, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_water_group <- function(code){
  mes = ""
  mes <- paste("[3.9.23]Stan powierzchni wodowiska:", sea_state(substr(code, 4, 4)))
  mes <- paste("Stan otwartego morza:", sea_state(substr(code, 5, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_water_temp_group <- function(code){
  mes = ""
  value = sprintf("%s%s st.C.", substr(code, 4,4), substr(code, 5, 5))
  mes <- paste("[3.9.25]Temperatura wody w ośrodkach wypoczynkowych w sezonie kąpielowym w stopniach Celsjusza:", value)
  message <<- paste(message, mes, sep=" ")
}
ninth_frost <- function(code){
  mes = ""
  frost_type <- function(x){
    switch(x,
     "0" = "szron na powierzchniach poziomych.",
     "1" = "szron na powierzchniach poziomych i pionowych.",
     "2" = "opad zawierający piasek lub pył pochodzenia pustynnego.",
     "3" = "opad zawierający popiół pochodzenia wulkanicznego."
     )
  }
  intensive <- function(x){
    switch (x,
      "0" = "słabe.",
      "1" = "umiarkowane.",
      "2" = "silne."
    )
  }
  mes <- paste("[3.9.26]Szron i kolorowe opady:", frost_type(substr(code, 4, 4)))
  mes <- paste(mes, "Intensywność zjawiska:", intensive(substr(code, 5, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_snow_group <- function(code){
  mes = ""
  snow_type <- function(x){
    switch(x,
     "0" = "gołoledź.",
     "1" = "szadź miękka.",
     "2" = "szadź twarda.",
     "3" = "osad śniegu.",
     "4" = "śnieg mokry.",
     "5" = "śnieg mokry zamarzający.",
     "6" = "osad mieszany (gołoledź i szadź lub szadź i marznący mokry śnieg, itp.).",
     "7" = "przyziemny osad lodowy."
     )
  }
  snow_temp <- function(x){
    switch(x,
     "0" = "temperatura bez zmian.",
     "1" = "temperatura obniża się, lecz pozostaje powyżej 00C.",
     "2" = "temperatura wzrasta, lecz pozostaje poniżej 00C.",
     "3" = "temperatura obniża się do wartości poniżej 00C.",
     "4" = "temperatura wzrasta i przekroczyła 00C.",
     "5" = "wahania przekraczające 00C (zmiany temperatury nieregularne).",
     "6" = "wahania nie przekraczające 00C (zmiany temperatury nieregularne).",
     "7" = "zmiany temperatury nieobserwowane.",
     "8" = "nie stosuje się.",
     "9" = "zmiany temperatury nie znane z powodu braku termografu."
     )
  }
  mes <- paste("[3.9.27]Osady stałe (lodowe):", snow_type(substr(code, 4, 4)))
  mes <- paste("Zmiany temp. związane z wystąpieniem szadzi lub gołoledzi:", snow_temp(substr(code, 5, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_snow_two_group <- function(code){
  mes = ""
  snow_type <- function(x){
    switch(x,
     "0" = "śnieg świeży, puszysty.",
     "1" = "śnieg świeży, przewiany w zaspy.",
     "2" = "śnieg świeży, zwarty.",
     "3" = "śnieg stary, sypki.",
     "4" = "śnieg stary, zbity.",
     "5" = "śnieg stary, wilgotny.",
     "6" = "śnieg sypki ze zlodowaciałą powierzchnią.",
     "7" = "śnieg zbity ze zlodowaciałą powierzchnią.",
     "8" = "śnieg wilgotny ze zlodowaciałą powierzchnią."
     )
  }
  snow_cap <- function(x){
    switch(x,
     "0" = "gładka, bez zasp, grunt zamarznięty.",
     "1" = "gładka, bez zasp, grunt niezamarznięty.",
     "2" = "gładka, bez zasp, stan gruntu nieznany.",
     "3" = "sfalowana, małe zaspy, grunt zamarznięty.",
     "4" = "sfalowana, małe zaspy, grunt niezamarznięty   .",
     "5" = "sfalowana, małe zaspy, stan gruntu nieznany.",
     "6" = "nieregularna, głębokie zaspy, grunt zamarznięty.",
     "7" = "nieregularna, głębokie zaspy, grunt niezamarznięty.",
     "8" = "nieregularna, głębokie zaspy, stan gruntu nieznany."
     )
  }
  mes <- paste("[3.9.28]Gatunek śniegu:", snow_type(substr(code, 4, 4)))
  mes <- paste(mes, "Ukształtowanie pokrywy śnieżnej:", snow_cap(substr(code, 5, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_snow_storm <- function(code){
  mes = ""
  storm_type <- function(x){
    switch(x,
     "0" = "śnieżne zmętnienie.",
     "1" = "zamieć niska słaba lub umiarkowana z lub bez opadu śniegu.",
     "2" = "zamieć niska silna bez opadu śniegu.",
     "3" = "zamieć niska silna z opadem śniegu.",
     "4" = "zamieć wysoka słaba lub umiarkowana bez opadu śniegu.",
     "5" = "zamieć wysoka silna bez opadu śniegu.",
     "6" = "zamieć wysoka słaba lub umiarkowana z opadem śniegu.",
     "7" = "zamieć wysoka silna z opadem śniegu.",
     "8" = "zamieć wysoka słaba lub umiarkowana oraz zamieć niska.",
     "9" = "zamieć wysoka silna oraz zamieć niska."
     )
  }
  storm_state <- function(x){
    switch(x,
     "0" = "koniec zamieci przed terminem obserwacji.",
     "1" = "zamieć o zmniejszającej się intensywności.",
     "2" = "zamieć o stałej intensywności.",
     "3" = "zamieć o zwiększającej się intensywności.",
     "4" = "zamieć z przerwami krótszymi niż 30 minut.",
     "5" = "zamieć wysoka przeszła w zamieć niską.",
     "6" = "zamieć niska przeszła w zamieć wysoką.",
     "7" = "ponowny rozwój zamieci po przerwie trwającej minimum 30 minut."
     )
  }
  mes <- paste("[3.9.29]Rodzaj zamieci śnieżnej:", storm_type(substr(code, 4, 4)))
  mes <- paste(mes, "Rozwój zamieci śnieżnej:", strom_state(substr(code, 5, 5)))
  message <<- paste(message, mes, sep=" ")
}
prec_sum_mm <- function(x){
  if((as.integer(x)>0) && (as.integer(x)<56)){
    sprintf("%s mm.", as.integer(x))
  } else if((as.integer(x)>55) && (as.integer(x)<90)){
    sprintf("około %s mm.", (as.integer(x)-56)*11.5)
  } else if((as.integer(x)>90) && (as.integer(x)<97)){
    sprintf("%s mm.", substr(x, 2, 2))
  } else if(x == "97") {
    "< 0,1 mm."
  } else if(x == "98") {
    "> 400 mm."
  } else if(x == "99") {
    "pomiar niemożliwy lub niedokładny."
  } else {
    "b/d."
  }
}
ninth_prec_sum_group <- function(code){
  mes = ""
  mes <- paste("[3.9.30]Suma opadu. Wysokość opadu lub grubość osadu:", prec_sum_mm(substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_snow_fresh_group <- function(code){
  mes = ""
  prec_sum <- function(x){
    if((as.integer(x)>0) && (as.integer(x)<56)){
      sprintf("%s cm.", as.integer(x))
    } else if((as.integer(x)>55) && (as.integer(x)<90)){
      sprintf("około %s cm.", (as.integer(x)-56)*11.5)
    } else if((as.integer(x)>90) && (as.integer(x)<97)){
      sprintf("%s cm.", substr(x, 2, 2))
    } else if(x == "97") {
      "< 0,1 cm."
    } else if(x == "98") {
      "> 400 cm."
    } else if(x == "99") {
      "pomiar niemożliwy lub niedokładny."
    } else {
      "b/d."
    }
  }
  mes <- paste("[3.9.31]Wysokość świeżo spadłego śniegu:", prec_sum(substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_hail_group <- function(code){
  mes = ""
  mes <- paste("[3.9.32]Maksymalna średnica gradzin:", prec_sum_mm(substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_water_eq_group <- function(code){
  mes = ""
  mes <- paste("[3.9.33]Wodny ekwiwalent opadów stałych w czasie obserwacji:", prec_sum_mm(substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_glaze_group <- function(code){
  mes = ""
  mes <- paste("[3.9.34]Średnica narośniętej gołoledzi w czasie obserwacji:", prec_sum_mm(substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_frost_group <- function(code){
  mes = ""
  mes <- paste("[3.9.35]Średnica narośniętej szadzi w czasie obserwacji:", prec_sum_mm(substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_prec_mix_group <- function(code){
  mes = ""
  mes <- paste("[3.9.36]Średnica osadu mieszanego w czasie obserwacji:", prec_sum_mm(substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_snow_wet_group <- function(code){
  mes = ""
  mes <- paste("[3.9.37]Średnica osadu mokrego śniegu w czasie obserwacji:", prec_sum_mm(substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_glaze_speed_group <- function(code){
  mes = ""
  value = sprintf("%s mm/h.", substr(code, 4, 5))
  mes <- paste("[3.9.38]Prędkość narastania gołoledzi:", value)
  message <<- paste(message, mes, sep=" ")
}
ninth_measur_height_group <- function(code){
  mes = ""
  value = sprintf('%s m', substr(code, 4, 5))
  mes <- paste("[3.9.39]Wysokość nad powierzchnią gruntu, na jakiej jest mierzona średnica osadu w poprzednich grupach:")
  message <<- paste(message, mes, sep=" ")
}
cloud_progres <- function(x){
  switch(x,
   "0" = "bez zmian.",
   "1" = "skłębianie się chmur.",
   "2" = "powolne unoszenie się chmur.",
   "3" = "szybkie unoszenie się chmur.",
   "4" = "unoszenie się i uwarstwianie chmur.",
   "5" = "powolne obniżanie się chmur.",
   "6" = "szybkie obniżanie się chmur.",
   "7" = "uwarstwianie się chmur.",
   "8" = "uwarstwianie i obniżanie się chmur.",
   "9" = "szybkie zmiany."
  )
}
ninth_clouds_group <- function(code){
  mes = ""
  mes <- paste("[3.9.40]Rozwój chmur:", cloud_progres(substr(code, 5, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_cloud_direction_group <- function(code){
  mes = ""
  mes <- paste("[3.9.41]Rodzja chmur:", clouds_type(substr(code, 4, 4)))
  mes <- paste(mes, "Kierunek, z którego chmury nadciągają:", substr(code, 5, 5))
  message <<- paste(message, mes, sep=" ")
}
ninth_cloud_concentration_direction_group <- function(code){
  mes = ""
  mes <- paste("[3.9.42]Rodzja chmur:", clouds_type(substr(code, 4, 4)))
  mes <- paste(mes, "Kierunek maksymalnej koncentracji chmur:", substr(code, 5, 5))
  message <<- paste(message, mes, sep=" ")
}
ninth_cloud_low_direction_group <- function(code){
  mes = ""
  mes <- paste("[3.9.43]Rodzja chmur:", clouds_type(substr(code, 4, 4)))
  mes <- paste(mes, "Kierunek, z którego nadciągają chmury niskie:", substr(code, 5, 5))
  message <<- paste(message, mes, sep=" ")
}
ninth_cloud_low_concentration_direction_group <- function(code){
  mes = ""
  mes <- paste("[3.9.44]Rodzaj chmur:", clouds_type(substr(code, 4, 4)))
  mes <- paste(mes, "Kierunek maksymalnej koncentracji chmur niskich:", substr(code, 5, 5))
  message <<- paste(message, mes, sep=" ")
}
ninth_cloud_low_top_group <- function(code){
  mes = ""
  mes <- paste("[3.9.45]Wysokość wierzchołków chmur najniższych lub wysokość podstawy chmur najniższych lub pionowy zasięg mgły:")
  mes <- paste(mes, substr(code, 4, 5))
  message <<- paste(message, mes, sep=" ")
}
ninth_cloud_color_group <- function(code){
  mes = ""
  color <- function(x){
    switch(x,
     "1" = "słabe zabarwienie chmur o wschodzie Słońca.",
     "2" = "silnie czerwone zabarwienie chmur o wschodzie Słońca.",
     "3" = "słabe zabarwienie chmur o zachodzie Słońca.",
     "4" = "silnie czerwone zabarwienie chmur o zachodzie Słońca.",
     "5" = "zbieżność chmur CH w punkcie poniżej 45° tworzące się lub wzmagające.",
     "6" = "zbieżność chmur CH w punkcie powyżej 45° tworzące się lub wzmagające.",
     "7" = "zbieżność chmur CH w punkcie poniżej 45° zanikające lub słabnące.",
     "8" = "zbieżność chmur CH w punkcie powyżej 45° zanikające lub słabnące."
     )
  }
  mes <- paste("[3.9.46]Zabarwienie chmur i ich zbieżność:", color(substr(code, 4, 4)))
  mes <- paste(mes, "Kierunek:", substr(code, 5, 5))
  message <<- paste(message, mes, sep=" ")
}
ninth_cloud_angle_group <- function(code){
  mes = ""
  angle <- function(x){
    switch(x,
     "0" = "górna część chmur niewidoczna.",
     "1" = "45° i więcej.",
     "2" = "około 30°.",
     "3" = "około 20°.",
     "4" = "około 15°.",
     "5" = "około 12°.",
     "6" = "około 9°.",
     "7" = "około 7°.",
     "8" = "około 6°.",
     "9" = "mniej niż 5°."
     )
  }
  mes <- paste("[3.9.47]Rodzaj chmur", clouds_type(substr(code, 4, 4)))
  mes <- paste(mes, "Kąt wzniesienia wierzchołka chmur nad horyzontem", angle(substr(code, 5, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_cloud_orogaphic_group <- function(code){
  mes = ""
  type <- function(x){
    switch(x,
     "1" = "pojedyncze chmury orograficzne , pileus, incus, tworzące się.",
     "2" = "pojedyncze chmury orograficzne , pileus, incus, bez zmian.",
     "3" = "pojedyncze chmury orograficzne , pileus, incus, zanikające.",
     "4" = "nieregularne ławice chmur orograficznych, ławica fenowa itp., tworzące się.",
     "5" = "nieregularne ławice chmur orograficznych, ławica fenowa itp., bez zmian.",
     "6" = "nieregularne ławice chmur orograficznych, ławica fenowa itp., zanikające.",
     "7" = "zwarta warstwa chmur orograficznych, ławica fenowa, tworzące się.",
     "8" = "zwarta warstwa chmur orograficznych, ławica fenowa, bez zmian.",
     "9" = "zwarta warstwa chmur orograficznych, ławica fenowa, zanikające."
     )
  }
  mes <- paste("[3.9.48]Chmury orograficzne:", type(substr(code, 4, 4)))
  mes <- paste(mes, "Kierunek:", substr(code, 5, 5))
  message <<- paste(message, mes, sep=" ")
}
ninth_cloud_vertical_group <- function(code){
  mes = ""
  type <- function(x){
    switch(x,
     "0" = "pojedyncze Cumulus humilis i/lub Cumulus mediocris.",
     "1" = "liczne Cumulus humilis i/lub Cumulus mediocris.",
     "2" = "pojedyncze Cumulus congestus.",
     "3" = "liczne Cumulus congestus.",
     "4" = "pojedyncze Cumulonimbus .",
     "5" = "liczne Cumulonimbus.",
     "6" = "pojedyncze Cumulus i Cumulonimbus.",
     "7" = "liczne Cumulus i Cumulonimbus."
     )
    mes <- paste("[3.9.49]Charakter chmur o rozwoju pionowym:", type(substr(code, 4, 4)))
    mes <- paste(mes, "Kierunek:", substr(code, 5, 5))
  }
  message <<- paste(message, mes, sep=" ")
}
ninth_cloud_mountaians_group <- function(code){
  mes = ""
  type <- function(x){
    switch(x,
     "0" = "góry całkowicie odsłonięte, występują tylko pojedyncze chmury.",
     "1" = "góry częściowo zasłonięte porozrzucanymi chmurami, co najmniej połowa wszystkich szczytów jest niewidoczna.",
     "2" = "zbocza gór całkowicie zasłonięte chmurami, szczyty i przełęcze odsłonięte.",
     "3" = "góry odsłonięte od strony obserwatora, jednak widoczna jest po przeciwnej stronie ciągła ściana chmur.",
     "4" = "chmury zalegają nisko nad górami, lecz wszystkie stoki i szczyty gór odsłonięte (mogą występować tylko pojedyncze chmury na zboczach).",
     "5" = "chmury zalegają nisko nad górami, szczyty częściowo przesłonięte przez chmury lub smugi opadów.",
     "6" = "wszystkie szczyty zasłonięte lecz przełęcze wolne od chmur, zbocza gór zasłonięte lub odsłonięte.",
     "7" = "góry przeważnie zasłonięte przez chmury, jednak niektóre szczyty wolne od chmur, zbocza gór zasłonięte lub odsłonięte.",
     "8" = "wszystkie zbocza, szczyty i przełęcze zasłonięte przez chmury.",
     "9" = "góry niewidoczne z powodu ciemności, mgły, opadu itp."
     )
  }
  mes <- paste("[3.9.50]Stan zachmurzenia w górach i na przełęczach:", type(substr(code, 4, 4)))
  mes <- paste(mes, "Rozwój chmur:", cloud_progres(substr(code, 5, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_fog_group <- function(code){
  mes = ""
  type <- function(x){
    switch(x,
     "0" = "brak chmur i zamglenia.",
     "1" = "zamglenie, nad nim pogodnie.",
     "2" = "płaty mgły.",
     "3" = "warstwa rzadkiej mgły.",
     "4" = "warstwa gęstej mgły.",
     "5" = "kilka odosobnionych chmur.",
     "6" = "odosobnione chmury, poniżej mgła.",
     "7" = "liczne odosobnione chmury.",
     "8" = "morze chmur.",
     "9" = "zła widzialność uniemożliwiająca obserwację ku dolinom."
     )
  }
  progres <- function(x){
    switch(x,
     "0" = "bez zmian.",
     "1" = "zachmurzenie malejące, chmury unoszą się.",
     "2" = "zachmurzenie malejące, wysokość chmur bez zmian.",
     "3" = "zachmurzenie bez zmian, chmury unoszą się.",
     "4" = "zachmurzenie maleje, chmury opadają.",
     "5" = "zachmurzenie wzrasta, chmury unoszą się.",
     "6" = "zachmurzenie bez zmian, chmury opadają.",
     "7" = "zachmurzenie wzrasta, wysokość chmur bez zmian.",
     "8" = "zachmurzenie wzrasta, chmury opadają.",
     "9" = "mgła z przerwami na stacji."
     )
  }
  mes <- paste("[3.9.51]Stan zachmurzenia i mgły poniżej stacji:", type(substr(code, 4, 4)))
  mes <- paste(mes, "rozwój chmur:", progres(substr(code, 5, 5)))
  message <<- paste(message, mes, sep=" ")
}
cloud_direct <- function(x){
  switch(x,
   "1" = "bardzo nisko nad horyzontem.",
   "3" = "poniżej 30 stopni nad horyzontem.",
   "7" = "powyżej 30 stopni nad horyzontem."
  )
}
ninth_cloud_max_concentration_group <- function(code){
  mes = ""
  mes <- paste("[3.9.58]Wzniesienie nad horyzontem podstawy kowadła Cb lub wierzchołka innej chmury:", cloud_direct(substr(code, 4, 4)))
  mes <- paste(mes, "Kierunek:", substr(code, 5, 5))
  message <<- paste(message, mes, sep=" ")
}
ninth_cloud_speed_group <- function(code){
  mes = ""
  speed <- function(x){
    switch(x,
     "0" = "< 5 węzłów         < 9 km/h           < 2 m/s.",
     "1" = "5 do 14 węzłów     10 do 25 km/h      3 do 7 m/s.",
     "2" = "15 do 24 węzłów    26 do 44 km/h      8 do 12 m/s.",
     "3" = "25 do 34 węzłów    45 do 62 km/h      13 do 17 m/s.",
     "4" = "35 do 44 węzłów    63 do 81 km/h      18 do 22 m/s.",
     "5" = "45 do 54 węzłów    82 do 100 km/h     23 do 27 m/s.",
     "6" = "55 do 64 węzłów    101 do 118 km/h    28 do 32 m/s.",
     "7" = "65 do 74 węzłów    119 do 137 km/h    33 do 38 m/s.",
     "8" = "75 do 84 węzłów    138 do 155 km/h    39 do 43 m/s.",
     "9" = "> 85 węzłów        > 156 km/h         > 44 m/s."
     )
  }
  mes <- paste("[3.9.59]Prędkość przemieszczania się obiektu/zjawiska:", speed(substr(code, 4, 4)))
  mes <- paste(mes, "kierunek:", substr(code, 5, 5))
  message <<- paste(message, mes, sep=" ")
}
ninth_adding_weather_group <- function(code){
  mes = ""
  situation <- function(x){
    switch(x,
     "04" = "popiół wulkaniczny zawieszony wysoko w powietrzu.",
     "06" = "gęste zmętnienie pyłowe, widzialność < 1 km.",
     "07" = "pył wodny na stacji.",
     "08" = "wichura pyłowa (piaskowa).",
     "09" = "ściana pyłu lub piasku w pewnej odległości od stacji.",
     "10" = "śnieżne zmętnienie.",
     "11" = "jednolita biel (granica między chmurami a pokrywą śnieżną nie do odróżnienia).",
     "13" = "błyskawica z chmury do ziemi.",
     "17" = "burza bez opadu.",
     "19" = "trąba lądowa w polu widzenia w ostatniej godzinie lub w czasie obserwacji.",
     "20" = "osad popiołu wulkanicznego.",
     "21" = "osad pyłu lub piasku.",
     "22" = "rosa.",
     "23" = "osad mokrego śniegu.",
     "24" = "szadź miękka.",
     "25" = "szadź twarda.",
     "26" = "szron.",
     "27" = "gołoledź   .",
     "28" = "skorupa lodowa (lód szklisty).",
     "30" = "wichura pyłowa lub piaskowa w temperaturze < 0 st. C.",
     "39" = "zamieć wysoka, niemożliwe do określenia czy pada śnieg.",
     "41" = "mgła na morzu.",
     "42" = "mgła w dolinach.",
     "43" = "arktyczny lub antarktyczny dym na morzu.",
     "44" = "mgła z pary (nad morzem, jeziorem, rzeką).",
     "45" = "mgła z pary (nad lądem).",
     "46" = "mgła nad lodem lub pokrywą śnieżną.",
     "47" = "gęsta mgła, widzialność od 60 do 90 m.",
     "48" = "gęsta mgła, widzialność od 30 do 60 m.",
     "49" = "gęsta mgła, widzialność poniżej 30 m.",
     "50" = "mżawka, intensywność opadu: poniżej 0,1 mm/h.",
     "51" = "mżawka, intensywność opadu: 0,1 do 0,19 mm/h.",
     "52" = "mżawka, intensywność opadu: 0,2 do 0,39 mm/h.",
     "53" = "mżawka, intensywność opadu: 0,4 do 0,79 mm/h.",
     "54" = "mżawka, intensywność opadu: 0,8 do 1,59 mm/h.",
     "55" = "mżawka, intensywność opadu: 1,6 do 3,19 mm/h.",
     "56" = "mżawka, intensywność opadu: 3,2 do 6,39 mm/h.",
     "57" = "mżawka, intensywność opadu: powyżej 6,4 mm/h.",
     "59" = "mżawka ze śniegiem (ww = 68 lub 69).",
     "60" = "deszcz, intensywność opadu: poniżej 1,0 mm/h.",
     "61" = "deszcz, intensywność opadu: 1,0 do 1,9 mm/h.",
     "62" = "deszcz, intensywność opadu: 2,0 do 3,9 mm/h.",
     "63" = "deszcz, intensywność opadu: 4,0 do 7,9 mm/h.",
     "64" = "deszcz, intensywność opadu: 8,0 do 15,9 mm/h.",
     "65" = "deszcz, intensywność opadu: 16,0 do 31,9 mm/h.",
     "66" = "deszcz, intensywność opadu: 32,0 do 63,9 mm/h.",
     "67" = "deszcz, intensywność opadu: powyżej 64,0 mm/h.",
     "70" = "śnieg, intensywność opadu: poniżej 1,0 cm/h.",
     "71" = "śnieg, intensywność opadu: 1,0 do 1,9 cm/h.",
     "72" = "śnieg, intensywność opadu: 2,0 do 3,9 cm/h.",
     "73" = "śnieg, intensywność opadu: 4,0 do 7,9 cm/h.",
     "74" = "śnieg, intensywność opadu: 8,0 do 15,9 cm/h.",
     "75" = "śnieg, intensywność opadu: 16,0 do 31,9 cm/h.",
     "76" = "śnieg, intensywność opadu: 32,0 do 63,9 cm/h.",
     "77" = "śnieg, intensywność opadu: powyżej 64,0 cm/h.",
     "78" = "opad śniegu lub kryształków lodu z bezchmurnego nieba.",
     "79" = "mokry śnieg zamarzający przy zetknięciu z powierzchnią.",
     "80" = "opad deszczu (ww = 87-99).",
     "81" = "opad marznącego deszczu (ww = 80-82).",
     "82" = "opad deszczu ze śniegiem ww = 26-27.",
     "83" = "opad śniegu ww = 26-27.",
     "84" = "opad krupy śnieżnej lub lodowej ww = 26-27.",
     "85" = "opad krupy śnieżnej lub lodowej z deszczem ww = 26-27.",
     "86" = "opad krupy śnieżnej lub lodowej i deszczem ze śniegiem ww = 68 lub 69.",
     "87" = "opad krupy śnieżnej lub lodowej ze śniegiem ww = 87-99.",
     "88" = "opad gradu ww = 87-99.",
     "89" = "opad gradu z deszczem ww = 87-99.",
     "90" = "opad gradu i deszczu ze śniegiem ww = 87-99.",
     "91" = "opad gradu ze śniegiem ww = 87-99.",
     "92" = "przelotny opad lub burza nad morzem.",
     "93" = "przelotny opad lub burza nad górami."
     )
  }
  mes <- paste("[3.9.61]Zjawisko pogody bieżącej obserwowane jednocześnie:", situation(substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_intensivity_last_hour_group <- function(code){
  mes = ""
  mes <- paste("[3.9.62]Intensyfikacja zjawiska w czasie poprzedniej godziny, lecz nie w czasie obserwacji:", weather(substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_intensivity_last_hour_two_group <- function(code){
  mes = ""
  mes <- paste("[3.9.63]Intensyfikacja zjawiska w czasie poprzedniej godziny, lecz nie w czasie obserwacji:", weather(substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_intesivity_one_group <- function(code){
  mes = ""
  mes <- paste("[3.9.64]Intensyfikacja zjawiska:", weather(substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_intensivity_two_group <- function(code){
  mes = ""
  mes <- paste("[3.9.65]Intensyfikacja zjawiska:", weather(substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_six_six_group <- function(code){
  mes = ""
  mes <- paste("[3.9.66]Zjawisko wystąpiło w czasie lub okresie określonym przed odpowiednie grupy czasowe:", weather(substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_six_seven_group <- function(code){
  mes = ""
  mes <- paste("[3.9.67]Zjawisko wystąpiło w czasie lub okresie określonym przed odpowiednie grupy czasowe:", weather(substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_six_nine_six_group <- function(code){
  mes = ""
  mes <- paste("[3.9.69]Deszcz/Śnieg/Opad przelotny na stacji nie związany z burzą w odległą, kierunek:", substr(code, 5, 5))
  message <<- paste(message, mes, sep=" ")
}
ninth_seven_group <- function(code){
  mes = ""
  mes <- paste("[3.9.70]Kierunek maksymalnej koncentracji zjawiska podanego pod:", cloud_direct(substr(code, 4, 4)))
  mes <- paste(mes, "kierunek:", substr(code, 5, 5))
  message <<- paste(message, mes, sep=" ")
}
ninth_seven_five_group <- function(code){
  mes = ""
  mes <- paste("[3.9.75]Prędkość, z którego napływa zjawisko:", substr(code, 4, 4))
  mes <- paste(mes, "kierunek:", substr(code, 5, 5))
  message <<- paste(message, mes, sep=" ")
}
ninth_eight_one_group <- function(code){
  mes = ""
  mes <- paste("[3.9.81]Widzialność w kierunku NE:", visibility_horizontal(substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_eigth_two_group <- function(code){
  mes = ""
  mes <- paste("[3.9.82]Widzialność w kierunku E:", visibility_horizontal(substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_eigth_three_group <- function(code){
  mes = ""
  mes <- paste("[3.9.83]Widzialność w kierunku SE:", visibility_horizontal(substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_eight_four_group <- function(code){
  mes = ""
  mes <- paste("[3.9.83]Widzialność w kierunku S:", visibility_horizontal(substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_eight_five_group <- function(code){
  mes = ""
  mes <- paste("[3.9.85]Widzialność w kierunku SW:", visibility_horizontal(substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_eight_six_group <- function(code){
  mes = ""
  mes <- paste("[3.9.86]Widzialność w kierunku W:", visibility_horizontal(substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_eight_seven_group <- function(code){
  mes = ""
  mes <- paste("[3.9.87]Widzialność w kierunku NW:", visibility_horizontal(substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_eight_eigth_group <- function(code){
  mes = ""
  mes <- paste("[3.9.88]Widzialność w kierunku N:", visibility_horizontal(substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_eight_nine_group <- function(code){
  mes = ""
  visibility <- function(x){
    switch(x,
     "0" = "widzialność bez zmian (Słońce, Księżyc lub gwiazdy przeświecają przez mgłę).",
     "1" = "widzialność bez zmian (Słońce, Księżyc lub gwiazdy nie przeświecają przez mgłę).",
     "2" = "widzialność wzrosła (Słońce, Księżyc lub gwiazdy przeświecają przez mgłę).",
     "3" = "widzialność wzrosła (Słońce, Księżyc lub gwiazdy nie przeświecają przez mgłę).",
     "4" = "widzialność spadła (Słońce, Księżyc lub gwiazdy przeświecają przez mgłę).",
     "5" = "widzialność spadła (Słońce, Księżyc lub gwiazdy nie przeświecają przez mgłę).",
     "6" = "napływ mgły z kierunku podanego pod Da.",
     "7" = "mgła się uniosła nie rozrywając się.",
     "8" = "mgła porozrywała się.",
     "9" = "przemieszczanie się ławic z mgły."
     )
  }
  mes <- paste("[3.9.89]Zmiana widzialności w ciągu godziny poprzedzającej obserwację:", visibility(substr(code, 4, 4)))
  message <<- paste(message, mes, sep=" ")
}
ninth_nine_zero_group <- function(code){
  mes = ""
  situation <- function(x){
    switch(x,
     "0" = "widmo Brockenu.",
     "1" = "tęcza.",
     "2" = "halo słoneczne lub księżycowe.",
     "3" = "słońca poboczne lub przeciwsłońce.",
     "4" = "słupy słoneczne.",
     "5" = "wieniec.",
     "6" = "zorza (poświata widziana w kierunku słońca przed jego wschodem i po zachodzie).",
     "7" = "zorza na górach.",
     "8" = "miraż.",
     "9" = "światło zodiakalne."
     )
  }
  mes <- paste("[3.9.90]Zjawiska optyczne:", situation(substr(code, 4, 4)))
  message <<- paste(message, mes, sep=" ")
}
ninth_nine_one_group <- function(code){
  mes = ""
  mirage <- function(x){
    switch(x,
     "0" = "bez określenia.",
     "1" = "uniesiony obraz odległego obiektu.",
     "2" = "wyraźnie uniesiony obraz odległego obiektu.",
     "3" = "odwrócony obraz odległego obiektu.",
     "4" = "złożone, zwielokrotnione obrazy odległego obiektu (obrazy nieodwrócone).",
     "5" = "złożone, zwielokrotnione obrazy odległego obiektu (niektóre obrazy odwrócone).",
     "6" = "wyraźne zniekształcenie słońca lub księżyca.",
     "7" = "słońce widoczne, choć astronomicznie znajduje się poniżej horyzontu.",
     "8" = "księżyc widoczny, choć astronomicznie znajduje się poniżej horyzontu.",
     "9" = "ognie Świętego Elma."
     )
  }
  mes <- paste("[3.9.91]Miraż:", mirage(substr(code, 4, 4)))
  message <<- paste(message, mes, sep=" ")
}
ninth_nine_two_group <- function(code){
  mes = ""
  smudge <- function(x){
    switch(x,
     "5" = "nie utrzymujące się smugi kondensacyjne.",
     "6" = "smugi kondensacyjne utrzymujące się, pokrywają mniej niż 1/8 nieba.",
     "7" = "smugi kondensacyjne utrzymujące się, pokrywają mniej niż 2/8 nieba.",
     "8" = "smugi kondensacyjne utrzymujące się, pokrywają mniej niż 3/8 nieba.",
     "9" = "smugi kondensacyjne utrzymujące się, pokrywają więcej niż 3/8 nieba."
     )
  }
  mes <- paste("[3.9.92]Smugi kondensacyjne:", smudge(substr(code, 4, 4)))
  message <<- paste(message, mes, sep=" ")
}
ninth_nine_three_group <- function(code){
  mes = ""
  clouds <- function(x){
    switch(x,
     "1" = "obłoki iryzujące.",
     "2" = "nocne obłoki świecące.",
     "3" = "chmury pochodzące z wodospadów.",
     "4" = "chmury pochodzące z pożarów.",
     "5" = "chmury pochodzące z wybuchów wulkanów."
     )
  }
  mes <- paste("[3.9.93]Chmury specjalne:", clouds(substr(code, 4, 4)))
  message <<- paste(message, mes, sep=" ")
}
ninth_nine_four_group <- function(code){
  mes = ""
  dark <- function(x){
    switch(x,
     "0" = "dzień ciemny.",
     "1" = "dzień bardzo ciemny.",
     "2" = "zupełnie ciemno."
     )
  }
  mes <- paste("[3.9.94]Ciemność w ciągu dnia:", dark(substr(code, 4, 4)))
  message <<- paste(message, mes, sep=" ")
}
ninth_nine_five <- function(code){
  mes = ""
  mes <- paste("[3.9.95]Najniższa wartość ciśnienia atmosferycznego zredukowana do poziomu morza:", substr(code, 4, 5))
  message <<- paste(message, mes, sep=" ")
}
ninth_nine_six <- function(code){
  mes = ""
  mes <- paste("[3.9.96]Nagły wzrost temperatury powietrza:", sprintf("%s st.C", substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_nine_seven <- function(code){
  mes = ""
  mes <- paste("[3.9.97]Nagły spadek temperatury powietrza:", sprintf("%s st.C", substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_nine_eigth <- function(code){
  mes = ""
  mes <- paste("[3.9.98]Nagły wzrost wilgotności względnej powietrza:", sprintf("%s", substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_nine_nine <- function(code){
  mes = ""
  mes <- paste("[3.9.99]Nagły spadek wilgotności względnej powietrza:", sprintf("%s", substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
ninth_group <- function(code){
  prefix = substr(code, 2, 3)
  switch(prefix,
   "00" = ninth_time_group(code),
   "01" = ninth_ending_group(code),
   "02" = ninth_starting_group(code),
   "03" = ninth_changing_group(code),
   "04" = ninth_ending_next_group(code),
   "05" = ninth_start_next_group(code),
   "06" = ninth_start_nine_group(code),
   "07" = ninth_seventh_group(code),
   "09" = ninth_ninth_group(code),
   "10" = ninth_tenth_group(code),
   "11" = ninth_eleven_group(code),
   "12" = ninth_twleve_group(code),
   "13" = ninth_wind_medium_group(code),
   "14" = ninth_wind_minimal_group(code),
   "15" = ninth_wind_drection_group(code),
   "16" = ninth_wind_right_group(code),
   "17" = ninth_wind_left_group(code),
   "18" = ninth_storm_group(code),
   "19" = ninth_sea_twister_group(code),
   "20" = ninth_sea_group(code),
   "21" = ninth_sea_strong_group(code),
   "22" = ninth_sea_water_group(code),
   "23" = ninth_water_group(code),
   "25" = ninth_water_temp_group(code),
   "26" = ninth_frost(code),
   "27" = ninth_snow_group(code),
   "28" = ninth_snow_two_group(code),
   "29" = ninth_snow_storm(code),
   "30" = ninth_prec_sum_group(code),
   "31" = ninth_snow_fresh_group(code),
   "32" = ninth_hail_group(code),
   "33" = ninth_water_eq_group(code),
   "34" = ninth_glaze_group(code),
   "35" = ninth_frost_group(code),
   "36" = ninth_prec_mix_group(code),
   "37" = ninth_snow_wet_group(code),
   "38" = ninth_glaze_speed_group(code),
   "39" = ninth_measur_height_group(code),
   "40" = ninth_clouds_group(code),
   "41" = ninth_cloud_direction_group(code),
   "42" = ninth_cloud_concentration_direction_group(code),
   "43" = ninth_cloud_low_direction_group(code),
   "44" = ninth_cloud_low_concentration_direction_group(code),
   "45" = ninth_cloud_low_top_group(code),
   "46" = ninth_cloud_color_group(code),
   "47" = ninth_cloud_angle_group(code),
   "48" = ninth_cloud_orogaphic_group(code),
   "49" = ninth_cloud_vertical_group(code),
   "50" = ninth_cloud_mountaians_group(code),
   "51" = ninth_fog_group(code),
   "58" = ninth_cloud_max_concentration_group(code),
   "59" = ninth_cloud_speed_group(code),
   "61" = ninth_adding_weather_group(code),
   "62" = ninth_intensivity_last_hour_group(code),
   "63" = ninth_intensivity_last_hour_two_group(code),
   "64" = ninth_intesivity_one_group(code),
   "65" = ninth_intensivity_two_group(code),
   "66" = ninth_six_six_group(code),
   "67" = ninth_six_seven_group(code),
   "69" = ninth_six_nine_six_group(code),
   "70" = ninth_seven_group(code),
   "71" = ninth_seven_group(code),
   "72" = ninth_seven_group(code),
   "73" = ninth_seven_group(code),
   "74" = ninth_seven_group(code),
   "75" = ninth_seven_five_group(code),
   "76" = ninth_seven_five_group(code),
   "77" = ninth_seven_five_group(code),
   "78" = ninth_seven_five_group(code),
   "79" = ninth_seven_five_group(code),
   "81" = ninth_eight_one_group(code),
   "82" = ninth_eigth_two_group(code),
   "83" = ninth_eigth_three_group(code),
   "84" = ninth_eigth_four_group(code),
   "85" = ninth_eight_five_group(code),
   "86" = ninth_eight_six_group(code),
   "87" = ninth_eight_seven_group(code),
   "88" = ninth_eight_eigth_group(code),
   "89" = ninth_eight_nine_group(code),
   "90" = ninth_nine_zero_group(code),
   "91" = ninth_nine_one_group(code),
   "92" = ninth_nine_two_group(code),
   "93" = ninth_nine_three_group(code),
   "94" = ninth_nine_four_group(code),
   "95" = ninth_nine_five(code),
   "96" = ninth_nine_six(code),
   "97" = ninth_nine_seven(code),
   "98" = ninth_nine_eight(code),
   "99" = ninth_nine_nine(code)
   )
}
fifth_five_seven_group <- function(code){
  mes = ""
  mes <- paste("[5.5.7]Niedosyt wilgotności powietrza podawany z dokładnością do 0,1 hPa:", substr(code, 3, 5))
  message <<- paste(message, mes, sep=" ")
}
fifth_five_five_group <- function(code){
  mes = ""
  mes <- paste("[5.5.5]Średni niedosyt wilgotności powietrza:", substr(code, 3, 5))
  message <<- paste(message, mes, sep=" ")
}
fifth_five_group <- function(code){
  if(substr(code, 1, 2) == "55"){
    fifth_five_five_group(code)
  } else if(substr(code, 1, 2) == "57"){
    fifth_five_seven_group(code)
  }
}
fifth_six_temperature_group <- function(code){
  mes = ""
  sign = ""
  if(substr(code, 2, 2) == "1"){
    sign = "-"
  }
  value = sprintf("%s.%s", substr(code, 3, 4), substr(code, 5, 5))
  mes <- paste("[5.6]Średnia temperatura dobowa z dnia bieżącego:", sign, value)
  message <<- paste(message, mes, sep=" ")
}
fifth_six_wind_group <- function(code){
  mes = ""
  mes <- paste("[5.6]Średnia prędkość wiatru:", substr(code, 2, 3))
  mes <- paste(mes, "wilgotność względna powietrza w procentach:", substr(code, 4, 5))
  message <<- paste(message, mes, sep=" ")
}
fifth_six_group <- function(code){
  if((substr(code, 2, 2) == "1") || (substr(code, 2, 2) == "0")){
    fifth_six_temperature_group(code)
  } else {
    fifth_six_wind_group(code)
  }
}
fifth_seven_snow_group <- function(code){
  mes = ""
  mes <- paste("[5.7]Zapas wody w śniegu:", substr(code, 2, 5))
  message <<- paste(message, mes, sep=" ")
}
fifth_seven_temperature <- function(code){
  mes = ""
  sign = ""
  if(substr(code, 2, 2) == "1"){
    sign = "-"
  }
  value = sprintf("%s.%s", substr(code, 3, 4), substr(code, 5, 5))
  mes <- paste("[5.7]Absolutne maksimum temperatury powietrza:", sign, value)
  message <<- paste(message, mes, sep=" ")
}
fifth_seven_group <- function(code){
  if((substr(code, 2, 2) == "1") || (substr(code, 2, 2) == "0")){
    fifth_seven_temperature(code)
  } else {
    fifth_seven_snow_group(code)
  }
}
fifth_eight_group <- function(code){
  mes = ""
  snow_type <- function(x){
    switch(x,
     "1" = "śnieg puszysty, świeży.",
     "2" = "śnieg krupiasty, sypki, powstały z opadu krupy, drobnych ziaren śniegu, gradu itp..",
     "3" = "śnieg zsiadły lub przewiany (suchy).",
     "4" = "śnieg zbity, suchy (deska śnieżna, gips), często tylko miejscami.",
     "5" = "śnieg mokry (lepki).",
     "6" = "śnieg o powierzchni zlodowaciałej, łamliwej (szreń).",
     "7" = "śnieg o powierzchni zlodowaciałej, niełamliwej (lodoszreń).",
     "8" = "pokrywa śnieżna ziarnista (duże, twarde kryształy powstałe na skutek rekrystalizacji).",
     "9" = "warstwa szadzi o grubości ponad 2 cm na śniegu lub gruncie."
     )
  }
  snow_form <- function(x){
    switch(x,
     "1" = "powierzchnia gładka (nie zachodzi przypadek e3 = 2 lub 3).",
     "2" = "powierzchnia gładka: warstwa suchego śniegu na szreni lub lodoszreni nie grubsza niż 2 cm).",
     "3" = "powierzchnia gładka lub sfalowana: pokrywa śnieżna pod względem gatunku niejednorodna.",
     "4" = "powierzchnia lekko sfalowana lub pomarszczona (nie zachodzi przypadek e3 = 5, 6 lub 7).",
     "5" = "powierzchnia lekko sfalowana lub pomarszczona: warstwa suchego śniegu na szreni lub lodoszreni nie grubsza niż 2 cm).",
     "6" = "powierzchnia lekko sfalowana lub pomarszczona: ostre twarde formy śnieżne wystające ponad powierzchnię.",
     "7" = "powierzchnia lekko sfalowana lub pomarszczona: wystające kamienie lub korzenie.",
     "8" = "powierzchnia nieregularna z zaspami: występuje tylko jeden gatunek śniegu.",
     "9" = "powierzchnia nieregularna z zaspami: między zaspami płytko leżące lub wystające kamienie, korzenie lub ostre formy lodowe: mogą występować różne gatunki śniegu."
     )
  }
  mes <- paste("[5.8]Grubość świeżo spadłego śniegu lub narośniętej szadzi w cm:", substr(code, 2, 3))
  mes <- paste(mes, "gatunek śniegu:", snow_type(substr(code, 4, 4)))
  mes <- paste(mes, "ukształtowanie pokrywy śnieżnej:", snow_form(code, 5, 5))
  message <<- paste(message, mes, sep=" ")
}
fifth_null_group <- function(code){
  mes = ""
  sign = ""
  if(substr(code, 2, 2) == "1"){
    sign = "-"
  }
  value = sprintf("%s.%s", substr(code, 3, 4), substr(code, 5, 5))
  mes <- paste(sprintf("[5.0]Średnia temperatura gruntu na głębokości 5 cm: %s%s.", sign, value))
  message <<- paste(message, mes, sep=" ")
}
fifth_first_group <- function(code){
  mes = ""
  sign = ""
  if(substr(code, 2, 2) == "1"){
    sign = "-"
  }
  value = sprintf("%s.%s", substr(code, 3, 4), substr(code, 5, 5))
  mes <- paste(sprintf("[5.1]Najwyższa wartość temperatury gruntu na głębokości 5 cm: %s%s.", sign, value))
  message <<- paste(message, mes, sep=" ")
}
fifth_second_group <- function(code){
  mes = ""
  sign = ""
  if(substr(code, 2, 2) == "1"){
    sign = "-"
  }
  value = sprintf("%s.%s", substr(code, 3, 4), substr(code, 5, 5))
  mes <- paste(sprintf("[5.2]Najniższa wartość temperatury gruntu na głębokości 5 cm: %s%s.", sign, value))
  message <<- paste(message, mes, sep=" ")
}
fifth_third_group <- function(code){
  mes = ""
  sign = ""
  if(substr(code, 2, 2) == "1"){
    sign = "-"
  }
  value = sprintf("%s.%s", substr(code, 3, 4), substr(code, 5, 5))
  mes <- paste(sprintf("[5.3]Absolutne minimum temperatury na wysokości 5 cm nad pow. gruntu lub pokrywa śnieżną: %s%s.", sign, value))
  message <<- paste(message, mes, sep=" ")
}
fifth_fourth_group <- function(code){
  deepth <- function(x){
    if(x == "01"){
      "powierzchnia gruntu zamarznięta, termometry gruntowe na wszystkich głębokościach pokazują temperaturę dodatnią."
    } else if(x == "04"){
      "powierzchnia gruntu rozmarznięta, termometr gruntowy na głębokości 5 cm pokazuje temperaturę ujemną (najbliższa powierzchni izoterma znajduje się na głęb. 1-4 cm)"
    } else if(x == "00"){
      "izoterma 0 występuje na głębokości 100 cm."
    } else if(x == "0/"){
      "izoterma 0 występuje na głębokości poniżej 100 cm."
    } else if(x == "/0"){
      "grunt zamarznięty, głębokości położenia izotermy 0 nie wyznaczono."
    } else {
      sprintf("izoterma 0 występuje na głębokości %s cm", as.integer(x))
    }
  }
  mes <- paste("[5.4]Głębokość najniżej położonej izotermy 0 w gruncie:", deepth(substr(code, 2, 3)))
  mes <- paste(mes, "Głębokość izotermy 0 położonej najbliżej powierzchni gruntu:", deepth(substr(code, 4, 5)))
  message <<- paste(message, mes, sep=" ")
}
translate <- function(code){
  split_code = strsplit(code, " ")[[1]]
  metar_date(split_code[[2]])
  precipations(split_code[[3]])
  clouds(split_code[[4]])
  for(i in 6:length(split_code)){
    if(split_code[[i]] == "333"){
      for(j in (i+1):length(split_code)){
        switch(substr(split_code[[j]], 1, 1),
         "1" = third_first_group(split_code[[j]]),
         "2" = third_second_group(split_code[[j]]),
         "3" = third_third_group(split_code[[j]]),
         "4" = third_fourth_group(split_code[[j]]),
         "6" = third_sixth_group(split_code[[j]]),
         "7" = third_seventh_group(split_code[[j]]),
         "8" = third_eith_group(split_code[[j]]),
         "9" = ninth_group(split_code[[j]]),
         stop = "b/d."
        )
      }
    } else if(split_code[[i]] == "333"){
      for(j in (i+1):length(split_code)){
        switch(substr(split_code[[j]], 1, 1),
           "0" = fifth_null_group(split_code[[j]]),
           "1" = fifth_first_group(split_code[[j]]),
           "2" = fifth_second_group(split_code[[j]]),
           "3" = fifth_third_group(split_code[[j]]),
           "4" = fifth_fourth_group(split_code[[j]]),
           "5" = fifth_five_group(split_code[[j]]),
           "6" = fifth_six_group(split_code[[j]]),
           "7" = fifth_seven_group(split_code[[j]]),
           "8" = fifth_eight_group(split_code[[j]]),
           stop = "b/d."
        )
      }
    } else {
      switch(substr(split_code[[i]], 1, 1),
         "1" = first_group(split_code[[i]]),
         "2" = second_group(split_code[[i]]),
         "3" = third_group(split_code[[i]]),
         "4" = fourth_group(split_code[[i]]),
         "5" = fifth_group(split_code[[i]]),
         "6" = sixth_group(split_code[[i]]),
         "7" = seventh_group(split_code[[i]]),
         stop = "b/d."
      )
    }
  }
}
# pobieranie
ogimet.html <- read_html("http://ogimet.com/ultimos_synops2.php?estado=Pola&fmt=html&Enviar=Ver")
ogimet.table <- html_nodes(ogimet.html, "table table tr")
# baza
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host="postgres_db", user= "postgres", password="super_secure", dbname = "synop_production")
# con <- dbConnect(drv, dbname = "synop_development")
# con <- dbConnect(drv, dbname = "synop_production")
# przetwarzanie
ogimet.metars <- list()
ogimet.messages <- list()
for(i in 1:length(ogimet.table)){
  metadata = html_text(html_nodes(ogimet.table[[i]], "td")[[3]])
  synop = gsub('[^A-Za-z0-9 /]', "", html_text(html_nodes(ogimet.table[[i]], "td")[[4]]))
  metar = paste(metadata, synop, sep=" ")
  ogimet.metars <- c(ogimet.metars, metar)
  message <- ""
  translate(metar)
  ogimet.messages <- c(ogimet.messages, message)
  station = substr(metar, 12, 16)
  day = substr(metar, 6, 7)
  hour = substr(metar, 8, 9)
  created_at = Sys.time()
  ogimet.df <- data.frame(station, day, hour, metar, message, created_at, row.names = NULL)
  dbWriteTable(con, "metar_raports", value = ogimet.df, append = TRUE, row.names = FALSE)
}
# zamykanie połączenia z bazą
dbDisconnect(con)
#
