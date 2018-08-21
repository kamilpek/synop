desc "Import metar data from ogimet.net. "
task :import_ogimet => :environment do
  import = build_import_ogimet
  if import.nil?
    puts "Something is wrong."
  else
    puts "Successfull import."
  end
end

def build_import_ogimet
  print "Import begining.\n"
  ogimet_html = Nokogiri::HTML(open("http://ogimet.com/ultimos_synops2.php?estado=Pola&fmt=html&Enviar=Ver"))
  ogimet_table = ogimet_html.css('table')[0].css('table')[0].css('tr')
  for i in 0..ogimet_table.count-1
  # for i in 1..1
    $temperature = ""
    $cloud_cover = ""
    $wind_direct = ""
    $wind_speed = ""
    $visibility = ""
    $situation = ""
    $pressure = ""
    $message = ""
    ogimet_data = ogimet_table[i].css('td')[2].text.gsub(/[^a-zA-Z0-9 \-]/,"")
    ogimet_synop = ogimet_table[i].css('td')[3].text.gsub(/[^a-zA-Z0-9 \-]/,"")
    ogimet_metar = ogimet_data + ogimet_synop
    translate(ogimet_metar)
    created_at = Time.now.utc
    station = ogimet_metar[10..15]
    hour = ogimet_metar[7..8]
    day = ogimet_metar[5..6]
    # puts ogimet_metar + " " + station
    # puts $message
    MetarRaport.create!(
      :temperature => $temperature,
      :cloud_cover => $cloud_cover,
      :wind_direct => $wind_direct,
      :wind_speed => $wind_speed,
      :visibility => $visibility,
      :created_at => created_at,
      :situation => $situation,
      :pressure => $pressure,
      :metar => ogimet_metar,
      :message => $message,
      :station => station,
      :hour => hour,
      :day => day,
    )
  end
end

def translate(code)
  split_code = code.split(' ')
  metar_date(split_code[1])
  precipations(split_code[2])
  clouds(split_code[3])
  for i in 4..split_code.count-1
    if split_code[i] == "333"
      for j in (i+1)..split_code.count-1
        case split_code[j][0].to_s
        when "1"
          thrid_first_group(split_code[j])
        when "2"
          third_second_group(split_code[j])
        when "3"
          third_third_group(split_code[j])
        when "4"
          third_fourth_group(split_code[j])
        when "6"
          third_sixth_group(split_code[j])
        when "7"
          third_seventh_group(split_code[j])
        when "8"
          third_eith_group(split_code[j])
        when "9"
          ninth_group(split_code[j])
        end
      end
    elsif split_code[i] == "555"
      for j in (i+1)..split_code.count-1
        case j[0]
        when "0"
          fifth_null_group(split_code[j])
        when "1"
          fifth_first_group(split_code[j])
        when "2"
          fifth_second_group(split_code[j])
        when "3"
          fifth_third_group(split_code[j])
        when "4"
          fifth_fourth_group(split_code[j])
        when "5"
          fifth_five_group(split_code[j])
        when "6"
          fifth_six_group(split_code[j])
        when "7"
          fifth_seven_group(split_code[j])
        when "8"
          fifth_eight_group(split_code[j])
        end
      end
    else
      case split_code[i][0..0]
      when "1"
        first_group(split_code[i])
      when "2"
        second_group(split_code[i])
      when "3"
        third_group(split_code[i])
      when "4"
        fourth_group(split_code[i])
      when "5"
        fifth_group(split_code[i])
      when "6"
        sixth_group(split_code[i])
      when "7"
        seventh_group(split_code[i])
      end
    end
  end
end

def metar_date(code)
  message = "Dzień: " + code[0..1].to_s + " Godzina: " + code[2..3].to_s
  message += " Wskaźnik wiatru: "
  case code[4..4]
  when "0"
    message += "prędkość w m/s (mierzona wiatromierzem Wilda lub szacowana)."
  when "1"
    message += "prędkość w m/s (mierzona anemometrem)."
  when "2"
    message += "prędkość w węzłach (mierzona wiatromierzem Wilda lub szacowana)."
  when "3"
    message += "prędkość w węzłach (mierzona anemometrem)."
  else
    message += "b/d."
  end
  $message += message
end

def visibility_horizontal(x)
  case x.to_i
  when 0..50
    value = x.to_s[0..0].to_s + "." + x.to_s[1..1].to_s + " km."
  when 54..59
    value = x.to_s[1..1] + " km."
  when 60..69
    value = "1" + x.to_s[1..1] + " km."
  when 70..79
    value = "2" + x.to_s[1..1] + " km."
  when 80
    value = "30 km."
  when 81
    value = "35 km."
  when 82
    value = "40 km."
  when 83
    value = "45 km."
  when 84
    value = "50 km."
  when 85
    value = "55 km."
  when 86
    value = "60 km."
  when 87
    value = "65 km."
  when 88
    value = "70 km."
  when 89
    value = "> 70 km."
  end
end

def precipations(code)
  message = " Wskaźnik grupy opadowej: "
  case code[0..0].to_i
  when 0
    message += "grupa opadowa w rozdziale 1 i 3."
  when 1
    message += "grupa opadowa tylko w rozdziale 1."
  when 2
    message += "grupa opadowa tylko w rozdziale 3."
  when 3
    message += "grupa opadowa pominięta (opady nie wystąpiły)."
  when 4
    message += "grupa opadowa pominięta (nie wykonywano pomiarów opadu)."
  end
  message += " Typ stacji: "
  case code[1..1].to_i
  when 1
    message += "stacja nieautomatyczna."
  when 2
    message += "stacja nieautomatyczna."
  when 3
    message += "stacja nieautomatyczna."
  when 4
    message += "stacja automatyczna."
  when 5
    message += "stacja automatyczna."
  when 6
    message += "stacja automatyczna."
  end
  altitude = " Wysokość względna podstawy najniższych chmur: "
  case code[2..2]
  when "0"
    altitude += "0 do 50 m."
  when "1"
    altitude += "50 do 100 m."
  when "2"
    altitude += "100 do 200 m."
  when "3"
    altitude += "200 do 300 m."
  when "4"
    altitude += "300 do 400 m."
  when "5"
    altitude += "600 do 1000 m."
  when "6"
    altitude += "1000 do 1500 m."
  when "7"
    altitude += "1500 do 2000 m."
  when "8"
    altitude += "2000 do 2500 m."
  when "9"
    altitude += "powyżej 2500 m."
  when "/"
    altitude += "nieznana."
  else
    altitude += "nieznana."
  end
  message += altitude
  visibility_horizont = visibility_horizontal(code[3..4]).to_s
  $visibility = visibility_horizont
  message += " Widzialność pozioma: " + visibility_horizont
  $message += message
end

def clouds(code)
  message = " Wielkość zachmurzenia ogólnego: "
  case code[0..0].to_i
  when 0
    size = "bezchumrnie."
  when 1
    size = "prawie bezchmurnie."
  when 2
    size = "mało chmur"
  when 3
    size = "zachmurzenie małe"
  when 4
    size = "zachmurzenie umiarkowane"
  when 5
    size = "pochmurnie"
  when 6
    size = "zachmurzenie duże"
  when 7
    size = "zachmurzenie prawie całkowite"
  when 8
    size = "zachmurzenie całkowite"
  when 9
    size = "niebo niewidoczne"
  else
    size = "b/d"
  end
  message += size + "."
  $cloud_cover = size
  message += " Kierunek wiatru w dziesiątkach stopni: "
  if code[1..2] == "00"
    wind_drct = "cisza."
  elsif code[1..2].to_i>0 and code[1..2].to_i<99
    wind_drct = "ok. #{code[1..2].to_i*9}."
  elsif code[1..2] == "99"
    wind_drct = "zmienny lub z wielu kierunków."
  else
    "b/d."
  end
  message += wind_drct.to_s
  $wind_direct = wind_drct
  wind_speed = code[3..4].to_s
  $wind_speed = wind_speed
  message += " Prędkość wiatru: #{wind_speed}."
  $message += message
end

def first_group(code)
  mes = " [1]Temparatura powietrza: "
  if code[1..1].to_i == 1
    mes += "-"
  end
  value = "#{code[2..3]}.#{code[4..4]} st.C."
  mes += value
  $message += mes
  $temperature += value
end

def second_group(code)
  mes = " [2]Temparatura punktu rosy: "
  if code[1..1].to_i == 1
    mes += "-"
  end
  value = "#{code[2..3]}.#{code[4..4]} st.C."
  mes += value
  $message += mes
end

def third_group(code)
  mes = " [3]Ciśnienie atmosferyczne na poziomie stacji: "
  if code[1..1] == "0"
    value = "1#{code[1..3]}.#{code[4..4]} hPa "
  else
    value = "0#{code[1..3]}.#{code[4..4]} hPa "
  end
  mes += value
  $message += mes
  $pressure += value
end

def fourth_group(code)
  mes = " [4]Ciśnienie atmosferyczne zredukowane do poziomu morza: "
  if code[1..1] == "0"
    mes += "10#{code[2..3]}.#{code[4..4]} hPa."
  else
    mes += "0#{code[2..3]}.#{code[4..4]} hPa."
  end
  $message += mes
end

def fifth_group(code)
  mes = " [5]Tendencja ciśnienia na poziomie stacji w ciągu 3 ostatnich godzin: "
  case code[1..1]
  when "0"
    mes += "wzrost duży, później spadek mały,"
  when "1"
    mes += "wzrost, później bez zmian,"
  when "2"
    mes += "wzrost,"
  when "3"
    mes += "spadek mały, później wzrost duży,"
  when "4"
    mes += "bez zmian,"
  when "5"
    mes += "spadek duży, później wzrost mały,"
  when "6"
    mes += "spadek duży, później bez zmian,"
  when "7"
    mes += "spadek,"
  when "8"
    mes += "wzrost mały, później spadek duży,"
  else
    mes += "b/d."
  end
  mes += " wielkość tendencji: #{code[2..4].to_i}."
  $message += mes
end

def sixth_group(code)
  mes = " [6]Suma opadów: "
  case code[1..3].to_i
  when 0..989
    mes += "#{code[1..3]} mm."
  when 990
    mes += "ślad."
  when 990..1000
    mes += "0.#{code[2..2]} mm."
  else
    mes += "b/d."
  end
  mes += "Czas trwania okresu kończącego się w terminie obserwacji, za który podaje się wysokość opadu: "
  case code[4..4]
  when "1"
    mes += "6h"
  when "2"
    mes += "12h"
  when "3"
    mes += "18h"
  when "4"
    mes += "24h"
  when "5"
    mes += "1h"
  when "6"
    mes += "2h"
  when "7"
    mes += "3h"
  when "8"
    mes += "9h"
  when "9"
    mes += "15h"
  else
    mes += "b/d."
  end
  $message += mes
