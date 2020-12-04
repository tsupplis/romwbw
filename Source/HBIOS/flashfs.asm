;
;==================================================================================================
;   FLASH DRIVER FOR FLASH & EEPROM PROGRAMMING 
;
;	26 SEP 2020 - CHIP IDENTIFICATION IMPLMENTED -- PHIL SUMMERS
;		    - CHIP ERASE IMPLEMENTED
;	23 OCT 2020 - SECTOR ERASE IMPLEMENTED
;	01 NOV 2020 - WRITE SECTOR IMPLEMENTED
;	04 DEC 2020 - READ SECTOR IMPLEMENTED
;==================================================================================================
;
;	UPPER RAM BANK IS ALWAYS AVAILABLE REGARDLESS OF MEMORY BANK SELECTION. HBX_BNKSEL AND
;	HB_CURBNK ARE ALWAYS AVAILABLE IN UPPER MEMORY AND THE STACK IS ALSO IN UPPER MEMORY DURING 
;	BIOS INITIALIZATION. TO ACCESS THE FLASH CHIP FEATURES, CODE IS COPIED TO THE UPPER RAM BANK 
;	AND THE FLASH CHIP IS SWITCHED INTO THE LOWER BANK.
;
;	INSPIRED BY WILL SOWERBUTTS FLASH4 UTILITY - https://github.com/willsowerbutts/flash4/
;
;==================================================================================================
;
FF_DBG:	.EQU	0			; DEBUG
;
;======================================================================
; BIOS FLASH INITIALIZATION
;
; IDENTIFY AND DISPLAY FLASH CHIPS IN SYSTEM.
; USES MEMORY SIZE DEFINED BY BUILD CONFIGURATION.
;======================================================================
;
;
FF_INIT:
	CALL	NEWLINE			; DISLAY NUMBER
	PRTS("FF: UNITS=$")		; OF UNITS 
	LD	A,+(ROMSIZE/512)	; CONFIGURED FOR.
	CALL	PRTDECB
;
	LD	B,A			; NUMBER OF DEVICES TO PROBE
	LD	C,$00			; START ADDRESS IS 0000:0000 IN DE:HL
FF_PROBE:
	LD	D,$00			; SET ADDRESS IN DE:HL
	LD	E,C			;
	LD	H,D			; WE INCREASE E BY $08
	LD	L,D			; ON EACH CYCLE THROUGH
;	
	PUSH	BC
	CALL	PC_SPACE
	LD	A,+(ROMSIZE/512)+1
	SUB	B			; PRINT
	CALL	PRTDECB			; DEVICE 
	LD	A,'='			; NUMBER
	CALL	COUT
	CALL	FF_IINIT		; GET ID AT THIS ADDRESS
	CALL	FF_LAND			; LOOKUP AND DISPLAY
	POP	BC
;
	LD	A,C			; UPDATE ADDRESS
	ADD	A,$08			; TO NEXT DEVICE
	LD	C,A
;
	DJNZ	FF_PROBE		; ALWAYS AT LEAST ONE DEVICE
;
#IF (FF_DBG==1)
	CALL	FF_TESTING
#ENDIF
;
	XOR	A			; INIT SUCCEEDED
	RET
;
;======================================================================
; TEST CODE AREA
;======================================================================
;
FF_TESTING:
;
#IF (0)
	LD	DE,$0008		; SET
	LD	HL,$0000		; ADDRESS
	CALL	FF_EINIT		; CHIP ERASE
	CALL	PRTHEXBYTE		; DISPLAY STATUS
#ENDIF	
;
#IF (0)
	LD	DE,$000A		; SET
	LD	HL,$8000		; ADDRESS
	CALL	FF_SINIT		; SECTOR ERASE
	CALL	PRTHEXBYTE		; DISPLAY STATUS
#ENDIF
;
#IF (0)
	LD	DE,$000A		; SET DESTINATION
	LD	HL,$8000		; ADDRESS
	LD	IX,FF_BUFFER		; SET SOURCE ADDRESS
	CALL	FF_WINIT		; WRITE SECTOR
	CALL	PRTHEXBYTE		; DISPLAY STATUS

