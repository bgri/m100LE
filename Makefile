# Generate smaller (uncommented and/or tokenized) versions from the
# original BASIC source code (M100LE+comments.DO).

generated+=M100LE+comments.BA M100LE.BA
generated+=CMPRSS.BA

# Tokenizing and uncommenting requires hackerb9's m100-tokenize program.
# See https://github.com/hackerb9/m100-tokenize
# If it is not installed, use 'make tokenize' to compile a
# (possibly old) version of m100-tokenize in the adjunct/ dir.
TOKENIZE:=$(shell command -v m100-tokenize 2>/dev/null)
ifndef TOKENIZE
    TOKENIZE	:=$(shell command -v adjunct/m100-tokenize 2>/dev/null)
    ifndef TOKENIZE
        $(warning "Compiling m100-tokenize in adjunct directory");
        generated:=tokenize ${generated}
    endif
    TOKENIZE	:=adjunct/m100-tokenize
endif


### FAKE TARGETS (not actual files)
.PHONY: all clean tar

# By default, generate every file using the implicit rules
all:  ${generated}

# 'make clean' to delete all generated files
clean:
	rm ${generated} 2>/dev/null || true
	rm m100le.tar.gz m100le.zip 2>/dev/null || true
	$(MAKE) -C adjunct clean

### Compile hackerb9's tokenizer program
tokenize:
	$(MAKE) -C adjunct tokenize


# GNU tar lets us easily put the files into a subdirectory in the archive.
# Unfortunately, MacOS's tar cannot do that.
UNAME := $(shell uname)
ifeq ($(UNAME), Darwin)
	gnuxform := 
else
	gnuxform := --xform 's%^%m100le/%'
endif

### Create an archive of the final product for distribution.
archivefiles := M100LE.BA M100LE+comments.DO WL*.CO README.md
archive: tar zip
tar: all
	tar -acf m100le.tar.gz ${gnuxform} ${archivefiles}
zip: all
	zip -q m100le.zip ${archivefiles}

### IMPLICIT RULES

# Convert M100LE+comments.DO -> M100LE+comments.BA, keeping comments.
%.BA: %.DO
	adjunct/tokenize $< $@

# Automatically convert M100LE+comments.DO -> M100LE.BA, removing comments & crunching.
%.BA: %+comments.DO
	adjunct/tokenize --crunch M100LE+comments.DO M100LE.BA

