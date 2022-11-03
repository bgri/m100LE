0 CLEAR
1 REM CMPRSS By hackerb9, 2022
5 REM Read five letter words from one file and output a three byte representations to a new .CO file.
6 REM Uses Ram Directory to POKE the          data directly into the .CO file.
7 REM Note The .CO file is currently hardcoded to fit 366 three-byte words.
9 ON ERROR GOTO 9990
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
205 ON ERROR GOTO 9910
207 PRINT "Waiting for ";IN$;CHR$(13);
210 OPEN IN$ FOR INPUT AS #1
212 ON ERROR GOTO 9940 ' IO error
213 IF EOF(1) THEN GOTO 400
215 ON ERROR GOTO 9920
220 GOSUB 7000 ' Create .CO file
225 ON ERROR GOTO 9930
230 GOSUB 8000 ' WA=addr of .CO file
240 IF WA=0 THEN GOTO 9930
250 ON ERROR GOTO 9990
255 B(0)=223:B(1)=73:B(2)=168
256 FOR I=0 TO 2: POKE WA+6+365*3+I, B(I): NEXT I
300 REM LOOP: Read, Encode, Write
305 DY=0
308 ON ERROR GOTO 9940
310 IF EOF(1) THEN GOTO 400
315 IF DY>=366 THEN PRINT "Stopped reading at 366 words": GOTO 400
320 LINE INPUT #1, A$
325 ON ERROR GOTO 9990
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
7000 REM Create .CO file to hold compressed wordlist
7004 'For NEC, fix bug in BSAVE.
7004 'For K85 & M10, fix SAVEM.
7006 'For Tandy, use ordinary SAVEM.
7010 ID=PEEK(1)
7019 ' Allocate space for 366 words
7020 SZ=366 * 3
7030 NK=1     ' On error, kill .CO file
7039 '148=NEC 225=K85 35=M10 125=M10-US
7040 IF (ID=148 OR ID=225 OR ID=35 OR ID=125) THEN GOSUB 8500: ELSE SAVEM WL$, 0, SZ-1
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
8009 ' HW ID 51=M100, 171=T200, 167=T102           148=NEC,  225=K85,                       35=M10 (Italy), 125=M10 (US)
8010 ID=PEEK(1)
8012 ' RD: RAM DIRECTORY ADDRESS. (Anderson's "Programming Tips" gives RD=63842 for M100/102 and 62034 for T200.)
8013 ' (Gary Weber's NEC.MAP gives RD=63567, but we can skip the system files by starting at 63633.)
8014 ' (Hackerb9 found K85 and M10 (with ROM ID=35) as having RD=63849)
8015 ' (Is M10 USA (ROM ID=125) the same as K85?)
8016 RD=-( 63842*(ID=51 OR ID=167)               + 62034*(ID=171)                        + 63633*(ID=148)                        + 63849*(ID=225 OR ID=35 OR ID=125) )
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
8499 '
8500 REM SAVEM KLUDGE
8501 ' Workaround a bug that drops the
8502 ' user into DIRECT MODE, halting
8503 ' the running program. The solution
8504 ' is to have the user type "RETURN"
8505 ' and hit the Enter key to jump
8506 ' back into the program.
8507 ' A nicer method is to fill the
8508 ' keyboard buffer as if the user
8509 ' had typed RETURN.
8510 PRINT "Bug detected! Fixing SAVEM/BSAVE."
8520 R$="RETURN"+CHR$(13)
8530 GOSUB 8800	      ' "Type" R$
8540 IF ID=148 THEN BSAVE WL$,0,SZ:     ELSE SAVEM WL$,0,SZ-1
8549 REM BASIC NEVER GETS HERE!
8550 STOP: RETURN
8799 '
8800 REM INSERT R$ INTO KEYBOARD BUFFER
8801 ' INPUT: R$, a string of <=32 char
8802 ' OUTPUT: None. Types R$ on kbd.
8805 ' TEMP: ID: Machine platform
8806 '       KC: Key count address
8807 '       KB: Keyboard buffer addrss
8808 '    I, SK: Loop iterator, skip
8809 '
8810 ID=PEEK(1)
8820 KC=-( 65128*(ID=148)                        + 65389*(ID=35 OR ID=125)               + 65387*(ID=225)               + 64799*(ID=171)                        + 65450*(ID=51 OR ID=167) )
8830 IF KC=0 THEN PRINT "Error: Keyboard buffer address not known for machine ID";ID;". Please file a bug report.": END
8840 KB=KC+1
8850 IF (LEN(R$) > 32) THEN PRINT "Error: String too long to fit in keyboard buffer: ";R$: END
8860 IF (LEN(R$) = 0) THEN RETURN
8870 SK=2 'Read every other byte
8879 ' Olivetti reads every byte
8880 IF (ID=35 OR ID=125) THEN SK=1
8889 ' "Type" into keyboard buffer.
8890 FOR I=0 TO LEN(R$)-1
8900 POKE KB+I*SK, ASC(MID$(R$,I+1,1))
8910 NEXT I
8919 ' Number of keys "typed".
8920 POKE KC, LEN(R$)
8930 RETURN
9900 REM Error handling
9910 PRINT "Could not open "IN$" for reading": GOTO 9990
9920 PRINT "Could not allocate" SZ "bytes for " WL$: GOTO 9990
9930 PRINT "Error finding address of "WL$: GOTO 9990
9940 PRINT "Error reading from "IN$: GOTO 9990
9989 REM Generic error handler
9990 PRINT"Got error" ERR "in line" ERL
9995 ' Do we need to remove the .CO file?
9996 IF NK=1 THEN KILL WL$
9999 ON ERROR GOTO 0: ERROR ERR: END