#ENDIF
;
#IF (0)
	LD	DE,$0007		; SET SOURCE
	LD	HL,$F000		; ADDRESS
	LD	IX,FF_BUFFER		; SET DESTINATION ADDRESS
	CALL	FF_RINIT		; READ SECTOR
	CALL	PRTHEXBYTE		; DISPLAY STATUS
	LD	DE,FF_BUFFER
	CALL	DUMP_BUFFER
#ENDIF
;
	RET
;
;======================================================================
; LOOKUP AND DISPLAY CHIP
;
; ON ENTRY DE CONTAINS CHIP ID
; ON EXIT  A  CONTAINS STATUS 0=SUCCESS, NZ=NOT IDENTIFIED
;======================================================================
;
FF_LAND:
;
#IF (FF_DBG==1)
	PRTS(" ID:$")
	LD	H,E
	LD	L,D
	CALL	PRTHEXWORDHL		; DISPLAY FLASH ID
	CALL	PC_SPACE
#ENDIF
;
	LD	HL,FF_TABLE		; SEARCH THROUGH THE FLASH
	LD	BC,FF_T_CNT		; TABLE TO FIND A MATCH
FF_NXT1:LD	A,(HL)
	CP	D
	JR	NZ,FF_NXT0		; FIRST BYTE DOES NOT MATCH
;
	INC	HL		
	LD	A,(HL)
	CP	E
	DEC	HL
	JR	NZ,FF_NXT0		; SECOND BYTE DOES NOT MATCH
;
	INC	HL
	INC	HL
	JR	FF_NXT2			; MATCH SO EXIT
;
FF_NXT0:PUSH	BC			; WE DIDN'T MATCH SO POINT
	LD	BC,FF_T_SZ		; TO THE NEXT TABLE ENTRY
	ADD	HL,BC
	POP	BC
;
	LD	A,B			; CHECK IF WE REACHED THE
	OR	C			; END OF THE TABLE
	DEC	BC
	JR	NZ,FF_NXT1		; NOT AT END YET
;
	LD	HL,FF_UNKNOWN		; WE REACHED THE END WITHOUT A MATCH
;
FF_NXT2:CALL	PRTSTR			; AFTER SEARCH DISPLAY THE RESULT
	RET
;======================================================================
;COMMON FUNCTION CALL
;
;======================================================================
;
FF_FNCALL:
	CALL	FF_CALCA		; GET BANK AND SECTOR DATA IN IY
;
	POP	DE			; GET ROUTINE TO CALL
;
	LD	(FF_STACK),SP		; SAVE STACK
	LD	HL,(FF_STACK)
;
	LD	BC,64
;	LD	BC,FF_I_SZ		; CODE SIZE REQUIRED
	CCF				; CREATE A RELOCATABLE
	SBC	HL,BC			; CODE BUFFER IN THE
	LD	SP,HL			; STACK AREA
;
	PUSH	HL			; SAVE THE EXECUTE ADDRESS
	EX	DE,HL			; PUT EXECUTE / START ADDRESS IN DE
;	LD	HL,FF_IDENT		; COPY OUR RELOCATABLE
	LDIR				; CODE TO THE BUFFER
	POP	HL			; CALL OUR RELOCATABLE CODE

	PUSH	IY			; PUT BANK AND SECTOR
	POP	BC			; DATA IN BC
;
#IF (FF_DBG==1)
	CALL	PRTHEXWORD
#ENDIF
;
	HB_DI
	CALL	JPHL			; EXECUTE RELOCATED CODE
	HB_EI
;
	LD	HL,(FF_STACK)		; RESTORE ORIGINAL 
	LD	SP,HL			; STACK POSITION
;
#IF (FF_DBG==1)
	CALL	PRTHEXWORD
	CALL	PC_SPACE
	EX	DE,HL
	CALL	PRTHEXWORDHL
	CALL	PC_SPACE
	EX	DE,HL
#ENDIF
;
	LD	A,C			; RETURN WITH STATUS IN A
;
	RET
