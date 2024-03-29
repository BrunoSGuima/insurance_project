#!/bin/bash
set -e


wait_for_postgres() {
  echo "Waiting PostgreSQL..."
  until PGPASSWORD=$POSTGRES_PASSWORD psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c '\q' 2>/dev/null; do
    >&2 echo "PostgreSQL is unavailable - waiting..."
    sleep 1
  done
  >&2 echo "PostgreSQL is ready."
}


export POSTGRES_USER=postgres
export POSTGRES_PASSWORD=password
export POSTGRES_DB=primarydb
export POSTGRES_HOST=postgres


wait_for_postgres


rm -f /app/tmp/pids/server.pid

echo "Starting Rails server..."
bundle exec rails server -b '0.0.0.0'
