/* bacmp.c

   bacmp is like cmp, but for Tandy BASIC (TRS-80 Model 100) .BA files.

   Usage: bacmp <file1> <file2>

    Compares two Model 100 BASIC files in tokenized format but allows
    for variation of files depending upon where in memory the file is
    intended to load.

    Prints nothing and returns success if they match. 
    Otherwise, prints the byte offset where the mismatch occurred.

   Method: the two bytes at the beginning of each line of BASIC (the
   line pointers) are 16-bit little-endian integers that may differ by
   a constant offset, delta. This program doesn't actually bother to
   locate the line pointers, other than the first ones which are in
   the first two bytes of each file and are used to calculate delta.
   Whenever a byte mismatch is detected, the adjacent bytes are read
   from each file to create hypothetical line pointers. The pointers
   are considered a match if ptrA + delta == ptrB.

   Note: "Model 100 BASIC" perhaps should be called Kyotronic-85 BASIC as
   that is the first computer that was sold with this particular BASIC
   interpreter from Microsoft. These machines all share the same file
   format for their BASIC files:

	TRS-80 Model 100
	Tandy 200
	Tandy 102
	Kyocera Kyotronic-85
	Olivetti M10

   While similar to the above machines in many other ways, the NEC
   PC-8201, PC-8201A, and PC-8300 use a different version of BASIC
   called "N82 BASIC". It is possible but unlikely this program will
   work for the NEC .BA files.
 */

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
  if (argc<=2) {
    fprintf(stderr, "Usage: bacmp <file1> <file2>\n");
    fprintf(stderr, "\n"
	    "\tCompares two Tandy BASIC files in tokenized format\n"
	    "\tbut allows for variation of files depending upon\n"
	    "\twhere in memory the file is intended to load.\n"
	    "\n"
	    "\tReturns success (0) and prints nothing if the files match.\n"
	    "\tPrints the byte offset of the mismatch if the files differ.\n"
	    "\n"
	    );
    exit(1);
  }

  FILE *fa, *fb;
  if ( (fa = fopen(argv[1], "r")) == NULL)
    fprintf(stderr, "Could not open file: <%s>\n", argv[1]);
  if ( (fb = fopen(argv[2], "r")) == NULL)
    fprintf(stderr, "Could not open file: <%s>\n", argv[2]);
  if (fa == NULL || fb == NULL) {
    exit(1);
  }

  int count=0;			   /* Bytes read so far */
  int ca1, ca2, cb1, cb2;	   /* 2 bytes from file A and 2 from B */
  int ca0=-1, cb0=-1;		   /* Previous byte */
  unsigned int offset_a, offset_b; /* Those bytes seen as little endian 16bit */
  int delta;			   /* Difference between offset_a and b */

  /* Get delta, difference between the offsets at start of each file */
  count+=2;
  ca1=fgetc(fa), ca2=fgetc(fa);
  offset_a = ca1 + (ca2<<8);
  cb1=fgetc(fb), cb2=fgetc(fb);
  offset_b = cb1 + (cb2<<8);
  delta = offset_b - offset_a; 

  while (ca1 != EOF && cb1 != EOF) {
    count++;
    ca0 = ca1; cb0 = cb1;	/* stash old value for lineptr check */
    ca1 = fgetc(fa);
    cb1 = fgetc(fb);
    if (ca1 == cb1) continue;

    if ( ca1 == EOF ) {
      fprintf(stderr, "EOF on %s after byte %d\n", argv[1], count-2);
      exit(1);
    }
    else if ( cb1 == EOF ) {
      fprintf(stderr, "EOF on %s after byte %d\n", argv[2], count-2);
      exit(2);
    }


    /* Bytes don't match, but maybe it is a lineptr? */
    /* Try with previous byte */
    offset_a = ca0 + (ca1<<8);
    offset_b = cb0 + (cb1<<8);
    if (offset_a + delta == offset_b) continue;
    /* Try with next byte */
    count++;
    ca2 = fgetc(fa);
    cb2 = fgetc(fb);
    offset_a = ca1 + (ca2<<8);
    offset_b = cb1 + (cb2<<8);
    if (offset_a + delta == offset_b) continue;
 
    /* fprintf(stderr, "ptr from file a: %d (%x %x)\n", offset_a, ca1, ca2); */
    /* fprintf(stderr, "ptr from file b: %d (%x %x)\n", offset_b, cb1, cb2); */
    /* fprintf(stderr, "difference b - a: %d (%x)\n", delta, delta); */

    /* Files do not match, so let the user know */
    if ( ca1 != cb1 )
      fprintf(stderr, "Files differ at byte %d:  0x%02X versus 0x%02X\n", count-2, ca1, cb1);
    else if ( ca2 == EOF ) 
      fprintf(stderr, "EOF on %s after byte %d\n", argv[1], count-1);
    else if ( cb2 == EOF )
      fprintf(stderr, "EOF on %s after byte %d\n", argv[2], count-1);
    else if ( ca2 != cb2 )
      fprintf(stderr, "Files differ at byte %d:  0x%02X versus 0x%02X\n", count-1, ca2, cb2);

    exit(3);
  }

  /* Files are identical */
  exit(0);
}