end

def weather(x)
  mes = ""
  case x
  when "00"
    mes += "rozwój chmur nieznany"
  when "01"
    mes += "chmury znikają lub stają się cieńsze"
  when "02"
    mes += "stan nie nieba się nie zmienia"
  when "03"
    mes += "chmury w stadium tworzenia się lub rozwoju"
  when "04"
    mes += "widzialność zmniejszona przez dym"
  when "05"
    mes += "zmętnienie"
  when "06"
    mes += "pył w powietrzu"
  when "07"
    mes += "pył lub piasek w powietrzu wznoszony przez wiatr"
  when "08"
    mes += "silnie rozwinięte wiry pyłowe lub piaskowe na stacji lub w pobliżu"
  when "09"
    mes += "wichura pyłowa lub piaskowa w zasięgu widzenia w czasie obserwacji lub na stacji w ciągu ostatniej godziny"
  when "10"
    mes += "zamglenie"
  when "11"
    mes += "cienka warstwa mgły lub mgły lodowej, w płatach"
  when "12"
    mes += "cienka warstwa mgły lub mgły lodowej, ciągła"
  when "13"
    mes += "widoczna błyskawica, nie słychać grzmotu"
  when "14"
    mes += "opad w polu widzenia nie sięgający gruntu"
  when "15"
    mes += "opad w polu widzenia sięgający gruntu, ponad 5 km od stacji"
  when "16"
    mes += "opad w polu widzenia sięgający gruntu, w pobliżu stacji lecz nie na stacji"
  when "17"
    mes += "burza bez opadu w czasie obserwacji"
  when "18"
    mes += "nawałnica na stacji lub w polu widzenia w czasie obserwacji lub w ciągu ostatniej godziny"
  when "19"
    mes += "trąba lądowa lub wodna na stacji lub w polu widzenia w czasie obserwacji lub w ciągu ostatniej godziny"
  when "20"
    mes += "mżawka (nie marznąca) lub śnieg ziarnisty"
  when "21"
    mes += "deszcz (nie marznący)"
  when "22"
    mes += "śnieg"
  when "23"
    mes += "deszcz ze śniegiem lub ziarna lodowe"
  when "24"
    mes += "mżawka marznąca lub deszcz marznący"
  when "25"
    mes += "przelotny deszcz"
  when "26"
    mes += "przelotny śnieg lub przelotny deszcz ze śniegiem"
  when "27"
    mes += "przelotny grad lub deszcz z gradem lub krupy śnieżne lub krupy lodowe"
  when "28"
    mes += "mgła lub mgła lodowa"
  when "29"
    mes += "burza bez opadu lub z opadem"
  when "30"
    mes += "słaba lub umiarkowana wichura pyłowa lub piaskowa, słabnąca w ciągu ostatniej godziny"
  when "31"
    mes += "słaba lub umiarkowana wichura pyłowa lub piaskowa, bez zmian w ciągu ostatniej godziny"
  when "32"
    mes += "słaba lub umiarkowana wichura pyłowa lub piaskowa, zaczynająca się lub wzmagająca w ciągu ostatniej godziny"
  when "33"
    mes += "silna wichura pyłowa lub piaskowa, słabnąca w ciągu ostatniej godziny"
  when "34"
    mes += "silna wichura pyłowa lub piaskowa, bez zmian w ciągu ostatniej godziny"
  when "35"
    mes += "silna wichura pyłowa lub piaskowa, zaczynająca się lub wzmagająca w ciągu ostatniej godziny"
  when "36"
    mes += "słaba lub umiarkowana zamieć śnieżna niska"
  when "37"
    mes += "silna zamieć śnieżna niska"
  when "38"
    mes += "słaba lub umiarkowana zamieć śnieżna wysoka"
  when "39"
    mes += "silna zamieć śnieżna wysoka"
  when "40"
    mes += "mgła (mgła lodowa) w pewnej odległości od stacji w czasie obserwacji, sięgająca powyżej poziomu oczu, w ciągu ostatniej godziny mgły na stacji nie było"
  when "41"
    mes += "mgła (mgła lodowa) w płatach"
  when "42"
    mes += "mgła (mgła lodowa), niebo widoczne, staje się rzadsza"
  when "43"
    mes += "mgła (mgła lodowa), niebo niewidoczne, staje się rzadsza"
  when "44"
    mes += "mgła (mgła lodowa), niebo widoczne, bez zmian w ciągu ostatniej godziny"
  when "45"
    mes += "mgła (mgła lodowa), niebo niewidoczne, bez zmian w ciągu ostatniej godziny"
  when "46"
    mes += "mgła (mgła lodowa), niebo widoczne, gęstnieje"
  when "47"
    mes += "mgła (mgła lodowa), niebo niewidoczne, gęstnieje"
  when "48"
    mes += "mgła osadzająca szadź, niebo widoczne"
  when "49"
    mes += "mgła osadzająca szadź, niebo niewidoczne"
  when "50"
    mes += "słaba, niemarznąca mżawka z przerwami"
  when "51"
    mes += "słaba, niemarznąca, ciągła mżawka"
  when "52"
    mes += "umiarkowana, niemarznąca mżawka z przerwami"
  when "53"
    mes += "umiarkowana, niemarznąca, ciągła mżawka"
  when "54"
    mes += "intensywna, niemarznąca mżawka z przerwami"
  when "55"
    mes += "intensywna, niemarznąca, ciągła mżawka"
  when "56"
    mes += "słaba marznąca mżawka"
  when "57"
    mes += "umiarkowana lub silna marznąca mżawka"
  when "58"
    mes += "słaba mżawka z deszczem"
  when "59"
    mes += "umiarkowana lub silna mżawka z deszczem"
  when "60"
    mes += "niemarznący, słaby deszcz z przerwami"
  when "61"
    mes += "niemarznący, słaby, ciągły"
  when "62"
    mes += "niemarznący, umiarkowany deszcz z przerwami"
  when "63"
    mes += "niemarznący, umiarkowany, ciągły deszcz"
  when "64"
    mes += "niemarznący, silny deszcz z przerwami"
  when "65"
    mes += "niemarznący, silny, ciągły deszcz"
  when "66"
    mes += "słaby marznący deszcz"
  when "67"
    mes += "umiarkowany lub silny marznący deszcz"
  when "68"
    mes += "słaby deszcz ze śniegiem"
  when "69"
    mes += "umiarkowany lub silny deszcz ze śniegiem"
  when "70"
    mes += "słaby śnieg z przerwami"
  when "71"
    mes += "słaby, ciągły śnieg"
  when "72"
    mes += "umiarkowany śnieg z przerwami"
  when "73"
    mes += "umiarkowany, ciągły śnieg"
  when "74"
    mes += "silny śnieg z przerwami"
  when "75"
    mes += "silny, ciągły śnieg"
  when "76"
    mes += "pył diamentowy"
  when "77"
    mes += "śnieg ziarnisty"
  when "78"
    mes += "oddzielne gwiazdki śniegu"
  when "79"
    mes += "ziarna lodowe"
  when "80"
    mes += "słaby przelotny deszcz"
  when "81"
    mes += "umiarkowany lub silny przelotny deszcz"
  when "82"
    mes += "gwałtowny przelotny deszcz"
  when "83"
    mes += "słaby przelotny deszcz ze śniegiem"
  when "84"
    mes += "umiarkowany lub silny przelotny deszcz ze śniegiem"
  when "85"
    mes += "słaby przelotny śnieg"
  when "86"
    mes += "umiarkowany lub silny przelotny śnieg"
  when "87"
    mes += "słabe przelotne krupy lodowe lub śnieżne"
  when "88"
    mes += "umiarkowane lub silne, przelotne krupy lodowe lub śnieżne"
  when "89"
    mes += "słaby przelotny grad"
  when "90"
    mes += "umiarkowany lub silny przelotny grad"
  when "91"
    mes += "burza w ciągu ostatniej godziny, w czasie obserwacji lekki deszcz"
  when "92"
    mes += "burza w ciągu ostatniej godziny, w czasie obserwacji umiarkowany lub silny deszcz"
  when "93"
    mes += "burza w ciągu ostatniej godziny, w czasie obserwacji lekki śnieg lub deszcz ze śniegiem"
  when "94"
    mes += "burza w ciągu ostatniej godziny, w czasie obserwacji umiarkowany lub silny śnieg lub deszcz ze śniegiem"
  when "95"
    mes += "słaba lub umiarkowana burza w czasie obserwacji"
  when "96"
    mes += "słaba lub umiarkowana burza z gradem w czasie obserwacji"
  when "97"
    mes += "silna burza"
  when "98"
    mes += "silna burza z wichurą pyłową lub piaskową"
  when "99"
    mes += "silna burza z gradem"
  else
    "b/d"
  end
end

def seventh_group(code)
  mes = " [7]Pogoda bieżąca: "
  weat = weather(code[1..2])
  $message += mes + weat
  $situation += weat
end

def thrid_first_group(code)
  mes = " [3.1]Temperatura maksymalna za ostatnie 12 godzin: "
  if code[1..1] == "1"
    mes += "-"
  end
  mes += "#{code[2..3]}.#{code[4..4]} st.C."
  $message += mes
end

def third_second_group(code)
  mes = " [3.2]Temperatura minimalna za ostatnie 12 godzin: "
  if code[1..1] == "1"
    mes += "-"
  end
  mes += "#{code[2..3]}.#{code[4..4]} st.C."
  $message += mes
end

def third_third_group(code)
  mes = " [3.3]Stan powierzchni gruntu bez śniegu: "
  case code[1]
  when "0"
    mes += "powierzchnia gruntu sucha"
  when "1"
    mes += "powierzchnia gruntu wilgotna"
  when "2"
    mes += "powierzchnia gruntu mokra (woda utrzymuje się na powierzchni i tworzy kałuże)"
  when "3"
    mes += "grunt podtopiony (wszędzie rozlana woda)"
  when "4"
    mes += "grunt zamarznięty"
  when "5"
    mes += "gołoledź"
  when "6"
    mes += "sypki i suchy pył lub piasek nie pokrywający powierzchni całkowicie"
  when "7"
    mes += "cienka warstwa sypkiego i suchego pyłu lub piasku pokrywająca grunt całkowicie"
  when "8"
    mes += "umiarkowana lub gruba warstwa sypkiego pyłu lub piasku pokrywająca grunt całkowicie"
  when "9"
    mes += "powierzchnia gruntu bardzo sucha z licznymi pęknięciami"
  else
    "b/d."
  end
  mes += ", minimalna temperatura 5 cm nad powierzchnią gruntu: "
  mes += "-" if code[2] == "1"
  mes += "#{code[2..3]}.#{code[4..4]} st.C."
  $message += mes