;
;======================================================================
; IDENTIFY FLASH CHIP. 
;  CALCULATE BANK AND ADDRESS DATA FROM ENTRY ADDRESS
;  CREATE A CODE BUFFER IN HIGH MEMORY AREA
;  COPY FLASH CODE TO CODE BUFFER
;  CALL RELOCATED FLASH IDENTITY CODE
;  RESTORE STACK
;  RETURN WITH ID CODE.
;
; ON ENTRY DE:HL POINTS TO AN ADDRESS WITH THE ADDRESS RANGE OF THE
;                CHIP TO BE IDENTIFIED.
; ON EXIT  DE CONTAINS THE CHIP ID BYTES.
;          NO STATUS IS RETURNED               
;======================================================================
;
FF_IINIT:
	PUSH	HL			; SAVE ADDRESS INFO
	LD	HL,FF_IDENT		; PUT ROUTINE TO CALL
	EX	(SP),HL			; ON THE STACK
	JP	FF_FNCALL		; EXECUTE
;
;======================================================================
; FLASH IDENTIFY
;  SELECT THE APPROPRIATE BANK / ADDRESS
;  ISSUE ID COMMAND
;  READ IN ID WORD
;  ISSUE ID EXIT COMMAND
;  SELECT ORIGINAL BANK
;
; ON ENTRY BC CONTAINS BANK AND SECTOR DATA
;          A  CONTAINS CURRENT BANK 
; ON EXIT  DE CONTAINS ID WORD
;          NO STATUS IS RETURNED 
;======================================================================
;
FF_IDENT:				; THIS CODE GETS RELOCATED TO HIGH MEMORY
;
	PUSH	AF			; SAVE CURRENT BANK
	LD	A,B			; SELECT BANK
	CALL	HBX_BNKSEL		; TO PROGRAM
;
	LD	HL,$5555		; LD	A,$AA			; COMMAND
	LD	(HL),$AA		; LD	($5555),A		; SETUP
	LD	A,H			; LD	A,$55
	LD	($2AAA),A		; LD	($2AAA),A
	LD	(HL),$90		; LD	A,$90
;					; LD	($5555),A
	LD	DE,($0000)						; READ ID
;
	LD	A,$F0			; 				; EXIT 
	LD	(HL),A			; LD	($5555),A		; COMMAND
;
	POP	AF			; RETURN TO ORIGINAL BANK
	CALL	HBX_BNKSEL		; WHICH IS OUR RAM BIOS COPY
;
	RET
;
FF_I_SZ	.EQU	$-FF_IDENT		; SIZE OF RELOCATABLE CODE BUFFER REQUIRED
;
;======================================================================
; FLASH CHIP ERASE.
;  CALCULATE BANK AND ADDRESS DATA FROM ENTRY ADDRESS
;  CREATE A CODE BUFFER IN HIGH MEMORY AREA
;  COPY FLASH CODE TO CODE BUFFER
;  CALL RELOCATED FLASH ERASE CODE
;  RESTORE STACK
;  RETURN WITH STATUS CODE.
;
; ON ENTRY DE:HL POINTS TO AN ADDRESS IDENTIFYING THE CHIP
; ON EXIT  A     RETURNS STATUS FLASH 0=SUCCESS FF=FAIL
;======================================================================
;
FF_EINIT:
	PUSH	HL			; SAVE ADDRESS INFO
	LD	HL,FF_ERASE		; PUT ROUTINE TO CALL
	EX	(SP),HL			; ON THE STACK
	JP	FF_FNCALL		; EXECUTE
;
;======================================================================
; ERASE FLASH CHIP. 
;
;  SELECT THE APPROPRIATE BANK / ADDRESS
;  ISSUE ERASE COMMAND
;  POLL TOGGLE BIT FOR COMPLETION STATUS.
;  SELECT ORIGINAL BANK
;
; ON ENTRY BC CONTAINS BANK AND SECTOR DATA
;          A  CONTAINS CURRENT BANK 
; ON EXIT  DE CONTAINS ID WORD
;          A  RETURNS STATUS FLASH 0=SUCCESS FF=FAIL
;======================================================================
;
FF_ERASE:				; THIS CODE GETS RELOCATED TO HIGH MEMORY
;
	PUSH	AF			; SAVE CURRENT BANK
	LD	A,B			; SELECT BANK
	CALL	HBX_BNKSEL		; TO PROGRAM
