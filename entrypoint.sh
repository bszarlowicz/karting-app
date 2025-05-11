#!/bin/bash
set -e

# Usunięcie server.pid, jeśli istnieje
rm -f /app/tmp/pids/server.pid

# Oczekiwanie na dostępność bazy danych
# until mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD -e "SELECT 1"; do
#   echo "Waiting for MySQL to be ready..."
#   sleep 2
# done

# Wykonanie migracji bazy danych
echo "Running database migrations..."
bundle exec rails db:migrate

# Uruchomienie komendy przekazanej do skryptu
exec "$@"