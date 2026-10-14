# Wasalny supervisor API integration

The Flutter app uses mock complaints in debug builds unless an API URL is
configured. In remote mode it calls the following REST contract:

- `GET /api/v1/supervisor/wasalny/complaints`
- `POST /api/v1/supervisor/wasalny/complaints/{id}/escalation`
  with `{ "reason": "..." }`
- `POST /api/v1/supervisor/wasalny/complaints/{id}/resolution`
  with `{ "note": "..." }`
- `POST /api/v1/supervisor/wasalny/complaints/{id}/inspection`
  with `{ "notes": "..." }`

Every successful response must be JSON with a `data` property. The list route
returns `data` as an array; mutation routes return `data` as the updated
complaint object. Complaint fields use the camelCase names consumed by
`WasalnyComplaintModel`; status values are `under_review`,
`escalated_to_chief`, `action_taken_blocked`, and `resolved`. Malformed
responses and non-success HTTP statuses are surfaced as errors; remote mode
does not fall back to mock data.

Run a debug build against a server with:

```text
flutter run --dart-define=API_BASE_URL=https://api.example.com
```

Remote mode must be selected explicitly:

```text
flutter run --dart-define=API_BASE_URL=https://api.example.com --dart-define=USE_MOCK_DATA=false
```

Set `--dart-define=USE_MOCK_DATA=true` to keep mock complaints while an API URL
is configured. Debug builds default to mocks; release builds default to remote
mode. A release build without a valid API URL fails during dependency
initialization rather than starting with mock complaints.

The current login flow is local and does not provide an API access token.
Remote authorization still needs to be connected to the server-backed
authentication/session implementation before deploying the API mode.
