# go-cli

## Goal

The `isnow` binary (`cmd/isnow` in `tsvsheet/isnow.go`), per the [CLI contract](../contracts/cli.md) and template.cli standards.

## Requirements

- R1. template.cli structure: `cmd/isnow/main.go` thin shim over testable `run(args) int`; `internal/app/commands/<cmd>/` wiring; `internal/domain/<cmd>/` pure logic over the root `isnow` package; `internal/constants/` errs.Const sentinels; urfave/cli/v3 with `ISNOW_` env sources, `--log-level`/`--log-format`, shell completion.
- R2. All commands and exit codes of the CLI contract: default/`is`, `next`, `prev`, `canon`, `explain`, `wait`, `run` (single entry and `--tab` nowtab), `build`, `serve`.
- R3. Clock, writers, sleeper, and process-spawner are injected; `wait` and `run` are tested with a fake clock — no real sleeping in tests.
- R4. `run` executes entries at occurrences with per-entry overlap suppression and structured logging of starts, exits, and skips.
- R5. `build` composes field-algebra flag values, validates via `Parse`, and prints the shortest form whose canonicalization equals the composed pattern's.
- R6. goreleaser config (`project_name: isnow`) and managed workflows per [decision 001](../decisions/001-repo-decomposition.md); README is badges + docs link.

## Acceptance criteria

- AC1. `make ci` green (includes 100% coverage of cmd and internal packages).
- AC2. The ecosystem spec's AC3 scenario passes against the built binary.
- AC3. A nowtab with two entries executes both at their (fake-clock) occurrences in an integration-style test.
