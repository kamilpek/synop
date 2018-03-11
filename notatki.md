# Synoptyk

## metar
[http://ogimet.com/ultimos_synops2.php?estado=Pola&fmt=html&Enviar=Ver](http://ogimet.com/ultimos_synops2.php?estado=Pola&fmt=html&Enviar=Ver)

html_doc = Nokogiri::HTML(open("http://ogimet.com/ultimos_synops2.php?estado=Pola&fmt=html&Enviar=Ver"))
html_doc.xpath('//table').xpath('//table').xpath('//tr')

```ruby
rails generate scaffold metar_station name:string number:integer latitude:float longitude:float elevation:integer status:boolean
rails generate scaffold metar_raport station:integer day:integer hour:integer metar:string message:text --no-timestamps
rails generate migration AddCreatedToMetarRaports created_at:datetime
```

## powietrze
* [lista stacji](http://api.gios.gov.pl/pjp-api/rest/station/findAll)
* [sensory](http://api.gios.gov.pl/pjp-api/rest/station/sensors/740)
* [dane pomiarowe](http://api.gios.gov.pl/pjp-api/rest/data/getData/4817)
* [indeksy](http://api.gios.gov.pl/pjp-api/rest/aqindex/getIndex/740)

```ruby
rails generate scaffold gios_station name:string latitude:float longitude:float number:integer city:string address:string
rails generate scaffold gios_measurments station:integer calc_date:datetime st_index:integer co_index:integer pm10_index:integer c6h6_index:integer no2_index:integer pm25_index:integer o3_index:integer so2_index:integer co_value:float pm10_value:float c6h6_value:float no2_value:float pm25_value:float o3_value:float so2_value:float co_date:datetime pm10_date:datetime c6h6_date:datetime no2_date:datetime pm25_date:datetime o3_date:datetime so2_date:datetime --no-timestamps
```
