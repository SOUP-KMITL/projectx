FROM ruby:2.1.3
MAINTAINER Saran Siriphantnon <deoxen0n2@gmail.com>

RUN mkdir /usr/src/app
WORKDIR /usr/src/app

ONBUILD COPY Gemfile /usr/src/app/
ONBUILD COPY Gemfile.lock /usr/src/app/

ONBUILD RUN bundle install

ONBUILD COPY . /usr/src/app

RUN apt-get update && apt-get install -y sqlite3 libsqlite3-dev

EXPOSE 5000

CMD ["rackup", "-E", "production", "-o", "0.0.0.0", "-p", "5000"]
