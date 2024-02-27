#!/bin/bash
set -e

rm -f /app/tmp/pids/server.pid


echo "Iniciando o servidor Rails..."
bundle exec rails server -b '0.0.0.0'
