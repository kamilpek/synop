# Synoptyk

## Wstęp
Rejestr danych ze stacji pogodowych polskiego [IMGW](http://www.imgw.pl/) oraz prognoz Norweskiego [yr.no](https://www.yr.no/).

## Plik csv ze stacjami meteo
[stacje.csv](https://github.com/kamilpek/synop/blob/master/stacje.csv)

## Specyfikacja zależności
* Ruby v2.3.1
* Rails v5.0.2
* PostgreSQL v9.5.7
* Bootstrap v3.3.7
* JSAPI

## Uruchomienie
* sudo docker network create --driver=bridge kps
* sudo docker run --name postgres_db -e POSTGRES_PASSWORD=super_secure --net=kps -d postgres
* sudo docker-compose build app
* sudo docker-compose run --rm app rake db:create db:migrate db:seed RAILS_ENV=production
* sudo docker-compose run --rm app rake import_stations RAILS_ENV=production
* sudo docker-compose run --rm app rake import_yrno RAILS_ENV=production
* sudo docker-compose run --rm app rake import_imgw_xml RAILS_ENV=production
* sudo docker-compose up -d app

## Wersja produktu
* v2.6.6 z dnia 04.07.2018

## Autor
[Kamil Pek](https://github.com/kamilpek)
