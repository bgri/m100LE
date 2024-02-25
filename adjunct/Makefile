tokenize: tandy-tokenize tandy-decomment

# Tokenizer that preserves comments
tandy-tokenize: tandy-tokenize.c tandy-tokenize-main.c
	gcc tandy-tokenize.c -o tandy-tokenize

# Tokenizer that omits comments and spaces
tandy-decomment: tandy-decomment.c tandy-tokenize-main.c
	gcc tandy-decomment.c -o tandy-decomment



clean:
	rm tandy-tokenize tandy-decomment 2>/dev/null || true

