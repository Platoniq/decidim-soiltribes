#!/bin/bash

set -e

echo "🔍 Checking if the database exists..."
if ! bundle exec rails db:exists >/dev/null 2>&1; then
  echo "⚠️ Database does not exist. Creating the database..."
  bundle exec rails db:create
  echo "✅ Database created"
  echo "Loading schema"
  bundle exec rails db:schema:load

else
  echo "✅ Database already exists"
fi

echo "🔄 Running database migrations..."
bundle exec rails db:migrate
echo "✅ Migrations are all up to date"

echo "🚀 Starting Rails server..."
exec "$@"
