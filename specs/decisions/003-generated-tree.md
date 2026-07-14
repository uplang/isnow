# 003 — Generated parser placement and gate exclusion

**Decision.** This repo's Makefile is retargeted on the up.grammar model: the org tree mounts into the ANTLR container and the `go`/`js` targets write directly into the siblings — `../isnow.go/internal/isnowgrammar` (package `isnowgrammar`, gofmt'd after generation) and `../isnow.js/src/isnowgrammar`. Generated trees are committed in the implementation repos; `*.interp`/`*.tokens` stay gitignored everywhere. Languages without an implementation repo (`python`, `java`, `cpp`) keep generating into local `gen/<lang>/`.

**Gate exclusion.** isnow.go uses the shared tools.repository Makefile with a `Makefile.local` setting `COVER_PKGS = $(shell go list ./... | grep -v /internal/isnowgrammar)` (the cirql precedent); the generated files' `DO NOT EDIT` headers exclude them from file-list gates. isnow.js scopes coverage (`--test-coverage-include='src/isnow/**'`) and eslint (`src/isnow tests`) to the residue, the up.js model. The hand-written residue is 100% covered in both.

**Alternative.** The global `src/grammar/<name>/` layout — rejected: the org's established grammar-implementation pattern (`up.go internal/upgrammar`, `up.js src/upgrammar`) wins on sibling consistency, and this repo's Makefile already names the package `isnowgrammar`.
