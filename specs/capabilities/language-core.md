# language-core

## Goal

Make `uplang/isnow` the complete language home: terminology, conformance corpus, and generation that feeds the implementation repos.

## Requirements

- R1. Fold the [terminology contract](../contracts/terminology.md) into SPECIFICATION.md as a glossary section; align README.md wording with it.
- R2. Create `conformance/` per the [corpus contract](../contracts/conformance-corpus.md), with every SPECIFICATION.md example as a case and coverage of every [semantics-contract](../contracts/semantics.md) rule (target ≥ 120 cases across the six files).
- R3. Retarget the Makefile's `go` and `js` targets to write into `../isnow.go/internal/isnowgrammar` and `../isnow.js/src/isnowgrammar` via the org-tree mount (up.grammar model, [decision 003](../decisions/003-generated-tree.md)); `python`/`java`/`cpp` keep `gen/<lang>/`.
- R4. Add a corpus-validation check (`make corpus`) that asserts YAML well-formedness and case-name uniqueness without needing an implementation.

## Acceptance criteria

- AC1. SPECIFICATION.md defines every term the contract names; no synonym survives a grep audit.
- AC2. `make image go js` regenerates both sibling trees reproducibly (clean git diff on re-run).
- AC3. `make corpus` exits 0; corpus case names are unique; every `error` value is one of the four codes.
