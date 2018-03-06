# Synoptyk

## metar
[http://ogimet.com/ultimos_synops2.php?estado=Pola&fmt=html&Enviar=Ver](http://ogimet.com/ultimos_synops2.php?estado=Pola&fmt=html&Enviar=Ver)

html_doc = Nokogiri::HTML(open("http://ogimet.com/ultimos_synops2.php?estado=Pola&fmt=html&Enviar=Ver"))
html_doc.xpath('//table').xpath('//table').xpath('//tr')

```ruby
rails generate scaffold metar_station name:string number:integer latitude:float longitude:float elevation:integer status:boolean
rails generate scaffold metar_raport station:integer day:integer hour:integer metar:string message:text --no-timestamps
```
