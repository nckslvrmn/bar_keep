FROM ruby:3.4

WORKDIR /app

ARG RAILS_ENV
ENV RAILS_ENV=${RAILS_ENV:-production}

ARG SECRET_KEY_BASE
ENV SECRET_KEY_BASE=${SECRET_KEY_BASE}

ENV BUNDLE_WITHOUT=development:test

RUN gem install bundler

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN bundle exec rails assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
