#!/bin/bash
set -e

rm -f /app/tmp/pids/server.pid


echo "Starting Rails server..."
bundle exec rails server -b '0.0.0.0'
