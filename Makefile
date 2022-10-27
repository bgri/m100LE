# Generate smaller (uncommented and/or tokenized) versions from the
# original BASIC source code (M100LE+comments.DO).

# Uncommenting uses two scripts in the adjunct dir:
# jumpdestinations and removecomments.

# Tokenizing requires hackerb9's tandy-tokenize program.
# See https://github.com/hackerb9/tandy-tokenize

generated+=M100LE+comments.BA M100LE.DO M100LE.BA
generated+=CMPRSS.BA

# By default, generate every file using the implicit rules
all:  ${generated}

# Delete all generated files
clean:
	rm ${generated} 2>/dev/null || true



# Automatically convert M100LE+comments.DO -> M100LE.DO
%.DO: %+comments.DO
	adjunct/removecomments $<  $@

# Automatically convert M100LE.DO -> M100LE.BA
%.BA: %.DO
	tandy-tokenize < $<  > $@