;
	LD	HL,$5555		; LD	A,$AA		; COMMAND
	LD	(HL),$AA		; LD	($5555),A	; SETUP
	LD	A,L			; LD	A,$55
	LD	($2AAA),A		; LD	($2AAA),A
	LD	(HL),$80		; LD	A,$80
	LD	(HL),$AA		; LD	($5555),A
	LD	A,L			; LD	A,$AA
	LD	($2AAA),A		; LD	($5555),A
	LD	(HL),$10		; LD	A,$55
					; LD	($2AAA),A
					; LD	A,$10
					; LD	($5555),A
;
	LD	A,(HL)			; DO TWO SUCCESSIVE READS FROM THE SAME FLASH ADDRESS. 
FF_WT2:	LD	C,(HL)			; IF TOGGLE BIT (BIT 6) 
	XOR	C			; IS THE SAME ON BOTH READS
	BIT	6,A			; THEN ERASE IS COMPLETE SO EXIT.
	JR	Z,FF_WT1		; Z TRUE IF BIT 6=0 I.E. "NO TOGGLE" WAS DETECTED. 
;
	LD	A,C			; OPERATION IS NOT COMPLETE. CHECK TIMEOUT BIT (BIT 5).
	BIT	5,C			; IF NO TIMEOUT YET THEN LOOP BACK AND KEEP CHECKING TOGGLE STATUS
	JR	Z,FF_WT2		; IF BIT 5=0 THEN RETRY; NZ TRUE IF BIT 5=1
;
	LD	A,(HL)			; WE GOT A TIMEOUT. RECHECK TOGGLE BIT IN CASE WE DID COMPLETE 
	XOR	(HL)			; THE OPERATION. DO TWO SUCCESSIVE READS. ARE THEY THE SAME?
	BIT	6,A			; IF THEY ARE THEN OPERATION WAS COMPLETED					
	JR	Z,FF_WT1		; OTHERWISE ERASE OPERATION FAILED OR TIMED OUT.
;
	LD	(HL),$F0		; WRITE DEVICE RESET
	LD	C,$FF			; SET FAIL STATUS
	JR	FF_WT3
;
FF_WT1:	LD	C,0			; SET SUCCESS STATUS
FF_WT3:	POP	AF
;	LD	A,B			; RETURN TO ORIGINAL BANK
	CALL	HBX_BNKSEL		; WHICH IS OUR RAM BIOS COPY
	RET
;
FF_E_SZ	.EQU	$-FF_ERASE		; SIZE OF RELOCATABLE CODE BUFFER REQUIRED
;
;======================================================================
; CALCULATE BANK AND ADDRESS DATA FROM MEMORY ADDRESS
;
; ON ENTRY DE:HL CONTAINS 32 BIT MEMORY ADDRESS.
; ON EXIT  I,B   CONTAINS BANK SELECT BYTE
;          Y,C   CONTAINS HIGH BYTE OF SECTOR ADDRESS
;          A     CONTAINS CURRENT BANK HB_CURBNK
;
; DDDDDDDDEEEEEEEE HHHHHHHHLLLLLLLL
; 3322222222221111 1111110000000000
; 1098765432109876 5432109876543210
; XXXXXXXXXXXXSSSS SSSSXXXXXXXXXXXX < S = SECTOR
; XXXXXXXXXXXXBBBB BXXXXXXXXXXXXXXX < B = BANK
;======================================================================
;
FF_CALCA:
;
#IF (FF_DBG==1)
	CALL	PC_SPACE	; DISPLAY SECTOR
	CALL	PRTHEX32	; SECTOR ADDRESS 
	CALL	PC_SPACE	; IN DE:HL
#ENDIF
;
	LD	A,E		; BOTTOM PORTION OF SECTOR
	AND	$0F		; ADDRESS THAT GETS WRITTEN
	RLC	H		; WITH ERASE COMMAND BYTE
	RLA			; A15 GETS DROPPED OFF AND
	LD	B,A		; ADDED TO BANK SELECT