end

def third_fourth_group(code)
  mes = " [3.4]Stan pokrywy śnieżnej: "
  case code[1]
  when "0"
    mes += "powierzchnia gruntu w większości pokryta lodem."
  when "1"
    mes += "zleżały lub mokry śnieg (z lodem lub bez) pokrywający mniej niż połowę gruntu."
  when "2"
    mes += "zleżały lub mokry śnieg (z lodem lub bez) pokrywający co najmniej połowę gruntu, lecz nie całkowicie."
  when "3"
    mes += "równa warstwa zleżałego lub mokrego śniegu (z lodem lub bez) pokrywająca grunt całkowicie."
  when "4"
    mes += "nierówna warstwa zleżałego lub mokrego śniegu (z lodem lub bez) pokrywająca grunt całkowicie."
  when "5"
    mes += "suchy i puszysty śnieg pokrywający mniej niż połowę powierzchni gruntu."
  when "6"
    mes += "suchy i puszysty śnieg pokrywający co najmniej połowę powierzchni gruntu lecz nie całkowicie."
  when "7"
    mes += "równa warstwa suchego i puszystego śniegu pokrywająca grunt całkowicie."
  when "8"
    mes += "nierówna warstwa suchego i puszystego śniegu pokrywająca grunt całkowicie."
  when "9"
    mes += "liczne wysokie zaspy śniegu pokrywające grunt całkowicie."
  else
    mes += "b/d."
  end
  mes += " Wysokść pokrywy śnieżnej: "
  case code[2..4].to_i
  when 0..997
    mes += "#{code[2..4]} cm."
  when 997
    mes += "mniej niż 0,5 cm."
  when 998
    mes += "płaty."
  when 999
    mes += "pomiar niemożliwy."
  else
    mes += "b/d."
  end
  $message += mes
end

def third_sixth_group(code)
  mes = " [3.6]Suma opadu: "
  case code[1..3].to_i
  when 0..990
    mes += "#{code[1..3]} mm."
  when 990
    mes += "ślad."
  when 990..1000
    mes += "0,#{code[2]} mm."
  else
    mes += "b/d."
  end
  $message += mes
end

def third_seventh_group(code)
  $message += " [3.7]Suma opadu za 24 godziny kończące się w momencie obserwacji w dziesiątych częściach mm: #{code[1..3]},#{code[4]} mm."
end

def clouds_type(x)
  case x
  when "0"
    mes = "Cirrus (Ci)"
  when "1"
    mes = "Cirrocumulus (Cc)"
  when "2"
    mes = "Cirrostratus (Cs)"
  when "3"
    mes = "Altocumulus (Ac)"
  when "4"
    mes = "Altostratus (As)"
  when "5"
    mes = "Nimbostratus (Ns)"
  when "6"
    mes = "Stratocumulus (Sc)"
  when "7"
    mes = "Stratus (St)"
  when "8"
    mes = "Cumulus (Cu)"
  when "9"
    mes = "Cumulonimbus (Cb)"
  when "/"
    mes = "chmury niewidoczne"
  else
    mes = "b/d."
  end
end

def third_eith_group(code)
  mes = " [3.8]Wielkość zachmurzenia: "
  if (code[1].to_i>0) && (code[1].to_i<9)
    mes += "#{code[1]}/8."
  else
    "b/d."
  end
  mes += " Rodzaj chmur: #{clouds_type(code[2])}"
  mes += " Wysokość podstawy chmur: "
  case code[3..4].to_i
  when 0
    mes += "< 30 m (< 100 stóp)."
  when 0..50
    mes += "#{(code[3..4].to_i)*(0.3)}0 m (#{code[3..4].to_i}0 stóp)."
  when 55..60
    mes += "#{(code[4].to_i)*(0.3)}0 m. (#{code[4].to_i}0 stóp)"
  when "81"
    mes += "10500 m (35000 stóp)."
  when "82"
    mes += "12000 m (40000 stóp)."
  when "83"
    mes += "13500 m (4500 stóp)."
  when "84"
    mes += "15000 m (5000 stóp)."
  when "85"
    mes += "16500 m (5500 stóp)."
  when "86"
    mes += "18000 m (6000 stóp)."
  when "87"
    mes += "19500 m (6500 stóp)."
  when "88"
    mes += "21000 m (70000 stóp)."
  when "89"
    mes += "> 21000 m (> 70000 stóp)."
  when "90"
    mes += "0 do 49 m (0 - 166 stóp)."
  when "91"
    mes += "50 do 99 m (167 - 333 stóp)."
  when "92"
    mes += "100 do 199 m (334 - 666 stóp)."
  when "93"
    mes += "200 do 299 m (667 - 999 stóp)."
  when "94"
    mes += "300 do 599 m (1000 - 1999 stóp.)"
  when "95"
    mes += "600 do 999 m (2000 - 3333 stóp)."
  when "96"
    mes += "1000 do 1499 m (3334 - 4999 stóp)."
  when "97"
    mes += "1500 do 1999 m (5000 - 6666 stóp)."
  when "98"
    mes += "2000 do 2499 m (6667 - 8333 stóp)."
  when "99"
    mes += "> 2500 m (> 8334 stóp)."
  else
    mes += "b/d."
  end
  $message += mes
end

def ninth_time_group(code)
  mes = " [3.9.0]Zmienność położenia lub intensywność zjawiska: "
  case code[3..4].to_i
  when 0
    mes += "w czasie obserwacji."
  when 0..59
    mes += "#{(code[3..4].to_i)*6} min."
  when 60
    mes += "360 min 4 h."
  when 61
    mes += "6 do 7 h."
  when 62
    mes += "7 do 8 h."
  when 63
    mes += "8 do 9 h."
  when 64
    mes += "9 do 10 h."
  when 65
    mes += "10 do 11 h."
  when 66
    mes += "11 do 12 h."
  when 67
    mes += "12 do 18 h."
  when 68
    mes += "powyżej 18 h."
  when 69
    mes += "czas nieznany."
  when 70
    mes += "początek w czasie obserwacji."
  when 71
    mes += "koniec w czasie obserwacji."
  when 72
    mes += "początek i koniec w czasie obserwacji."
  when 73
    mes += "istotna zmiana w czasie obserwacji."
  when 74
    mes += "początek po obserwacji."
  when 75
    mes += "koniec po obserwacji."
  when 76
    mes += "na stacji (w otoczeniu)."
  when 77
    mes += "nad stacją."
  when 78
    mes += "we wszystkich kierunkach."
  when 79
    mes += "we wszystkich kierunkach, lecz nie nad stacją."
  when 80
    mes += "zbliżające się do stacji."
  when 81
    mes += "oddalające się od stacji."
  when 82
    mes += "przechodzące obok stacji w pewnej odległości."
  when 83
    mes += "widziane w pewnej odległości."
  when 84
    mes += "występujące w pobliżu, lecz nie na stacji."
  when 85
    mes += "uniesione wysoko nad gruntem."
  when 86
    mes += "w pobliżu gruntu."
  when 87
    mes += "sporadyczne, sporadycznie."
  when 88
    mes += "okresowe."
  when 89
    mes += "częste (w częstych przedziałach)."
  when 90
    mes += "jednostajne; jednostajne w natężeniu; jednostajnie; bez zmian."
  when 91
    mes += "wzrastające; wzrastające w natężeniu; wzrost."
  when 92
    mes += "zmniejszające się; zmniejszające się w natężeniu; spadek."
  when 93
    mes += "zmienne; zmieniające się."
  when 94
    mes += "ciągłe; ciągle."
  when 95
    mes += "bardzo słabe; znacznie poniżej normy; bardzo cienkie."
  when 96
    mes += "słabe; poniżej normy; cienkie."
  when 97
    mes += "średnie; w normie; średnia grubość; stopniowe."
  when 98
    mes += "silne; groźne; grube; powyżej normy; wyraźne; nagłe."
  when 99
    mes += "bardzo silne; zabijające; bardzo groźne; gęste; znacznie powyżej normy."
  else
    mes += "b/d."
  end
  $message += mes
end

def ninth_ending_group(code)
  $message += " [3.9.1]Czas zakończenia zjawiska podanego pod ww w grupie 7: #{code[3..4]}."
end

def ninth_starting_group(code)
  $message += " [3.9.2]Czas rozpoczęcia zjawiska podanego w kolejnej grupie 9: #{code[3..4]}."
end

def ninth_changing_group(code)
  $message += " [3.9.3]Zmienność położenia lub intensywność zjawiska podanego w kolejnej grupie 9: #{code[3..4]}."
end

def ninth_ending_next_group(code)
  $message += " [3.9.4]Czas zakończenia zjawiska podanego w poprzedzającej grupie 9: #{code[3..4]}."
end

def ninth_start_next_group(code)
  $message += " [3.9.5]Czas wystąpienia zjawiska podanego w kolejnej grupie 9: #{code[3..4]}."
end

def ninth_start_nine_group(code)
  $message += " [3.9.6]Czas trwania zjawiska niejednostajnego lub czas rozpoczęcia zjawiska jednostajnego podanego w kolejnej grupie 9: #{code[3..4]}."
end

def ninth_seventh_group(code)
  $message += " [3.9.7]Czas trwania okresu odniesienia kończącego się w czasie obserwacji, dla zjawiska podawanego w kolejnej grupie 9: #{code[3..4]}."
end

def ninth_ninth_group(code)
  mes = " [3.9.9]Czas początku lub końca opadu kodowanego przez RRR: "
  case code[3]
  when "1"
    mes += "mniej niż 1 h przed czasem obserwacji."
  when "2"
    mes += "1 do 2 h przed czasem obserwacji."
  when "3"
    mes += "2 do 3 h przed czasem obserwacji."
  when "4"
    mes += "3 do 4 h przed czasem obserwacji."
  when "5"
    mes += "4 do 5 h przed czasem obserwacji."
  when "6"
    mes += "5 do 6 h przed czasem obserwacji."
  when "7"
    mes += "6 do 12 h przed czasem obserwacji."
  when "8"
    mes += "> 12 h przed czasem obserwacji."
  when "9"
    mes += "nieznany."
  else
    mes += "b/d."
  end
  mes += " Czas trwania i rodzaj w/w opadu: "
  case code[4]
  when "0"
    mes += "krótszy niż 1 h."
  when "1"
    mes += "od 1 do 3 h."
  when "2"
    mes += "od 3 do 6 h."
  when "3"
    mes += "powyżej 6 h."
  when "4"
    mes += "krótszy niż 1 h."
  when "5"
    mes += "od 1 do 3 h."
  when "6"
    mes += "od 3 do 6 h."
  when "7"
    mes += "powyżej 6 h."
  when "9"
    mes += "czas trwania nieznany"
  else
    mes += "b/d."
  end
  $message += mes
