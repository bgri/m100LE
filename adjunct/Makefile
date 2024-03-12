tokenize: m100-tokenize m100-decomment m100-crunch 

# Tokenizer that preserves comments
m100-tokenize: m100-tokenize.c
	gcc $< -o $@

# Lexer that omits comments
m100-decomment: m100-decomment.c 

# Lexer that omits whitespace
m100-crunch: m100-crunch.c 

clean:
	rm m100-tokenize m100-decomment m100-crunch 2>/dev/null || true

