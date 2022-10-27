0 CLEAR
1 REM CMPRSS By hackerb9, 2022
5 REM Read five letter words from one file and output a three byte representations to a new .CO file.
6 REM Uses Ram Directory to POKE the          data directly into the .CO file.
7 REM Note The .CO file is currently hardcoded to fit 366 three-byte words.
9 ON ERROR GOTO 990
10 IN$="COM:98N1ENN"
14 ID=PEEK(1) ' ID=148 on NEC machines.
15 IF (ID=148) THEN IN$="COM:9N81XN"
20 FILES
25 PRINT "Which Wordlist .DO file to read?"
30 PRINT "(Hit Enter to read from ["IN$"])"
39 'N.B. "Enter" does not change IN$
40 INPUT IN$
55 A$=IN$: DX$="DO"
60 GOSUB 800: REM Sanity check filename
65 IN$=A$
70 IF A$="" THEN GOTO 10 ' Not sane
99 REM If we get here, IN$ is the input.
100 WL$="WL20XX.CO"
110 IF RIGHT$(IN$,3) <> ".DO" AND RIGHT$(IN$,3) <> ".do" THEN 140
120 IX=INSTR(1, IN$, ".")
130 WL$=LEFT$(IN$, IX)+"CO"
140 PRINT "File to write ["WL$"]";
149 'Enter will not change WL$
150 INPUT WL$
160 A$=WL$: DX$="CO" 'default extension
170 GOSUB 800:REM Sanity check filename
180 WL$=A$
190 IF A$="" THEN GOTO 110 'Not sane
200 REM OPEN FILES
205 ON ERROR GOTO 910
207 PRINT "Waiting for ";IN$;CHR$(13);
210 OPEN IN$ FOR INPUT AS #1
212 ON ERROR GOTO 940 ' IO error
213 IF EOF(1) THEN GOTO 400
215 ON ERROR GOTO 920
220 GOSUB 7000 ' Create .CO file
225 ON ERROR GOTO 930
230 GOSUB 8000 ' WA=addr of .CO file
240 IF WA=0 THEN GOTO 930
250 ON ERROR GOTO 990
255 B(0)=223:B(1)=73:B(2)=168
256 FOR I=0 TO 2: POKE WA+6+365*3+I, B(I): NEXT I
300 REM LOOP: Read, Encode, Write
305 DY=0
308 ON ERROR GOTO 940
310 IF EOF(1) THEN GOTO 400
315 IF DY>=366 THEN PRINT "Stopped reading at 366 words": GOTO 400
320 LINE INPUT #1, A$
325 ON ERROR GOTO 990
330 GOSUB 500 'compress to 3 bytes=
340 PRINT INT(100*DY/366)"%",
345 PRINT B(0) ", " B(1) ", " B(2) "     " CHR$(13);
350 FOR I=0 TO 2
355 POKE WA+6+DY*3+I, B(I)
360 NEXTI
370 DY=DY+1
399 GOTO 310
400 REM DONE
410 PRINT "100 %"
420 PRINT"Finished compressing."
490 CLOSE #1
499 END
500 REM Encode string in A$ to B(0..2)
501 REM modifies X,Y,T,A
510 X=0
515 IF LEN(A$) <> 5 THEN PRINT"Length of "A$" is not 5.": ERROR 0
520 FOR T=5 TO 1 STEP -1
530 A=ASC(MID$(A$,T,1))
540 A=A AND 31
550 A=A-1
560 X=X*26+A
580 NEXT
590 'Continue to 600
600 REM CONVERT NUMBER IN A TO B0,B1,B2
601 'Modifies x,y,b0,b1,b2
610 FOR I=0 TO 2
620 Y=INT(X/256):B(I)=(X-Y*256):X=Y
630 NEXT I
670 RETURN
800 REM Sanity check filename in A$.            Returns A$="" if invalid.
801 REM Set DX$ to default two character extension before calling this subroutine.
802 IF DX$="" THEN DX$="CO"
805 EX$=""
809 ' Skip "COM:98N1ENN"
810 IF INSTR(1,A$,":") THEN RETURN:
819 ' Filename and extension if no dot
820 DT=INSTR(1,A$,".") ' Find the dot
830 IF DT>0 THEN FN$=MID$(A$,1,DT-1): EX$=MID$(A$,DT+1,2): ELSE FN$=A$
840 IF LEN(FN$) > 6 THEN PRINT"Filename must be six characters or less": A$="": RETURN
850 IF LEN(FN$) = 0 THEN PRINT"Please enter a filename.": A$="": RETURN
860 IF LEN(EX$) > 2 THEN PRINT"Extension too long. Maybe try ."DX$: A$="": RETURN
869 'Default extension is in DX$
870 IF LEN(EX$) = 0 THEN EX$=DX$
880 A$=FN$+"."+EX$
890 RETURN
900 REM Error handling
910 PRINT "Could not open "IN$" for reading": GOTO 996
920 PRINT "Could not allocate" SZ "bytes for " WL$: GOTO 996
930 PRINT "Error finding address of "WL$: GOTO 996
940 PRINT "Error reading from "IN$: GOTO 996
989 REM Generic error handler
990 PRINT"Got error" ERR "in line" ERL
995 ' Do we need to remove the .CO file?
996 IF NK=1 THEN KILL WL$
999 ON ERROR GOTO 0: ERROR ERR: END
7000 REM Create .CO file to hold compressed wordlist
7004 'For NEC, use BSAVE (at line 8201)
7004 'For M10, use SAVEM (at line 8300)
7006 'For others, use SAVEM.
7010 ID=PEEK(1)
7019 ' Allocate space for 366 words
7020 SZ=366 * 3
7030 NK=1     ' On error, kill .CO file
7039 'NEC and Olivetti need special handling
7040 IF (ID=148) THEN GOSUB 8201:            ELSE IF (ID=35) GOSUB 8300:             ELSE SAVEM WL$, 0, SZ-1
7050 RETURN
8000 REM Random Access subroutine
8001 REM Input: WL$ is file to locate.
8002 REM Output: WA is address in RAM.
8003 REM Temp: ID, RD, FL, FN$, T1, T2
8004 REM
8005 REM Warning: Run CLEAR at start of program or this will return an invalid address.
8006 REM
8007 ' Set WL$ to 8 chars, no dot
8008 GOSUB 8100
8009 ' HW ID:51=M100, 171=T200, 148=NEC,       35=M10, 225=K85
8010 ID=PEEK(1)
8014 ' Ram Directory address. (Anderson's "Programming Tips" gives RD=63842 for M100 and 62034 for T200.)
8015 ' (Gary Weber's NEC.MAP gives RD=63567, but we can skip the system files by starting at 63633.)
8016 RD=-( 63842*(ID=51 OR ID=167)               + 62034*(ID=171)                        + 63633*(ID=148)                        + 63849*(ID=35) )
8017 IF RD=0 THEN PRINT "Error: Unknown machine ID";ID;". Please file a bug report.": END

