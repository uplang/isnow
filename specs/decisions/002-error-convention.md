# 002 — Errors are errs.Const sentinels

**Decision.** `isnow.go` declares every emitted error as a `github.com/gomatic/go-error` `errs.Const` sentinel (`ErrSyntax`, `ErrSymbol`, `ErrRange`, `ErrContext` in the library; CLI-layer sentinels in `internal/constants`), wrapped with `Const.With(cause, args...)`. The four library sentinels map 1:1 to the conformance corpus error codes.

**Alternative.** up.go's local `type Error string` + `ParseError` struct with spec `E_*` codes — rejected for isnow: UP's codes are a cross-implementation conformance artifact of _that_ spec; isnow's corpus pins error identity by the four coarse codes instead, and the fleet-wide standard (template.cli, `yze/errconst`) is errs.Const. JS mirrors with a single `IsnowError` class carrying `.code`.
