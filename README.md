# isnow

> **DTimpalr — a Date/Time Pattern Language for Repetition.** One compact expression describes anything from a fixed instant to a complex recurrence, and answers a single question: *is it now?*

isnow patterns are **matchers**, not generators. `*/*/1 * 12:*:00` matches every instant on the first of a month during the noon hour; an implementation exposes `is(pattern, instant)`. It is a strict superset of cron in expressiveness — ranges, sets, exclusions, from-end counting, increments, and start/end bounds, over a uniform per-field algebra.

```
6                       every day at 06:00
M,W,F midnight          Mon/Wed/Fri at 00:00
11/ Th-[1] noon         last Thursday of November at noon
::+[9] >=6 <=18         every 9 seconds from 06:00 to 18:00
```

This repository is the **grammar-first** home of the language: the ANTLR4 grammar is the source of truth, and language implementations are generated from it.

- **Grammar:** [IsnowParser.g4](IsnowParser.g4) · [IsnowLexer.g4](IsnowLexer.g4)
- **Specification (semantics):** [SPECIFICATION.md](SPECIFICATION.md)
- **Generate a parser:** `make image && make go` (or `python`, `js`, `java`, `cpp`) — output lands in `gen/<lang>/` to lift into an implementation repo. `make help` lists targets. The Java/ANTLR toolchain is isolated in Docker; nothing else is needed to regenerate.

**Status:** Draft 0.1.0 — recovered and consolidated from the original 2011 design. Not yet wired to CI or a docs site.
