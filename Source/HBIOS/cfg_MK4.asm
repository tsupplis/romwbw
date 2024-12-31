;
;==================================================================================================
;   ROMWBW PLATFORM CONFIGURATION DEFAULTS FOR PLATFORM: MK4
;==================================================================================================
;
; THIS FILE DEFINES THE DEFAULT CONFIGURATION SETTINGS FOR THE PLATFORM
; INDICATED ABOVE. THIS FILE SHOULD *NOT* NORMALLY BE CHANGED.	INSTEAD,
; YOU SHOULD OVERRIDE SETTINGS YOU WANT USING A CONFIGURATION FILE IN
; THE CONFIG DIRECTORY UNDER THIS DIRECTORY.
;
; THIS FILE SHOULD *NOT* NORMALLY BE CHANGED.  IT IS MAINTAINED BY THE
; AUTHORS OF ROMWBW.  TO OVERRIDE SETTINGS YOU SHOULD USE A
; CONFIGURATION FILE IN THE CONFIG DIRECTORY UNDER THIS DIRECTORY.
;
; ROMWBW USES CASCADING CONFIGURATION FILES AS INDICATED BELOW:
;
; cfg_MASTER.asm			- MASTER: CONFIGURATION FILE DEFINES ALL POSSIBLE ROMWBW SETTINGS
; |
; +-> cfg_<platform>.asm		- PLATFORM: DEFAULT SETTINGS FOR SPECIFIC PLATFORM
;     |
;     +-> Config/<plt>_std.asm		- BUILD: SETTINGS FOR EACH OFFICIAL DIST BUILD
;         |
;         +-> Config/<plt>_<cust>.asm	- USER: CUSTOM USER BUILD SETTINGS
;
; THE TOP (MASTER CONFIGURATION) FILE DEFINES ALL POSSIBLE ROMWBW
; CONFIGURATION SETTINGS. EACH FILE BELOW THE MASTER CONFIGURATION FILE
; INHERITS THE CUMULATIVE SETTINGS OF THE FILES ABOVE IT AND MAY
; OVERRIDE THESE SETTINGS AS DESIRED.
;
; OTHER THAN THE TOP MASTER FILE, EACH FILE MUST "#INCLUDE" ITS PARENT
; FILE (SEE #INCLUDE STATEMENT BELOW).  THE TOP TWO FILES SHOULD NOT BE
; MODIFIED.  TO CUSTOMIZE YOUR BUILD SETTINGS YOU SHOULD MODIFY THE
; DEFAULT BUILD SETTINGS (Config/<platform>_std.asm) OR PREFERABLY
; CREATE AN OPTIONAL CUSTOM USER SETTINGS FILE THAT INCLUDES THE DEFAULT
; BUILD SETTINGS FILE (SEE EXAMPLE Config/SBC_user.asm).
;
; BY CREATING A CUSTOM USER SETTINGS FILE, YOU ARE LESS LIKELY TO BE
; IMPACTED BY FUTURE CHANGES BECAUSE YOU WILL BE INHERITING MOST
; OF YOUR SETTINGS WHICH WILL BE UPDATED BY AUTHORS AS ROMWBW EVOLVES.
;
; *** WARNING: ASIDE FROM THE MASTER CONFIGURATION FILE, YOU MUST USE
; ".SET" TO OVERRIDE SETTINGS.  THE ASSEMBLER WILL ERROR IF YOU ATTEMPT
; TO USE ".EQU" BECAUSE IT WON'T LET YOU REDEFINE A SETTING WITH ".EQU".
;
#DEFINE PLATFORM_NAME "Mark IV", " [", CONFIG, "]"
;
#INCLUDE "cfg_MASTER.asm"
;
PLATFORM	.SET	PLT_MK4		; PLT_[SBC|ZETA|ZETA2|N8|MK4|UNA|RCZ80|RCEZ80|RCZ180|EZZ80|SCZ180|GMZ180|DYNO|RCZ280|MBC|RPH|Z80RETRO|S100|DUO|HEATH|EPITX|MON|STDZ180|NABU|FZ80]
CPUFAM		.SET	CPU_Z180	; CPU FAMILY: CPU_[Z80|Z180|Z280|EZ80]
BIOS		.SET	BIOS_WBW	; HARDWARE BIOS: BIOS_[WBW|UNA]
BATCOND		.SET	FALSE		; ENABLE LOW BATTERY WARNING MESSAGE
HBIOS_MUTEX	.SET	FALSE		; ENABLE REENTRANT CALLS TO HBIOS (ADDS OVERHEAD)
USELZSA2	.SET	TRUE		; ENABLE FONT COMPRESSION
TICKFREQ	.SET	50		; DESIRED PERIODIC TIMER INTERRUPT FREQUENCY (HZ)
;
BOOT_TIMEOUT	.SET	-1		; AUTO BOOT TIMEOUT IN SECONDS, -1 TO DISABLE, 0 FOR IMMEDIATE
BOOT_DELAY	.SET	0		; FIXED BOOT DELAY IN SECONDS PRIOR TO CONSOLE OUTPUT
AUTOCON		.SET	TRUE		; ENABLE CONSOLE TAKEOVER AT LOADER PROMPT
;
CPUSPDCAP	.SET	SPD_FIXED	; CPU SPEED CHANGE CAPABILITY SPD_FIXED|SPD_HILO
CPUSPDDEF	.SET	SPD_HIGH	; CPU SPEED DEFAULT SPD_UNSUP|SPD_HIGH|SPD_LOW
CPUOSC		.SET	18432000	; CPU OSC FREQ IN MHZ
INTMODE		.SET	2		; INTERRUPTS: 0=NONE, 1=MODE 1, 2=MODE 2, 3=MODE 3 (Z280)
DEFSERCFG	.SET	SER_38400_8N1 | SER_RTS	; DEFAULT SERIAL LINE CONFIG (SEE STD.ASM)
;
RAMSIZE		.SET	512		; SIZE OF RAM IN KB (MUST MATCH YOUR HARDWARE!!!)
ROMSIZE		.SET	512		; SIZE OF ROM IN KB (MUST MATCH YOUR HARDWARE!!!)
APP_BNKS	.SET	$FF		; BANKS TO RESERVE FOR APP USE ($FF FOR AUTO SIZING)
MEMMGR		.SET	MM_Z180		; MEMORY MANAGER: MM_[SBC|Z2|N8|Z180|Z280|MBC|RPH|MON|EZ512]
RAMBIAS		.SET	ROMSIZE		; OFFSET OF START OF RAM IN PHYSICAL ADDRESS SPACE
;
Z180_BASE	.SET	$40		; Z180: I/O BASE ADDRESS FOR INTERNAL REGISTERS
Z180_CLKDIV	.SET	1		; Z180: CHK DIV: 0=OSC/2, 1=OSC, 2=OSC*2
Z180_MEMWAIT	.SET	0		; Z180: MEMORY WAIT STATES (0-3)
Z180_IOWAIT	.SET	1		; Z180: I/O WAIT STATES TO ADD ABOVE 1 W/S BUILT-IN (0-3)
Z180_TIMER	.SET	TRUE		; Z180: ENABLE Z180 SYSTEM PERIODIC TIMER
;
MK4_IDE		.SET	$80		; MK4: IDE REGISTERS BASE ADR
MK4_XAR		.SET	$88		; MK4: EXTERNAL ADDRESS REGISTER (XAR) ADR
MK4_SD		.SET	$89		; MK4: SD CARD CONTROL REGISTER ADR
MK4_RTC		.SET	$8A		; MK4: RTC LATCH REGISTER ADR
;
RTCIO		.SET	MK4_RTC		; RTC LATCH REGISTER ADR
;
KIOENABLE	.SET	FALSE		; ENABLE ZILOG KIO SUPPORT
KIOBASE		.SET	$80		; KIO BASE I/O ADDRESS
;
CTCENABLE	.SET	FALSE		; ENABLE ZILOG CTC SUPPORT
CTCDEBUG	.SET	FALSE		; ENABLE CTC DRIVER DEBUG OUTPUT
CTCBASE		.SET	$B0		; CTC BASE I/O ADDRESS
CTCTIMER	.SET	FALSE		; ENABLE CTC PERIODIC TIMER
;
PCFENABLE	.SET	FALSE		; ENABLE PCF8584 I2C CONTROLLER
PCFBASE		.SET	$F0		; PCF8584 BASE I/O ADDRESS
;
EIPCENABLE	.SET	FALSE		; EIPC: ENABLE Z80 EIPC (Z84C15) INITIALIZATION
;
SKZENABLE	.SET	FALSE		; ENABLE SERGEY'S Z80-512K FEATURES
;
WDOGMODE	.SET	WDOG_NONE	; WATCHDOG MODE: WDOG_[NONE|EZZ80|SKZ]
;
FPLED_ENABLE	.SET	FALSE		; FP: ENABLES FRONT PANEL LEDS
FPLED_IO	.SET	$00		; FP: PORT ADDRESS FOR FP LEDS
FPLED_INV	.SET	FALSE		; FP: LED BITS ARE INVERTED
FPLED_DSKACT	.SET	TRUE		; FP: ENABLES DISK I/O ACTIVITY ON FP LEDS
FPSW_ENABLE	.SET	FALSE		; FP: ENABLES FRONT PANEL SWITCHES
FPSW_IO		.SET	$00		; FP: PORT ADDRESS FOR FP SWITCHES
FPSW_INV	.SET	FALSE		; FP: SWITCH BITS ARE INVERTED
;
DIAGLVL		.SET	DL_CRITICAL	; ERROR LEVEL REPORTING
;
LEDENABLE	.SET	FALSE		; ENABLES STATUS LED (SINGLE LED)
LEDMODE		.SET	LEDMODE_STD	; LEDMODE_[STD|SC|RTC|NABU]
LEDPORT		.SET	$0E		; STATUS LED PORT ADDRESS
LEDDISKIO	.SET	TRUE		; ENABLES DISK I/O ACTIVITY ON STATUS LED
;
DSKYENABLE	.SET	FALSE		; ENABLES DSKY FUNCTIONALITY
DSKYDSKACT	.SET	TRUE		; ENABLES DISK ACTIVITY ON DSKY DISPLAY
ICMENABLE	.SET	FALSE		; ENABLES ORIGINAL DSKY ICM DRIVER (7218)
ICMPPIBASE	.SET	$60		; BASE I/O ADDRESS OF ICM PPI
PKDENABLE	.SET	FALSE		; ENABLES DSKY NG PKD DRIVER (8259)
PKDPPIBASE	.SET	$60		; BASE I/O ADDRESS OF PKD PPI
PKDOSC		.SET	3000000		; OSCILLATOR FREQ FOR PKD (IN HZ)
H8PENABLE	.SET	FALSE		; ENABLES HEATH H8 FRONT PANEL
LCDENABLE	.SET	FALSE		; ENABLE LCD DISPLAY
LCDBASE		.SET	$DA		; BASE I/O ADDRESS OF LCD CONTROLLER
GM7303ENABLE	.SET	FALSE		; ENABLES THE GM7303 BOARD WITH 16X2 LCD
;
BOOTCON		.SET	0		; BOOT CONSOLE DEVICE
SECCON		.SET	$FF		; SECONDARY CONSOLE DEVICE
CRTACT		.SET	FALSE		; ACTIVATE CRT (VDU,CVDU,PROPIO,ETC) AT STARTUP
VDAEMU		.SET	EMUTYP_ANSI	; VDA EMULATION: EMUTYP_[TTY|ANSI]
VDAEMU_SERKBD	.SET	$FF		; VDA EMULATION: SERIAL KBD UNIT #, OR $FF FOR HW KBD
ANSITRACE	.SET	1		; ANSI DRIVER TRACE LEVEL (0=NO,1=ERRORS,2=ALL)
PPKTRACE	.SET	1		; PPK DRIVER TRACE LEVEL (0=NO,1=ERRORS,2=ALL)
KBDTRACE	.SET	1		; KBD DRIVER TRACE LEVEL (0=NO,1=ERRORS,2=ALL)
PPKKBLOUT	.SET	KBD_US		; PPK KEYBOARD LANGUAGE: KBD_[US|DE]
KBDKBLOUT	.SET	KBD_US		; KBD KEYBOARD LANGUAGE: KBD_[US|DE]
MKYKBLOUT	.SET	KBD_US		; KBD KEYBOARD LANGUAGE: KBD_[US|DE]
;
DSRTCENABLE	.SET	TRUE		; DSRTC: ENABLE DS-1302 CLOCK DRIVER (DSRTC.ASM)
DSRTCMODE	.SET	DSRTCMODE_STD	; DSRTC: OPERATING MODE: DSRTCMODE_[STD|MFPIC|K80W]
DSRTCCHG	.SET	FALSE		; DSRTC: FORCE BATTERY CHARGE ON (USE WITH CAUTION!!!)
;
DS1501RTCENABLE	.SET	FALSE		; DS1501RTC: ENABLE DS-1501 CLOCK DRIVER (DS1501RTC.ASM)
DS1501RTC_BASE	.SET	$50		; DS1501RTC: I/O BASE ADDRESS
;
BQRTCENABLE	.SET	FALSE		; BQRTC: ENABLE BQ4845 CLOCK DRIVER (BQRTC.ASM)
BQRTC_BASE	.SET	$50		; BQRTC: I/O BASE ADDRESS
;
INTRTCENABLE	.SET	FALSE		; ENABLE PERIODIC INTERRUPT CLOCK DRIVER (INTRTC.ASM)
;
RP5RTCENABLE	.SET	FALSE		; RP5C01 RTC BASED CLOCK (RP5RTC.ASM)
;
HTIMENABLE	.SET	FALSE		; ENABLE SIMH TIMER SUPPORT
SIMRTCENABLE	.SET	FALSE		; ENABLE SIMH CLOCK DRIVER (SIMRTC.ASM)
;
DS7RTCENABLE	.SET	FALSE		; DS7RTC: ENABLE DS-1307 I2C CLOCK DRIVER (DS7RTC.ASM)
DS7RTCMODE	.SET	DS7RTCMODE_PCF	; DS7RTC: OPERATING MODE: DS7RTC_[PCF]
;
DS5RTCENABLE	.SET	FALSE		; DS5RTC: ENABLE DS-1305 SPI CLOCK DRIVER (DS5RTC.ASM)
;
SSERENABLE	.SET	FALSE		; SSER: ENABLE SIMPLE SERIAL DRIVER (SSER.ASM)
SSERCFG		.SET	SER_9600_8N1	; SSER: SERIAL LINE CONFIG
SSERSTATUS	.SET	$FF		; SSER: STATUS PORT
SSERDATA	.SET	$FF		; SSER: DATA PORT
SSERIRDY	.SET	%00000001	; SSER: INPUT READY BIT MASK
SSERIINV	.SET	FALSE		; SSER: INPUT READY BIT INVERTED
SSERORDY	.SET	%00000010	; SSER: OUTPUT READY BIT MASK
SSEROINV	.SET	FALSE		; SSER: OUTPUT READY BIT INVERTED
;
DUARTENABLE	.SET	FALSE		; DUART: ENABLE 2681/2692 SERIAL DRIVER (DUART.ASM)
;
UARTENABLE	.SET	TRUE		; UART: ENABLE 8250/16550-LIKE SERIAL DRIVER (UART.ASM)
UARTCNT		.SET	6		; UART: NUMBER OF CHIPS TO DETECT (1-8)
UARTOSC		.SET	1843200		; UART: OSC FREQUENCY IN MHZ
UARTINTS	.SET	FALSE		; UART: INCLUDE INTERRUPT SUPPORT UNDER IM1/2/3
UART4UART	.SET	TRUE		; UART: SUPPORT 4UART ECB BOARD
UART4UARTBASE	.SET	$C0		; UART: BASE IO ADDRESS OF 4UART ECB BOARD
UART0BASE	.SET	$18		; UART 0: REGISTERS BASE ADR
UART0CFG	.SET	DEFSERCFG	; UART 0: SERIAL LINE CONFIG
UART1BASE	.SET	$80		; UART 1: REGISTERS BASE ADR
UART1CFG	.SET	SER_300_8N1	; UART 1: SERIAL LINE CONFIG
UART2BASE	.SET	$C0		; UART 2: REGISTERS BASE ADR
UART2CFG	.SET	DEFSERCFG	; UART 2: SERIAL LINE CONFIG
UART3BASE	.SET	$C8		; UART 3: REGISTERS BASE ADR
UART3CFG	.SET	DEFSERCFG	; UART 3: SERIAL LINE CONFIG
UART4BASE	.SET	$D0		; UART 4: REGISTERS BASE ADR
UART4CFG	.SET	DEFSERCFG	; UART 4: SERIAL LINE CONFIG
UART5BASE	.SET	$D8		; UART 5: REGISTERS BASE ADR
UART5CFG	.SET	DEFSERCFG	; UART 5: SERIAL LINE CONFIG
UART6BASE	.SET	$FF		; UART 6: REGISTERS BASE ADR
UART6CFG	.SET	DEFSERCFG	; UART 6: SERIAL LINE CONFIG
UART7BASE	.SET	$FF		; UART 7: REGISTERS BASE ADR
UART7CFG	.SET	DEFSERCFG	; UART 7: SERIAL LINE CONFIG
;
ASCIENABLE	.SET	TRUE		; ASCI: ENABLE Z180 ASCI SERIAL DRIVER (ASCI.ASM)
ASCIINTS	.SET	TRUE		; ASCI: INCLUDE INTERRUPT SUPPORT UNDER IM1/2/3
ASCISWAP	.SET	FALSE		; ASCI: SWAP CHANNELS
ASCIBOOT	.SET	0		; ASCI: REBOOT ON RCV CHAR (0=DISABLED)
ASCI0CFG	.SET	DEFSERCFG	; ASCI 0: SERIAL LINE CONFIG
ASCI1CFG	.SET	DEFSERCFG	; ASCI 1: SERIAL LINE CONFIG
;
Z2UENABLE	.SET	FALSE		; Z2U: ENABLE Z280 UART SERIAL DRIVER (Z2U.ASM)
;
ACIAENABLE	.SET	FALSE		; ACIA: ENABLE MOTOROLA 6850 ACIA DRIVER (ACIA.ASM)
;
SIOENABLE	.SET	FALSE		; SIO: ENABLE ZILOG SIO SERIAL DRIVER (SIO.ASM)
SIODEBUG	.SET	FALSE		; SIO: ENABLE DEBUG OUTPUT
SIOBOOT		.SET	0		; SIO: REBOOT ON RCV CHAR (0=DISABLED)
SIOCNT		.SET	1		; SIO: NUMBER OF CHIPS TO DETECT (1-2), 2 CHANNELS PER CHIP
SIOINTS		.SET	TRUE		; SIO: INCLUDE SIO INTERRUPT SUPPORT UNDER IM1/2/3
SIO0MODE	.SET	SIOMODE_ZP	; SIO 0: CHIP TYPE: SIOMODE_[STD|RC|SMB|ZP|Z80R]
SIO0BASE	.SET	$B0		; SIO 0: REGISTERS BASE ADR
SIO0ACLK	.SET	(4915200/8)	; SIO 0A: OSC FREQ IN HZ, ZP=2457600/4915200, RC/SMB=7372800
SIO0ACFG	.SET	DEFSERCFG	; SIO 0A: SERIAL LINE CONFIG
SIO0ACTCC	.SET	-1		; SIO 0A: CTC CHANNEL 0=A, 1=B, 2=C, 3=D, -1 FOR NONE
SIO0BCLK	.SET	(4915200/8)	; SIO 0B: OSC FREQ IN HZ, ZP=2457600/4915200, RC/SMB=7372800
SIO0BCFG	.SET	DEFSERCFG	; SIO 0B: SERIAL LINE CONFIG
SIO0BCTCC	.SET	-1		; SIO 0B: CTC CHANNEL 0=A, 1=B, 2=C, 3=D, -1 FOR NONE
;
XIOCFG		.SET	DEFSERCFG	; XIO: SERIAL LINE CONFIG
;
VDUENABLE	.SET	FALSE		; VDU: ENABLE VDU VIDEO/KBD DRIVER (VDU.ASM)
VDUSIZ		.SET	V80X25		; VDU: DISPLAY FORMAT [V80X24|V80X25|V80X30]
CVDUENABLE	.SET	FALSE		; CVDU: ENABLE CVDU VIDEO/KBD DRIVER (CVDU.ASM)
CVDUMODE	.SET	CVDUMODE_ECB	; CVDU: CVDU MODE: CVDUMODE_[NONE|ECB|MBC]
CVDUMON		.SET	CVDUMON_EGA	; CVDU: CVDU MONITOR SETUP: CVDUMON_[NONE|CGA|EGA]
GDCENABLE	.SET	FALSE		; GDC: ENABLE 7220 GDC VIDEO/KBD DRIVER (GDC.ASM)
TMSENABLE	.SET	FALSE		; TMS: ENABLE TMS9918 VIDEO/KBD DRIVER (TMS.ASM)
TMSMODE		.SET	TMSMODE_SCG	; TMS: DRIVER MODE: TMSMODE_[SCG|N8|MSX|MSXKBD|MSXMKY|MBC|COLECO|DUO|NABU]
TMS80COLS	.SET	FALSE		; TMS: ENABLE 80 COLUMN SCREEN, REQUIRES V9958
TMSTIMENABLE	.SET	FALSE		; TMS: ENABLE TIMER INTERRUPTS (REQUIRES IM1)
VGAENABLE	.SET	FALSE		; VGA: ENABLE VGA VIDEO/KBD DRIVER (VGA.ASM)
VGASIZ		.SET	V80X25		; VGA: DISPLAY FORMAT [V80X25|V80X30|V80X43]
VRCENABLE	.SET	FALSE		; VRC: ENABLE VGARC VIDEO/KBD DRIVER (VRC.ASM)
SCONENABLE	.SET	FALSE		; SCON: ENABLE S100 CONSOLE DRIVER (SCON.ASM)
EFENABLE	.SET	FALSE		; EF: ENABLE EF9345 VIDEO DRIVER (EF.ASM)
FVENABLE	.SET	FALSE		; FV: ENABLE FPGA VGA VIDEO DRIVER (FV.ASM)
;
MDENABLE	.SET	TRUE		; MD: ENABLE MEMORY (ROM/RAM) DISK DRIVER (MD.ASM)
MDROM		.SET	TRUE		; MD: ENABLE ROM DISK
MDRAM		.SET	TRUE		; MD: ENABLE RAM DISK
MDTRACE		.SET	1		; MD: TRACE LEVEL (0=NO,1=ERRORS,2=ALL)
MDFFENABLE	.SET	FALSE		; MD: ENABLE FLASH FILE SYSTEM
;
FDENABLE	.SET	FALSE		; FD: ENABLE FLOPPY DISK DRIVER (FD.ASM)
FDMODE		.SET	FDMODE_DIDE	; FD: DRIVER MODE: FDMODE_[DIO|ZETA|ZETA2|DIDE|N8|DIO3|RCSMC|RCWDC|DYNO|EPFDC|MBC]
FDCNT		.SET	2		; FD: NUMBER OF FLOPPY DRIVES ON THE INTERFACE (1-2)
FDTRACE		.SET	1		; FD: TRACE LEVEL (0=NO,1=FATAL,2=ERRORS,3=ALL)
FDMAUTO		.SET	TRUE		; FD: AUTO SELECT DEFAULT/ALTERNATE MEDIA FORMATS
FD0TYPE		.SET	FDT_3HD		; FD 0: DRIVE TYPE: FDT_[3DD|3HD|5DD|5HD|8]
FD1TYPE		.SET	FDT_3HD		; FD 1: DRIVE TYPE: FDT_[3DD|3HD|5DD|5HD|8]
;
RFENABLE	.SET	FALSE		; RF: ENABLE RAM FLOPPY DRIVER
RFCNT		.SET	1		; RF: NUMBER OF RAM FLOPPY UNITS (1-4)
;
IDEENABLE	.SET	TRUE		; IDE: ENABLE IDE DISK DRIVER (IDE.ASM)
IDETRACE	.SET	1		; IDE: TRACE LEVEL (0=NO,1=ERRORS,2=ALL)
IDECNT		.SET	1		; IDE: NUMBER OF IDE INTERFACES TO DETECT (1-3), 2 DRIVES EACH
IDE0MODE	.SET	IDEMODE_MK4	; IDE 0: DRIVER MODE: IDEMODE_[DIO|DIDE|MK4|RC|GIDE]
IDE0BASE	.SET	$80		; IDE 0: IO BASE ADDRESS
IDE0DATLO	.SET	$00		; IDE 0: DATA LO PORT FOR 16-BIT I/O
IDE0DATHI	.SET	$00		; IDE 0: DATA HI PORT FOR 16-BIT I/O
IDE0A8BIT	.SET	TRUE		; IDE 0A (MASTER): 8 BIT XFER
IDE0B8BIT	.SET	TRUE		; IDE 0B (MASTER): 8 BIT XFER
IDE1MODE	.SET	IDEMODE_DIDE	; IDE 1: DRIVER MODE: IDEMODE_[DIO|DIDE|MK4|RC|GIDE]
IDE1BASE	.SET	$20		; IDE 1: IO BASE ADDRESS
IDE1DATLO	.SET	$28		; IDE 1: DATA LO PORT FOR 16-BIT I/O
IDE1DATHI	.SET	$28		; IDE 1: DATA HI PORT FOR 16-BIT I/O
IDE1A8BIT	.SET	FALSE		; IDE 1A (MASTER): 8 BIT XFER
IDE1B8BIT	.SET	FALSE		; IDE 1B (MASTER): 8 BIT XFER
IDE2MODE	.SET	IDEMODE_DIDE	; IDE 2: DRIVER MODE: IDEMODE_[DIO|DIDE|MK4|RC|GIDE]
IDE2BASE	.SET	$30		; IDE 2: IO BASE ADDRESS
IDE2DATLO	.SET	$38		; IDE 2: DATA LO PORT FOR 16-BIT I/O
IDE2DATHI	.SET	$38		; IDE 2: DATA HI PORT FOR 16-BIT I/O
IDE2A8BIT	.SET	FALSE		; IDE 2A (MASTER): 8 BIT XFER
IDE2B8BIT	.SET	FALSE		; IDE 2B (MASTER): 8 BIT XFER
;
PPIDEENABLE	.SET	FALSE		; PPIDE: ENABLE PARALLEL PORT IDE DISK DRIVER (PPIDE.ASM)
PPIDETRACE	.SET	1		; PPIDE: TRACE LEVEL (0=NO,1=ERRORS,2=ALL)
PPIDECNT	.SET	2		; PPIDE: NUMBER OF PPI CHIPS TO DETECT (1-3), 2 DRIVES PER CHIP
PPIDE0BASE	.SET	$14		; PPIDE 0: PPI REGISTERS BASE ADR
PPIDE0A8BIT	.SET	FALSE		; PPIDE 0A (MASTER): 8 BIT XFER
PPIDE0B8BIT	.SET	FALSE		; PPIDE 0B (SLAVE): 8 BIT XFER
PPIDE1BASE	.SET	$20		; PPIDE 1: PPI REGISTERS BASE ADR
PPIDE1A8BIT	.SET	FALSE		; PPIDE 1A (MASTER): 8 BIT XFER
PPIDE1B8BIT	.SET	FALSE		; PPIDE 0B (SLAVE): 8 BIT XFER
PPIDE2BASE	.SET	$00		; PPIDE 2: PPI REGISTERS BASE ADR
PPIDE2A8BIT	.SET	FALSE		; PPIDE 2A (MASTER): 8 BIT XFER
PPIDE2B8BIT	.SET	FALSE		; PPIDE 0B (SLAVE): 8 BIT XFER
;
SDENABLE	.SET	TRUE		; SD: ENABLE SD CARD DISK DRIVER (SD.ASM)
SDMODE		.SET	SDMODE_MK4	; SD: DRIVER MODE: SDMODE_[JUHA|N8|CSIO|PPI|UART|DSD|MK4|SC|MT|USR|PIO|Z80R|EPITX|FZ80|GM|EZ512|K80W]
SDPPIBASE	.SET	$60		; SD: BASE I/O ADDRESS OF PPI FOR PPI MODDE
SDCNT		.SET	1		; SD: NUMBER OF SD CARD DEVICES (1-2), FOR DSD/SC/MT ONLY
SDTRACE		.SET	1		; SD: TRACE LEVEL (0=NO,1=ERRORS,2=ALL)
SDCSIOFAST	.SET	TRUE		; SD: ENABLE TABLE-DRIVEN BIT INVERTER IN CSIO MODE
SDMTSWAP	.SET	FALSE		; SD: SWAP THE LOGICAL ORDER OF THE SPI PORTS OF THE MT011
;
CHENABLE	.SET	FALSE		; CH: ENABLE CH375/376 USB SUPPORT
;
PRPENABLE	.SET	FALSE		; PRP: ENABLE ECB PROPELLER IO BOARD DRIVER (PRP.ASM)
PRPSDENABLE	.SET	TRUE		; PRP: ENABLE PROPIO DRIVER SD CARD SUPPORT
PRPSDTRACE	.SET	1		; PRP: SD CARD TRACE LEVEL (0=NO,1=ERRORS,2=ALL)
PRPCONENABLE	.SET	TRUE		; PRP: ENABLE PROPIO DRIVER VIDEO/KBD SUPPORT
;
PPPENABLE	.SET	FALSE		; PPP: ENABLE ZETA PARALLEL PORT PROPELLER BOARD DRIVER (PPP.ASM)
PPPBASE		.SET	$60		; PPP: PPI REGISTERS BASE ADDRESS
PPPSDENABLE	.SET	TRUE		; PPP: ENABLE PPP DRIVER SD CARD SUPPORT
PPPSDTRACE	.SET	1		; PPP: SD CARD TRACE LEVEL (0=NO,1=ERRORS,2=ALL)
PPPCONENABLE	.SET	TRUE		; PPP: ENABLE PPP DRIVER VIDEO/KBD SUPPORT
;
ESPENABLE	.SET	FALSE		; ESP: ENABLE ESP32 IO BOARD DRIVER (ESP.ASM)
;
HDSKENABLE	.SET	FALSE		; HDSK: ENABLE SIMH HDSK DISK DRIVER (HDSK.ASM)
;
PIOENABLE	.SET	FALSE		; PIO: ENABLE ZILOG PIO DRIVER (PIO.ASM)
PIOCNT		.SET	2		; PIO: NUMBER OF CHIPS TO DETECT (1-2), 2 CHANNELS PER CHIP
PIO0BASE	.SET	$B8		; PIO 0: REGISTERS BASE ADR
PIO1BASE	.SET	$BC		; PIO 1: REGISTERS BASE ADR
;
LPTENABLE	.SET	FALSE		; LPT: ENABLE CENTRONICS PRINTER DRIVER (LPT.ASM)
LPTMODE		.SET	LPTMODE_NONE	; LPT: DRIVER MODE: LPTMODE_[NONE|SPP|MG014]
LPTCNT		.SET	1		; LPT: NUMBER OF CHIPS TO DETECT (1-2)
LPTTRACE	.SET	1		; LPT: TRACE LEVEL (0=NO,1=ERRORS,2=ALL)
LPT0BASE	.SET	$E8		; LPT 0: REGISTERS BASE ADR
LPT1BASE	.SET	$EC		; LPT 1: REGISTERS BASE ADR
;
PPAENABLE	.SET	FALSE		; PPA: ENABLE PPA DISK DRIVER (PPA.ASM)
;
IMMENABLE	.SET	FALSE		; IMM: ENABLE IMM DISK DRIVER (IMM.ASM)
;
SYQENABLE	.SET	FALSE		; SYQ: ENABLE IMM DISK DRIVER (SYQ.ASM)
;
PIO_4P		.SET	FALSE		; PIO: ENABLE PARALLEL PORT DRIVER FOR ECB 4P BOARD
PIO4BASE	.SET	$90		; PIO: PIO REGISTERS BASE ADR FOR ECB 4P BOARD
PIO_ZP		.SET	FALSE		; PIO: ENABLE PARALLEL PORT DRIVER FOR ECB ZILOG PERIPHERALS BOARD (PIO.ASM)
PIOZBASE	.SET	$88		; PIO: PIO REGISTERS BASE ADR FOR ECB ZP BOARD
PIO_SBC		.SET	FALSE		; PIO: ENABLE PARALLEL PORT DRIVER FOR 8255 CHIP
PIOSBASE	.SET	$60		; PIO: PIO REGISTERS BASE ADR FOR SBC PPI
;
UFENABLE	.SET	FALSE		; UF: ENABLE ECB USB FIFO DRIVER (UF.ASM)
UFBASE		.SET	$0C		; UF: REGISTERS BASE ADR
;
SN76489ENABLE	.SET	FALSE		; SN: ENABLE SN76489 SOUND DRIVER
AUDIOTRACE	.SET	FALSE		; ENABLE TRACING TO CONSOLE OF SOUND DRIVER
SN7CLK		.SET	3579545		; SN: PSG CLOCK FREQ, ASSUME MSX STD
SNMODE		.SET	SNMODE_VGM	; SN: DRIVER MODE: SNMODE_[NONE|RC|VGM|DUO]
;
AY38910ENABLE	.SET	FALSE		; AY: ENABLE AY-3-8910 / YM2149 SOUND DRIVER
AY_CLK		.SET	1789772		; AY: PSG CLOCK FREQ, ASSUME MSX STD
AYMODE		.SET	AYMODE_SCG	; AY: DRIVER MODE: AYMODE_[SCG|N8|RCZ80|RCZ180|MSX|LINC|MBC|DUO|NABU]
;
SPKENABLE	.SET	FALSE		; SPK: ENABLE RTC LATCH IOBIT SOUND DRIVER (SPK.ASM)
;
DMAENABLE	.SET	FALSE		; DMA: ENABLE DMA DRIVER (DMA.ASM)
DMABASE		.SET	$E0		; DMA: DMA BASE ADDRESS
DMAMODE		.SET	DMAMODE_ECB	; DMA: DMA MODE (NONE|ECB|Z180|Z280|RC|MBC|DUO)
;
YM2612ENABLE	.SET	FALSE		; YM2612: ENABLE YM2612 DRIVER
VGMBASE		.SET	$C0		; YM2612: BASE ADDRESS FOR VGM BOARD (YM2612/SN76489s/CTC)