end

def ninth_tenth_group(code)
  $message += " [3.9.10]Największy poryw wiatru w ciągu 10 minut poprzedzających obserwację: #{code[3..4]}."
end

def ninth_eleven_group(code)
  $message += " [3.9.11]Największy poryw wiatru: #{code[3..4]}."
end

def ninth_twleve_group(code)
  $message += " [3.9.12]Największa średnia prędkość wiatru: #{code[3..4]}."
end

def ninth_wind_medium_group(code)
  $message += " [3.9.13]Średnia prędkość wiatru: #{code[3..4]}."
end

def ninth_wind_minimal_group(code)
  $message += " [3.9.14]Najmniejsza średnia prędkość wiatru: #{code[3..4]}."
end

def ninth_wind_drection_group(code)
  $message += " [3.9.15]Kierunek wiatru w dzięstkach stopni: #{code[3..4]}."
end

def ninth_wind_right_group(code)
  $message += " [3.9.16]Wyraźna prawoskrętna zmiana kierunku wiatru."
end

def ninth_wind_left_group(code)
  $message += " [3.9.17]Wyraźna lewoskrętna zmiana kierunku wiatru."
end

def ninth_storm_group(code)
  mes = " [3.9.18]Rodzaj nawałnicy: "
  case code[3]
  when "0"
    mes += "cisza lub słaby wiatr przed nawałnicą."
  when "1"
    mes += "cisza lub słaby wiatr przed kolejnymi nawałnicami."
  when "2"
    mes += "wiatr porywisty przed nawałnicą."
  when "3"
    mes += "wiatr porywisty przed kolejnymi nawałnicami."
  when "4"
    mes += "nawałnica przed wiatrem porywistym."
  when "5"
    mes += "na ogół wiatr porywisty, między porywami nawałnice."
  when "6"
    mes += "nawałnica zbliża się do stacji."
  when "7"
    mes += "linia nawałnicy."
  when "8"
    mes += "nawałnica z nawiewanym lub przenoszonym pyłem lub piaskiem."
  when "9"
    mes += "linia nawałnicy z nawiewanym lub przenoszonym pyłem lub piaskiem."
  else
    mes += "b/d."
  end
  mes += " Kierunek z którego nadchodzi zjawisko: "
  case code[4]
  when "0"
    mes += "występuje na stacji."
  when "1"
    mes += "NE."
  when "2"
    mes += "E."
  when "3"
    mes += "SE."
  when "4"
    mes += "S."
  when "5"
    mes += "SW."
  when "6"
    mes += "W."
  when "7"
    mes += "NW."
  when "8"
    mes += "N."
  when "9"
    mes += "ze wszystkich kierunków."
  else
    mes += "b/d."
  end
  $message += mes
end

def ninth_sea_twister_group(code)
  mes = " [3.9.19]Rodzaj zjawiska: "
  case code[3]
  when "0"
    mes += "trąba(y) morska(ie) w odległości do 3 km od stacji."
  when "1"
    mes += "trąba(y) morska(ie) w odległości powyżej 3 km od stacji."
  when "2"
    mes += "trąba(y) lądowa(e) w odległości do 3 km od stacji."
  when "3"
    mes += "trąba(y) lądowa(e) w odległości powyżej 3 km od stacji."
  when "4"
    mes += "słabe wiry powietrzne."
  when "5"
    mes += "umiarkowane wiry powietrzne."
  when "6"
    mes += "silne wiry powietrzne."
  when "7"
    mes += "słabe wiry pyłowe."
  when "8"
    mes += "umiarkowane wiry pyłowe."
  when "9"
    mes += "silne wiry pyłowe."
  else
    mes += "b/d."
  end
  mes += " Kierunek z którego nadzodzi zjawisko: "
  case code[4]
  when "0"
    mes += "występuje na stacji."
  when "1"
    mes += "NE."
  when "2"
    mes += "E."
  when "3"
    mes += "SE."
  when "4"
    mes += "S."
  when "5"
    mes += "SW."
  when "6"
    mes += "W."
  when "7"
    mes += "NW."
  when "8"
    mes += "N."
  when "9"
    mes += "ze wszystkich kierunków."
  else
    mes += "b/d."
  end
  $message += mes
end

def sea_state(x)
  case x
  when "0"
    mes += "gładkie, wysokość fal: 0 m."
  when "1"
    mes += "zmarszczone, wysokość fal: 0 - 0,1 m."
  when "2"
    mes += "lekko sfalowane, wysokość fal: 0,1 - 0,5 m."
  when "3"
    mes += "sfalowane, wysokość fal: 0,5 - 1,25 m."
  when "4"
    mes += "rozkołysane, wysokość fal: 1,25 - 2,5 m."
  when "5"
    mes += "silnie rozkołysane, wysokość fal: 2,5 m - 4 m."
  when "6"
    mes += "wzburzone, wysokość fal: 4 m - 6 m."
  when "7"
    mes += "silnie wzburzone, wysokość fal: 6 m - 9 m."
  when "8"
    mes += "groźne, wysokość fal: 9 m - 14 m."
  when "9"
    mes += "rozszalałe (wyjątkowo groźne), wysokość fal: ponad 14 m."
  else
    mes += "b/d."
  end
end

def ninth_sea_group(code)
  mes = " [3.9.20]Stan otwartego morza: #{sea_state(code[3])}"
  mes += "Największa prędkość wiatru w stopniach Beauforta:"
  case code[4]
  when "0"
    mes += "0 stopni w skali Beauforta."
  when "1"
    mes += "1 stopień w skali Beauforta."
  when "2"
    mes += "2 stopnie w skali Beauforta."
  when "3"
    mes += "3 stopnie w skali Beauforta."
  when "4"
    mes += "4 stopnie w skali Beauforta."
  when "5"
    mes += "5 stopni w skali Beauforta."
  when "6"
    mes += "6 stopni w skali Beauforta."
  when "7"
    mes += "7 stopni w skali Beauforta."
  when "8"
    mes += "8 stopni w skali Beauforta."
  when "9"
    mes += "9 stopni w skali Beauforta."
  else
    mes += "b/d."
  end
  $message += mes
end

def ninth_sea_strong_group(code)
  mes = " [3.9.21]Stan otwartego morza: #{sea_state(code[3])}"
  mes += " Największa prędkość wiatru w stopniach Beauforta: #{code[4]}0 w skali Beauforta."
  $message += mes
end

def ninth_sea_water_group(code)
  mes = " [3.9.22]Stan powierzchni wodowiska dla hydroplanów: #{sea_state(code[3])}"
  mes += " Widzialność pozioma nad powierzchnią wodowiska dla hydroplanów: "
  case code[4]
  when "0"
    mes += "< 0,05 km."
  when "1"
    mes += "0,05 – 0,2 km."
  when "2"
    mes += "0,2 – 0,5 km."
  when "3"
    mes += "0,5 – 1,0 km."
  when "4"
    mes += "1,0 – 2,0 km."
  when "5"
    mes += "2,0 – 4,0 km."
  when "6"
    mes += "4,0 – 10,0 km."
  when "7"
    mes += "10,0 – 20,0 km."
  when "8"
    mes += "20,0 – 50,0 km."
  when "9"
    mes += "> 50 km."
  else
    mes += "b/d."
  end
  $message += mes
end

def ninth_water_group(code)
  $message += " [3.9.23]Stan powierzchni wodowiska: #{sea_state(code[3])}"
  $message += " Stan otwartego morza:  #{sea_state(code[4])}"
end

def ninth_water_temp_group(code)
  $message += " [3.9.25]Temperatura wody w ośrodkach wypoczynkowych w sezonie kąpielowym w stopniach Celsjusza: #{code[3..4]} st.C."
end

def ninth_frost(code)
  mes = " [3.9.26]Szron i kolorowe opady: "
  case code[3]
  when "0"
    mes += "szron na powierzchniach poziomych."
  when "1"
    mes += "szron na powierzchniach poziomych i pionowych."
  when "2"
    mes += "opad zawierający piasek lub pył pochodzenia pustynnego."
  when "3"
    mes += "opad zawierający popiół pochodzenia wulkanicznego."
  else
    mes += "b/d."
  end
  mes += " Intensywność zjawiska: "
  case code[4]
  when "0"
    mes += "słabe."
  when "1"
    mes += "umiarkowane."
  when "2"
    mes += "silne."
  else
    mes += "b/d."
  end
  $message += mes
end

def ninth_snow_group(code)
  mes = " [3.9.27]Osady stałe (lodowe): "
  case code[3]
  when "0"
    mes += "gołoledź."
  when "1"
    mes += "szadź miękka."
  when "2"
    mes += "szadź twarda."
  when "3"
    mes += "osad śniegu."
  when "4"
    mes += "śnieg mokry."
  when "5"
    mes += "śnieg mokry zamarzający."
  when "6"
    mes += "osad mieszany (gołoledź i szadź lub szadź i marznący mokry śnieg, itp.)."
  when "7"
    mes += "przyziemny osad lodowy."
  else
    mes += "b/d."
  end
  mes += " Zmiany temp. związane z wystąpieniem szadzi lub gołoledzi: "
  case code[4]
  when "0"
    mes += "temperatura bez zmian."
  when "1"
    mes += "temperatura obniża się, lecz pozostaje powyżej 00C."
  when "2"
    mes += "temperatura wzrasta, lecz pozostaje poniżej 00C."
  when "3"
    mes += "temperatura obniża się do wartości poniżej 00C."
  when "4"
    mes += "temperatura wzrasta i przekroczyła 00C."
  when "5"
    mes += "wahania przekraczające 00C (zmiany temperatury nieregularne)."
  when "6"
    mes += "wahania nie przekraczające 00C (zmiany temperatury nieregularne)."
  when "7"
    mes += "zmiany temperatury nieobserwowane."
  when "8"
    mes += "nie stosuje się."
  when "9"
    mes += "zmiany temperatury nie znane z powodu braku termografu."
  else
    mes += "b/d."
  end
  $message += mes
