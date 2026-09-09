# CineTrack

A small Flutter app on top of the TMDB API. Browse what is trending, search for a movie, open the details, and save it to a watchlist that works offline.


## Screens

- **Trending** – today's trending movies, infinite scroll, pull to refresh.
- **Search** – results show after you stop typing, not on every letter.
- **Details** – poster, backdrop, rating, genres, runtime, overview, and a row of similar movies. Header collapses on scroll.
- **Watchlist** – swipe left to remove, undo from the snackbar. Works with no internet.
- **Settings** – Dark, Light or System theme, remembered between launches.

Every screen has a loading, empty and error state.

## How to run

You need Flutter 3.44+ and a free TMDB token. Get the token at https://developer.themoviedb.org → Settings → API → **API Read Access Token** (the long one starting with `eyJ`).

```
git clone https://github.com/LanyaJamal/cinetrack.git
cd cinetrack
cp env.example.json env.json
```

Paste your token into `env.json`, then:

```
flutter pub get
flutter run --dart-define-from-file=env.json
```

`env.json` is git-ignored so the token stays on your machine. In VS Code the launch config already passes the flag, just press F5.

About the Flutter version: the brief said 3.32+. The current `flutter_riverpod`, `cached_network_image` and `shared_preferences` need Dart 3.12, which ships with Flutter 3.44, so that is the minimum here. Developed on 3.47.0.

## State management

**Riverpod 3**, no code generation.

I picked it because it does state and dependency injection together. Every class that talks to the network or storage has a provider, screens only read providers, and `AsyncValue` gives me loading / data / error without extra flags.

- Trending → `AsyncNotifier` (movies, page, `loadMore()`, `refresh()`)
- Search → `Notifier<String>` for the debounced query + a `FutureProvider` that runs it
- Details → `FutureProvider.family` by movie id
- Watchlist → `Notifier<List<MovieModel>>`, updates the UI first, writes to disk after
- Theme → `Notifier<ThemeMode>` saved in shared preferences

## Structure

```
lib/src/
  app/        MaterialApp, themes, routes
  core/       api, http client, errors, Result<T>, storage, theme, shared widgets
  features/   movies, watchlist, settings, home
```

Each feature has `data` and `presentation`. The rule everywhere: the data source throws, the repository catches and returns a `Result<T>`, the notifier turns it into an `AsyncValue`, the widget only reads providers.

Errors are a sealed `ApiFailure` (network, unauthorized, not found, server, parse, unknown), so the `switch` that picks the message has to handle every case.

## Watchlist offline

Saved with `shared_preferences` as one JSON list. Reading is synchronous, so the tab never shows a spinner. Enough for a personal list; `sqflite` would be the choice if it needed thousands of rows or queries.

## Packages

`flutter_riverpod`, `http`, `cached_network_image`, `shared_preferences`. That is all.
