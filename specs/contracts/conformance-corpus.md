# Conformance corpus contract

The language-agnostic test corpus that keeps every implementation honest. It lives in this repo under `conformance/`, one YAML file per theme, and every implementation loads the sibling checkout (`../isnow/conformance/`) and passes 100% of cases; the suite self-skips when the sibling checkout is absent (the up.js model).

## File format

Each file is a YAML document: `cases:` — a list of case objects. Every case has a unique `name` (kebab-case, unique corpus-wide) and exactly one of the shapes below. All instants are RFC 3339 with offset; the evaluation zone is the fixed offset given, unless the case carries `tz:` (an IANA zone name — used for DST cases), which overrides it. Weekday numbering: Sunday = 1.

### holds case

```yaml
- name: wednesday-noon-holds
  isnow: "M,W,F noon"
  at: "2026-07-15T12:00:00-05:00"
  holds: true
```

### canonical case

```yaml
- name: bare-hour-canonicalizes
  isnow: "6"
  canonical: "*/*/* * 06:00:00"
```

### next / prev case (derivation)

```yaml
- name: next-last-thursday-november
  isnow: "11/ Th-[1] noon"
  from: "2026-01-01T00:00:00Z"
  next:
    - "2026-11-26T12:00:00Z"
```

`next` lists occurrences strictly after `from`, in order; its length is the `n` requested. A `prev` case is the mirror: occurrences strictly before `from`, nearest first. An empty list (`next: []`) asserts that one occurrence was requested and none exists within the window/horizon.

### error case (parse or semantic rejection)

```yaml
- name: ambiguous-symbol-rejected
  isnow: "T noon"
  error: symbol
```

`error` values are stable machine-readable codes shared by all implementations: `syntax`, `symbol` (unknown/ambiguous), `range` (value outside field), `context` (semantically invalid construct, e.g. unbounded year from-end).

## Files

`conformance/` starts with: `structure.yaml` (groups, ladder, canonical forms), `algebra.yaml` (wildcard/exact/set/exclusion/span/from-end/unit compound/step), `symbols.yaml`, `bounds.yaml` (windows, continuous stepping), `derivation.yaml` (next/prev), `errors.yaml`. Every SPECIFICATION.md example appears as a case.

## Obligations

- A case added here is a contract change: implementations must pass it before their next release.
- Implementations must not skip individual cases; a case an implementation cannot pass is a bug in the implementation or a dispute to resolve in this contract — never a `t.Skip`.
