# CLI contract (`isnow`)

One binary, `isnow`, built from `tsvsheet/isnow.go` `cmd/isnow` per template.cli standards (urfave/cli/v3, env prefix `ISNOW_`, `--log-level`/`--log-format` global flags, shell completion enabled). The binary is the question: the default command is the membership test.

## Exit codes (uniform)

`0` the isnow holds / the operation succeeded · `1` the isnow does not hold (test commands only) · `2` invalid isnow or arguments · `3` runtime failure.

## Commands

| Command | Behavior |
| --- | --- |
| `isnow <isnow> [--at INSTANT] [--tz ZONE]` (alias `is`) | Membership test against now (or `--at`). Silent; exit code is the answer. `--explain` adds the canonical form and verdict on stdout. |
| `isnow next <isnow> [-n N] [--from INSTANT]` | Print the next N occurrences, RFC 3339, one per line. `prev` mirrors it. |
| `isnow canon <isnow>` | Print the canonical form. |
| `isnow explain <isnow>` | Print canonical form + generated English description. |
| `isnow wait <isnow> [--timeout D]` | Block until the next occurrence, then exit 0 (composable: `isnow wait 6 && backup`). Timeout → exit 3. |
| `isnow run <isnow> -- CMD [ARG…]` | Cron-superset executor: run CMD at every occurrence until interrupted. |
| `isnow run --tab FILE` | Execute a **nowtab**: lines of `<isnow>\t<command>` (`#` comments); each entry runs at its occurrences. |
| `isnow build [--year X] [--month X] [--day X] [--weekday X] [--hour X] [--minute X] [--second X] [--since S] [--until S]` | The builder: compose an isnow from field-algebra flag values, print the shortest equivalent form (and `--canonical` for the full form). |
| `isnow serve [--addr :8601]` | Start the HTTP server (http-api contract). |

## Behavioral requirements

- `--tz` (env `ISNOW_TZ`) selects the evaluation zone everywhere; default is the process-local zone.
- All time input accepts RFC 3339, `2006-01-02T15:04:05`, `2006-01-02 15:04:05`, and `2006-01-02` (midnight), interpreted in the evaluation zone when no offset is given.
- `run` schedules purely by occurrence (it computes each entry's next occurrence and fires then — never polling); overlapping executions of one entry are not started concurrently — a still-running command skips the occurrence with a logged warning.
- Everything is testable: main is a thin shim over `run(args) int`; clock, output writers, and process-spawner are injected.