;
	LD	A,H		; TOP SECTION OF SECTOR
	RRA			; ADDRESS THAT GETS WRITTEN
	AND	$70		; TO BANK SELECT PORT
	LD	C,A
;
	PUSH	BC
	POP	IY
;
#IF (FF_DBG==1)
	CALL	PRTHEXWORD	; DISPLAY BANK AND
	CALL	PC_SPACE	; SECTOR RESULT
#ENDIF
;
	LD	A,(HB_CURBNK)	; WE ARE STARTING IN HB_CURBNK
;
	RET
;
;======================================================================
; ERASE FLASH SECTOR
;
; ON ENTRY DE:HL CONTAINS 32 BIT MEMORY ADDRESS.
;  CALCULATE BANK AND ADDRESS DATA FROM ENTRY ADDRESS
;  CREATE A CODE BUFFER IN HIGH MEMORY AREA
;  COPY FLASH CODE TO CODE BUFFER
;  CALL RELOCATED FLASH ERASE CODE
;  RESTORE STACK
;  RETURN WITH STATUS CODE.
;
; ON ENTRY DE:HL POINTS TO AN ADDRESS IDENTIFYING THE CHIP
; ON EXIT  A     RETURNS STATUS FLASH 0=SUCCESS FF=FAIL
;======================================================================
;
FF_SINIT:
	PUSH	HL			; SAVE ADDRESS INFO
	LD	HL,FF_SERASE		; PUT ROUTINE TO CALL
	EX	(SP),HL			; ON THE STACK
	JP	FF_FNCALL		; EXECUTE
;
;======================================================================
; ERASE FLASH SECTOR. 
;
;  SELECT THE APPROPRIATE BANK / ADDRESS
;  ISSUE ERASE SECTOR COMMAND
;  POLL TOGGLE BIT FOR COMPLETION STATUS.
;  SELECT ORIGINAL BANK
;
; ON ENTRY BC CONTAINS BANK AND SECTOR DATA
;          A  CONTAINS CURRENT BANK 
; ON EXIT  A  RETURNS STATUS FLASH 0=SUCCESS FF=FAIL
;======================================================================
;
FF_SERASE:				; THIS CODE GETS RELOCATED TO HIGH MEMORY
;
	PUSH	AF			; SAVE CURRENT BANK
	LD	A,B			; SELECT BANK
	CALL	HBX_BNKSEL		; TO PROGRAM
					;
	LD	HL,$5555		; LD	A,$AA			; COMMAND
	LD	A,L			; LD	($5555),A		; SETUP	
	LD	(HL),$AA		; LD	A,$55
	LD	($2AAA),A		; LD	($2AAA),A
	LD	(HL),$80		; LD	A,$80
	LD	(HL),$AA		; LD	($5555),A
	LD	($2AAA),A		; LD	A,$AA
					; LD	($5555),A
					; LD	A,$55
					; LD	($2AAA),A

	LD	H,C			; SECTOR 
	LD	L,$00			; ADDRESS
;
	LD	A,$30			; SECTOR ERASE
	LD	(HL),A			; COMMAND
;
;	LD	DE,$0000		; DEBUG COUNT
;
	LD	A,(HL)			; DO TWO SUCCESSIVE READS
FF_WT4:	LD	C,(HL)			; FROM THE SAME FLASH ADDRESS.
	XOR	C			; IF THE SAME ON BOTH READS
	BIT	6,A			; THEN ERASE IS COMPLETE SO EXIT.
;	INC	DE			; 
	JR	Z,FF_WT5		; BIT 6 = 0 IF SAME ON SUCCESSIVE READS = COMPLETE
					; BIT 6 = 1 IF DIFF ON SUCCESSIVE READS = INCOMPLETE
;
	LD	A,C			; OPERATION IS NOT COMPLETE. CHECK TIMEOUT BIT (BIT 5).
	BIT	5,C			; IF NO TIMEOUT YET THEN LOOP BACK AND KEEP CHECKING TOGGLE STATUS
	JR	Z,FF_WT4		; IF BIT 5=0 THEN RETRY; NZ TRUE IF BIT 5=1