end

def ninth_snow_two_group(code)
  mes = " [3.9.28]Gatunek śniegu: "
  case code[3]
  when "0"
    mes += "śnieg świeży, puszysty."
  when "1"
    mes += "śnieg świeży, przewiany w zaspy."
  when "2"
    mes += "śnieg świeży, zwarty."
  when "3"
    mes += "śnieg stary, sypki."
  when "4"
    mes += "śnieg stary, zbity."
  when "5"
    mes += "śnieg stary, wilgotny."
  when "6"
    mes += "śnieg sypki ze zlodowaciałą powierzchnią."
  when "7"
    mes += "śnieg zbity ze zlodowaciałą powierzchnią."
  when "8"
    mes += "śnieg wilgotny ze zlodowaciałą powierzchnią."
  else
    mes += "b/d."
  end
  mes += " Ukształtowanie pokrywy śnieżnej: "
  case code[4]
  when "0"
    mes += "gładka, bez zasp, grunt zamarznięty."
  when "1"
    mes += "gładka, bez zasp, grunt niezamarznięty."
  when "2"
    mes += "gładka, bez zasp, stan gruntu nieznany."
  when "3"
    mes += "sfalowana, małe zaspy, grunt zamarznięty."
  when "4"
    mes += "sfalowana, małe zaspy, grunt niezamarznięty."
  when "5"
    mes += "sfalowana, małe zaspy, stan gruntu nieznany."
  when "6"
    mes += "nieregularna, głębokie zaspy, grunt zamarznięty."
  when "7"
    mes += "nieregularna, głębokie zaspy, grunt niezamarznięty."
  when "8"
    mes += "nieregularna, głębokie zaspy, stan gruntu nieznany."
  else
    mes += "b/d."
  end
  $message += mes
end

def ninth_snow_storm(code)
  mes = " [3.9.29]Rodzaj zamieci śnieżnej: "
  case code[3]
  when "0"
    mes += "śnieżne zmętnienie."
  when "1"
    mes += "zamieć niska słaba lub umiarkowana z lub bez opadu śniegu."
  when "2"
    mes += "zamieć niska silna bez opadu śniegu."
  when "3"
    mes += "zamieć niska silna z opadem śniegu."
  when "4"
    mes += "zamieć wysoka słaba lub umiarkowana bez opadu śniegu."
  when "5"
    mes += "zamieć wysoka silna bez opadu śniegu."
  when "6"
    mes += "zamieć wysoka słaba lub umiarkowana z opadem śniegu."
  when "7"
    mes += "zamieć wysoka silna z opadem śniegu."
  when "8"
    mes += "zamieć wysoka słaba lub umiarkowana oraz zamieć niska."
  when "9"
    mes += "zamieć wysoka silna oraz zamieć niska."
  else
    mes += "b/d."
  end
  mes += " Rozwój zamieci śnieżnej: "
  case code[4]
  when "0"
    mes += "koniec zamieci przed terminem obserwacji."
  when "1"
    mes += "zamieć o zmniejszającej się intensywności."
  when "2"
    mes += "zamieć o stałej intensywności."
  when "3"
    mes += "zamieć o zwiększającej się intensywności."
  when "4"
    mes += "zamieć z przerwami krótszymi niż 30 minut."
  when "5"
    mes += "zamieć wysoka przeszła w zamieć niską."
  when "6"
    mes += "zamieć niska przeszła w zamieć wysoką."
  when "7"
    mes += "ponowny rozwój zamieci po przerwie trwającej minimum 30 minut."
  else
    mes += "b/d."
  end
  $message += mes
end

def prec_sum_mm(x)
  case x.to_i
  when 0..55
    mes = "#{x} mm."
  when 56..89
    mes = "około #{(x.to_i-56)*(11.5)} mm."
  when 90..96
    mes = "#{x[1]} mm."
  when 97
    mes = "< 0,1 mm."
  when 98
    mes = "> 400 mm."
  when 99
    mes = "pomiar niemożliwy lub niedokładny."
  else
    mes = "b/d."
  end
end

def ninth_prec_sum_group(code)
  $message += " [3.9.30]Suma opadu. Wysokość opadu lub grubość osadu: #{prec_sum_mm(code[3..4])}"
end

def ninth_snow_fresh_group(code)
  $message += " [3.9.31]Wysokość świeżo spadłego śniegu: #{prec_sum_mm(code[3..4])}"
end

def ninth_hail_group(code)
  $message += " [3.9.32]Maksymalna średnica gradzin: #{prec_sum_mm(code[3..4])}"
end

def ninth_water_eq_group(code)
  $message += " [3.9.33]Wodny ekwiwalent opadów stałych w czasie obserwacji: #{prec_sum_mm(code[3..4])}"
end

def ninth_glaze_group(code)
  $message += " [3.9.34]Średnica narośniętej gołoledzi w czasie obserwacji: #{prec_sum_mm(code[3..4])}"
end

def ninth_frost_group(code)
  $message += " [3.9.35]Średnica narośniętej szadzi w czasie obserwacji: #{prec_sum_mm(code[3..4])}"
end

def ninth_prec_mix_group(code)
  $message += " [3.9.36]Średnica osadu mieszanego w czasie obserwacji:  #{prec_sum_mm(code[3..4])}"
end

def ninth_snow_wet_group(code)
  $message += " [3.9.37]Średnica osadu mokrego śniegu w czasie obserwacji:  #{prec_sum_mm(code[3..4])}"
end

def ninth_glaze_speed_group(code)
  $message += " [3.9.38]Prędkość narastania gołoledzi: #{code[3..4]} mm/h."
end

def ninth_measur_height_group(code)
  $message += " [3.9.39]Wysokość nad powierzchnią gruntu, na jakiej jest mierzona średnica osadu w poprzednich grupach: #{code[3..4]} m."
end

def cloud_progres(x)
  case x
  when "0"
    mes = "bez zmian."
  when "1"
    mes = "skłębianie się chmur."
  when "2"
    mes = "powolne unoszenie się chmur."
  when "3"
    mes = "szybkie unoszenie się chmur."
  when "4"
    mes = "unoszenie się i uwarstwianie chmur."
  when "5"
    mes = "powolne obniżanie się chmur."
  when "6"
    mes = "szybkie obniżanie się chmur."
  when "7"
    mes = "uwarstwianie się chmur."
  when "8"
    mes = "uwarstwianie i obniżanie się chmur."
  when "9"
    mes = "szybkie zmiany."
  else
    mes = "b/d."
  end
end

def ninth_clouds_group(code)
  $message += " [3.9.40]Rozwój chmur: #{cloud_progres(code[4])}"
end

def ninth_cloud_direction_group(code)
  $message += " [3.9.41]Rodzaj chmur: #{clouds_type(code[3])}"
  $message += " Kierunek, z którego chmury nadciągają: #{code[4]}."
end

def ninth_cloud_concentration_direction_group(code)
  $message += " [3.9.42]Rodzaj chmur: #{clouds_type(code[3])}"
  $message += " Kierunek maksymalnej koncentracji chmur: #{code[4]}."
end

def ninth_cloud_low_direction_group(code)
  $message += " [3.9.43]Rodzaj chmur: #{clouds_type(code[3])}"
  $message += " Kierunek, z którego nadciągają chmury niskie: #{code[4]}."
end

def ninth_cloud_low_concentration_direction_group(code)
  $message += " [3.9.44]Rodzaj chmur: #{clouds_type(code[3])}"
  $message += " Kierunek maksymalnej koncentracji chmur niskich: #{code[4]}"
end

def ninth_cloud_low_top_group(code)
  $message += " [3.9.45]Wysokość wierzchołków chmur najniższych lub wysokość podstawy chmur najniższych lub pionowy zasięg mgły: #{code[3..4]}."
end

def ninth_cloud_color_group(code)
  mes = " [3.9.46]Zabarwienie chmur i ich zbieżność: "
  case code[3]
  when "1"
    mes += "słabe zabarwienie chmur o wschodzie Słońca."
  when "2"
    mes += "silnie czerwone zabarwienie chmur o wschodzie Słońca."
  when "3"
    mes += "słabe zabarwienie chmur o zachodzie Słońca."
  when "4"
    mes += "silnie czerwone zabarwienie chmur o zachodzie Słońca."
  when "5"
    mes += "zbieżność chmur CH w punkcie poniżej 45° tworzące się lub wzmagające."
  when "6"
    mes += "zbieżność chmur CH w punkcie powyżej 45° tworzące się lub wzmagające."
  when "7"
    mes += "zbieżność chmur CH w punkcie poniżej 45° zanikające lub słabnące."
  when "8"
    mes += "zbieżność chmur CH w punkcie powyżej 45° zanikające lub słabnące."
  else
    mes += "b/d."
  end
  mes += " Kierunek: #{code[4]}."
  $message += mes
end

def ninth_cloud_angle_group(code)
  mes = " [3.9.47]Rodzaj chmur: #{clouds_type[3]}"
  mes += " Kąt wzniesienia wierzchołka chmur nad horyzontem: "
  case code[4]
  when "0"
    mes += "górna część chmur niewidoczna."
  when "1"
    mes += "45° i więcej."
  when "2"
    mes += "około 30°."
  when "3"
    mes += "około 20°."
  when "4"
    mes += "około 15°."
  when "5"
    mes += "około 12°."
  when "6"
    mes += "około 9°."
  when "7"
    mes += "około 7°."
  when "8"
    mes += "około 6°."
  when "9"
    mes += "mniej niż 5°."
  else
    mes += "b/d."
  end
  $message += mes
end

def ninth_cloud_orogaphic_group(code)
  mes = " [3.9.48]Chmury orograficzne: "
  case code[3]
  when "1"
    mes += "pojedyncze chmury orograficzne , pileus, incus, tworzące się."
  when "2"
    mes += "pojedyncze chmury orograficzne , pileus, incus, bez zmian."
  when "3"
    mes += "pojedyncze chmury orograficzne , pileus, incus, zanikające."
  when "4"
    mes += "nieregularne ławice chmur orograficznych, ławica fenowa itp., tworzące się."
  when "5"
    mes += "nieregularne ławice chmur orograficznych, ławica fenowa itp., bez zmian."
  when "6"
    mes += "nieregularne ławice chmur orograficznych, ławica fenowa itp., zanikające."
  when "7"
    mes += "zwarta warstwa chmur orograficznych, ławica fenowa, tworzące się."
  when "8"
    mes += "zwarta warstwa chmur orograficznych, ławica fenowa, bez zmian."
  when "9"
    mes += "zwarta warstwa chmur orograficznych, ławica fenowa, zanikające."
  else
    mes += "b/d."
  end
  mes += " Kierunek: #{code[4]}."
  $message += mes
