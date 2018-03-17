# Synoptyk

## metar
[http://ogimet.com/ultimos_synops2.php?estado=Pola&fmt=html&Enviar=Ver](http://ogimet.com/ultimos_synops2.php?estado=Pola&fmt=html&Enviar=Ver)

html_doc = Nokogiri::HTML(open("http://ogimet.com/ultimos_synops2.php?estado=Pola&fmt=html&Enviar=Ver"))
html_doc.xpath('//table').xpath('//table').xpath('//tr')

```ruby
rails generate scaffold metar_station name:string number:integer latitude:float longitude:float elevation:integer status:boolean
rails generate scaffold metar_raport station:integer day:integer hour:integer metar:string message:text --no-timestamps
rails generate migration AddCreatedToMetarRaports created_at:datetime
rails generate migration AddParamsToMetarRaports visibility:string cloud_cover:string wind_direct:string wind_speed:string temperature:string pressure:string situation:string

\copy (select name, number, latitude, longitude, elevation from metar_stations) To 'stacje_metar.csv' With CSV HEADER
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

## dane hydrologiczne
```ruby
rails generate scaffold hydro_station name:string number:integer longitude:float latitude:integer river:string
rails generate scaffold hydro_measurments station:number water:integer water_date:datetime temperature:float temperature_date:datetime ice:integer ice_date:datetime encroach:integer encroach_date:datetime
```

## gminy
```ruby
rails generate scaffold city province:integer county:integer commune:integer genre:integer name:string name_add:string longitude:float latitude:float --no-timestamps

\copy (select * from cities where longitude is null) To 'terc_empty.csv' With CSV HEADER
delete from cities where longitude is null;
select * from cities where longitude is null;
select count(id) from cities where longitude is not null;
select count(id) from cities where longitude is null;
select * from cities order by province, county, commune, genre;
\copy (select province, county, commune, genre, name, name_add, longitude, latitude from cities order by province asc, county asc, commune asc, name asc, genre asc) To 'terc.csv' With CSV HEADER

http://api.geonames.org/findNearbyPlaceName?lat=51.1443537&lng=16.2427819&username=kamilpek
http://api.geonames.org/get?geonameId=3093691&username=kamilpek&style=full
http://www.yr.no/place/Poland/Lower Silesia/Legnickie Pole/forecast.xml

encoded_url = URI.encode("http://www.yr.no/place/Poland/Lower%20Silesia/Osiedle%20M%C5%82odych/forecast.xml")
url = URI.parse("http://www.yr.no/place/Poland/Lower%20Silesia/Osiedle%20M%C5%82odych/forecast.xml")
url = URI.parse("http://www.yr.no/place/Poland/Lower%20Silesia/L%C4%85dek-Zdr%C3%B3j/forecast.xml")
req = Net::HTTP.new(url.host, url.port)
res = req.request_head(url.path)
res.code

```
