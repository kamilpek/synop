# Synoptyk

## Uruchomienie
* sudo docker network create --driver=bridge kps
* sudo docker run --name postgres_db -e POSTGRES_PASSWORD=super_secure --net=kps -d postgres
* sudo docker-compose build app
* sudo docker-compose run --rm app rake db:create db:migrate db:seed RAILS_ENV=production
* sudo docker-compose run --rm app rake import_stations RAILS_ENV=production
* sudo docker-compose run --rm app rake import_yrno RAILS_ENV=production
* sudo docker-compose run --rm app rake import_imgw_xml RAILS_ENV=production
* sudo docker-compose up -d app

## Wersja
* v2.6.14 z dnia 16.07.2018

## Autor
[Kamil Pek](https://github.com/kamilpek)