end

def ninth_cloud_vertical_group(code)
  mes = " [3.9.49]Charakter chmur o rozwoju pionowym: "
  case code[3]
  when "0"
    mes += "pojedyncze Cumulus humilis i/lub Cumulus mediocris."
  when "1"
    mes += "liczne Cumulus humilis i/lub Cumulus mediocris."
  when "2"
    mes += "pojedyncze Cumulus congestus."
  when "3"
    mes += "liczne Cumulus congestus."
  when "4"
    mes += "pojedyncze Cumulonimbus ."
  when "5"
    mes += "liczne Cumulonimbus."
  when "6"
    mes += "pojedyncze Cumulus i Cumulonimbus."
  when "7"
    mes += "liczne Cumulus i Cumulonimbus."
  else
    mes += "b/d."
  end
  mes += " Kierunek: #{code[4]}."
  $message += mes
end

def ninth_cloud_mountaians_group(code)
  mes = " [3.9.50]Stan zachmurzenia w górach i na przełęczach: "
  case code[3]
  when "0"
    mes += "góry całkowicie odsłonięte, występują tylko pojedyncze chmury."
  when "1"
    mes += "góry częściowo zasłonięte porozrzucanymi chmurami, co najmniej połowa wszystkich szczytów jest niewidoczna."
  when "2"
    mes += "zbocza gór całkowicie zasłonięte chmurami, szczyty i przełęcze odsłonięte."
  when "3"
    mes += "góry odsłonięte od strony obserwatora, jednak widoczna jest po przeciwnej stronie ciągła ściana chmur."
  when "4"
    mes += "chmury zalegają nisko nad górami, lecz wszystkie stoki i szczyty gór odsłonięte (mogą występować tylko pojedyncze chmury na zboczach)."
  when "5"
    mes += "chmury zalegają nisko nad górami, szczyty częściowo przesłonięte przez chmury lub smugi opadów."
  when "6"
    mes += "wszystkie szczyty zasłonięte lecz przełęcze wolne od chmur, zbocza gór zasłonięte lub odsłonięte."
  when "7"
    mes += "góry przeważnie zasłonięte przez chmury, jednak niektóre szczyty wolne od chmur, zbocza gór zasłonięte lub odsłonięte."
  when "8"
    mes += "wszystkie zbocza, szczyty i przełęcze zasłonięte przez chmury."
  when "9"
    mes += "góry niewidoczne z powodu ciemności, mgły, opadu itp."
  else
    mes += "b/d."
  end
  mes += " Rozwój chmur: #{cloud_progres(code[4])}"
  $message += mes
end

def ninth_fog_group(code)
  mes = " [3.9.51]Stan zachmurzenia i mgły poniżej stacji: "
  case code[3]
  when "0"
    mes += "brak chmur i zamglenia."
  when "1"
    mes += "zamglenie, nad nim pogodnie."
  when "2"
    mes += "płaty mgły."
  when "3"
    mes += "warstwa rzadkiej mgły."
  when "4"
    mes += "warstwa gęstej mgły."
  when "5"
    mes += "kilka odosobnionych chmur."
  when "6"
    mes += "odosobnione chmury, poniżej mgła."
  when "7"
    mes += "liczne odosobnione chmury."
  when "8"
    mes += "morze chmur."
  when "9"
    mes += "zła widzialność uniemożliwiająca obserwację ku dolinom."
  else
    mes += "b/d."
  end
  mes += " rozwój chmur: "
  case code[4]
  when "0"
    mes += "bez zmian."
  when "1"
    mes += "zachmurzenie malejące, chmury unoszą się."
  when "2"
    mes += "zachmurzenie malejące, wysokość chmur bez zmian."
  when "3"
    mes += "zachmurzenie bez zmian, chmury unoszą się."
  when "4"
    mes += "zachmurzenie maleje, chmury opadają."
  when "5"
    mes += "zachmurzenie wzrasta, chmury unoszą się."
  when "6"
    mes += "zachmurzenie bez zmian, chmury opadają."
  when "7"
    mes += "zachmurzenie wzrasta, wysokość chmur bez zmian."
  when "8"
    mes += "zachmurzenie wzrasta, chmury opadają."
  when "9"
    mes += "mgła z przerwami na stacji."
  else
    mes += "b/d."
  end
  $message += mes
end

def cloud_direct(x)
  case x
  when "1"
    mes = "bardzo nisko nad horyzontem."
  when "3"
    mes = "poniżej 30 stopni nad horyzontem."
  when "7"
    mes = "powyżej 30 stopni nad horyzontem."
  end
end

def ninth_cloud_max_concentration_group(code)
  $message += " [3.9.58]Wzniesienie nad horyzontem podstawy kowadła Cb lub wierzchołka innej chmury: #{cloud_direct(code[3])}"
  $message += " Kierunek: #{code[4]}"
end

def ninth_cloud_speed_group(code)
  mes = " [3.9.59]Prędkość przemieszczania się obiektu/zjawiska: "
  case code[3]
  when "0"
    mes += "< 5 węzłów         < 9 km/h           < 2 m/s."
  when "1"
    mes += "5 do 14 węzłów     10 do 25 km/h      3 do 7 m/s."
  when "2"
    mes += "15 do 24 węzłów    26 do 44 km/h      8 do 12 m/s."
  when "3"
    mes += "25 do 34 węzłów    45 do 62 km/h      13 do 17 m/s."
  when "4"
    mes += "35 do 44 węzłów    63 do 81 km/h      18 do 22 m/s."
  when "5"
    mes += "45 do 54 węzłów    82 do 100 km/h     23 do 27 m/s."
  when "6"
    mes += "55 do 64 węzłów    101 do 118 km/h    28 do 32 m/s."
  when "7"
    mes += "65 do 74 węzłów    119 do 137 km/h    33 do 38 m/s."
  when "8"
    mes += "75 do 84 węzłów    138 do 155 km/h    39 do 43 m/s."
  when "9"
    mes += "> 85 węzłów        > 156 km/h         > 44 m/s."
  end
  mes += " Kierunek: #{code[4]}."
  $message += mes
end

def ninth_adding_weather_group(code)
  mes = " [3.9.61]Zjawisko pogody bieżącej obserwowane jednocześnie: "
  case code[3..4]
  when "04"
    mes += "popiół wulkaniczny zawieszony wysoko w powietrzu."
  when "06"
    mes += "gęste zmętnienie pyłowe, widzialność < 1 km."
  when "07"
    mes += "pył wodny na stacji."
  when "08"
    mes += "wichura pyłowa (piaskowa)."
  when "09"
    mes += "ściana pyłu lub piasku w pewnej odległości od stacji."
  when "10"
    mes += "śnieżne zmętnienie."
  when "11"
    mes += "jednolita biel (granica między chmurami a pokrywą śnieżną nie do odróżnienia)."
  when "13"
    mes += "błyskawica z chmury do ziemi."
  when "17"
    mes += "burza bez opadu."
  when "19"
    mes += "trąba lądowa w polu widzenia w ostatniej godzinie lub w czasie obserwacji."
  when "20"
    mes += "osad popiołu wulkanicznego."
  when "21"
    mes += "osad pyłu lub piasku."
  when "22"
    mes += "rosa."
  when "23"
    mes += "osad mokrego śniegu."
  when "24"
    mes += "szadź miękka."
  when "25"
    mes += "szadź twarda."
  when "26"
    mes += "szron."
  when "27"
    mes += "gołoledź   ."
  when "28"
    mes += "skorupa lodowa (lód szklisty)."
  when "30"
    mes += "wichura pyłowa lub piaskowa w temperaturze < 0 st. C."
  when "39"
    mes += "zamieć wysoka, niemożliwe do określenia czy pada śnieg."
  when "41"
    mes += "mgła na morzu."
  when "42"
    mes += "mgła w dolinach."
  when "43"
    mes += "arktyczny lub antarktyczny dym na morzu."
  when "44"
    mes += "mgła z pary (nad morzem, jeziorem, rzeką)."
  when "45"
    mes += "mgła z pary (nad lądem)."
  when "46"
    mes += "mgła nad lodem lub pokrywą śnieżną."
  when "47"
    mes += "gęsta mgła, widzialność od 60 do 90 m."
  when "48"
    mes += "gęsta mgła, widzialność od 30 do 60 m."
  when "49"
    mes += "gęsta mgła, widzialność poniżej 30 m."
  when "50"
    mes += "mżawka, intensywność opadu: poniżej 0,1 mm/h."
  when "51"
    mes += "mżawka, intensywność opadu: 0,1 do 0,19 mm/h."
  when "52"
    mes += "mżawka, intensywność opadu: 0,2 do 0,39 mm/h."
  when "53"
    mes += "mżawka, intensywność opadu: 0,4 do 0,79 mm/h."
  when "54"
    mes += "mżawka, intensywność opadu: 0,8 do 1,59 mm/h."
  when "55"
    mes += "mżawka, intensywność opadu: 1,6 do 3,19 mm/h."
  when "56"
    mes += "mżawka, intensywność opadu: 3,2 do 6,39 mm/h."
  when "57"
    mes += "mżawka, intensywność opadu: powyżej 6,4 mm/h."
  when "59"
    mes += "mżawka ze śniegiem (ww - 68 lub 69)."
  when "60"
    mes += "deszcz, intensywność opadu: poniżej 1,0 mm/h."
  when "61"
    mes += "deszcz, intensywność opadu: 1,0 do 1,9 mm/h."
  when "62"
    mes += "deszcz, intensywność opadu: 2,0 do 3,9 mm/h."
  when "63"
    mes += "deszcz, intensywność opadu: 4,0 do 7,9 mm/h."
  when "64"
    mes += "deszcz, intensywność opadu: 8,0 do 15,9 mm/h."
  when "65"
    mes += "deszcz, intensywność opadu: 16,0 do 31,9 mm/h."
  when "66"
    mes += "deszcz, intensywność opadu: 32,0 do 63,9 mm/h."
  when "67"
    mes += "deszcz, intensywność opadu: powyżej 64,0 mm/h."
  when "70"
    mes += "śnieg, intensywność opadu: poniżej 1,0 cm/h."
  when "71"
    mes += "śnieg, intensywność opadu: 1,0 do 1,9 cm/h."
  when "72"
    mes += "śnieg, intensywność opadu: 2,0 do 3,9 cm/h."
  when "73"
    mes += "śnieg, intensywność opadu: 4,0 do 7,9 cm/h."
  when "74"
    mes += "śnieg, intensywność opadu: 8,0 do 15,9 cm/h."
  when "75"
    mes += "śnieg, intensywność opadu: 16,0 do 31,9 cm/h."
  when "76"
    mes += "śnieg, intensywność opadu: 32,0 do 63,9 cm/h."
  when "77"
    mes += "śnieg, intensywność opadu: powyżej 64,0 cm/h."
  when "78"
    mes += "opad śniegu lub kryształków lodu z bezchmurnego nieba."
  when "79"
    mes += "mokry śnieg zamarzający przy zetknięciu z powierzchnią."
  when "80"
    mes += "opad deszczu (ww - 87-99)."
  when "81"
    mes += "opad marznącego deszczu (ww - 80-82)."
  when "82"
    mes += "opad deszczu ze śniegiem ww - 26-27."
  when "83"
    mes += "opad śniegu ww - 26-27."
  when "84"
    mes += "opad krupy śnieżnej lub lodowej ww - 26-27."
  when "85"
    mes += "opad krupy śnieżnej lub lodowej z deszczem ww - 26-27."
  when "86"
    mes += "opad krupy śnieżnej lub lodowej i deszczem ze śniegiem ww - 68 lub 69."
  when "87"
    mes += "opad krupy śnieżnej lub lodowej ze śniegiem ww - 87-99."
  when "88"
    mes += "opad gradu ww - 87-99."
  when "89"
    mes += "opad gradu z deszczem ww - 87-99."
  when "90"
    mes += "opad gradu i deszczu ze śniegiem ww - 87-99."
  when "91"
    mes += "opad gradu ze śniegiem ww - 87-99."
  when "92"
    mes += "przelotny opad lub burza nad morzem."
  when "93"
    mes += "przelotny opad lub burza nad górami."
  end
  $message += mes
