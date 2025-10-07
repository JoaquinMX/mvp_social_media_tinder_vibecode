# Project Roadmap

## Vision
Build a group-based activity discovery application where users swipe through events from multiple content providers (places, movies, videogames) and surface full or partial matches based on group preferences.

## Guiding Principles
- Follow the best practices documented in `flutter_dart_riverpod_mockito.md` for architecture, naming, state management, and testing.
- Prioritize modularity to support new content categories and additional providers in the future.
- Ensure privacy and data security when handling group membership and preferences.

## Milestones

### 1. Foundations & Planning
- Define high-level architecture (Flutter + Riverpod + backend services).
- Identify required third-party APIs (Google Places, TMDB, IGDB) and authentication needs.
- Decide data model for users, groups, events, and swipes.
- Establish repository structure and tooling (formatting, linting, CI/CD).

### 2. Core Experience (MVP)
- Implement onboarding flow for creating/joining groups.
- Build category selection UI allowing users to toggle Movies, Places, and Videogames.
- Implement swipe deck experience for events, including left (no) and right (yes) gestures.
- Capture "no" reasons from predefined list (Expensive, Too far, Not interested, Other).
- Calculate matches based on group size rules (unanimous for 2, configurable threshold for larger groups).
- Provide match list view highlighting full matches for the group and partial matches requiring reconsideration.

### 3. Data Integrations
- Integrate Google Places API to fetch and display place events, including map previews via MapLibre.
- Integrate TMDB API for movies and IGDB API for videogames, with caching to limit API calls.
- Normalize data from providers into unified event model.

### 4. Collaboration & Re-evaluation
- Allow users who said "no" on partial matches to review and update their decision.
- Notify group members when new matches are achieved after re-evaluation.
- Persist decisions and match states in backend storage (e.g., Firebase, Supabase, or custom backend).

### 5. Enhancements & Polish
- Add filtering options (price range, distance, genre).
- Implement analytics and logging through Riverpod provider observers.
- Add testing layers: unit tests for match logic, widget tests for swipe interactions, integration tests for API clients.
- Optimize performance with pagination, caching, and `const` widgets where applicable.

## Next Steps
1. Finalize technical stack decision and draft architecture diagram.
2. Scaffold Flutter project with Riverpod setup and linting rules.
3. Prototype swipe deck UI using placeholder data.
4. Implement backend/API wrappers with mocked data for testing.
5. Iterate towards full MVP functionality before integrating live APIs.

## Change Log
- **2024-06-05**: Initial roadmap drafted capturing milestones, guiding principles, and next steps.
- **2024-06-05**: Scaffolded Flutter app with Riverpod architecture, mock data integrations, and end-to-end MVP flows (onboarding, swipe, matches).
