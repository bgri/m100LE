/* tandy-tokenize-main.c		Front end for Model 100 BASIC tokenizer
 * 
 * This is just the frontend. 
 * For the actual tokenizer, see tandy-tokenize.lex.
 */

  /* Usage: tandy-tokenize  [ input.ba [ output.ba ] ]

   * Examples:  
   	(a) tandy-tokenize  FOO.DO  FOO.BA
   	(b) tandy-tokenize  <FOO.DO  >FOO.BA
   	(c) tandy-tokenize  FOO.DO | cat > FOO.BA
	
     Note that (a) and (b) are identical, but (c) is slightly different.

     If the output stream cannot be rewound, then the line pointers will 
     not be updated at the end. This does not matter for a genuine 
     Model T computer, but some emulators are known to be persnickety
     and will refuse to load the file.  

   */


int main(int argc, char *argv[]) {

  ++argv, --argc; 		/* skip over program name */

  /* First arg (if any) is input file name */
  yyin = (argc>0) ? fopen( argv[0], "r" ) : stdin;
  if (yyin == NULL) { perror(argv[0]); exit(1);  }


  /* Second arg (if any) is output file name */
  ++argv, --argc;
  yyout = (argc>0) ? fopen( argv[0], "w+" ) : stdout;
  if (yyout == NULL) { perror(argv[0]); exit(1);  }
  
  while (yylex())
    ;
  return 0;
}


int yywrap() {
  return 1;			/* Always only read one file */
}


int yyput(uint8_t c) {
  /* Like putchar, but send to yyout instead of stdout */
  fputc(c, yyout);
  lastput = c;			/* Save last char for handling EOF */
  return 0;
}

int fixup_ptrs() {
  /* At EOF, rewrite the line pointers in the output file so that each
     line points to the next. This is not actually necessary. */

  int offset = 0xA001;		/* Offset into memory for start of program */

  ptr[nlines++] = ftell(yyout);	/* Pointer to final NULL byte */

  if (fseek(yyout, 0L, SEEK_SET) != 0) {
    perror("fseek");
    fprintf(stderr,
	    "Warning: Could not rewind the output file to fixup pointers.\n"
	    "This will work on genuine hardware but not on some emulators.\n");
    return 1;
  }
  
  for (int n=1; n < nlines; n++) {
    fseek(yyout, ptr[n-1], SEEK_SET);
    yyput( (offset + ptr[n]) & 0xFF);
    yyput( (offset + ptr[n]) >> 8);
  }
    
  return 0;
}
