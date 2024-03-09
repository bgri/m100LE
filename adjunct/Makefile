tokenize: tandy-tokenize tandy-decomment

# Tokenizer that preserves comments
tandy-tokenize: tandy-tokenize.c tandy-tokenize-main.c
	gcc tandy-tokenize.c -o tandy-tokenize

# Lexer that omits comments
tandy-decomment: tandy-decomment.c 
	gcc tandy-decomment.c -o tandy-decomment

# Lexer that omits whitespace
tandy-crunch: tandy-crunch.c 
	gcc tandy-crunch.c -o tandy-crunch



clean:
	rm tandy-tokenize tandy-decomment tandy-crunch 2>/dev/null || true

