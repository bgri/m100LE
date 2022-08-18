/* cmprss.c		hackerb9 2022
 *
 * Given a wordlist on stdin or as filename argumentsa, write the
 * binary version that CMPRSS.BA would have created.
 *
 * Five letter words are converted to three binary bytes.
 *
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void cmprss(FILE *fi, FILE *fo) {
  /* Read words from fi, encode and write to fo  */
  char word[1024];
  int lines=0;			/* Number of lines processed */
  while (fscanf(fi, "%s", &word) != EOF) {
    if (strlen(word) != 5) {
      fprintf(stderr, "Error: '%s' is not of length 5\n", word);
      exit(1);
    }
    int a=0;			/* accumulator */
    for (int i=4; i>=0; i--) {
      a = a*26 + ( word[i] & 0b11111) - 1; /* A=0, B=1, ..., Z=25 */
    }
    fprintf(stderr, "%s %d: ", word, a);
    for (int i=0; i<3; i++) {
      fputc(a%256, fo);
      fprintf(stderr, "%d ", a%256);
      a=a/256;
    }
    fprintf(stderr, "\n");
    lines++;
  }
  while (lines++ < 366)
    fprintf(fo, "%c%c%c", 223, 73, 168);
}

void header(FILE *fo) {
  /* Write the Tandy 6 byte header for a .CO file */
  /* Size = 3 x 366 = 1098 = 4 x 256 + 74 */
  fprintf(fo, "%c%c%c%c%c%c", 0, 0, 74, 4, 0, 0);
}

int main(int argc, char *argv[]) {
  FILE *fi, *fo;
  char output[FILENAME_MAX+1];

  if (argc == 1) {
    fi = stdin;
    fo = stdout;
    header(fo);
    cmprss(fi, fo);
  }
  else {
    while (*(++argv)) {
      if ( (fi=fopen(*argv, "r")) == NULL) {
	perror(*argv);
	exit(1);
      }
      fprintf(stderr, "Reading from %s\n", *argv);
      strncpy(output, *argv, FILENAME_MAX);
      output[strlen(output)-2]--; 			/* .DO --> .CO */
      if ( (fo=fopen(output, "w")) == NULL) {
	perror(output);
	exit(1);
      }
      fprintf(stderr, "Writing to %s\n", output);
      header(fo);
      cmprss(fi, fo);
    }
  }

  return 0;
}

    
    
  
