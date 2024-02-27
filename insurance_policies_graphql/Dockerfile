FROM ruby:3.2 AS base

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .


CMD ["rails", "server", "-b", "0.0.0.0"]
