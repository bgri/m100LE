# Generate smaller (uncommented and/or tokenized) versions from the
# original BASIC source code (M100LE+comments.DO).

# Uncommenting and tokenizing requires hackerb9's tandy-tokenize program.
# See https://github.com/hackerb9/tandy-tokenize

# If it is not installed, use 'make tokenize' to compile a
# (possibly old) version of tandy-tokenize in the adjunct dir.

generated+=M100LE+comments.BA M100LE.BA
generated+=CMPRSS.BA

# By default, generate every file using the implicit rules
all:  ${generated}

# Delete all generated files
clean:
	rm ${generated} 2>/dev/null || true
	rm adjunct/tandy-tokenize adjunct/tandy-decomment 2>/dev/null || true

# Convert M100LE+comments.DO -> M100LE+comments.BA, keeping comments.
%.BA: %.DO
	tandy-tokenize < $<  > $@

# Automatically convert M100LE+comments.DO -> M100LE.BA, removing comments.
%.BA: %+comments.DO
	tandy-decomment $<  $@

### hackerb9's tokenizer program (only needed if not already installed)
tokenize: adjunct/tandy-tokenize adjunct/tandy-decomment

# Tokenizer that preserves comments
adjunct/tandy-tokenize: adjunct/tandy-tokenize.c adjunct/tandy-tokenize-main.c
	cd adjunct && \
	gcc tandy-tokenize.c -o tandy-tokenize

# Tokenizer that omits comments and spaces
adjunct/tandy-decomment: adjunct/tandy-decomment.c adjunct/tandy-tokenize-main.c
	cd adjunct && \
	gcc tandy-decomment.c -o tandy-decomment

