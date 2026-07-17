# docs-governance

## Goal

Docs repos and org governance for the new repos.

## Requirements

- R1. Create `tsvsheet/docs.isnow.go` and `tsvsheet/docs.isnow.js` from nicerobot/template.repo-docs (private, Hugo at root, self-gating pages.yml untouched), with `baseURL`/`title`/`description` set.
- R2. docs.isnow.go content: language tour (terminology-driven), CLI reference (every command with examples), HTTP API reference, cron-migration guide ("your crontab as isnows"), semantics deep-dive. docs.isnow.js: library usage, API reference, playground pointer.
- R3. `tsvsheet/_admin/manifest.yaml`: add `isnow.js` → `docs: docs.isnow.js` override with a docs-reason (non-Go implementation, matching the up.js entry's model).
- R4. New code repos' wikis stay disabled (org default); READMEs follow the badges-plus-docs-link shape.

## Acceptance criteria

- AC1. Both docs repos exist, build with Hugo locally, and carry the unmodified managed pages.yml.
- AC2. Every CLI command and HTTP endpoint appears in docs.isnow.go with a runnable example.
- AC3. `manifest.yaml` parses and the new entries mirror existing entries' shape.
