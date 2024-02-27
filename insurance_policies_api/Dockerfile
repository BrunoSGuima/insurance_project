FROM ruby:3.2.2 AS base


ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get install -y \
  libpq-dev \ 
  postgresql-client \ 
  nodejs \ 
  npm \ 
  && npm install -g yarn \ 
  && apt-get clean \ 
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


WORKDIR /app


COPY Gemfile* /app/


RUN bundle install


COPY . /app


EXPOSE 3000


COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]


CMD ["rails", "server", "-b", "0.0.0.0"]
