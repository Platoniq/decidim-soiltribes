FROM ruby:3.3.4-slim
ENV DEBIAN_FRONTEND=noninteractive \
  RAILS_ENV=production \
  BUNDLE_WITHOUT=development:test \
  BUNDLE_DEPLOYMENT=true \
  BUNDLE_PATH=/usr/local/bundle
RUN apt-get update && apt-get install -y \
  build-essential \
  curl \
  git \
  libssl-dev \
  zlib1g-dev \
  p7zip \
  libpq-dev \
  libicu-dev \
  imagemagick \
  wkhtmltopdf \
  && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /etc/apt/keyrings && \
  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
  echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_18.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
  apt-get update && apt-get install -y nodejs && \
  curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarnkey.gpg >/dev/null && \
  echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install -y yarn
WORKDIR /app
COPY Gemfile /app
COPY Gemfile.lock /app
RUN bundle install --without development test
COPY package.json /app
COPY package-lock.json /app
RUN npm ci
COPY . /app

# Two-step asset precompilation that avoids database connections
# Step 1: Compile Shakapacker assets directly without Rails
RUN RAILS_ENV=production NODE_ENV=production ./bin/shakapacker

# Step 2: Compile non-Shakapacker assets with DATABASE_URL pointing to non-existent db
RUN RAILS_ENV=production DATABASE_URL="postgresql://user:pass@127.0.0.1:5432/non_existent_db" \
    DISABLE_DATABASE_ENVIRONMENT_CHECK=1 SECRET_KEY_BASE=build \
    bundle exec rake assets:precompile --trace || true

RUN rm -rf node_modules tmp/cache && \
  apt-get autoremove -y && apt-get clean
EXPOSE 3000
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
HEALTHCHECK CMD curl -f http://localhost:3000/api || exit 1
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
