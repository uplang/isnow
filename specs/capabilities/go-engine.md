# go-engine

## Goal

The root package `isnow` of `uplang/isnow.go`: parse → typed AST → canonicalize → match → derive, implementing the [semantics contract](../contracts/semantics.md) behind the [library API](../contracts/library-api.md).

## Requirements

- R1. `Parse` drives the committed `internal/isnowgrammar` lexer/parser with error listeners replaced (syntax errors become `ErrSyntax` with line/column context — never stderr), then walks the tree into an immutable `Pattern` (value receivers, no pointer mutation).
- R2. Canonicalization applies the ladder, resolves symbols, validates domains, and renders `Canonical()` deterministically (zero-padded two-digit fields, four-digit year).
- R3. `Holds` evaluates all seven fields plus bounds per the semantics contract, including tails, wrap spans, both step readings, week-unit steps, and continuous stepping.
- R4. `Next`/`Prev` derive occurrences by day-pruned search with analytic in-day time sets (the strategy satisfying the semantics contract's no-second-scanning requirement); DST behavior follows the semantics contract (a gap yields no occurrence; a fold yields both absolute instants).
- R5. `Explain` renders a deterministic English description composed from the terminology contract's names.
- R6. The conformance suite loads `../isnow/conformance/` (self-skipping when absent) and passes every case; unit tests independently pin the same rules so the gate never depends on the sibling.
- R7. Errors are the four `errs.Const` sentinels ([decision 002](../decisions/002-error-convention.md)); every failure path is asserted with `errors.Is`.

## Acceptance criteria

- AC1. `make check` green: 100% coverage of owned packages, gocognit ≤ 7, staticcheck/vet/vulncheck clean.
- AC2. All corpus cases pass; fuzz test (`FuzzParse`) runs clean for 30s (no panics, parse-canonical-reparse is a fixed point).
- AC3. Every SPECIFICATION.md example produces the spec's stated canonical form or meaning.
