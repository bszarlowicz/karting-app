# Karting App Backend - Ruby on Rails

To jest backendowa część aplikacji Karting App, zbudowana w oparciu o Ruby on Rails (wersja 7), pełniąca rolę REST API dla klienta frontendowego (React).

---

## Technologie
Ruby on Rails 7

- MySQL jako baza danych
- Devise + JWT do uwierzytelniania użytkowników
- Active Storage do obsługi przesyłania plików

---

## Wymagania systemowe
- Ruby 3.x
- Rails 7.x
- MySQL
- Node.js

---

## Instalacja

Sklonuj repozytorium:

```bash
git clone <URL_REPO>
cd <nazwa-folderu>
```

Zainstaluj zależności:
```bash
bundle install
```
Stwórz bazę danych i załaduj schemat:
```bash
rails db:create db:migrate db:seed
```

Uruchom serwer:
```bash
rails s
```