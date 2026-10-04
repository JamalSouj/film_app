# 🎬 Film App

A cinematic movie & TV show streaming application built with **Flutter**, featuring a modern and responsive UI, seamless streaming, and an architecture ready for scale.

## 📐 Architecture

This project strictly follows the **Clean Architecture** pattern to ensure separation of concerns, testability, and maintainability. The codebase is organized by features, with the core media logic separated into distinct layers:

- **Domain Layer**: Contains pure business logic and entities (`Media`, `MovieDetail`, `TvDetail`) completely independent of external libraries or frameworks. Includes Use Cases (e.g., `GetTrendingMedia`, `SearchMedia`) and Repository interfaces.
- **Data Layer**: Responsible for data retrieval and API communication. Contains Data Models with mapping logic (`fromJson` / `toEntity`), Remote Data Sources using `Dio`, and the implementation of the Domain Repositories.
- **Presentation Layer**: The UI and State Management layer organized by feature (`home`, `search`, `details`, `player`). It uses **Riverpod** for robust dependency injection and reactive state management.

## 🚀 Technologies Used

- **Framework**: Flutter (Dart)
- **State Management & DI**: [Riverpod](https://riverpod.dev/) (`flutter_riverpod`)
- **Networking**: [Dio](https://pub.dev/packages/dio)
- **Routing**: [go_router](https://pub.dev/packages/go_router)
- **Video Player**: `flutter_inappwebview` for embedded streaming servers
- **Local Storage**: [Hive](https://docs.hivedb.dev/)
- **UI/UX Helpers**:
  - `cached_network_image` for performant image caching
  - `shimmer` for skeleton loading states
  - `google_fonts` for premium typography (Inter)

## 🛠 Getting Started

### Prerequisites
- Flutter SDK (`^3.10.8`)
- Dart SDK
- API keys (if using TMDB API, place them in your `.env` file)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/JamalSouj/film_app.git
   cd film_app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## 📂 Project Structure

```text
lib/
 ├── core/
 │    ├── constants/       # App-wide constants and configurations
 │    ├── network/         # Base Dio client
 │    ├── router/          # GoRouter configuration
 │    ├── theme/           # App colors and dimensions
 │    └── utils/           # Helper functions
 └── features/
      ├── media/           # Core Data & Domain logic (Clean Architecture)
      │    ├── data/       # Models, Data Sources, Repositories Impl
      │    ├── domain/     # Entities, Repositories (Interface), Use Cases
      │    └── presentation# Shared core providers
      ├── home/            # Home screen UI and specific providers
      ├── search/          # Search UI with debouncing
      ├── details/         # Movie & TV show details and seasons
      └── player/          # Web-view based streaming player
```

## 📄 License

This project is open-source and available under the MIT License.
