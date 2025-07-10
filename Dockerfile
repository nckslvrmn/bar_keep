FROM ruby:3.4
LABEL org.opencontainers.image.source="https://github.com/nckslvrmn/bar_keep"
LABEL org.opencontainers.image.description="Bar Keep: A simple inventory manager for your home bar"
LABEL org.opencontainers.image.licenses=MIT

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
