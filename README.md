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

## Ostrzeżenia meteo
```bash
curl http://localhost:3000/api/v1/alerts.json?access_token=f04e31f2a69a7eedc293cea8a107ae3e
```

## Wersja produktu
* v2.14.0 z dnia 05.04.2020

## Autor
[Kamil Pek](https://github.com/kamilpek)
