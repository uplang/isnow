# go-server

## Goal

`isnow serve` — the HTTP time server of the [HTTP API contract](../contracts/http-api.md).

## Requirements

- R1. Every contract endpoint on Go 1.22+ `net/http` ServeMux with catch-all isnow path capture plus the `q` query alternative; JSON per the contract's shapes; default `:8601`.
- R2. Handlers are pure functions of (request, injected clock); `wait` long-poll and `watch` SSE are driven by the injected clock/timer in tests.
- R3. Graceful shutdown on context cancel; read timeouts everywhere; write timeouts except `wait`/`watch`; request logging through the CLI logger.
- R4. 400/404 error bodies carry the corpus error codes; invalid `at`/`tz`/`timeout` parameters report `parameter`.

## Acceptance criteria

- AC1. `make ci` green with handler coverage at 100% via `httptest` (including SSE framing and long-poll timeout paths).
- AC2. The ecosystem spec's AC4 curl scenario passes against a running server.
- AC3. `watch` emits an occurrence event within one fake-clock tick of an occurrence and heartbeats between occurrences.