;
	LD	A,(HL)			; WE GOT A TIMOUT. RECHECK TOGGLE BIT IN CASE WE DID COMPLETE 
	XOR	(HL)			; THE OPERATION. DO TWO SUCCESSIVE READS. ARE THEY THE SAME?
	BIT	6,A			; IF THEY ARE THEN OPERATION WAS COMPLETED					
	JR	Z,FF_WT5		; OTHERWISE ERASE OPERATION FAILED OR TIMED OUT.
;
	LD	(HL),$F0		; WRITE DEVICE RESET
	LD	C,$FF			; SET FAIL STATUS
	JR	FF_WT6
;
FF_WT5:	LD	C,0			; SET SUCCESS STATUS
FF_WT6:	POP	AF			; RETURN TO ORIGINAL BANK
	CALL	HBX_BNKSEL		; WHICH IS OUR RAM BIOS COPY
;
	RET
;
FF_S_SZ	.EQU	$-FF_SERASE		; SIZE OF RELOCATABLE CODE BUFFER REQUIRED
;
;======================================================================
; READ FLASH SECTOR OF 4096 BYTES
;
; SET ADDRESS TO START OF SECTOR
; CALCULATE BANK AND ADDRESS DATA FROM SECTOR START ADDRESS
;  CREATE A CODE BUFFER IN HIGH MEMORY AREA
;  COPY FLASH CODE TO CODE BUFFER
;  CALL RELOCATED FLASH READ SECTOR CODE
;  RESTORE STACK
;
; ON ENTRY DE:HL POINTS TO A 32 BIT MEMORY ADDRESS.
;          IX    POINTS TO WHERE TO SAVE DATA
;======================================================================
;
FF_RINIT:
	LD	L,0			; CHANGE ADDRESS
	LD	A,H			; TO SECTOR BOUNDARY
	AND	$F0			; BY MASKING OFF
	LD	H,A			; LOWER 12 BITS
;
	PUSH	HL			; SAVE ADDRESS INFO
	LD	HL,FF_SREAD		; PUT ROUTINE TO CALL
	EX	(SP),HL			; ON THE STACK
	JP	FF_FNCALL		; EXECUTE
;
	RET
;======================================================================
; FLASH READ SECTOR. 
;
;  SELECT THE APPROPRIATE BANK / ADDRESS
;  READ SECTOR OF 4096 BYTES, BYTE AT A TIME
;  SELECT SOURCE BANK,  READ DATA,
;	   SELECT DESTINATION BANK, WRITE DATA
;          DESTINATION BANK IS ALWAYS CURRENT BANK
;
; ON ENTRY BC CONTAINS BANK AND SECTOR DATA
;          IX POINTS TO DATA TO BE WRITTEN
;          A  CONTAINS CURRENT BANK 
; ON EXIT  A  RETURNS STATUS FLASH 0=SUCCESS FF=FAIL
;======================================================================
;
FF_SREAD:				; THIS CODE GETS RELOCATED TO HIGH MEMORY
;
	PUSH	AF			; SAVE CURRENT BANK
;
	LD	H,C			; SECTOR
	LD	L,$00			; ADDRESS
	LD	D,L			; INITIALIZE 
	LD	E,L			; BYTE COUNT
;
FF_RD1:
	LD	A,B			; SELECT BANK
	CALL	HBX_BNKSEL		; TO READ
	LD	C,(HL)			; READ BYTE
;
	POP	AF
	PUSH	AF			; SELECT BANK
	CALL	HBX_BNKSEL		; TO WRITE
	LD	(IX+0),C		; WRITE BYTE

	INC	HL			; NEXT SOURCE LOCATION
	INC	IX			; NEXT DESTINATION LOCATION
;
	INC	DE			; CONTINUE READING UNTIL
	BIT	4,D			; WE HAVE DONE ONE SECTOR
	JR	Z,FF_RD1

	POP	AF			; RETURN TO ORIGINAL BANK
