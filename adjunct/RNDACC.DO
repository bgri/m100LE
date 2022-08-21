0 REM RNDACC by hackerb9 2022
1 REM Random access to files in RAM.
2 REM This program can read directly
3 REM from a compressed .CO word list
4 REM created by CMPRSS.BA.
5 '
7 ' Files change their location in RAM,     moving aside as other files grow. 
8 ' Note: EDIT modifies a hidden file,      but not the directory pointers!
9 ' CLEAR refreshes the pointers.
10 CLEAR
19 ' HW ID. 51=M100, 171=T200, 148=NEC,            167=M102,  35=M10,  225=K85
20 ID=PEEK(1)
29 ' Check if ID is known, sets ID$.
30 GOSUB 8300
40 PRINT"Machine detected as ";ID$
45 ' RD is Ram Directory address. 
46 ' (Anderson's "Programming Tips" gives RD=63842 for M100/2 and 62034 for T200.)
47 ' (Gary Weber's NEC.MAP gives RD=63567, but we can skip the system files by starting at 63633.)
50 RD=-( 63842*(ID=51 OR ID=167) + 62034*(ID=171) + 63633*(ID=148) )
60 IF RD=0 THEN PRINT "Ram Directory address not yet known.": PRINT"Please file a bug report to add support for the "ID$: END
70 IF ID=148 THEN YY$=LEFT$(DATE$, 2): ELSE YY$=RIGHT$(DATE$, 2)
79 ' WL20xx.CO is the wordle wordlist        for each day in 20xx, compressed.
80 WL$="WL20"+YY$+".CO"
85 PRINT "Searching for ";WL$
89 ' Search directory for "WL20xx.CO" 
90 FOR A = RD TO 65535 STEP 11
99 ' Attribute flag: See Oppedahl's "Inside the TRS-80 Model 100" for details.
100 FL=PEEK(A) 
109 ' Stop at end of directory (255)
110 IF FL=255 THEN 300
120 IF (FL AND 128)=0 THEN NEXT 'VALID?
130 IF (FL AND 16)<>0 THEN NEXT 'In ROM
140 IF (FL AND 8) <>0 THEN NEXT 'Hidden
149 ' X is file address in memory
150 X=PEEK(A+1)+256*PEEK(A+2)
159 ' Add filename all at once for speed
160 FN$=CHR$(PEEK(A+3)) + CHR$(PEEK(A+4)) + CHR$(PEEK(A+5)) + CHR$(PEEK(A+6)) + CHR$(PEEK(A+7)) + CHR$(PEEK(A+8)) + "." + CHR$(PEEK(A+9)) + CHR$(PEEK(A+10))
169 ' Got filename in FN$
170 PRINT FN$, X
180 IF FN$=WL$ THEN 200
190 NEXT A
199 GOTO 300
200 REM Found WL20xx.CO. Now access it.
201 ' X is WL20XX.CO's address in RAM
205 IF (PEEK(X)<>0) OR (PEEK(X+1)<>0) OR (PEEK(X+4)<>0) OR (PEEK(X+5)<>0) THEN PRINT "Load and/or Start addr are not 0. Odd."
209 ' SZ is # of bytes of data
210 SZ=PEEK(X+2)+256*PEEK(X+3)
212 IF (SZ/3) <> INT(SZ/3) THEN PRINT "Weird. Ought to be divisible by three."
215 PRINT"Found";SZ;"bytes of data"
220 PRINT "Enter an ordinal date ( 1 to"; SZ/3 ;")"; 
225 INPUT DY
230 DY=DY-1
235 IF SZ < DY*3+2 THEN PRINT "Out of Data error": END
236 IF DY<0 THEN PRINT "Negative index error": END
238 ' Skip .CO header and index by DY
239 ' Each 5 letter word is 3 bytes.
240 X = X+6 + DY*3
245 B0=PEEK(X):B1=PEEK(X+1):B2=PEEK(X+2)
247 PRINT"Three byte encoding:"B0;B1;B2
250 A=PEEK(X)+256*PEEK(X+1)+256*256*PEEK(X+2)
260 FOR T=1 TO 5
270 B=INT(A/26)
280 PRINTCHR$(A-B*26+ASC("A"));
290 A=B: NEXT T
295 PRINT
299 END
300 REM File not found
310 PRINT "Error: File ";WL$;" not found."
320 END
8300 REM Return if ID is valid.
8301 REM Halt with error if invalid.
8302 REM INPUT: ID is PEEK(1)
8303 REM OUTPUT: ID$ is machine name.
8310 ID$=""
8320 IF ID=51 THEN ID$="Model 100"
8330 IF ID=167 THEN ID$="Tandy 102"
8340 IF ID=171 THEN ID$="Tandy 200"
8350 IF ID=148 THEN ID$="NEC PC-8201, 8201A, or 8300"
8360 IF ID=35 THEN ID$="Olivetti M10"
8370 IF ID=225 THEN ID$="Kyotronic K-85"
8450 IF ID$<>"" THEN RETURN
8460 PRINT "Unknown machine ID";ID
8470 PRINT "Please file a bug report."
