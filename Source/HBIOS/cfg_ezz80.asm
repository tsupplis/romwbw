;
;==================================================================================================
;   ROMWBW 2.X CONFIGURATION DEFAULTS FOR EASY Z80
;==================================================================================================
;
; BUILD CONFIGURATION OPTIONS
;
CPUOSC		.EQU	10000000	; CPU OSC FREQ
MEMMGR		.EQU	MM_Z2		; MM_NONE, MM_SBC, MM_Z2, MM_N8, MM_Z180
RAMSIZE		.EQU	512		; SIZE OF RAM IN KB, MUST MATCH YOUR HARDWARE!!!
DEFSERCFG	.EQU	SER_115200_8N1	; DEFAULT SERIAL LINE CONFIG (SHOULD MATCH ABOVE)
INTMODE		.EQU	2		; 0=NONE, 1=INT MODE 1, 2=INT MODE 2
DIAGENABLE	.EQU	FALSE		; TRUE FOR DIAGNOSTIC CODE PORT OUTPUT
DIAGPORT	.EQU	$00		; DIAGNOSTIC PORT ADDRESS
;
CRTACT		.EQU	FALSE		; CRT ACTIVATION AT STARTUP
VDAEMU		.EQU	EMUTYP_ANSI	; DEFAULT VDA EMULATION (EMUTYP_TTY, EMUTYP_ANSI, ...)
;
DSKYENABLE	.EQU	FALSE		; TRUE FOR DSKY SUPPORT (DO NOT COMBINE WITH PPIDE)
;
HTIMENABLE	.EQU	FALSE		; TRUE FOR SIMH TIMER SUPPORT
SIMRTCENABLE	.EQU	FALSE		; SIMH CLOCK DRIVER
DSRTCENABLE	.EQU	FALSE		; DS-1302 CLOCK DRIVER
DSRTCMODE	.EQU	DSRTCMODE_STD	; DSRTCMODE_STD, DSRTCMODE_MFPIC
DSRTCCHG	.EQU	FALSE		; DS-1302 CONFIGURE CHARGE ON (TRUE) OR OFF (FALSE)
;
ASCIENABLE	.EQU	FALSE		; TRUE FOR Z180 ASCI SUPPORT
UARTENABLE	.EQU	FALSE		; TRUE FOR UART SUPPORT (ALMOST ALWAYS WANT THIS TO BE TRUE)
UARTOSC		.EQU	1843200		; UART OSC FREQUENCY
ACIAENABLE	.EQU	FALSE		; TRUE FOR MOTOROLA 6850 ACIA SUPPORT
;
SIOENABLE	.EQU	TRUE		; TRUE FOR ZILOG SIO SUPPORT
SIODEBUG	.EQU	FALSE		; PS
SIOCNT		.EQU	2		; 1 OR 2 SIO CHIPS (EACH CHIP HAS 2 CHANNELS)
SIO0MODE	.EQU	SIOMODE_EZZ80	; TYPE OF FIRST SIO TO DETECT: SIOMODE_RC/SMB/ZP/EZZ80
SIO0BASE	.EQU	$80		; IO PORT ADDRESS BASE FOR FIRST SIO CHIP
SIO0ACLK	.EQU	1843200		; 2457600/4915200=ZP,7372800=RC/SMB - SIO FIXED OSC FREQUENCY
SIO0ADIV	.EQU	1		; 1=RC2014/SMB, 2/4/8/16/32/64/128/256=ZP depending on jumper X5
SIO0ACFG	.EQU	DEFSERCFG	; DEFAULT SERIAL LINE CONFIG
SIO0BCLK	.EQU	1843200		; 2457600/4915200=ZP,7372800=RC/SMB - SIO FIXED OSC FREQUENCY
SIO0BDIV	.EQU	1		; 1=RC2014/SMB, 2/4/8/16/32/64/128/256=ZP depending on jumper X5
SIO0BCFG	.EQU	DEFSERCFG	; DEFAULT SERIAL LINE CONFIG
SIO1MODE	.EQU	SIOMODE_RC	; TYPE OF SECOND SIO TO DETECT: SIOMODE_RC, SIOMODE_SMB
SIO1BASE	.EQU	$84		; IO PORT ADDRESS BASE FOR SECOND SIO CHIP
SIO1ACLK	.EQU	7372800		; 2457600/4915200=ZP,7372800=RC/SMB - SIO FIXED OSC FREQUENCY
SIO1ADIV	.EQU	1		; 1=RC2014/SMB, 2/4/8/16/32/64/128/256=ZP depending on jumper X5
SIO1ACFG	.EQU	DEFSERCFG	; DEFAULT SERIAL LINE CONFIG
SIO1BCLK	.EQU	7372800		; 2457600/4915200=ZP,7372800=RC/SMB - SIO FIXED OSC FREQUENCY
SIO1BDIV	.EQU	1		; 1=RC2014/SMB, 2/4/8/16/32/64/128/256=ZP depending on jumper X5
SIO1BCFG	.EQU	DEFSERCFG	; DEFAULT SERIAL LINE CONFIG
;
VDUENABLE	.EQU	FALSE		; TRUE FOR VDU BOARD SUPPORT
CVDUENABLE	.EQU	FALSE		; TRUE FOR CVDU BOARD SUPPORT
NECENABLE	.EQU	FALSE		; TRUE FOR uPD7220 BOARD SUPPORT
TMSENABLE	.EQU	FALSE		; TRUE FOR N8 (TMS9918) VIDEO/KBD SUPPORT
VGAENABLE	.EQU	FALSE		; TRUE FOR VGA VIDEO/KBD SUPPORT
;
SPKENABLE	.EQU	FALSE		; TRUE FOR RTC LATCH IOBIT SOUND
AYENABLE	.EQU	FALSE		; TRUE FOR AY PSG SOUND
AYMODE		.EQU	AYMODE_RCZ80	; AYMODE_[SCG/N8/RCZ80/RCZ180]
;
MDENABLE	.EQU	TRUE		; TRUE FOR ROM/RAM DISK SUPPORT (ALMOST ALWAYS WANT THIS ENABLED)
MDTRACE		.EQU	1		; 0=SILENT, 1=ERRORS, 2=EVERYTHING (ONLY RELEVANT IF MDENABLE = TRUE)
;
FDENABLE	.EQU	FALSE		; TRUE FOR FLOPPY SUPPORT
FDMODE		.EQU	FDMODE_RCWDC	; FDMODE_DIO, FDMODE_ZETA, FDMODE_DIDE, FDMODE_N8, FDMODE_DIO3
FDTRACE		.EQU	1		; 0=SILENT, 1=FATAL ERRORS, 2=ALL ERRORS, 3=EVERYTHING (ONLY RELEVANT IF FDENABLE = TRUE)
FDMEDIA		.EQU	FDM144		; FDM720, FDM144, FDM360, FDM120 (ONLY RELEVANT IF FDENABLE = TRUE)
FDMEDIAALT	.EQU	FDM720		; ALTERNATE MEDIA TO TRY, SAME CHOICES AS ABOVE (ONLY RELEVANT IF FDMAUTO = TRUE)
FDMAUTO		.EQU	TRUE		; SELECT BETWEEN MEDIA OPTS ABOVE AUTOMATICALLY
;
RFENABLE	.EQU	FALSE		; TRUE FOR RAM FLOPPY SUPPORT
;
IDEENABLE	.EQU	TRUE		; TRUE FOR IDE SUPPORT
IDEMODE		.EQU	IDEMODE_RC	; IDEMODE_DIO, IDEMODE_DIDE, IDEMODE_RC
IDETRACE	.EQU	1		; 0=SILENT, 1=ERRORS, 2=EVERYTHING (ONLY RELEVANT IF IDEENABLE = TRUE)
IDE8BIT		.EQU	TRUE		; USE IDE 8BIT TRANSFERS (PROBABLY ONLY WORKS FOR CF CARDS!)
;
PPIDEENABLE	.EQU	FALSE		; TRUE FOR PPIDE SUPPORT (DO NOT COMBINE WITH DSKYENABLE)
PPIDEMODE	.EQU	PPIDEMODE_RC	; PPIDEMODE_SBC, PPPIDEMODE_DIO3, PPIDEMODE_MFP, PPIDEMODE_N8, PPIDEMODE_RC
PPIDETRACE	.EQU	1		; 0=SILENT, 1=ERRORS, 2=EVERYTHING (ONLY RELEVANT IF PPIDEENABLE = TRUE)
PPIDE8BIT	.EQU	FALSE		; USE IDE 8BIT TRANSFERS (PROBABLY ONLY WORKS FOR CF CARDS!)
;
SDENABLE	.EQU	FALSE		; TRUE FOR SD SUPPORT
SDMODE		.EQU	SDMODE_PPI	; SDMODE_JUHA, SDMODE_CSIO, SDMODE_UART, SDMODE_PPI, SDMODE_DSD
SDTRACE		.EQU	1		; 0=SILENT, 1=ERRORS, 2=EVERYTHING (ONLY RELEVANT IF IDEENABLE = TRUE)
SDCSIOFAST	.EQU	FALSE		; TABLE-DRIVEN BIT INVERTER
;
PRPENABLE	.EQU	FALSE		; TRUE FOR PROPIO SUPPORT
;
PPPENABLE	.EQU	FALSE		; TRUE FOR PARPORTPROP SUPPORT
PPPSDENABLE	.EQU	TRUE		; TRUE FOR PARPORTPROP SD SUPPORT
PPPSDTRACE	.EQU	1		; 0=SILENT, 1=ERRORS, 2=EVERYTHING (ONLY RELEVANT IF PPPENABLE = TRUE)
PPPCONENABLE	.EQU	TRUE		; TRUE FOR PROPIO CONSOLE SUPPORT (PS/2 KBD & VGA VIDEO)
;
HDSKENABLE	.EQU	FALSE		; TRUE FOR SIMH HDSK SUPPORT
;
TERMENABLE	.EQU	FALSE		; TERM PSEUDO DEVICE, WILL BE ENABLED IF A VDA IS ENABLED
;
BOOTTYPE	.EQU	BT_MENU		; BT_MENU (WAIT FOR KEYPRESS), BT_AUTO (BOOT_DEFAULT AFTER BOOT_TIMEOUT SECS)
BOOT_TIMEOUT	.EQU	20		; APPROX TIMEOUT IN SECONDS FOR AUTOBOOT, 0 FOR IMMEDIATE
BOOT_DEFAULT	.EQU	'Z'		; SELECTION TO INVOKE AT TIMEOUT
;
PIO_4P		.EQU	FALSE		; TRUE FOR ECB-4PIO PIO SUPPORT
PIO_ZP		.EQU	FALSE		; TRUE FOR ECB-ZILOG PERIPHERALS BOARD
PPI_SBC		.EQU	FALSE		; TRUE FOR SBC V2 8255 (IF NOT BEING USED FOR PPIDE)
;
UFENABLE	.EQU	FALSE		; TRUE FOR ECB USB-FIFO SUPPORT

