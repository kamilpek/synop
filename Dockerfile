FROM ruby:2.3.1

RUN apt-get update -yqq \
  && apt-get install -yqq --no-install-recommends \
    postgresql-client \
    nodejs \
    qt5-default \
    libqt5webkit5-dev \
    graphviz \
    cron \
    vim \
  && apt-get -q clean \
  && rm -rf /var/lib/apt/lists

RUN cp /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
WORKDIR /usr/src/app
CMD touch /log/cron.log
COPY Gemfile* ./
RUN bundle install
COPY . .
RUN bundle exec whenever --update-crontab
CMD cron
