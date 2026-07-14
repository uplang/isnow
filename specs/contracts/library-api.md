# Library API contract

The public surface each implementation exposes, named per the terminology contract. Signatures are idiomatic per language; semantics are identical and pinned by the conformance corpus.

## Go (`github.com/uplang/isnow.go`, package `isnow`)

```go
// Parse recognizes src and resolves symbols + the shorthand ladder.
func Parse(src string) (Pattern, error)

// Pattern is an immutable, canonicalized isnow.
func (Pattern) Holds(at time.Time) bool          // the membership test
func (Pattern) Next(from time.Time) (time.Time, bool)  // strictly after from; false when no occurrence within the horizon or window
func (Pattern) Prev(from time.Time) (time.Time, bool)
func (Pattern) Canonical() string                // canonical form
func (Pattern) String() string                   // canonical form (fmt.Stringer)
func (Pattern) Explain() string                  // generated English description

// Is is the one-shot convenience: Parse + Holds.
func Is(src string, at time.Time) (bool, error)
```

Errors are `errs.Const` sentinels matching the corpus error codes: `ErrSyntax`, `ErrSymbol`, `ErrRange`, `ErrContext`. The evaluation zone is `at.Location()` — the caller owns zone selection; the library never reads the environment or the wall clock.

## JS (`@uplang/isnow`, ESM)

```js
parse(src)               // → Pattern (throws IsnowError with .code ∈ {syntax, symbol, range, context})
pattern.holds(at)        // at: Date or ISO string; boolean
pattern.next(from)       // → Date | null
pattern.prev(from)       // → Date | null
pattern.canonical        // string property
pattern.explain()        // string
is(src, at)              // one-shot convenience
```

JS evaluates in a fixed zone chosen at parse time via `parse(src, {timeZone})` (IANA name, default the host zone), using `Intl`-derived field extraction — `Date` carries no zone.

## Shared semantic pins

Both implementations: Sunday = 1; derivation horizon 100 years from `from` (unbounded patterns beyond it report no occurrence); bounded patterns never report occurrences outside their window; `Holds`/`holds` truncates the instant to whole seconds. `Explain` text is implementation-defined (deterministic per implementation, terminology-contract vocabulary, but not corpus-pinned); everything else is pinned byte-identical by the corpus.
