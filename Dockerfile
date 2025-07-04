FROM ruby:3.4

WORKDIR /app

ARG RAILS_ENV
ENV RAILS_ENV=${RAILS_ENV:-production}

ENV BUNDLE_WITHOUT=development:test

RUN apt-get update && apt-get install -y \
    librsvg2-bin \
    && rm -rf /var/lib/apt/lists/*

RUN gem install bundler

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN chmod +x bin/docker-entrypoint

EXPOSE 3000

ENTRYPOINT ["bin/docker-entrypoint"]
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
