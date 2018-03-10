FROM ruby:2.3.1

RUN apt-get update -yqq \
  && apt-get install -yqq --no-install-recommends \
    postgresql-client \
    nodejs \
    qt5-default \
    libqt5webkit5-dev \
    graphviz \
    vim \
    r-base r-base-dev \
  && apt-get -q clean \
  && rm -rf /var/lib/apt/lists

RUN apt-get update
RUN apt-get install -y locales locales-all
ENV LC_ALL pl_PL.UTF-8
ENV LANG pl_PL.UTF-8
ENV LANGUAGE pl_PL.UTF-8
WORKDIR /usr/src/app
COPY Gemfile* ./
RUN bundle install
COPY . .
