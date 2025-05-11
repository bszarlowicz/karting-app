FROM ruby:3.2.3

# Instalacja zależności systemowych
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    default-mysql-client

# Ustawienie katalogu roboczego
WORKDIR /app

# Kopiowanie plików Gemfile
COPY Gemfile Gemfile.lock ./

# Instalacja gemów
RUN bundle install

# Kopiowanie reszty aplikacji
COPY . .

# Dodanie skryptu entrypoint.sh
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# Ustawienie skryptu jako punktu wejścia
ENTRYPOINT ["entrypoint.sh"]

# Uruchomienie Rails serwera przy starcie kontenera
CMD ["rails", "server", "-b", "0.0.0.0"]