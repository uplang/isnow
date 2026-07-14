# js-engine

## Goal

`@uplang/isnow` in `uplang/isnow.js`: the same semantics as go-engine for the web, per the [library API contract](../contracts/library-api.md), on the up.js repo model.

## Requirements

- R1. ESM package: residue in `src/isnow/` (parse, model, canonicalize, match, derive, explain), generated parser committed in `src/isnowgrammar/`, `antlr4` runtime dependency.
- R2. Zone-aware evaluation via `Intl.DateTimeFormat` field extraction for the parse-time `timeZone` option; the conformance runner evaluates offset-only cases with plain fixed-offset arithmetic (no Intl) and uses the case's `tz:` IANA name when present.
- R3. `node --test` with 100% line coverage of `src/isnow/**`; eslint (complexity ≤ 7) over residue and tests; conformance suite over `../isnow/conformance/`, self-skipping when absent.
- R4. `IsnowError` with `.code` matching the corpus error codes.
- R5. Makefile with `check`/`ci`/`grammars` targets and node.yml workflow, mirroring up.js; README badges + docs link.

## Acceptance criteria

- AC1. `make ci` green; coverage gate at 100%.
- AC2. All corpus cases pass with results identical to Go's (holds, canonical, next/prev, error codes; explain text is per-implementation).
- AC3. The package works from a browser bundle with no Node-only APIs in the residue.
