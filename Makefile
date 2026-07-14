.DEFAULT_GOAL := help

# isnow — the one normative grammar for the DTimpalr date/time pattern
# language, generated to every target language so implementations parse from a
# single source of truth.
#
# IsnowLexer.g4 + IsnowParser.g4 are the source of truth (SPECIFICATION.md).
# This Makefile compiles them to each language with ANTLR4, into gen/<lang>/.
# Lift a generated tree into a new isnow.<lang> implementation repo, or retarget
# these rules at a sibling repo once one exists (see up.grammar for that model).
# The Java/ANTLR toolchain is isolated in Docker; generated code is committed in
# each implementation, so their normal builds stay toolchain-free.

MAKEFILE_DIR := $(patsubst %/,%,$(dir $(realpath $(lastword $(MAKEFILE_LIST)))))
ANTLR_IMAGE  := isnow-antlr
LEXER        := IsnowLexer.g4
PARSER       := IsnowParser.g4

RUN := docker run --rm -v "$(MAKEFILE_DIR)":/work -w /work $(ANTLR_IMAGE)

.PHONY: help
help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*## ' $(MAKEFILE_LIST) | awk 'BEGIN{FS=":.*## "}{printf "  %-10s %s\n", $$1, $$2}'

.PHONY: image
image: docker/antlr/Dockerfile ## Build the pinned ANTLR4 generator image
	docker build -t $(ANTLR_IMAGE) docker/antlr

.PHONY: gen
gen: go python js java cpp ## Generate every stock-ANTLR target into gen/<lang>/

.PHONY: go
go: image ## Generate the Go parser into gen/go
	$(RUN) -Dlanguage=Go -package isnowgrammar -o gen/go $(LEXER)
	$(RUN) -Dlanguage=Go -visitor -package isnowgrammar -lib gen/go -o gen/go $(PARSER)

.PHONY: python
python: image ## Generate the Python 3 parser into gen/python
	$(RUN) -Dlanguage=Python3 -o gen/python $(LEXER)
	$(RUN) -Dlanguage=Python3 -visitor -lib gen/python -o gen/python $(PARSER)

.PHONY: js
js: image ## Generate the JavaScript parser into gen/js
	$(RUN) -Dlanguage=JavaScript -o gen/js $(LEXER)
	$(RUN) -Dlanguage=JavaScript -visitor -lib gen/js -o gen/js $(PARSER)

.PHONY: java
java: image ## Generate the Java parser into gen/java
	$(RUN) -Dlanguage=Java -package org.uplang.isnowgrammar -o gen/java $(LEXER)
	$(RUN) -Dlanguage=Java -visitor -package org.uplang.isnowgrammar -lib gen/java -o gen/java $(PARSER)

.PHONY: cpp
cpp: image ## Generate the C++ parser into gen/cpp (ANTLR has no plain-C target)
	$(RUN) -Dlanguage=Cpp -o gen/cpp $(LEXER)
	$(RUN) -Dlanguage=Cpp -visitor -lib gen/cpp -o gen/cpp $(PARSER)

.PHONY: clean
clean: ## Remove generated parsers
	rm -rf gen