end

def ninth_intensivity_last_hour_group(code)
  $message += " [3.9.62]Intensyfikacja zjawiska w czasie poprzedniej godziny, lecz nie w czasie obserwacji: #{weather(code[3..4])}"
end

def ninth_intensivity_last_hour_two_group(code)
  $message += " [3.9.63]Intensyfikacja zjawiska w czasie poprzedniej godziny, lecz nie w czasie obserwacji: #{weather(code[3..4])}"
end

def ninth_intesivity_one_group(code)
  $message += " [3.9.64]Intensyfikacja zjawiska:  #{weather(code[3..4])}"
end

def ninth_intensivity_two_group(code)
  $message += " [3.9.65]Intensyfikacja zjawiska:  #{weather(code[3..4])}"
end

def ninth_six_six_group(code)
  $message += " [3.9.66]Zjawisko wystąpiło w czasie lub okresie określonym przed odpowiednie grupy czasowe:  #{weather(code[3..4])}"
end

def ninth_six_seven_group(code)
  $message += " [3.9.67]Zjawisko wystąpiło w czasie lub okresie określonym przed odpowiednie grupy czasowe:  #{weather(code[3..4])}"
end

def ninth_six_nine_six_group(code)
  $message += " [3.9.69]Deszcz/Śnieg/Opad przelotny na stacji nie związany z burzą w odległą, kierunek: #{code[4]}."
end

def ninth_seven_group(code)
  $message += " [3.9.70]Kierunek maksymalnej koncentracji zjawiska podanego pod: #{cloud_direct(code[3])}, kierunek #{code[4]}."
end

def ninth_seven_five_group(code)
  $message += " [3.9.75]Prędkość, z którego napływa zjawisko: #{code[3]}, kierunek #{code[4]}."
end

def ninth_eight_one_group(code)
  $message += " [3.9.81]Widzialność w kierunku NE: #{visibility_horizontal(code[3..4])}"
end

def ninth_eigth_two_group(code)
  $message += " [3.9.82]Widzialność w kierunku E: #{visibility_horizontal(code[3..4])}"
end

def ninth_eigth_three_group(code)
  $message += " [3.9.83]Widzialność w kierunku SE: #{visibility_horizontal(code[3..4])}"
end

def ninth_eight_four_group(code)
  $message += " [3.9.83]Widzialność w kierunku S: #{visibility_horizontal(code[3..4])}"
end

def ninth_eight_five_group(code)
  $message += " [3.9.85]Widzialność w kierunku SW: #{visibility_horizontal(code[3..4])}"
end

def ninth_eight_six_group(code)
  $message += " [3.9.86]Widzialność w kierunku W: #{visibility_horizontal(code[3..4])}"
end

def ninth_eight_seven_group(code)
  $message += " [3.9.87]Widzialność w kierunku NW: #{visibility_horizontal(code[3..4])} "
end

def ninth_eight_eigth_group(code)
  $message += " [3.9.88]Widzialność w kierunku N: #{visibility_horizontal(code[3..4])}"
end

def ninth_eight_nine_group(code)
  mes = " [3.9.89]Zmiana widzialności w ciągu godziny poprzedzającej obserwację: "
  case code[3]
  when "0"
    mes += "widzialność bez zmian (Słońce, Księżyc lub gwiazdy przeświecają przez mgłę)."
  when "1"
    mes += "widzialność bez zmian (Słońce, Księżyc lub gwiazdy nie przeświecają przez mgłę)."
  when "2"
    mes += "widzialność wzrosła (Słońce, Księżyc lub gwiazdy przeświecają przez mgłę)."
  when "3"
    mes += "widzialność wzrosła (Słońce, Księżyc lub gwiazdy nie przeświecają przez mgłę)."
  when "4"
    mes += "widzialność spadła (Słońce, Księżyc lub gwiazdy przeświecają przez mgłę)."
  when "5"
    mes += "widzialność spadła (Słońce, Księżyc lub gwiazdy nie przeświecają przez mgłę)."
  when "6"
    mes += "napływ mgły z kierunku podanego pod Da."
  when "7"
    mes += "mgła się uniosła nie rozrywając się."
  when "8"
    mes += "mgła porozrywała się."
  when "9"
    mes += "przemieszczanie się ławic z mgły."
  end
  $message += mes
end

def ninth_nine_zero_group(code)
  mes = " [3.9.90]Zjawiska optyczne: "
  case code[3]
  when "0"
    mes += "widmo Brockenu."
  when "1"
    mes += "tęcza."
  when "2"
    mes += "halo słoneczne lub księżycowe."
  when "3"
    mes += "słońca poboczne lub przeciwsłońce."
  when "4"
    mes += "słupy słoneczne."
  when "5"
    mes += "wieniec."
  when "6"
    mes += "zorza (poświata widziana w kierunku słońca przed jego wschodem i po zachodzie)."
  when "7"
    mes += "zorza na górach."
  when "8"
    mes += "miraż."
  when "9"
    mes += "światło zodiakalne."
  end
  $message += mes
end

def ninth_nine_one_group(code)
  mes = " [3.9.91]Miraż: "
  case code[3]
  when "0"
    mes += "bez określenia."
  when "1"
    mes += "uniesiony obraz odległego obiektu."
  when "2"
    mes += "wyraźnie uniesiony obraz odległego obiektu."
  when "3"
    mes += "odwrócony obraz odległego obiektu."
  when "4"
    mes += "złożone, zwielokrotnione obrazy odległego obiektu (obrazy nieodwrócone)."
  when "5"
    mes += "złożone, zwielokrotnione obrazy odległego obiektu (niektóre obrazy odwrócone)."
  when "6"
    mes += "wyraźne zniekształcenie słońca lub księżyca."
  when "7"
    mes += "słońce widoczne, choć astronomicznie znajduje się poniżej horyzontu."
  when "8"
    mes += "księżyc widoczny, choć astronomicznie znajduje się poniżej horyzontu."
  when "9"
    mes += "ognie Świętego Elma."
  end
  $message += mes
end

def ninth_nine_two_group(code)
  mes = " [3.9.92]Smugi kondensacyjne: "
  case code[3]
  when "5"
    mes += "nie utrzymujące się smugi kondensacyjne."
  when "6"
    mes += "smugi kondensacyjne utrzymujące się, pokrywają mniej niż 1/8 nieba."
  when "7"
    mes += "smugi kondensacyjne utrzymujące się, pokrywają mniej niż 2/8 nieba."
  when "8"
    mes += "smugi kondensacyjne utrzymujące się, pokrywają mniej niż 3/8 nieba."
  when "9"
    mes += "smugi kondensacyjne utrzymujące się, pokrywają więcej niż 3/8 nieba."
  end
  $message += mes
end

def ninth_nine_three_group(code)
  mes = " [3.9.93]Chmury specjalne: "
  case code[3]
  when "1"
    mes += "obłoki iryzujące."
  when "2"
    mes += "nocne obłoki świecące."
  when "3"
    mes += "chmury pochodzące z wodospadów."
  when "4"
    mes += "chmury pochodzące z pożarów."
  when "5"
    mes += "chmury pochodzące z wybuchów wulkanów."
  end
  $message += mes
end

def ninth_nine_five(code)
  $message += " [3.9.95]Najniższa wartość ciśnienia atmosferycznego zredukowana do poziomu morza: #{code[3..4]}."
end

def ninth_nine_six(code)
  $message += " [3.9.96]Nagły wzrost temperatury powietrza: #{code[3..4]} st. C."
end

def ninth_nine_seven(code)
  $message += " [3.9.97]Nagły spadek temperatury powietrza: #{code[3..4]} st. C."
end

def ninth_nine_eigth(code)
  $message += " [3.9.98]Nagły wzrost wilgotności względnej powietrza: #{code[3..4]}."
end

def ninth_nine_nine(code)
  $message += " [3.9.99]Nagły spadek wilgotności względnej powietrza: #{code[3..4]}."
end

