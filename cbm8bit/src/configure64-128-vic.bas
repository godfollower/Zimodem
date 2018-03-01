!--------------------------------------------------
!- Thursday, March 01, 2018 12:53:43 AM
!- Import of : 
!- z:\unsorted\configure.prg
!- Commodore 64
!--------------------------------------------------
1 REM CONFIGURE64/128  1200B 2.0+
2 REM UPDATED 02/28/2018 02:54P
5 POKE254,PEEK(186):IFPEEK(254)<8THENPOKE254,8
10 SY=PEEK(65532):IFSY=61THENPOKE58,254:CLR
13 IFSY=34THENX=23777:POKEX,170:IFPEEK(X)<>170THENPRINT"<16k":STOP
15 OPEN5,2,0,CHR$(8):IFPEEK(65532)=34THENPOKE56,87:POKE54,87:POKE52,87
17 DIMWF$(100):WF=0:P$="ok":DIMPB$(50):POKE186,PEEK(254)
20 CR$=CHR$(13):PRINTCHR$(14);:SY=PEEK(65532):POKE53280,254:POKE53281,246
30 CO$="{light blue}":IFSY=226THENML=49152:POKE665,73-(PEEK(678)*30)
35 IFSY=34THENML=22273:IFPEEK(ML)<>76THENCLOSE5:LOAD"pmlvic.bin",PEEK(254),1:RUN
38 IFSY=34THENPOKE36879,27:CO$=CHR$(31)
40 IFSY=226ANDPEEK(ML+1)<>209THENCLOSE5:LOAD"pml64.bin",PEEK(254),1:RUN
50 IFSY=61THENML=4864:POKE981,15:P=PEEK(215)AND128:IFP=128THENSYS30643
60 IFSY=61ANDPEEK(ML+1)<>217THENCLOSE5:LOAD"pml128.bin",PEEK(254),1:RUN
70 IFSY=61THENCO$=CHR$(159)
100 REM
110 P$="a"
120 PRINTCO$;"{clear}{down*2}CONFIGURE v1.5":PRINT"Requires C64Net WiFi Firmware 2.0+"
130 PRINT"1200 baud version"
140 PRINT"By Bo Zimmerman (bo@zimmers.net)":PRINT:PRINT
197 REM --------------------------------
198 REM GET STARTED                    !
199 REM -------------------------------
200 PH=0:PT=0:MV=ML+18:CR$=CHR$(13)+CHR$(10):QU$=CHR$(34):POKEMV+14,5
202 PRINT "Initializing modem...";:CT=0
203 GET#5,A$:IFA$<>""THEN203
205 PRINT#5,CR$;"athz0f0e0&p1";CR$;
206 GOSUB900:IFP$<>"OK"THENCT=CT+1:IFCT<10THEN203
207 IFCT<10THENGET#5,A$:IFA$<>""THEN207
208 IFCT<10THENPRINT#5,"athf3e0&p1";CR$;
209 IFCT<10THENGOSUB900:IFP$<>"OK"THENCT=CT+1:GOTO207
210 IFCT=10THENPRINT"Initialization failed.":PRINT"Is your modem set to 1200b?"
220 IFCT=10THENSTOP
300 PRINT:PRINT:GOTO 1000
897 REM --------------------------------
898 REM GET E$ FROM MODEM, OR ERROR    !
899 REM -------------------------------
900 E$="":P$=""
910 SYSML
920 IFE$<>""ANDP$<>E$THENPRINT"{reverse on}{red}Comm error. Expected ";E$;", Got ";P$;CO$;"{reverse off}"
925 RETURN
997 REM --------------------------------
998 REM THE MAIN LOOP                  !
999 REM -------------------------------
1000 CT=0:C1=0:CD=0:LC$="1":GOSUB1010:WI$=P$:GOSUB1010:IFP$=WI$THEN1030
1005 GOTO1000
1010 SYSML+12:PRINT#5,CR$;"ati3";CR$;
1020 GOSUB900:IFP$<>LC$THEN1025
1021 CT=CT+1:IFCT>3THENRETURN
1023 C1=0:GOTO1010
1025 LC$=P$:CT=0:C1=C1+1:IFC1>15THENP$="":RETURN
1027 GOTO1010
1029 RETURN
1030 WI$=P$:PRINT"Current WiFi SSI: ";WI$
1040 CD=0:IFWI$=""THEN2000
1045 GOSUB 1050:IFCD=0THEN2000
1047 GOTO4000
1050 PRINT:PRINT"Testing connection...";:TT=TI+200
1055 IFTI<TTTHEN1055
1060 CT=0:GET#5,A$:IFA$<>""THEN1060
1070 SYSML+12:PRINT#5,CR$;"atc";QU$;"98.138.253.109:80";QU$;CR$;
1080 GOSUB900:CD=1:IFP$="OK"THEN1080
1085 IFLEFT$(P$,8)<>"CONNECT "THENCD=0:CT=CT+1:ONCTGOTO1070,1070,1070,1070,1200
1090 FORI=1TO3:SYSML+12:PRINT#5,CR$;"ath0";CR$;:GOSUB900:NEXTI
1100 PRINT#5,CR$;"ath0";CR$;:GOSUB900
1200 IFCD=0THENPRINT"{reverse on}{red}Fail!{reverse off}";CO$
1210 IFCD=1THENPRINT"{reverse on}{light green}Success!{reverse off}";CO$
1220 RETURN
2000 SYSML+12:SYSML+12:PRINT:PRINT"Scanning for WiFi hotspots...";
2010 PRINT#5,CR$;"atw";CR$;
2020 GOSUB900:I=1:IFP$=""ORP$="OK"THENPRINT"Done!":PRINT:PRINT:GOTO3000
2030 IFI>=LEN(P$)THEN2100
2040 IFMID$(P$,I,1)=" "THENP$=LEFT$(P$,I-1):GOTO2100
2050 I=I+1:GOTO2030
2100 WF$(WF+1)=P$:WF=WF+1:GOTO2020
3000 PG=1
3100 LP=WF:IFLP>PG+15THENLP=PG+15
3110 FORI=PGTOLP:PRINTSTR$(I)+") ";WF$(I):NEXTI
3120 PRINT:PRINT"Enter X to Quit to BASIC."
3130 IFLP<WFTHENPRINT"Enter N for Next Page"
3140 IFPG>15THENPRINT"Enter P for Prev Page"
3150 PRINT"Enter a number to Connect to that SSI"
3200 PRINT"? ";:GOSUB5000:A$=P$:IFA$=""THEN3100
3210 IFA$="x"ORA$="X"THENCLOSE5:END
3220 IFA$="n"ORA$="N"THENIFLP<WFTHENPG=PG+15:GOTO3100
3230 IFA$="p"ORA$="P"THENIFPG>15THENPG=PG-15:GOTO3100
3240 A=ASC(MID$(A$,1,1)):IFA<48ORA>57THEN3100
3250 A=VAL(A$):IFA<PG OR A>PG+15 OR A>WFTHEN3100
3260 WI=A:PRINT"Attempt to connect to: ";WF$(A)
3300 PRINT"Enter WiFi Password: ";:GOSUB5000:PA$=P$
3400 SYSML+12:PRINT#5,CR$;"atw";QU$;WF$(WI);",";PA$;QU$;CR$;:GOSUB900
3410 IFP$="ERROR"THENPRINT"{reverse on}{red}Connect Fail!{reverse off}";CO$:GOTO3100
3415 IFP$="OK"THEN3420
3416 IFP$<>""THEN3400
3417 GOSUB900:GOTO3410
3420 PRINT"{reverse on}{light green}Connect success!{reverse off}";CO$
3430 PRINT
3431 TT=TI+300
3432 IFTI<TTTHEN3432
3440 CD=0:GOSUB1050:IFCD=0THEN3100
3450 PRINT"{reverse off}{light green}Saving new options..."
3460 SYSML+12:SYSML+12:SYSML+12
3470 PRINT#5,CR$;"atz0&we0&p1";CR$
3480 GOSUB900:IFP$<>"OK"ANDP$<>"ok"THEN3470
3490 P$="":SYSML+12:IFP$<>""THEN3490
3500 SYSML+12:CLOSE5:RUN
4000 PRINT"Change WiFi connection (y/N)? ";
4010 GETA$:IFA$="y"ORA$="Y"THENPRINT"Y":GOTO2000
4020 IFA$<>"n"ANDA$<>"N"ANDA$<>CHR$(13)THEN4010
4030 PRINT"N":PRINT
4100 PRINT"Current 'Phone' book:":PB=0
4110 PRINT#5,CR$;"atp";CR$
4120 TT=TI+100
4130 GOSUB900:IFP$=""ANDTI>TTTHEN4200
4140 IFP$=""THEN4130
4150 I=1:PP$=P$:IFP$="ok"ORP$="OK"THEN4200
4160 IFMID$(PP$,I,1)<>" "THENI=I+1:GOTO4160
4170 PP$=LEFT$(PP$,I-1)
4190 PB$(PB)=PP$:PB=PB+1:PRINTPB;") ";P$:GOTO4120
4200 PRINT" A ) Add new":PRINT" Q ) Quit to BASIC"
4210 PRINT:PRINT"Enter your choice: ";:GOSUB5000:Q$=P$
4220 QQ$=LEFT$(Q$,1):IFQQ$="q"ORQQ$="Q"THENCLOSE5:END
4230 QQ=VAL(Q$):IF(QQ<0ORQQ>PB)ANDQQ$<>"a"ANDQQ$<>"A"THENPRINT:GOTO4100
4240 IFQQ<=0THEN4300
4250 PRINT"E)dit or D)elete? ";
4260 GETA$:IFA$="e"ORA$="E"THENPRINT"E":B1$=PB$(QQ-1):GOTO4310
4270 IFA$<>"d"ANDA$<>"D"THEN4260
4280 PRINT"D"
4290 PRINT#5,"atp";CHR$(34);PB$(QQ-1);"=delete";CHR$(34):GOSUB900:GOTO4100
4300 PRINT"Phone number: ";:GOSUB5000:B1$=P$
4305 IFLEN(B1$)<3THENPRINT"Wrong.":GOTO4100
4310 FORI=1TOLEN(B1$):B1=ASC(MID$(B1$,I,1)):IFB1<48ORB1>57THENB1$=""
4320 NEXTI:IFB1$=""THENPRINT"Bad digits.":GOTO4100
4330 PRINT"Target host: ";:GOSUB5000:B2$=P$
4335 IFLEN(B2$)<4THENPRINT"Wrong.":GOTO4100
4340 PRINT"Target port: ";:GOSUB5000:B2=VAL(P$)
4345 IFB2<=0THENPRINT"Wrong.":GOTO4100
4350 B3$="":PRINT"Do PETSCII translation (y/n)? ";
4360 GOSUB4980:IFA=1THENB3$=B3$+"p"
4370 PRINT"Do TELNET translation (y/n)? ";
4380 GOSUB4980:IFA=1THENB3$=B3$+"t"
4390 PRINT"Do terminal Echo (y/n)? ";
4400 GOSUB4980:IFA=1THENB3$=B3$+"e"
4410 PRINT"Do XON/XOFF Flow Control (y/n)? ";
4420 GOSUB4980:IFA=1THENB3$=B3$+"x"
4430 B4$=MID$(STR$(B2),2)
4440 PRINT#5,"atp";B3$;CHR$(34);B1$;"=";B2$;":";B4$;CHR$(34):GOSUB900
4450 GOTO4100
4499 STOP
4980 GETA$:IFA$<>"y"ANDA$<>"Y"ANDA$<>"n"ANDA$<>"N"THEN4980
4990 A=0:AA$="N":IFA$="y"ORA$="Y"THENAA$="Y":A=1
4995 PRINTAA$:RETURN
5000 P$=""
5005 PRINT"{reverse on} {reverse off}{left}";
5010 GETA$:IFA$=""THEN5010
5020 IFA$=CHR$(13)THENPRINT" {left}":RETURN
5030 IFA$<>CHR$(20)THENPRINTA$;"{reverse on} {reverse off}{left}";:P$=P$+A$:GOTO5010
5040 IFP$=""THEN5010
5050 P$=LEFT$(P$,LEN(P$)-1):PRINT" {left*2} {left}{reverse on} {reverse off}{left}";:GOTO5010
49999 STOP
50000 OPEN5,2,0,CHR$(8)
50010 GET#5,A$:IFA$<>""THENPRINTA$;
50020 GETA$:IFA$<>""THENPRINT#5,A$;
50030 GOTO 50010
55555 F$="configure":OPEN1,8,15,"s0:"+F$:CLOSE1:SAVE(F$),8:VERIFY(F$),8