8019 ' Search directory for WL$
8020 FOR T1 = RD TO 65535 STEP 11
8029 ' Attribute flag: See Oppedahl's "Inside the TRS-80 Model 100" for details.
8030 FL=PEEK(T1)
8039 ' Stop at end of directory (255)
8040 IF FL=255 THEN GOTO 8080
8044 ' Skip invalid files
8045 IF (FL AND 128)=0 THEN NEXT T1
8049 ' WA is file address in memory
8050 WA=PEEK(T1+1)+256*PEEK(T1+2)
8059 ' Filename matches WL$?
8060 FOR T2=1 TO 8: IF ASC(MID$(WL$,T2, 1)) <> PEEK(T1+2+T2) THEN NEXT T1: ELSE NEXT T2
8070 IF T2=9 THEN PRINT "Found "WL$" at" WA: RETURN
8080 REM File not found
8085 PRINT "Did not find " WL$
8090 WA=0: RETURN
8100 REM Normalize filename to 8 chars
8101 REM E.g. "FOO.DO" -> "FOO   DO"
8102 REM INPUT & OUTPUT: WL$
8103 REM Temp: T1, T2, FN$, EX$
8110 T1=INSTR(1,WL$,".")
8115 FN$=WL$:EX$=""
8120 IF T1>0 THEN FN$=MID$(WL$,1,T1-1): EX$=MID$(WL$,T1+1,2)
8130 IF LEN(FN$)>6 THEN PRINT "filename too long": STOP
8140 IF LEN(FN$)<6 THEN FN$=FN$+" ": GOTO 8140
8150 IF LEN(EX$)<2 THEN EX$=EX$+" ": GOTO 8150
8160 FN$=FN$+EX$: WL$=""
8170 FOR T1=1 TO 8
8172 T2=ASC(MID$(FN$,T1,1)): IF (T2>=ASC("a")) AND (T2<=ASC("z")) THEN T2=T2-32
8173 WL$=WL$+CHR$(T2)
8175 NEXT T1
8180 RETURN
8200 REM NEC BSAVE BUG WORKAROUND
8201 ' BSAVE on the NEC drops the user
8202 ' into DIRECT MODE, halting the
8203 ' running program. The solution is
8204 ' to have the user type "RETURN"
8205 ' and hit the Enter key to jump
8206 ' back into the program.
8207 ' A nicer method is to fill the
8208 ' keyboard buffer as if the user
8209 ' had typed RETURN.
8210 PRINT "NEC detected! Fixing BSAVE."
8219 REM NEC Keyboard buffer and count.
8220 KB=65129: KC=65128
8230 R$="RETURN"+CHR$(13)
8239 ' "Type" into keyboard buffer.
8240 FOR I=0 TO LEN(R$)-1
8250 POKE KB+I*2, ASC(MID$(R$,I+1,1))
8260 NEXT I
8269 ' Number of keys "typed".
8270 POKE KC, LEN(R$)
8280 BSAVE WL$,0,SZ
8289 REM NEC BASIC NEVER GETS HERE
8290 STOP: RETURN
8300 REM OLIVETTI ALSO HAS THE BUG!
8310 PRINT "Olivetti detected! Fixing SAVEM"
8319 REM Olivetti Keyboard buffer and count.
8320 KB=65390: KC=65389
8330 R$="RETURN"+CHR$(13)
8339 ' "Type" into keyboard buffer.
8340 FOR I=0 TO LEN(R$)-1
8350 POKE KB+I*2, ASC(MID$(R$,I+1,1))
8360 NEXT I
8369 ' Number of keys "typed".
8370 POKE KC, LEN(R$)
8380 SAVEM WL$,0,SZ
8389 REM OLIVETTI BASIC NEVER GETS HERE
8390 STOP: RETURN
9999 END