;	CALL	HBX_BNKSEL		; WHICH IS OUR RAM BIOS COPY
	XOR	A
;
	RET
;
FF_R_SZ	.EQU	$-FF_SREAD		; SIZE OF RELOCATABLE CODE BUFFER REQUIRED
;
;======================================================================
; WRITE FLASH SECTOR OF 4096 BYTES
;
; *** SOURCE DATA MUST BE IN UPPER MEMORY
;
; SET ADDRESS TO START OF SECTOR
; CALCULATE BANK AND ADDRESS DATA FROM SECTOR START ADDRESS
;  CREATE A CODE BUFFER IN HIGH MEMORY AREA
;  COPY FLASH CODE TO CODE BUFFER
;  CALL RELOCATED FLASH WRITE SECTOR CODE
;  RESTORE STACK
;
; ON ENTRY DE:HL POINTS TO A 32 BIT MEMORY ADDRESS.
;          IX    POINTS TO DATA TO BE WRITTEN
;======================================================================
;
FF_WINIT:
	LD	L,0			; CHANGE ADDRESS
	LD	A,H			; TO SECTOR BOUNDARY
	AND	$F0			; BY MASKING OFF
	LD	H,A			; LOWER 12 BITS
;
	PUSH	HL			; SAVE ADDRESS INFO
	LD	HL,FF_SWRITE		; PUT ROUTINE TO CALL
	EX	(SP),HL			; ON THE STACK
	JP	FF_FNCALL		; EXECUTE
;
;======================================================================
; FLASH WRITE SECTOR. 
;
;  SELECT THE APPROPRIATE BANK / ADDRESS
;  WRITE 1 SECTOR OF 4096 BYTES, BYTE AT A TIME
;   ISSUE WRITE BYTE COMMAND AND WRITE THE DATA BYTE
;   POLL TOGGLE BIT FOR COMPLETION STATUS.
;  SELECT ORIGINAL BANK
;
; ON ENTRY BC CONTAINS BANK AND SECTOR DATA
;          IX POINTS TO DATA TO BE WRITTEN
;          A  CONTAINS CURRENT BANK 
; ON EXIT  A  RETURNS STATUS FLASH 0=SUCCESS FF=FAIL
;======================================================================
;
FF_SWRITE:				; THIS CODE GETS RELOCATED TO HIGH MEMORY
;
	PUSH	AF			; SAVE CURRENT BANK
	LD	A,B			; SELECT BANK
	CALL	HBX_BNKSEL		; TO PROGRAM
;
	LD	H,C			; SECTOR
	LD	L,$00			; ADDRESS
	LD	D,L			; INITIALIZE 
	LD	E,L			; BYTE COUNT
;
FF_WR1:
	LD	C,(IX+0)		; READ IN BYTE
;
	LD	A,$AA			; COMMAND
	LD	($5555),A		; SETUP
	LD	A,$55
	LD	($2AAA),A
;
	LD	A,$A0			; WRITE
	LD	($5555),A		; COMMAND
;
	LD	(HL),C			; WRITE OUT BYTE
;
;					; DO TWO SUCCESSIVE READS 
	LD	A,(HL)			; FROM THE SAME FLASH ADDRESS. 
FF_WT7:	LD	C,(HL)			; IF TOGGLE BIT (BIT 6) 
	XOR	C			; IS THE SAME ON BOTH READS
	BIT	6,A			; THEN ERASE IS COMPLETE SO EXIT.
	JR	NZ,FF_WT7		; Z TRUE IF BIT 6=0 I.E. "NO TOGGLE" WAS DETECTED. 
;
	INC	HL			; NEXT DESTINATION LOCATION
	INC	IX			; NEXT SOURCE LOCATION
;
	INC	DE			; CONTINUE WRITING UNTIL
	BIT	4,D			; WE HAVE DONE ONE SECTOR
	JR	Z,FF_WR1
;
	POP	AF			; RETURN TO ORIGINAL BANK
	CALL	HBX_BNKSEL		; WHICH IS OUR RAM BIOS COPY
;
	RET
