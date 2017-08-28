FROM ruby:2.4.1

ENV WD /var/www/thinknetica
WORKDIR ${WD}
COPY . $WD

RUN apt-get update && apt-get install -y curl libpq-dev libxml2-dev libxslt-dev libffi-dev libv8-dev && \
    curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get install -y nodejs && \
    gem install bundler

COPY Gemfile $WD
COPY Gemfile.lock $WD

RUN bundle install

EXPOSE 3000

CMD ["sh", "-c", "puma --config ${WD}/config/puma/${RAILS_ENV}.rb"]
