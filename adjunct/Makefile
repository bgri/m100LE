tokenize: m100-tokenize m100-jumps m100-decomment m100-crunch

# Tokenizer that preserves comments
m100-tokenize: m100-tokenize.c
	gcc $< -o $@

clean:
	rm m100-tokenize m100-jumps m100-decomment m100-crunch 2>/dev/null || true

