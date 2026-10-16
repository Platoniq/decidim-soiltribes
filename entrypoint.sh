#!/bin/bash

set -e

echo "🔍 Checking if the database exists..."
if ! bundle exec rails db:exists >/dev/null 2>&1; then
  echo "⚠️ Database does not exist. Creating the database..."
  bundle exec rails db:create
  echo "✅ Database created"
else
  echo "✅ Database already exists"
fi

echo "🔄 Running database migrations..."
bundle exec rails db:migrate
echo "✅ Migrations are all up to date"

# Decidim ships data migrations alongside schema ones, and its release notes ask
# for both. Without this they were never run: the data migrations table did not
# exist and the whole 0.30 -> 0.31 set was outstanding.
echo "🔄 Running data migrations..."
bundle exec rails data:migrate
echo "✅ Data migrations are all up to date"

echo "🚀 Starting Rails server..."
exec "$@"
