;
;==================================================================================================
; CH375/376 USB SUB-DRIVER
;==================================================================================================
;
; Thanks and credit to Alan Cox.  Much of this driver is based on
; his code in FUZIX (https://github.com/EtchedPixels/FUZIX).
;
; This file contains the USB Drive specific support for the CH37x
; driver.  This file is included by the core driver file (ch.asm) as
; needed.
;
; The USB support is implemented as pure raw sector I/O.  The CH376
; file-level support is not utilized.
;
; NOTES:
;  - There seem to be compatibility issues with older USB thumb drives.
;    Such drives will complete DISK_INIT successfully, but then return
;    an error attempting to do any I/O.  The error is $17 indicating
;    the CH37x encountered an overflow during communication with the
;    device.   I found that adding a DISK_MOUNT command (only possible
;    on CH376) resolved the issue for some devices, so that has been
;    added to the RESET routine when using CH376.
;
; TODO:
;  - Implement auto-recovery on error status?
;
CHUSB_FASTIO	.EQU	TRUE		; USE INIR/OTIR?
;
; CHUSB DEVICE STATUS
;
CHUSB_STOK	.EQU	0
CHUSB_STNOMEDIA	.EQU	-1
CHUSB_STCMDERR	.EQU	-2
CHUSB_STIOERR	.EQU	-3
CHUSB_STTO	.EQU	-4
CHUSB_STNOTSUP	.EQU	-5
;
; CHUSB DEVICE CONFIGURATION
;
CHUSB_CFGSIZ	.EQU	14		; SIZE OF USB CFG TBL ENTRIES
;
; CONFIG ENTRY DATA OFFSETS
;
; THE LOCATION OF CHSD_MODE IS SHARED BY ALL SUB-DRIVERS AND THE
; CH_SETMODE FUNCTION IN THE MAIN DRIVER (CH.ASM).  IF YOU CHANGE
; IT, YOU MUST SYNC UP THE MAIN DRIVER AND ALL SUB-DRIVERS!
;
; FIRST 3 BYTES SAME AS CH CONFIG
CHUSB_STAT	.EQU	3		; LAST STATUS (BYTE)
CHUSB_MEDCAP	.EQU	4		; MEDIA CAPACITY (DWORD)
CHUSB_LBA	.EQU	8		; CURRENT LBA (DWORD)
CHUSB_MODE	.EQU	12		; PTR TO MODE BYTE (WORD)
;
CHUSB_CFGTBL:
;
#IF (CHCNT >= 1)
CHUSB_CFG0:
	.DB	0			; DEV NUM, FILLED DYNAMICALLY
	.DB	CHTYP_NONE		; DEV TYPE, FILLED DYNCAMICALLY
	.DB	CH0BASE			; IO BASE ADDRESS
	.DB	0			; DEVICE STATUS
	.DW	0,0			; DEVICE CAPACITY
	.DW	0,0			; CURRENT LBA
	.DW	CH0_MODE		; POINTER TO MODE BYTE
;
  #IF (CH0USBENABLE)
	DEVECHO	"CHUSB: IO="
	DEVECHO	CH0BASE
	DEVECHO	"\n"
  #ENDIF
#ENDIF
;
#IF (CHCNT >= 2)
CHUSB_CFG1:
	.DB	0			; DEV NUM
	.DB	CHTYP_NONE		; DEV TYPE, FILLED DYNCAMICALLY
	.DB	CH1BASE			; IO BASE ADDRESS
	.DB	0			; DEVICE STATUS
	.DW	0,0			; DEVICE CAPACITY
	.DW	0,0			; CURRENT LBA
	.DW	CH1_MODE		; POINTER TO MODE BYTE
;
  #IF (CH1USBENABLE)
	DEVECHO	"CHUSB: IO="
	DEVECHO	CH1BASE
	DEVECHO	"\n"
  #ENDIF
#ENDIF
;
#IF ($ - CHUSB_CFGTBL) != (CHCNT * CHUSB_CFGSIZ)
	.ECHO	"*** INVALID CHUSB CONFIG TABLE ***\n"
#ENDIF
;
	.DB	$FF			; END OF TABLE MARKER
;
;
;
CHUSB_INIT:
	LD	A,(IY+CH_TYPE)		; GET DEVICE TYPE
	PUSH	HL			; COPY INCOMING HL
	POP	IY			; ... TO IY
	LD	(IY+CH_TYPE),A		; SAVE DEVICE TYPE
;
	; UPDATE DRIVER RELATIVE UNIT NUMBER IN CONFIG TABLE
	LD	A,(CHUSB_DEVNUM)	; GET NEXT UNIT NUM TO ASSIGN
	LD	(IY+CH_DEV),A		; UPDATE IT
	INC	A			; BUMP TO NEXT UNIT NUM TO ASSIGN
	LD	(CHUSB_DEVNUM),A	; SAVE IT
;
	; ADD UNIT TO GLOBAL DISK UNIT TABLE
	LD	BC,CHUSB_FNTBL		; BC := FUNC TABLE ADR
	PUSH	IY			; CFG ENTRY POINTER
	POP	DE			; COPY TO DE
	CALL	DIO_ADDENT		; ADD ENTRY TO GLOBAL DISK DEV TABLE
;
	CALL	CHUSB_RESET		; RESET & DISCOVER MEDIA
#IF (CHUSBTRACE <= 1)
	CALL	NZ,CHUSB_PRTSTAT
#ENDIF
	RET	NZ			; ABORT ON FAILURE
;
	; START PRINTING DEVICE INFO
	CALL	CHUSB_PRTPREFIX		; PRINT DEVICE PREFIX
;
	; PRINT STORAGE CAPACITY (BLOCK COUNT)
	PRTS(" BLOCKS=0x$")		; PRINT FIELD LABEL
	LD	A,CHUSB_MEDCAP		; OFFSET TO CAPACITY FIELD
	CALL	LDHLIYA			; HL := IY + A, REG A TRASHED
	CALL	LD32			; GET THE CAPACITY VALUE
	CALL	PRTHEX32		; PRINT HEX VALUE
;
	; PRINT STORAGE SIZE IN MB
	PRTS(" SIZE=$")			; PRINT FIELD LABEL
	LD	B,11			; 11 BIT SHIFT TO CONVERT BLOCKS --> MB
	CALL	SRL32			; RIGHT SHIFT
	CALL	PRTDEC32		; PRINT DWORD IN DECIMAL
	PRTS("MB$")			; PRINT SUFFIX
;
	XOR	A			; SIGNAL SUCCESS
	RET
;
; DRIVER FUNCTION TABLE
;
CHUSB_FNTBL:
	.DW	CHUSB_STATUS
	.DW	CHUSB_RESET
	.DW	CHUSB_SEEK
	.DW	CHUSB_READ
	.DW	CHUSB_WRITE
	.DW	CHUSB_VERIFY
	.DW	CHUSB_FORMAT
	.DW	CHUSB_DEVICE
	.DW	CHUSB_MEDIA
	.DW	CHUSB_DEFMED
	.DW	CHUSB_CAP
	.DW	CHUSB_GEOM
#IF (($ - CHUSB_FNTBL) != (DIO_FNCNT * 2))
	.ECHO	"*** INVALID CHUSB FUNCTION TABLE ***\n"
#ENDIF
;
CHUSB_VERIFY:
CHUSB_FORMAT:
CHUSB_DEFMED:
	SYSCHKERR(ERR_NOTIMPL)		; NOT IMPLEMENTED
	RET
;
;
;
CHUSB_READ:
	LD	A,CH_MODE_USB		; REQUEST USB MODE
	CALL	CH_SETMODE		; DO IT
	JP	NZ,CHUSB_CMDERR		; HANDLE ERROR
;
	CALL	HB_DSKREAD		; HOOK HBIOS DISK READ SUPERVISOR
	LD	(CHUSB_DSKBUF),HL	; SAVE DISK BUFFER ADDRESS
	LD	A,CH_CMD_DSKRD		; DISK READ COMMAND
	CALL	CHUSB_RWSTART		; SEND CMD AND LBA
;
	; READ THE SECTOR IN 64 BYTE CHUNKS
	LD	B,8			; 8 CHUNKS OF 64 FOR 512 BYTE SECTOR
	LD	HL,(CHUSB_DSKBUF)	; GET DISK BUF ADR
CHUSB_READ1:
	CALL	CH_POLL			; WAIT FOR DATA READY
	CP	$1D			; DATA READY TO READ?
	;CALL	PC_LT			; *DEBUG*
	;CALL	PRTHEXBYTE		; *DEBUG*
	JP	NZ,CHUSB_IOERR		; HANDLE IO ERROR
	CALL	CH_CMD_RD		; SEND READ USB DATA CMD
	CALL	CH_RD			; READ DATA BLOCK LENGTH
	CP	64			; AS EXPECTED?
	JP	NZ,CHUSB_IOERR		; IF NOT, HANDLE ERROR
;
#IF (CHUSB_FASTIO)
	; READ 64 BYTE CHUNK
	PUSH	BC			; SAVE LOOP CONTROL
	LD	B,64			; READ 64 BYTES
	LD	C,(IY+CH_IOBASE)	; BASE PORT
	INIR				; DO IT FAST
	POP	BC			; RESTORE LOOP CONTROL
#ELSE
	; BYTE READ LOOP
	PUSH	BC			; SAVE LOOP CONTROL
	LD	B,64			; READ 64 BYTES
CHUSB_READ2:
	CALL	CH_RD			; GET NEXT BYTE
	LD	(HL),A			; SAVE IT
	INC	HL			; INC BUF PTR
	DJNZ	CHUSB_READ2		; LOOP AS NEEDED
	POP	BC			; RESTORE LOOP CONTROL
#ENDIF
;
	; PREPARE FOR NEXT CHUNK
	LD	A,CH_CMD_DSKRDGO	; CONTINUE DISK READ
	CALL	CH_CMD			; SEND IT
	DJNZ	CHUSB_READ1		; LOOP TILL DONE
;
	; FINAL CHECK FOR COMPLETION & SUCCESS
	CALL	CH_POLL			; WAIT FOR COMPLETION
	CP	$14			; SUCCESS?
	JP	NZ,CHUSB_IOERR		; IF NOT, HANDLE ERROR
;
	; INCREMENT LBA
	PUSH	HL			; SAVE HL
	LD	A,CHUSB_LBA		; LBA OFFSET
	CALL	LDHLIYA			; HL := IY + A, REG A TRASHED
	CALL	INC32HL			; INCREMENT THE VALUE
	POP	HL			; RESTORE HL
;
	XOR	A			; SIGNAL SUCCESS
	RET
;
;
;
CHUSB_WRITE:
	LD	A,CH_MODE_USB		; REQUEST USB MODE
	CALL	CH_SETMODE		; DO IT
	JP	NZ,CHUSB_CMDERR		; HANDLE ERROR
;
	CALL	HB_DSKWRITE		; HOOK HBIOS DISK WRITE SUPERVISOR
	LD	(CHUSB_DSKBUF),HL	; SAVE DISK BUFFER ADDRESS
	LD	A,CH_CMD_DSKWR		; DISK READ COMMAND
	CALL	CHUSB_RWSTART		; SEND CMD AND LBA
;
	; WRITE THE SECTOR IN 64 BYTE CHUNKS
	LD	B,8			; 8 CHUNKS OF 64 FOR 512 BYTE SECTOR
	LD	HL,(CHUSB_DSKBUF)	; GET DISK BUF ADR
CHUSB_WRITE1:
	CALL	CH_POLL			; WAIT FOR DATA READY
	CP	$1E			; DATA READY TO WRITE
	;CALL	PC_GT			; *DEBUG*
	;CALL	PRTHEXBYTE		; *DEBUG*
	JP	NZ,CHUSB_IOERR		; HANDLE IO ERROR
	CALL	CH_CMD_WR		; SEND WRITE USB DATA CMD
	LD	A,64			; 64 BYTE CHUNK
	CALL	CH_WR			; SEND DATA BLOCK LENGTH
;
#IF (CHUSB_FASTIO)
	; WRITE 64 BYTE CHUNK
	PUSH	BC			; SAVE LOOP CONTROL
	LD	B,64			; WRITE 64 BYTES
	LD	C,(IY+CH_IOBASE)	; BASE PORT
	OTIR				; DO IT FAST
	POP	BC			; RESTORE LOOP CONTROL
#ELSE
	; BYTE WRITE LOOP
	PUSH	BC			; SAVE LOOP CONTROL
	LD	B,64			; WRITE 64 BYTES
CHUSB_WRITE2:
	LD	A,(HL)			; GET NEXT BYTE
	INC	HL			; INC BUF PTR
	CALL	CH_WR			; WRITE NEXT BYTE
	DJNZ	CHUSB_WRITE2		; LOOP AS NEEDED
	POP	BC			; RESTORE LOOP CONTROL
#ENDIF
;
	; PREPARE FOR NEXT CHUNK
	LD	A,CH_CMD_DSKWRGO	; CONTINUE DISK READ
	CALL	CH_CMD			; SEND IT
	DJNZ	CHUSB_WRITE1		; LOOP TILL DONE
;
	; FINAL CHECK FOR COMPLETION & SUCCESS
	CALL	CH_POLL			; WAIT FOR COMPLETION
	CP	$14			; SUCCESS?
	JP	NZ,CHUSB_IOERR		; IF NOT, HANDLE ERROR
;
	; INCREMENT LBA
	PUSH	HL			; SAVE HL
	LD	A,CHUSB_LBA		; LBA OFFSET
	CALL	LDHLIYA			; HL := IY + A, REG A TRASHED
	CALL	INC32HL			; INCREMENT THE VALUE
	POP	HL			; RESTORE HL
;
	XOR	A			; SIGNAL SUCCESS
	RET
;
; INITIATE A DISK SECTOR READ/WRITE OPERATION
; A: READ OR WRITE OPCODE
;
CHUSB_RWSTART:
	CALL	CH_CMD			; SEND R/W COMMAND
;
	; SEND LBA, 4 BYTES, LITTLE ENDIAN
	LD	A,CHUSB_LBA		; OFFSET TO CAPACITY FIELD
	CALL	LDHLIYA			; HL := IY + A, REG A TRASHED
	LD	B,4			; SEND 4 BYTES
CHUSB_RWSTART1:
	LD	A,(HL)			; GET BYTE
	INC	HL			; BUMP PTR
	CALL	CH_WR			; SEND BYTE
	DJNZ	CHUSB_RWSTART1		; LOOP AS NEEDED
;
	; REQUEST 1 SECTOR
	LD	A,1			; 1 SECTOR
	CALL	CH_WR			; SEND IT
	RET
;
;
;
CHUSB_STATUS:
	; RETURN UNIT STATUS
	LD	A,(IY+CHUSB_STAT)	; GET STATUS OF SELECTED DEVICE
	OR	A			; SET FLAGS
	RET				; AND RETURN
;
; RESET THE INTERFACE AND REDISCOVER MEDIA
;
CHUSB_RESET:
	;PRTS("\n\rRES USB:$")		; *DEBUG*
	;CALL	CH_FLUSH		; DISCARD ANY GARBAGE
	;CALL	CH_RESET		; FULL CH37X RESET
;
	; RESET THE BUS
	LD	A,CH_CMD_MODE		; SET MODE COMMAND
	CALL	CH_CMD			; SEND IT
	LD	A,7			; RESET BUS
	CALL	CH_WR			; SEND IT
	CALL	CH_NAP			; SMALL WAIT
	CALL	CH_RD			; GET RESULT
	;CALL	PC_SPACE		; *DEBUG*
	;CALL	PRTHEXBYTE		; *DEBUG*
	CALL	CH_NAP			; SMALL WAIT
;
	; ACTIVATE USB MODE
	LD	A,CH_CMD_MODE		; SET MODE COMMAND
	CALL	CH_CMD			; SEND IT
	LD	A,6			; USB ENABLED, SEND SOF
	CALL	CH_WR			; SEND IT
	CALL	CH_NAP			; SMALL WAIT
	CALL	CH_RD			; GET RESULT
	;CALL	PC_SPACE		; *DEBUG*
	;CALL	PRTHEXBYTE		; *DEBUG*
	CALL	CH_NAP			; SMALL WAIT
;
	LD	A,CH_MODE_USB		; WE ARE NOW IN USB MODE
	LD	L,(IY+CHUSB_MODE+0)	; GET MODE PTR (LSB)
	LD	H,(IY+CHUSB_MODE+1)	; GET MODE PTR (MSB)
	LD	(HL),A			; SAVE IT
;
	; INITIALIZE DISK
	LD	B,24			; TRY A FEW TIMES
CHUSB_RESET1:
	;PRTS("\n\rDSKINIT:$")		; *DEBUG*
	LD	A,CH_CMD_DSKINIT	; DISK INIT COMMAND
	CALL	CH_CMD			; SEND IT
	LD	DE,10000		; 10000 * 16 = 160US ???
	LD	DE,20000		; 10000 * 16 = 160US ???
	LD	DE,12500		; 1250 * 16 = 200US ???
	CALL	VDELAY			; DELAY
	CALL	CH_POLL			; WAIT FOR RESULT
	;CALL	PC_SPACE		; *DEBUG*
	;CALL	PRTHEXBYTE		; *DEBUG*
	CP	$14			; SUCCESS?
	JR	Z,CHUSB_RESET1A		; IF SO, CHECK READY
	CP	$16			; NO MEDIA
	JP	Z,CHUSB_NOMEDIA		; HANDLE IT
	CALL	CH_NAP			; SMALL DELAY
	DJNZ	CHUSB_RESET1		; LOOP AS NEEDED
	JP	CHUSB_TO		; HANDLE TIMEOUT
;
CHUSB_RESET1A:
	;CALL	CHUSB_DSKRES		; DISK RESET
	;CP	$14			; GOOD?
	;JR	Z,CHUSB_RESET2
	;CALL	CHUSB_DSKRDY		; CHECK IF DISK READY
	;CP	$14			; GOOD?
	;JR	Z,CHUSB_RESET2		; IF SO, MOVE ON
	;DJNZ	CHUSB_RESET1		; KEEP TRYING
;
CHUSB_RESET2:
	; USE OF CH376 DISK_MOUNT COMMAND SEEMS TO IMPROVE
	; COMPATIBILITY WITH SOME OLDER USB THUMBDRIVES.
	LD	A,(IY+CH_TYPE)		; CH37X TYPE?
	CP	CHTYP_376		; IS CH376?
	CALL	Z,CHUSB_DSKMNT		; IF SO, TRY MOUNT, IGNORE ERRS
	;CALL	CHUSB_AUTOSET		; *DEBUG*
	;CALL	CHUSB_TSTCON		; *DEBUG*
	;CALL	CHUSB_MAXLUN		; *DEBUG*
	;CALL	CHUSB_DSKRDY		; *DEBUG*
	;CALL	CHUSB_DSKINQ		; *DEBUG*
;;
	CALL	CHUSB_DSKSIZ		; GET AND RECORD DISK SIZE
	RET	NZ			; ABORT ON ERROR
;
	; SET STATUS AND RETURN
	XOR	A			; CLEAR STATUS
	LD	(IY+CHUSB_STAT),A	; RECORD STATUS
	OR	A			; SET FLAGS
	RET				; AND RETURN
;
;
;
CHUSB_DEVICE:
	LD	D,DIODEV_CHUSB		; D := DEVICE TYPE
	LD	E,(IY+CH_DEV)		; E := PHYSICAL DEVICE NUMBER
	LD	C,%00110011		; USB HARD DISK ATTRIBUTES
	LD	H,(IY+CH_TYPE)		; H := MODE
	LD	L,(IY+CH_IOBASE)	; L := BASE I/O ADDRESS
	XOR	A			; SIGNAL SUCCESS
	RET
;
; CHUSB_GETMED
;
CHUSB_MEDIA:
	LD	A,E			; GET FLAGS
	OR	A			; SET FLAGS
	JR	Z,CHUSB_MEDIA1		; JUST REPORT CURRENT STATUS AND MEDIA
	CALL	CHUSB_RESET		; RESET CHUSB INTERFACE
;
CHUSB_MEDIA1:
	LD	A,(IY+CHUSB_STAT)	; GET STATUS
	OR	A			; SET FLAGS
	LD	D,0			; NO MEDIA CHANGE DETECTED
	LD	E,MID_HD		; ASSUME WE ARE OK
	RET	Z			; RETURN IF GOOD INIT
	LD	E,MID_NONE		; SIGNAL NO MEDIA
	LD	A,ERR_NOMEDIA		; NO MEDIA ERROR
	OR	A			; SET FLAGS
	RET				; AND RETURN
;
;
;
CHUSB_SEEK:
	BIT	7,D			; CHECK FOR LBA FLAG
	CALL	Z,HB_CHS2LBA		; CLEAR MEANS CHS, CONVERT TO LBA
	RES	7,D			; CLEAR FLAG REGARDLESS (DOES NO HARM IF ALREADY LBA)
	LD	(IY+CHUSB_LBA+0),L	; SAVE NEW LBA
	LD	(IY+CHUSB_LBA+1),H	; ...
	LD	(IY+CHUSB_LBA+2),E	; ...
	LD	(IY+CHUSB_LBA+3),D	; ...
	XOR	A			; SIGNAL SUCCESS
	RET				; AND RETURN
;
;
;
CHUSB_CAP:
	LD	A,(IY+CHUSB_STAT)	; GET STATUS
	PUSH	AF			; SAVE IT
	LD	A,CHUSB_MEDCAP		; OFFSET TO CAPACITY FIELD
	CALL	LDHLIYA			; HL := IY + A, REG A TRASHED
	CALL	LD32			; GET THE CURRENT CAPACITY INTO DE:HL
	LD	BC,512			; 512 BYTES PER BLOCK
	POP	AF			; RECOVER STATUS
	OR	A			; SET FLAGS
	RET
;
;
;
CHUSB_GEOM:
	; FOR LBA, WE SIMULATE CHS ACCESS USING 16 HEADS AND 16 SECTORS
	; RETURN HS:CC -> DE:HL, SET HIGH BIT OF D TO INDICATE LBA CAPABLE
	CALL	CHUSB_CAP		; GET TOTAL BLOCKS IN DE:HL, BLOCK SIZE TO BC
	LD	L,H			; DIVIDE BY 256 FOR # TRACKS
	LD	H,E			; ... HIGH BYTE DISCARDED, RESULT IN HL
	LD	D,16 | $80		; HEADS / CYL = 16, SET LBA CAPABILITY BIT
	LD	E,16			; SECTORS / TRACK = 16
	RET				; DONE, A STILL HAS CHUSB_CAP STATUS
;
; CH37X HELPER ROUTINES
;
;
; PERFORM DISK MOUNT
;
CHUSB_DSKMNT:
	;PRTS("\n\rMOUNT:$")		; *DEBUG*
	LD	A,CH_CMD_DSKMNT		; DISK QUERY
	CALL	CH_CMD			; DO IT
	CALL	CH_POLL			; WAIT FOR RESPONSE
	;CALL	PC_SPACE		; *DEBUG*
	;CALL	PRTHEXBYTE		; *DEBUG*
	CP	$14			; SUCCESS?
	RET	NZ			; ABORT IF NOT
;
#IF FALSE
	CALL	CH_CMD_RD		; SEND READ COMMAND
	CALL	CH_RD			; GET LENGTH
	;CALL	PC_SPACE		; *DEBUG*
	;CALL	PRTHEXBYTE		; *DEBUG*
	LD	B,A			; LOOP COUNTER
	LD	HL,HB_WRKBUF		; USE WORK BUFFER FOR DATA
CHUSB_DSKMNT1:
	CALL	CH_RD			; GET A BYTE
	LD	(HL),A			; SAVE IT
	INC	HL			; BUMP BUF PTR
	DJNZ	CHUSB_DSKMNT1		; LOOP FOR ALL DATA
;
	;LD	DE,HB_WRKBUF		; *DEBUG*
	;CALL	DUMP_BUFFER		; *DEBUG*
;
	CALL	CHUSB_PRTPREFIX		; PRINT DEVICE PREFIX
	LD	HL,HB_WRKBUF + 8
	LD	B,28
CHUSB_DSKMNT2:
	LD	A,(HL)
	INC	HL
	CALL	COUT
	DJNZ	CHUSB_DSKMNT2
#ENDIF
;
	XOR	A
	RET
;
; PERFORM DISK SIZE
;
CHUSB_DSKSIZ:
	;PRTS("\n\rDSKSIZ:$")		; *DEBUG*
	LD	A,CH_CMD_DSKSIZ		; DISK SIZE COMMAND
	CALL	CH_CMD			; SEND IT
	CALL	CH_POLL			; WAIT FOR RESULT
	;CALL	PC_SPACE		; *DEBUG*
	;CALL	PRTHEXBYTE		; *DEBUG*
	CP	$14			; SUCCESS?
	JP	NZ,CHUSB_CMDERR		; HANDLE CMD ERROR
	CALL	CH_CMD_RD		; SEND READ USB DATA CMD
	CALL	CH_RD			; GET RD DATA LEN
	;CALL	PC_SPACE		; *DEBUG*
	;CALL	PRTHEXBYTE		; *DEBUG*
	CP	$08			; MAKE SURE IT IS 8
	JP	NZ,CHUSB_CMDERR		; HANDLE CMD ERROR
	LD	A,CHUSB_MEDCAP		; MEDIA CAPACITY OFFSET
	CALL	LDHLIYA			; HL := IY + A, REG A TRASHED
	PUSH	HL			; SAVE ADDRESS
	CALL	CH_RD
	LD	D,A
	CALL	CH_RD
	LD	E,A
	CALL	CH_RD
	LD	H,A
	CALL	CH_RD
	LD	L,A
	CALL	CH_RD
	CALL	CH_RD
	CALL	CH_RD
	CALL	CH_RD
	POP	BC			; RECOVER ADDRESS TO BC
	CALL	ST32			; STORE IT
	XOR	A			; SIGNAL SUCCESS
	RET				; AND DONE
;
#IF FALSE
;
; PERFORM DISK INQUIRY
; BASICALLY THE SCSI INQUIRY COMMAND
;
CHUSB_DSKINQ:
	;PRTS("\n\rINQUIRY:$")		; *DEBUG*
	LD	A,CH_CMD_DSKINQ		; DISK QUERY
	CALL	CH_CMD			; DO IT
	CALL	CH_POLL			; WAIT FOR RESPONSE
	;CALL	PC_SPACE		; *DEBUG*
	;CALL	PRTHEXBYTE		; *DEBUG*
	CP	$14			; SUCCESS?
	RET	NZ			; ABORT IF NOT
	CALL	CH_CMD_RD		; SEND READ COMMAND
	CALL	CH_RD			; GET LENGTH
	LD	B,A			; LOOP COUNTER
	LD	HL,HB_WRKBUF		; USE WORK BUFFER FOR DATA
DSKINQ1:
	CALL	CH_RD			; GET A BYTE
	LD	(HL),A			; SAVE IT
	INC	HL			; BUMP BUF PTR
	DJNZ	DSKINQ1			; LOOP FOR ALL DATA
;
	;LD	DE,HB_WRKBUF		; *DEBUG*
	;CALL	DUMP_BUFFER		; *DEBUG*
;
	;CALL	CHUSB_PRTPREFIX		; PRINT DEVICE PREFIX
	;LD	HL,HB_WRKBUF + 8
	;LD	B,28
DSKINQ2:
	;LD	A,(HL)
	;INC	HL
	;CALL	COUT
	;DJNZ	DSKINQ2
;
	RET
;
; PERFORM SET RETRIES
;
CHUSB_SETRETRY:
	;PRTS("\n\rSETRETRY:$")		; *DEBUG*
	LD	A,CH_CMD_SETRETRY	; DISK READY
	CALL	CH_CMD			; DO IT
	CALL	CH_NAP
	LD	A,$25			; CONSTANT
	CALL	CH_WR			; SEND IT
	CALL	CH_NAP
	LD	A,$BF			; MAX
	CALL	CH_WR
	CALL	CH_NAP
	CALL	CH_RD			; GET RESULT
	;CALL	PC_SPACE		; *DEBUG*
	;CALL	PRTHEXBYTE		; *DEBUG*
;
	RET
;
; PERFORM DISK RESET
;
CHUSB_DSKRES:
	;PRTS("\n\rDSKRES:$")		; *DEBUG*
	LD	A,CH_CMD_DSKRES		; DISK READY
	CALL	CH_CMD			; DO IT
	CALL	CH_POLL			; WAIT FOR RESPONSE
	;CALL	PC_SPACE		; *DEBUG*
	;CALL	PRTHEXBYTE		; *DEBUG*
;
	RET
;
; PERFORM DISK READY
;
CHUSB_DSKRDY:
	;PRTS("\n\rDSKRDY:$")		; *DEBUG*
	LD	A,CH_CMD_DSKRDY		; DISK READY
	CALL	CH_CMD			; DO IT
	CALL	CH_POLL			; WAIT FOR RESPONSE
	;CALL	PC_SPACE		; *DEBUG*
	;CALL	PRTHEXBYTE		; *DEBUG*
	CP	$14			; *DEBUG*
	JR	NZ,CHUSB_DSKRDY		; *DEBUG*
;
	RET
;
; PERFORM AUTO SETUP
;
CHUSB_AUTOSET:
	;PRTS("\n\rAUTOSET:$")		; *DEBUG*
	LD	A,CH_CMD_AUTOSET	; AUTOMATIC SETUP FOR USB
	CALL	CH_CMD			; DO IT
	CALL	LDELAY			; *DEBUG*
	CALL	CH_POLL			; WAIT FOR RESPONSE
	;CALL	PC_SPACE		; *DEBUG*
	;CALL	PRTHEXBYTE		; *DEBUG*
;
	RET
;
; PERFORM TEST CONNECT
;
CHUSB_TSTCON:
	;PRTS("\n\rTSTCON:$")		; *DEBUG*
	LD	A,CH_CMD_TSTCON		; TEST USB DEVICE CONNECT
	CALL	CH_CMD			; DO IT
	CALL	CH_NAP			; WAIT A BIT
	CALL	CH_RD			; GET RESPONSE
	;CALL	PC_SPACE		; *DEBUG*
	;CALL	PRTHEXBYTE		; *DEBUG*
;
	RET
;
; PERFORM GET MAX LUN
;
CHUSB_MAXLUN:
	;PRTS("\n\rMAXLUN:$")		; *DEBUG*
	LD	A,CH_CMD_MAXLUN		; TEST USB DEVICE CONNECT
	CALL	CH_CMD			; DO IT
	CALL	CH_NAP			; WAIT A BIT
	LD	A,$38			; CONSTANT
	CALL	CH_WR			; SEND IT
	CALL	CH_NAP
	CALL	CH_RD			; GET RESPONSE
	;CALL	PC_SPACE		; *DEBUG*
	;CALL	PRTHEXBYTE		; *DEBUG*
;
	RET
;
#ENDIF
;
; ERROR HANDLERS
;
;
CHUSB_NOMEDIA:
	LD	A,CHUSB_STNOMEDIA
	JR	CHUSB_ERR
;
CHUSB_CMDERR:
	LD	A,CHUSB_STCMDERR
	JR	CHUSB_ERR
;
CHUSB_IOERR:
	LD	A,CHUSB_STIOERR
	JR	CHUSB_ERR
;
CHUSB_TO:
	LD	A,CHUSB_STTO
	JR	CHUSB_ERR
;
CHUSB_NOTSUP:
	LD	A,CHUSB_STNOTSUP
	JR	CHUSB_ERR
;
CHUSB_ERR:
	LD	(IY+CHUSB_STAT),A	; SAVE NEW STATUS
;
CHUSB_ERR2:
#IF (CHUSBTRACE >= 2)
	CALL	CHUSB_PRTSTAT
#ENDIF
	OR	A			; SET FLAGS
	RET
;
;
;
CHUSB_PRTERR:
	RET	Z			; DONE IF NO ERRORS
	; FALL THRU TO CHUSB_PRTSTAT
;
; PRINT FULL DEVICE STATUS LINE
;
CHUSB_PRTSTAT:
	PUSH	AF
	PUSH	DE
	PUSH	HL
	LD	A,(IY+CHUSB_STAT)
	CALL	CHUSB_PRTPREFIX		; PRINT UNIT PREFIX
	CALL	PC_SPACE		; FORMATTING
	CALL	CHUSB_PRTSTATSTR
	POP	HL
	POP	DE
	POP	AF
	RET
;
; PRINT STATUS STRING
;
CHUSB_PRTSTATSTR:
	PUSH	AF
	PUSH	DE
	PUSH	HL
	LD	A,(IY+CHUSB_STAT)
	NEG
	LD	HL,CHUSB_STR_ST_MAP
	ADD	A,A
	CALL	ADDHLA
	LD	E,(HL)
	INC	HL
	LD	D,(HL)
	CALL	WRITESTR
	POP	HL
	POP	DE
	POP	AF
	RET
;
; PRINT DIAGNONSTIC PREFIX
;
CHUSB_PRTPREFIX:
	PUSH	AF
	CALL	NEWLINE
	PRTS("CHUSB$")
	LD	A,(IY+CH_DEV)		; GET CURRENT DEVICE NUM
	CALL	PRTDECB
	CALL	PC_COLON
	POP	AF
	RET
;
; DATA STORAGE
;
CHUSB_DEVNUM	.DB	0		; TEMP DEVICE NUM USED DURING INIT
CHUSB_DSKBUF	.DW	0
;
CHUSB_STR_ST_MAP:
	.DW		CHUSB_STR_STOK
	.DW		CHUSB_STR_STNOMEDIA
	.DW		CHUSB_STR_STCMDERR
	.DW		CHUSB_STR_STIOERR
	.DW		CHUSB_STR_STTO
	.DW		CHUSB_STR_STNOTSUP
;
CHUSB_STR_STOK		.TEXT	"OK$"
CHUSB_STR_STNOMEDIA	.TEXT	"NO MEDIA$"
CHUSB_STR_STCMDERR	.TEXT	"COMMAND ERROR$"
CHUSB_STR_STIOERR	.TEXT	"IO ERROR$"
CHUSB_STR_STTO		.TEXT	"TIMEOUT$"
CHUSB_STR_STNOTSUP	.TEXT	"NOT SUPPORTED$"
CHUSB_STR_STUNK		.TEXT	"UNKNOWN ERROR$"