;
FF_W_SZ	.EQU	$-FF_SWRITE		; SIZE OF RELOCATABLE CODE BUFFER REQUIRED
;
;======================================================================
;
;	FLASH STYLE
;
;======================================================================
;
ST_NORMAL	.EQU	0
ST_ERASE_CHIP	.EQU	1		; SECTOR BASED ERASE NOT SUPPORTED
ST_PROGRAM_SECT	.EQU	2
;
;======================================================================
;
; FLASH CHIP MACRO
;
;======================================================================
;
#DEFINE	FF_CHIP(FFROMID,FFROMNM,FFROMSS,FFROMSC,FFROMMD)\
#DEFCONT ;						\
#DEFCONT	.DW	FFROMID				\
#DEFCONT	.DB	FFROMNM				\
#DEFCONT	.DW	FFROMSS				\
#DEFCONT	.DW	FFROMSC				\
#DEFCONT	.DB	FFROMMD				\
#DEFCONT ;
;
;======================================================================
;
; FLASH CHIP LIST
;
;======================================================================
;
FF_TABLE:
FF_CHIP(00120H,"29F010$    ",128,8,ST_NORMAL)
FF_CHIP(001A4H,"29F040$    ",512,8,ST_NORMAL)
FF_CHIP(01F04H,"AT49F001NT$",1024,1,ST_ERASE_CHIP)
FF_CHIP(01F05H,"AT49F001N$ ",1024,1,ST_ERASE_CHIP)
FF_CHIP(01F07H,"AT49F002N$ ",2048,1,ST_ERASE_CHIP)
FF_CHIP(01F08H,"AT49F002NT$",2048,1,ST_ERASE_CHIP)
FF_CHIP(01F13H,"AT49F040$  ",4096,1,ST_ERASE_CHIP)
FF_CHIP(01F5DH,"AT29C512$  ",1,512,ST_PROGRAM_SECT)
FF_CHIP(01FA4H,"AT29C040$  ",2,2048,ST_PROGRAM_SECT)
FF_CHIP(01FD5H,"AT29C010$  ",1,1024,ST_PROGRAM_SECT)
FF_CHIP(01FDAH,"AT29C020$  ",2,1024,ST_PROGRAM_SECT)
FF_CHIP(02020H,"M29F010$   ",128,8,ST_PROGRAM_SECT)
FF_CHIP(020E2H,"M29F040$   ",512,8,ST_NORMAL)
FF_CHIP(0BFB5H,"39F010$    ",32,32,ST_NORMAL)
FF_CHIP(0BFB6H,"39F020$    ",32,64,ST_NORMAL)
FF_CHIP(0BFB7H,"39F040$    ",32,128,ST_NORMAL)
FF_CHIP(0C2A4H,"MX29F040$  ",512,8,ST_NORMAL)
;
FF_T_CNT	.EQU	17
FF_T_SZ		.EQU	($-FF_TABLE) / FF_T_CNT
FF_UNKNOWN	.DB	"UNKNOWN$"
FF_STACK:	.DW	0
;
;======================================================================
;
; 4K FLASH BUFFER
;
;======================================================================
;
FF_BUFFER	.FILL	4096,$FF
;======================================================================
;
; RELOCATABLE CODE SPACE REQUIREMENTS
;
;======================================================================
;
FF_CSIZE	.EQU	0
;
#IF (FF_W_SZ>FF_CSIZE)
FF_CSIZE	.SET	FF_W_SZ
#ENDIF
#IF (FF_S_SZ>FF_CSIZE)
FF_CSIZE	.SET	FF_S_SZ
#ENDIF
#IF (FF_E_SZ>FF_CSIZE)
FF_CSIZE	.SET	FF_E_SZ
#ENDIF
#IF (FF_I_SZ>FF_CSIZE)
FF_CSIZE	.SET	FF_I_SZ
#ENDIF
#IF (FF_R_SZ>FF_CSIZE)
FF_CSIZE	.SET	FF_R_SZ
#ENDIF
;
		.ECHO	"FF requires "
		.ECHO	FF_CSIZE
		.ECHO	" bytes stack space.\n"
