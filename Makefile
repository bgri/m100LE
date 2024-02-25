# Generate smaller (uncommented and/or tokenized) versions from the
# original BASIC source code (M100LE+comments.DO).

generated+=M100LE+comments.BA M100LE.BA
generated+=CMPRSS.BA

# Tokenizing and uncommenting requires hackerb9's tandy-tokenize program.
# See https://github.com/hackerb9/tandy-tokenize
# If it is not installed, use 'make tokenize' to compile a
# (possibly old) version of tandy-tokenize in the adjunct/ dir.
TOKENIZE:=$(shell command -v tandy-tokenize 2>/dev/null)
TKNZ	:=$(shell command -v tandy-decomment 2>/dev/null)
ifndef TOKENIZE
    TOKENIZE	:=$(shell command -v adjunct/tandy-tokenize 2>/dev/null)
    ifndef TOKENIZE
        $(warning ${PATH} "Compiling tandy-tokenize in adjunct directory");
        generated:=tokenize ${generated}
    endif
    TOKENIZE	:=adjunct/tandy-tokenize
    TKNZ	:=adjunct/tandy-decomment
endif


### FAKE TARGETS (not actual files)
.PHONY: all clean

# By default, generate every file using the implicit rules
all:  ${generated}

# 'make clean' to delete all generated files
clean:
	rm ${generated} 2>/dev/null || true
	$(MAKE) -C adjunct clean

### Compile hackerb9's tokenizer program (only if not already installed)
tokenize:
	$(MAKE) -C adjunct tokenize

### IMPLICIT RULES

# Convert M100LE+comments.DO -> M100LE+comments.BA, keeping comments.
%.BA: %.DO
	${TOKENIZE} < $<  > $@

# Automatically convert M100LE+comments.DO -> M100LE.BA, removing comments.
%.BA: %+comments.DO
	${TKNZ} $<  $@

