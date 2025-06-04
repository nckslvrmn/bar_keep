FROM ruby:3.4

WORKDIR /app

# Set Rails environment to production
ENV RAILS_ENV=production
ENV BUNDLE_WITHOUT=development:test

RUN gem install bundler

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

# Precompile assets for production
RUN bundle exec rails assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
