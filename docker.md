# Docker

Start sieci
```bash
sudo docker network create --driver=bridge kps
```

Start bazy danych
```bash
sudo docker-compose up -d postgres_db
sudo docker run --name postgres_db -e POSTGRES_PASSWORD=super_secure --net=kps -d postgres
#
sudo docker start postgres_db
```
Budowa aplikacji
```bash
sudo docker-compose build app
```

Tworzenie bazy i uruchomienie migracji
```bash
sudo docker-compose run --rm app rake db:create db:migrate RAILS_ENV=production
sudo docker-compose run --rm app rake db:create db:migrate RAILS_ENV=development
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

Uruchomienie aplikacji
```bash
sudo docker-compose up -d app
```

Przejście do konsoli w aplikacji
```bash
sudo docker-compose exec app bash
```

Startowanie/Wygaszanie aplikacji
```bash
sudo docker-compose start/stop
```

Czyszczenie obrazów dockera
```bash
sudo docker rmi --force $(sudo docker images | grep "^<none>" | awk "{print $3}")
```
