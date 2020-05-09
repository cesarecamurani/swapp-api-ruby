FROM ruby:2.7

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install --path=vendor/cache

COPY . .

EXPOSE 3000

CMD rails server -b 0.0.0.0