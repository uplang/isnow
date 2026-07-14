# HTTP API contract (`isnow serve`)

Versioned under `/v1`. An isnow appears in the URL as a catch-all path suffix (so its internal `/` separators need no encoding) or, equivalently, as the `q` query parameter; `at` (RFC 3339) and `tz` (IANA zone, default UTC) are common query parameters. JSON responses use snake_case keys from the terminology contract. Default listen address `:8601` (ISO 8601).

## Endpoints

| Endpoint | Behavior |
| --- | --- |
| `GET /v1/is/{isnow...}` | The status-code membership test: **204** if the isnow holds at `at` (default now), **412 Precondition Failed** if not. No body. This is the endpoint that makes `curl` a scheduler predicate. |
| `GET /v1/check/{isnow...}` | Same test, always **200** with body: `{"isnow", "canonical", "at", "holds"}`. |
| `GET /v1/next/{isnow...}?n=1&from=` | **200** `{"isnow", "canonical", "occurrences": [RFC3339…]}`; occurrences strictly after `from` (default now). `n` capped at 1000. |
| `GET /v1/prev/{isnow...}?n=1&from=` | Mirror of `next`, strictly before `from`. |
| `GET /v1/canon/{isnow...}` | **200** `{"isnow", "canonical"}`. |
| `GET /v1/explain/{isnow...}` | **200** `{"isnow", "canonical", "explanation"}` — a generated English description. |
| `GET /v1/build?year=&month=&day=&weekday=&hour=&minute=&second=&since=&until=` | The builder: composes field expressions into an isnow. **200** `{"isnow", "canonical", "explanation"}`. Each parameter takes raw field-algebra text (e.g. `weekday=M,W,F`). |
| `GET /v1/wait/{isnow...}?timeout=60s` | Long-poll: responds **204** at the isnow's next occurrence, **504** if `timeout` (max 10m) elapses first. |
| `GET /v1/watch/{isnow...}` | Server-Sent Events: an `occurrence` event (data = RFC 3339 instant) at each occurrence, `heartbeat` comments every 30s. |
| `GET /healthz` | **200** `{"status": "ok", "now": RFC3339}`. |

## Errors

Invalid isnow or parameters: **400** with `{"error": {"code", "message"}}`; `code` is a corpus error code (`syntax`, `symbol`, `range`, `context`) or `parameter`. Unknown routes: **404** with the same shape. Every response carries `Cache-Control: no-store`.

## Operational requirements

Graceful shutdown on SIGINT/SIGTERM; read/write timeouts (SSE and wait excepted from write timeout); request logging via the CLI's structured logger; no state — every endpoint is a pure function of (isnow, query, clock).
