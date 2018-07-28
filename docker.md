# Docker for synop

Start sieci
```bash
sudo docker network create --driver=bridge kps
```

Start bazy danych
```bash
sudo docker start postgres_db
sudo docker run --name postgres_db -e POSTGRES_PASSWORD=super_secure --net=kps -d postgres
```

Budowa aplikacji
```bash
sudo docker-compose build app
```

Tworzenie bazy i uruchomienie migracji
```bash
sudo docker-compose run --rm app rake db:create db:migrate db:seed RAILS_ENV=production
sudo docker-compose run --rm app rake db:migrate RAILS_ENV=production
sudo docker-compose run --rm app rake db:create db:migrate db:seed RAILS_ENV=development
sudo docker-compose run --rm app rake db:drop RAILS_ENV=production DISABLE_DATABASE_ENVIRONMENT_CHECK=1
```

Pobieranie danych z API
```bash
sudo docker-compose run --rm app rake import_stations RAILS_ENV=production
sudo docker-compose run --rm app rake import_yrno RAILS_ENV=production
sudo docker-compose run --rm app rake import_imgw_xml RAILS_ENV=production
sudo docker-compose run --rm app rake import_gios_stations RAILS_ENV=production
sudo docker-compose run --rm app rake import_gios_measur RAILS_ENV=production
sudo docker-compose run --rm app rake import_stations_metar RAILS_ENV=production
Rscript lib/tasks/ogimet.R
sudo docker-compose run --rm app rake import_radar RAILS_ENV=production
sudo docker-compose run --rm app rake import_stations_gw RAILS_ENV=production
sudo docker-compose run --rm app rake import_gw RAILS_ENV=production
```

Tworzenie użytkownika
```bash
sudo docker-compose run --rm app rake create_user RAILS_ENV=production
sudo docker-compose run --rm app rake create_user RAILS_ENV=development
```

Kompilowanie asstesów
```bash
sudo docker-compose run --rm app rake assets:precompile RAILS_ENV=production
```

Uruchomienie zaplanowanych zadań
```bash
sudo docker-compose run --rm app whenever --update-crontab
sudo docker-compose run --rm app crontab -l
sudo docker-compose run --rm app service cron status
sudo docker-compose run --rm app /etc/init.d/cron start
```

Uruchomienie aplikacji
```bash
sudo docker-compose up -d app
```

Przejście do konsoli rails
```bash
sudo docker-compose run app rails console -e production
```

Przejście do konsoli R
```bash
sudo docker-compose run app R
```

Przejście do konsoli w aplikacji
```bash
sudo docker-compose exec app bash
```

Startowanie/Wygaszanie aplikacji
```bash
sudo docker-compose start/stop
```

Kopia zapasowa bazy danych
```bash
sudo docker exec postgres_db pg_dump -U postgres -c -C -O --inserts solectwo_production > "solectwo-2018-02-05.sql"
sudo docker exec postgres_db pg_dump -U postgres -c -C -O --inserts synop_production > "synop-2018-03-14.sql"
cat synop-2018-07-28.sql | sudo docker exec -i postgres_db psql -U postgres
```

Czyszczenie obrazów dockera
```bash
sudo docker rmi --force $(sudo docker images | grep "^<none>" | awk "{print $3}")
```
