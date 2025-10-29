# Database Schema Diagram

The diagram below captures the relational structure that supports collaborative swiping, advanced filtering, and match tracking. It is designed for PostgreSQL and keeps source-specific metadata in dedicated tables so that integrations (TMDB, Google Places, IGDB) can evolve independently.

```mermaid
erDiagram
    USERS ||--o{ GROUP_MEMBERS : participates
    GROUPS ||--o{ GROUP_MEMBERS : has
    GROUPS ||--o{ GROUP_CATEGORY_PREFERENCES : selects
    GROUPS ||--o{ GROUP_FILTER_PROFILES : configures
    GROUP_FILTER_PROFILES ||--o{ GROUP_FILTER_PLATFORMS : allows
    GROUPS ||--o{ GROUP_MATCHES : produces
    GROUP_MATCHES ||--o{ MATCH_DECISIONS : summarises

    EVENTS ||--o{ EVENT_LOCATIONS : located_at
    EVENTS ||--o{ EVENT_PLATFORMS : supports
    EVENTS ||--o{ MOVIE_DETAILS : movie_meta
    EVENTS ||--o{ GAME_DETAILS : game_meta
    EVENTS ||--o{ EVENT_SOURCES : sourced_from
    EVENTS ||--o{ SWIPE_DECISIONS : receives

    USERS {
        uuid id PK
        text display_name
        text email
        timestamptz created_at
    }

    GROUPS {
        uuid id PK
        text name
        integer match_threshold
        timestamptz created_at
    }

    GROUP_MEMBERS {
        uuid id PK
        uuid group_id FK
        uuid user_id FK
        boolean is_local
        text role
        timestamptz joined_at
    }

    GROUP_CATEGORY_PREFERENCES {
        uuid id PK
        uuid group_id FK
        text category
        timestamptz created_at
    }

    GROUP_FILTER_PROFILES {
        uuid id PK
        uuid group_id FK
        integer max_price_level
        integer max_runtime_minutes
        numeric max_distance_km
        timestamptz created_at
    }

    GROUP_FILTER_PLATFORMS {
        uuid id PK
        uuid filter_profile_id FK
        text platform
    }

    EVENTS {
        uuid id PK
        text category
        text title
        text description
        text image_url
        integer price_level
        jsonb metadata
        timestamptz available_from
    }

    EVENT_LOCATIONS {
        uuid id PK
        uuid event_id FK
        numeric latitude
        numeric longitude
        text address
        text city
        text country
    }

    EVENT_PLATFORMS {
        uuid id PK
        uuid event_id FK
        text platform
    }

    MOVIE_DETAILS {
        uuid event_id PK FK
        integer runtime_minutes
        integer tmdb_id
        text certification
    }

    GAME_DETAILS {
        uuid event_id PK FK
        integer igdb_id
        text genre
        text age_rating
    }

    EVENT_SOURCES {
        uuid id PK
        uuid event_id FK
        text provider
        text external_id
        timestamptz synced_at
    }

    SWIPE_DECISIONS {
        uuid id PK
        uuid event_id FK
        uuid group_member_id FK
        text decision
        text reason
        timestamptz decided_at
    }

    GROUP_MATCHES {
        uuid id PK
        uuid group_id FK
        uuid event_id FK
        text status
        integer yes_votes
        integer threshold
        timestamptz created_at
    }

    MATCH_DECISIONS {
        uuid id PK
        uuid match_id FK
        uuid group_member_id FK
        text decision
        timestamptz updated_at
    }
```

## Design Notes

- **Advanced filtering** lives in `GROUP_FILTER_PROFILES`, which stores ceiling values for price, runtime, and distance. Platform-specific filters use the `GROUP_FILTER_PLATFORMS` join table to keep the schema flexible as new console or streaming options emerge.
- **Event metadata** is separated by content type. Movie-specific attributes (runtime, certification, TMDB identifiers) sit in `MOVIE_DETAILS`, whereas videogame enrichments (IGDB identifiers, genres, age ratings) live in `GAME_DETAILS`. Both tables share the event primary key, enabling efficient joins only when the data is relevant.
- **Traceability** is provided by the `EVENT_SOURCES` and `SWIPE_DECISIONS` tables, ensuring that downstream analytics can inspect how preferences were formed and when matches were confirmed or reconsidered.
- **Match lifecycle** uses `GROUP_MATCHES` and `MATCH_DECISIONS` so that partial approvals and later reversals can be recorded without losing the original swipe history.

This schema keeps the domain extensible for future persistence work, while mirroring the advanced filtering capabilities introduced in the current UI.
