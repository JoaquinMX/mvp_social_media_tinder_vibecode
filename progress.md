# Progress Tracker

## Milestone 1: Foundations & Planning
- [x] Defined high-level Flutter + Riverpod architecture and project structure.
- [x] Identified third-party APIs (Google Places, TMDB, IGDB) and map stack (MapLibre).
- [x] Established data models for users, groups, events, and swipes.
- [x] Added repository scaffolding, lint rules, and placeholder assets for prototyping.

## Milestone 2: Core Experience (MVP)
- [x] Implemented onboarding flow for creating a group and configuring thresholds.
- [x] Added category selection UI for Movies, Places, and Videogames.
- [x] Built swipe deck experience with yes/no actions and rejection reasons.
- [x] Captured "no" reasons with predefined options.
- [x] Calculated matches with full and partial grouping logic.
- [x] Created match summary views for full matches and partial re-evaluations.

## Milestone 3: Data Integrations
- [x] Normalized provider data into a unified event model.
- [x] Added mock repository with Google Places / TMDB / IGDB placeholders and MapLibre preview support.
- [ ] Implemented live API clients and caching layers.

## Milestone 4: Collaboration & Re-evaluation
- [x] Enabled users to revisit partial matches and convert "no" to "yes" decisions.
- [ ] Added realtime notifications for new matches after re-evaluation.
- [ ] Persisted decisions in a backend service.

## Milestone 5: Enhancements & Polish
- [ ] Added advanced filtering (price, distance, genre).
- [x] Integrated Riverpod provider observer for logging.
- [x] Added unit tests for match logic.
- [ ] Implemented pagination and performance tuning.
