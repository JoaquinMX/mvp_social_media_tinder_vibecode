# Group Activity Swipe App

## Overview
The Group Activity Swipe App is a Flutter-based mobile application that helps friends decide what to do together. Inspired by the Tinder swipe interaction, each user can swipe right to accept or left to reject events drawn from multiple categories such as movies, places, and videogames. The system aggregates individual preferences to surface unanimous or partial matches so groups can quickly agree on plans.

## Core Features
- **Group-based decision making**: Require at least two members per group, support configurable partial match thresholds for larger groups, and let undecided users revisit their choices.
- **Swipe interaction**: Present events in a card deck that users swipe right (yes) or left (no) while optionally supplying predefined rejection reasons (Expensive, Too far, Not interested, Other).
- **Multi-category events**: Source activities from Google Places (via Places API + MapLibre for visualization), movies from TMDB, and videogames from IGDB, with a unified data model for consistent presentation.
- **Match curation**: Display separate lists for full matches (everyone said yes) and partial matches that need reconsideration by specific members.
- **Map-powered places**: Preview location cards with MapLibre and ready-to-wire Google Places IDs.
- **Simulated group consensus**: Deterministic simulator generates other members' votes so the full/partial match flows can be exercised end-to-end before the realtime backend is ready.
- **Advanced filtering**: Configure maximum price, movie runtime ceilings, and preferred videogame platforms to tailor the swipe deck before the backend persists preferences.

## Architecture
- **Presentation**: Material 3 UI split into feature directories (`onboarding`, `categories`, `swipe`, `matches`, `events`). Widgets consume Riverpod providers instead of stateful singletons.
- **State management**: `appFlowController` coordinates navigation stages, `swipeDeckController` orchestrates event queues, and match providers compute derived results. A `ProviderLogger` observer is wired for future analytics.
- **Data layer**: `MockEventRepository` hydrates cards from `assets/data/events.json` with normalized models. Replace with real API clients once credentials are available.
- **Filtering**: A dedicated `EventFiltersController` drives Riverpod-powered filter state that is applied during repository fetches and summarised in the swipe UI.
- **Domain models**: Equatable types (`GroupSettings`, `Event`, `SwipeDecision`, `MatchResult`) encapsulate business logic and power deterministic unit tests.
- **Testing**: `test/match_calculator_test.dart` validates match thresholds and reason handling. Expand with widget/integration tests as APIs solidify.

## Running locally
1. Install Flutter 3.19+ and enable the desired platforms (`flutter config --enable-{ios,android,web}` as needed).
2. Fetch dependencies and generate artifacts: `flutter pub get` and `dart run build_runner build -d`.
3. Launch the app on a simulator/emulator: `flutter run`.
4. Execute automated tests: `flutter test`.

> **API Keys**: Provide `GOOGLE_PLACES_KEY`, `TMDB_KEY`, and `IGDB_CLIENT/SECRET` via `.env` or runtime configuration when implementing the live repositories.

## Technical Approach
- **Client**: Flutter application following the best practices outlined in [`flutter_dart_riverpod_mockito.md`](./flutter_dart_riverpod_mockito.md), using Riverpod for state management, reusable widgets, and comprehensive testing.
- **Backend & Data**: API layer that aggregates content providers, normalizes payloads, caches responses, and manages user/group state. Consider Firebase, Supabase, or a custom backend for persistence and authentication.
- **Mapping**: Integrate MapLibre for rendering place locations returned by the Google Places API and enabling location-aware filtering.
- **Testing Strategy**: Unit tests for business logic (match thresholds, swipe handling), widget tests for UI flows, and integration tests that mock external APIs using Mockito-generated mocks.

## Getting Started
1. Review [`progress.md`](./progress.md) to understand what has been completed from the roadmap and what remains.
2. Configure environment variables and API keys for Google Places, TMDB, and IGDB.
3. Swap the mock repository with real API clients and wire persistence for swipe decisions.
4. Follow the roadmap in [`roadmap.md`](./roadmap.md) to iterate towards a production-ready MVP.

## Database Planning
- Consult [`docs/database_schema.md`](./docs/database_schema.md) for the PostgreSQL-oriented entity relationship diagram that underpins persistence work and mirrors the advanced filtering model introduced in the prototype.

## Contributing
- Follow the naming, formatting, and state management conventions described in [`flutter_dart_riverpod_mockito.md`](./flutter_dart_riverpod_mockito.md).
- Document any architectural changes within `roadmap.md` to maintain a history of decisions and milestones.
- Ensure new features include relevant tests and respect the modular structure for future category expansion.
