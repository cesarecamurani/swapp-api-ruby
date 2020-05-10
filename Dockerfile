FROM ruby:2.7

RUN mkdir /app
WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
COPY vendor /app/vendor

RUN bundle install --local

COPY . /app

EXPOSE 3000

CMD bundle exec puma -C config/puma.rb