def ninth_group(code)
  case code[1..2]
  when "00"
    ninth_time_group(code)
  when "01"
    ninth_ending_group(code)
  when "02"
    ninth_starting_group(code)
  when "03"
    ninth_changing_group(code)
  when "04"
    ninth_ending_next_group(code)
  when "05"
    ninth_start_next_group(code)
  when "06"
    ninth_start_nine_group(code)
  when "07"
    ninth_seventh_group(code)
  when "09"
    ninth_ninth_group(code)
  when "10"
    ninth_tenth_group(code)
  when "11"
    ninth_eleven_group(code)
  when "12"
    ninth_twleve_group(code)
  when "13"
    ninth_wind_medium_group(code)
  when "14"
    ninth_wind_minimal_group(code)
  when "15"
    ninth_wind_drection_group(code)
  when "16"
    ninth_wind_right_group(code)
  when "17"
    ninth_wind_left_group(code)
  when "18"
    ninth_storm_group(code)
  when "19"
    ninth_sea_twister_group(code)
  when "20"
    ninth_sea_group(code)
  when "21"
    ninth_sea_strong_group(code)
  when "22"
    ninth_sea_water_group(code)
  when "23"
    ninth_water_group(code)
  when "25"
    ninth_water_temp_group(code)
  when "26"
    ninth_frost(code)
  when "27"
    ninth_snow_group(code)
  when "28"
    ninth_snow_two_group(code)
  when "29"
    ninth_snow_storm(code)
  when "30"
    ninth_prec_sum_group(code)
  when "31"
    ninth_snow_fresh_group(code)
  when "32"
    ninth_hail_group(code)
  when "33"
    ninth_water_eq_group(code)
  when "34"
    ninth_glaze_group(code)
  when "35"
    ninth_frost_group(code)
  when "36"
    ninth_prec_mix_group(code)
  when "37"
    ninth_snow_wet_group(code)
  when "38"
    ninth_glaze_speed_group(code)
  when "39"
    ninth_measur_height_group(code)
  when "40"
    ninth_clouds_group(code)
  when "41"
    ninth_cloud_direction_group(code)
  when "42"
    ninth_cloud_concentration_direction_group(code)
  when "43"
    ninth_cloud_low_direction_group(code)
  when "44"
    ninth_cloud_low_concentration_direction_group(code)
  when "45"
    ninth_cloud_low_top_group(code)
  when "46"
    ninth_cloud_color_group(code)
  when "47"
    ninth_cloud_angle_group(code)
  when "48"
    ninth_cloud_orogaphic_group(code)
  when "49"
    ninth_cloud_vertical_group(code)
  when "50"
    ninth_cloud_mountaians_group(code)
  when "51"
    ninth_fog_group(code)
  when "58"
    ninth_cloud_max_concentration_group(code)
  when "59"
    ninth_cloud_speed_group(code)
  when "61"
    ninth_adding_weather_group(code)
  when "62"
    ninth_intensivity_last_hour_group(code)
  when "63"
    ninth_intensivity_last_hour_two_group(code)
  when "64"
    ninth_intesivity_one_group(code)
  when "65"
    ninth_intensivity_two_group(code)
  when "66"
    ninth_six_six_group(code)
  when "67"
    ninth_six_seven_group(code)
  when "69"
    ninth_six_nine_six_group(code)
  when "70"
    ninth_seven_group(code)
  when "71"
    ninth_seven_group(code)
  when "72"
    ninth_seven_group(code)
  when "73"
    ninth_seven_group(code)
  when "74"
    ninth_seven_group(code)
  when "75"
    ninth_seven_five_group(code)
  when "76"
    ninth_seven_five_group(code)
  when "77"
    ninth_seven_five_group(code)
  when "78"
    ninth_seven_five_group(code)
  when "79"
    ninth_seven_five_group(code)
  when "81"
    ninth_eight_one_group(code)
  when "82"
    ninth_eigth_two_group(code)
  when "83"
    ninth_eigth_three_group(code)
  when "84"
    ninth_eigth_four_group(code)
  when "85"
    ninth_eight_five_group(code)
  when "86"
    ninth_eight_six_group(code)
  when "87"
    ninth_eight_seven_group(code)
  when "88"
    ninth_eight_eigth_group(code)
  when "89"
    ninth_eight_nine_group(code)
  when "90"
    ninth_nine_zero_group(code)
  when "91"
    ninth_nine_one_group(code)
  when "92"
    ninth_nine_two_group(code)
  when "93"
    ninth_nine_three_group(code)
  when "94"
    ninth_nine_four_group(code)
  when "95"
    ninth_nine_five(code)
  when "96"
    ninth_nine_six(code)
  when "97"
    ninth_nine_seven(code)
  when "98"
    ninth_nine_eight(code)
  when "99"
    ninth_nine_nine(code)
  end
end

def fifth_five_seven_group(code)
  $message += " [5.5.7]Niedosyt wilgotności powietrza podawany z dokładnością do 0,1 hPa: #{code[2..4]}."
end

def fifth_five_five_group(code)
  $message += " [5.5.5]Średni niedosyt wilgotności powietrza: #{code[2..4]}."
end

def fifth_five_group(code)
  if code[0..1] == "55"
    fifth_five_five_group(code)
  elsif code[0..1] == "57"
    fifth_five_seven_group(code)
  end
end

def fifth_six_temperature_group(code)
  mes = " [5.6]Średnia temperatura dobowa z dnia bieżącego: "
  mes += "-" if code[1] == "1"
  mes += "#{code[2..3]}.#{code[4]}"
  $message += mes
end

def fifth_six_wind_group(code)
  $message += mes = " [5.6]Średnia prędkość wiatru: #{code[1..2]}, wilgotność względna powietrza w procentach: #{code[3..4]}."
end

def fifth_six_group(code)
  if (code[1] == "1") || (code[1] == "0")
    fifth_six_temperature_group(code)
  else
    fifth_six_wind_group(code)
  end
end

def fifth_seven_snow_group(code)
  $message += " [5.7]Zapas wody w śniegu: #{code[1..4]}"
end

def fifth_seven_temperature(code)
  mes = " [5.7]Absolutne maksimum temperatury powietrza: "
  mes += "-" if code[1] == "1"
  mes += "#{code[2..3]}.#{code[4]}"
  $message += mes
end

def fifth_seven_group(code)
  if (code[1] == "1") || (code[1] == "0")
    fifth_seven_temperature(code)
  else
    fifth_seven_snow_group(code)
  end
end

def fifth_eight_group(code)
  mes = " [5.8]Grubość świeżo spadłego śniegu lub narośniętej szadzi w cm: #{code[1..2]},"
  mes += " gatunek śniegu: "
  case code[3]
  when "1"
    mes += "śnieg puszysty, świeży."
  when "2"
    mes += "śnieg krupiasty, sypki, powstały z opadu krupy, drobnych ziaren śniegu, gradu itp.."
  when "3"
    mes += "śnieg zsiadły lub przewiany (suchy)."
  when "4"
    mes += "śnieg zbity, suchy (deska śnieżna, gips), często tylko miejscami."
  when "5"
    mes += "śnieg mokry (lepki)."
  when "6"
    mes += "śnieg o powierzchni zlodowaciałej, łamliwej (szreń)."
  when "7"
    mes += "śnieg o powierzchni zlodowaciałej, niełamliwej (lodoszreń)."
  when "8"
    mes += "pokrywa śnieżna ziarnista (duże, twarde kryształy powstałe na skutek rekrystalizacji)."
  when "9"
    mes += "warstwa szadzi o grubości ponad 2 cm na śniegu lub gruncie."
  end
  mes += " Ukształtowanie pokrywy śnieżnej: "
  case code[4]
  when "1"
    mes += "powierzchnia gładka (nie zachodzi przypadek e3 - 2 lub 3)."
  when "2"
    mes += "powierzchnia gładka: warstwa suchego śniegu na szreni lub lodoszreni nie grubsza niż 2 cm)."
  when "3"
    mes += "powierzchnia gładka lub sfalowana: pokrywa śnieżna pod względem gatunku niejednorodna."
  when "4"
    mes += "powierzchnia lekko sfalowana lub pomarszczona (nie zachodzi przypadek e3 - 5, 6 lub 7)."
  when "5"
    mes += "powierzchnia lekko sfalowana lub pomarszczona: warstwa suchego śniegu na szreni lub lodoszreni nie grubsza niż 2 cm)."
  when "6"
    mes += "powierzchnia lekko sfalowana lub pomarszczona: ostre twarde formy śnieżne wystające ponad powierzchnię."
  when "7"
    mes += "powierzchnia lekko sfalowana lub pomarszczona: wystające kamienie lub korzenie."
  when "8"
    mes += "powierzchnia nieregularna z zaspami: występuje tylko jeden gatunek śniegu."
  when "9"
    mes += "powierzchnia nieregularna z zaspami: między zaspami płytko leżące lub wystające kamienie, korzenie lub ostre formy lodowe: mogą występować różne gatunki śniegu."
  end
  $message += mes
end

def fifth_null_group(code)
  mes = " [5.0]Średnia temperatura gruntu na głębokości 5 cm: "
  mes += "-" if code[1] == "1"
  mes += "#{code[2..3]}.#{code[4]}"
  $message += mes
end

def fifth_first_group(code)
  mes = " [5.1]Najwyższa wartość temperatury gruntu na głębokości 5 cm: "
  mes += "-" if code[1] == "1"
  mes += "#{code[2..3]}.#{code[4]}"
  $message += mes
end

def fifth_second_group(code)
  mes = " [5.2]Najniższa wartość temperatury gruntu na głębokości 5 cm: "
  mes += "-" if code[1] == "1"
  mes += "#{code[2..3]}.#{code[4]}"
  $message += mes
end

def fifth_third_group(code)
  mes = " [5.3]Absolutne minimum temperatury na wysokości 5 cm nad pow. gruntu lub pokrywa śnieżną: "
  mes += "-" if code[1] == "1"
  mes += "#{code[2..3]}.#{code[4]}"
  $message += mes
end

def deepth(x)
  case x
  when "01"
    mes = "powierzchnia gruntu zamarznięta, termometry gruntowe na wszystkich głębokościach pokazują temperaturę dodatnią."
  when "04"
    mes = "powierzchnia gruntu rozmarznięta, termometr gruntowy na głębokości 5 cm pokazuje temperaturę ujemną (najbliższa powierzchni izoterma znajduje się na głęb. 1-4 cm)"
  when "00"
    mes = "izoterma 0 występuje na głębokości 100 cm."
  when "0/"
    mes = "izoterma 0 występuje na głębokości poniżej 100 cm."
  when "/0"
    mes = "grunt zamarznięty, głębokości położenia izotermy 0 nie wyznaczono."
  else
    mes = "izoterma 0 występuje na głębokości #{x} cm."
  end
end

def fifth_fourth_group(code)
  mes = " [5.4]Głębokość najniżej położonej izotermy 0 w gruncie: #{deepth(code[1..2])}"
  mes += " Głębokość izotermy 0 położonej najbliżej powierzchni gruntu: #{deepth(code[3..4])}"
  $message += mes
end
