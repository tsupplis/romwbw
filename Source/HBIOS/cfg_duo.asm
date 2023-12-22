;
;==================================================================================================
;   ROMWBW 3.X CONFIGURATION DEFAULTS FOR DUODYNE
;==================================================================================================
;
; THIS FILE CONTAINS THE FULL SET OF DEFAULT CONFIGURATION SETTINGS FOR THE PLATFORM
; INDICATED ABOVE. THIS FILE SHOULD *NOT* NORMALLY BE CHANGED.	INSTEAD, YOU SHOULD
; OVERRIDE ANY SETTINGS YOU WANT USING A CONFIGURATION FILE IN THE CONFIG DIRECTORY
; UNDER THIS DIRECTORY.
;
; THIS FILE CAN BE CONSIDERED A REFERENCE THAT LISTS ALL POSSIBLE CONFIGURATION SETTINGS
; FOR THE PLATFORM.
;
#DEFINE PLATFORM_NAME "Duodyne", " [", CONFIG, "]"
;
#INCLUDE "hbios.inc"
;
PLATFORM	.EQU	PLT_DUO		; PLT_[SBC|ZETA|ZETA2|N8|MK4|UNA|RCZ80|RCZ180|EZZ80|SCZ180|DYNO|RCZ280|MBC|RPH|Z80RETRO|S100|DUO|HEATH|MON]
CPUFAM		.EQU	CPU_Z80		; CPU FAMILY: CPU_[Z80|Z180|Z280]
BIOS		.EQU	BIOS_WBW	; HARDWARE BIOS: BIOS_[WBW|UNA]
BATCOND		.EQU	FALSE		; ENABLE LOW BATTERY WARNING MESSAGE
HBIOS_MUTEX	.EQU	FALSE		; ENABLE REENTRANT CALLS TO HBIOS (ADDS OVERHEAD)
USELZSA2	.EQU	TRUE		; ENABLE FONT COMPRESSION
TICKFREQ	.EQU	50		; DESIRED PERIODIC TIMER INTERRUPT FREQUENCY (HZ)
;
BOOT_TIMEOUT	.EQU	-1		; AUTO BOOT TIMEOUT IN SECONDS, -1 TO DISABLE, 0 FOR IMMEDIATE
BOOT_DELAY	.EQU	0		; FIXED BOOT DELAY IN SECONDS PRIOR TO CONSOLE OUTPUT
;
CPUSPDCAP	.EQU	SPD_FIXED	; CPU SPEED CHANGE CAPABILITY SPD_FIXED|SPD_HILO
CPUSPDDEF	.EQU	SPD_UNSUP	; CPU SPEED DEFAULT SPD_UNSUP|SPD_HIGH|SPD_LOW
CPUOSC		.EQU	8000000		; CPU OSC FREQ IN MHZ
INTMODE		.EQU	2		; INTERRUPTS: 0=NONE, 1=MODE 1, 2=MODE 2, 3=MODE 3 (Z280)
DEFSERCFG	.EQU	SER_38400_8N1 | SER_RTS	; DEFAULT SERIAL LINE CONFIG (SEE STD.ASM)
;
RAMSIZE		.EQU	512		; SIZE OF RAM IN KB (MUST MATCH YOUR HARDWARE!!!)
ROMSIZE		.EQU	512		; SIZE OF ROM IN KB (MUST MATCH YOUR HARDWARE!!!)
MEMMGR		.EQU	MM_Z2		; MEMORY MANAGER: MM_[SBC|Z2|N8|Z180|Z280|MBC|RPH|MON]
MPGSEL_0	.EQU	$50		; Z2 MEM MGR BANK 0 PAGE SELECT REG (WRITE ONLY)
MPGSEL_1	.EQU	$51		; Z2 MEM MGR BANK 1 PAGE SELECT REG (WRITE ONLY)
MPGSEL_2	.EQU	$52		; Z2 MEM MGR BANK 2 PAGE SELECT REG (WRITE ONLY)
MPGSEL_3	.EQU	$53		; Z2 MEM MGR BANK 3 PAGE SELECT REG (WRITE ONLY)
MPGENA		.EQU	$54		; Z2 MEM MGR PAGING ENABLE REGISTER (BIT 0, WRITE ONLY)
;
RTCIO		.EQU	$94		; RTC LATCH REGISTER ADR
;
KIOENABLE	.EQU	FALSE		; ENABLE ZILOG KIO SUPPORT
KIOBASE		.EQU	$80		; KIO BASE I/O ADDRESS
;
CTCENABLE	.EQU	TRUE		; ENABLE ZILOG CTC SUPPORT
CTCDEBUG	.EQU	FALSE		; ENABLE CTC DRIVER DEBUG OUTPUT
CTCBASE		.EQU	$60		; CTC BASE I/O ADDRESS
CTCTIMER	.EQU	TRUE		; ENABLE CTC PERIODIC TIMER
CTCMODE		.EQU	CTCMODE_CTR	; CTC MODE: CTCMODE_[NONE|CTR|TIM16|TIM256]
CTCPRE		.EQU	256		; PRESCALE CONSTANT (1-256)
CTCPRECH	.EQU	2		; PRESCALE CHANNEL (0-3)
CTCTIMCH	.EQU	3		; TIMER CHANNEL (0-3)
CTCOSC		.EQU	(7372800/8)	; CTC CLOCK FREQUENCY
;
PCFENABLE	.EQU	FALSE		; ENABLE PCF8584 I2C CONTROLLER
PCFBASE		.EQU	$56		; PCF8584 BASE I/O ADDRESS
;
EIPCENABLE	.EQU	FALSE		; EIPC: ENABLE Z80 EIPC (Z84C15) INITIALIZATION
;
SKZENABLE	.EQU	FALSE		; ENABLE SERGEY'S Z80-512K FEATURES
;
WDOGMODE	.EQU	WDOG_NONE	; WATCHDOG MODE: WDOG_[NONE|EZZ80|SKZ]
;
FPLED_ENABLE	.EQU	TRUE		; FP: ENABLES FRONT PANEL LEDS
FPLED_IO	.EQU	$42		; FP: PORT ADDRESS FOR FP LEDS
FPLED_DSKACT	.EQU	TRUE		; FP: ENABLES DISK I/O ACTIVITY ON FP LEDS
FPSW_ENABLE	.EQU	TRUE		; FP: ENABLES FRONT PANEL SWITCHES
FPSW_IO		.EQU	$42		; FP: PORT ADDRESS FOR FP SWITCHES
;
DIAGLVL		.EQU	DL_CRITICAL	; ERROR LEVEL REPORTING
;
LEDENABLE	.EQU	TRUE		; ENABLES STATUS LED
LEDMODE		.EQU	LEDMODE_RTC	; LEDMODE_[STD|RTC]
LEDPORT		.EQU	RTCIO		; STATUS LED PORT ADDRESS
LEDDISKIO	.EQU	TRUE		; ENABLES DISK I/O ACTIVITY ON STATUS LED
;
DSKYENABLE	.EQU	TRUE		; ENABLES DSKY FUNCTIONALITY
DSKYDSKACT	.EQU	TRUE		; ENABLES DISK ACTIVITY ON DSKY DISPLAY
ICMENABLE	.EQU	FALSE		; ENABLES ORIGINAL DSKY ICM DRIVER (7218)
ICMPPIBASE	.EQU	$88		; BASE I/O ADDRESS OF ICM PPI
PKDENABLE	.EQU	TRUE		; ENABLES DSKY NG PKD DRIVER (8259)
PKDPPIBASE	.EQU	$88		; BASE I/O ADDRESS OF PKD PPI
PKDOSC		.EQU	3000000		; OSCILLATOR FREQ FOR PKD (IN HZ)
H8PENABLE	.EQU	FALSE		; ENABLES HEATH H8 FRONT PANEL
;
BOOTCON		.EQU	0		; BOOT CONSOLE DEVICE
SECCON		.EQU	$FF		; SECONDARY CONSOLE DEVICE
CRTACT		.EQU	FALSE		; ACTIVATE CRT (VDU,CVDU,PROPIO,ETC) AT STARTUP
VDAEMU		.EQU	EMUTYP_ANSI	; VDA EMULATION: EMUTYP_[TTY|ANSI]
VDAEMU_SERKBD	.EQU	$FF		; VDA EMULATION: SERIAL KBD UNIT #, OR $FF FOR HW KBD
ANSITRACE	.EQU	1		; ANSI DRIVER TRACE LEVEL (0=NO,1=ERRORS,2=ALL)
PPKTRACE	.EQU	1		; PPK DRIVER TRACE LEVEL (0=NO,1=ERRORS,2=ALL)
KBDTRACE	.EQU	1		; KBD DRIVER TRACE LEVEL (0=NO,1=ERRORS,2=ALL)
PPKKBLOUT	.EQU	KBD_US		; PPK KEYBOARD LANGUAGE: KBD_[US|DE]
KBDKBLOUT	.EQU	KBD_US		; KBD KEYBOARD LANGUAGE: KBD_[US|DE]
MKYENABLE	.EQU	FALSE		; MSX 5255 PPI KEYBOARD COMPATIBLE DRIVER (REQUIRES TMS VDA DRIVER)
MKYKBLOUT	.EQU	KBD_US		; KBD KEYBOARD LANGUAGE: KBD_[US|DE]
;
DSRTCENABLE	.EQU	TRUE		; DSRTC: ENABLE DS-1302 CLOCK DRIVER (DSRTC.ASM)
DSRTCMODE	.EQU	DSRTCMODE_STD	; DSRTC: OPERATING MODE: DSRTC_[STD|MFPIC]
DSRTCCHG	.EQU	FALSE		; DSRTC: FORCE BATTERY CHARGE ON (USE WITH CAUTION!!!)
;
DS1501RTCENABLE	.EQU	FALSE		; DS1501RTC: ENABLE DS-1501 CLOCK DRIVER (DS1501RTC.ASM)
DS1501RTC_BASE	.EQU	$50		; DS1501RTC: I/O BASE ADDRESS
;
BQRTCENABLE	.EQU	FALSE		; BQRTC: ENABLE BQ4845 CLOCK DRIVER (BQRTC.ASM)
BQRTC_BASE	.EQU	$50		; BQRTC: I/O BASE ADDRESS
;
INTRTCENABLE	.EQU	FALSE		; ENABLE PERIODIC INTERRUPT CLOCK DRIVER (INTRTC.ASM)
;
RP5RTCENABLE	.EQU	FALSE		; RP5C01 RTC BASED CLOCK (RP5RTC.ASM)
;
HTIMENABLE	.EQU	FALSE		; ENABLE SIMH TIMER SUPPORT
SIMRTCENABLE	.EQU	FALSE		; ENABLE SIMH CLOCK DRIVER (SIMRTC.ASM)
;
DS7RTCENABLE	.EQU	FALSE		; DS7RTC: ENABLE DS-1307 I2C CLOCK DRIVER (DS7RTC.ASM)
DS7RTCMODE	.EQU	DS7RTCMODE_PCF	; DS7RTC: OPERATING MODE: DS7RTC_[PCF]
;
DUARTENABLE	.EQU	FALSE		; DUART: ENABLE 2681/2692 SERIAL DRIVER (DUART.ASM)
;
UARTENABLE	.EQU	TRUE		; UART: ENABLE 8250/16550-LIKE SERIAL DRIVER (UART.ASM)
UARTOSC		.EQU	7372800		; UART: OSC FREQUENCY IN MHZ
UARTINTS	.EQU	FALSE		; UART: INCLUDE INTERRUPT SUPPORT UNDER IM1/2/3
UARTCFG		.EQU	DEFSERCFG	; UART: LINE CONFIG FOR UART PORTS
UARTCASSPD	.EQU	SER_300_8N1	; UART: ECB CASSETTE UART DEFAULT SPEED
UARTSBC		.EQU	TRUE		; UART: AUTO-DETECT SBC/ZETA/DUO ONBOARD UART
UARTSBCFORCE	.EQU	FALSE		; UART: FORCE DETECTION OF SBC UART (FOR SIMH)
UARTAUX		.EQU	TRUE		; UART: AUTO-DETECT AUX UART
UARTCAS		.EQU	FALSE		; UART: AUTO-DETECT ECB CASSETTE UART
UARTMFP		.EQU	FALSE		; UART: AUTO-DETECT MF/PIC UART
UART4		.EQU	FALSE		; UART: AUTO-DETECT 4UART UART
UARTRC		.EQU	FALSE		; UART: AUTO-DETECT RC UART
UARTDUAL	.EQU	TRUE		; UART: AUTO-DETECT DUAL UART
;
ASCIENABLE	.EQU	FALSE		; ASCI: ENABLE Z180 ASCI SERIAL DRIVER (ASCI.ASM)
;
Z2UENABLE	.EQU	FALSE		; Z2U: ENABLE Z280 UART SERIAL DRIVER (Z2U.ASM)
;
ACIAENABLE	.EQU	FALSE		; ACIA: ENABLE MOTOROLA 6850 ACIA DRIVER (ACIA.ASM)
;
SIOENABLE	.EQU	TRUE		; SIO: ENABLE ZILOG SIO SERIAL DRIVER (SIO.ASM)
SIODEBUG	.EQU	FALSE		; SIO: ENABLE DEBUG OUTPUT
SIOBOOT		.EQU	0		; SIO: REBOOT ON RCV CHAR (0=DISABLED)
SIOCNT		.EQU	1		; SIO: NUMBER OF CHIPS TO DETECT (1-2), 2 CHANNELS PER CHIP
SIO0MODE	.EQU	SIOMODE_ZP	; SIO 0: CHIP TYPE: SIOMODE_[STD|RC|SMB|ZP|Z80R]
SIO0BASE	.EQU	$60		; SIO 0: REGISTERS BASE ADR
SIO0ACLK	.EQU	(7372800/4)	; SIO 0A: OSC FREQ IN HZ, ZP=2457600/4915200, RC/SMB=7372800
SIO0ACFG	.EQU	DEFSERCFG	; SIO 0A: SERIAL LINE CONFIG
SIO0ACTCC	.EQU	0		; SIO 0A: CTC CHANNEL 0=A, 1=B, 2=C, 3=D, -1 FOR NONE
SIO0BCLK	.EQU	(7372800/4)	; SIO 0B: OSC FREQ IN HZ, ZP=2457600/4915200, RC/SMB=7372800
SIO0BCFG	.EQU	DEFSERCFG	; SIO 0B: SERIAL LINE CONFIG
SIO0BCTCC	.EQU	1		; SIO 0B: CTC CHANNEL 0=A, 1=B, 2=C, 3=D, -1 FOR NONE
;
XIOCFG		.EQU	DEFSERCFG	; XIO: SERIAL LINE CONFIG
;
VDUENABLE	.EQU	FALSE		; VDU: ENABLE VDU VIDEO/KBD DRIVER (VDU.ASM)
VDUSIZ		.EQU	V80X25		; VDU: DISPLAY FORMAT [V80X24|V80X25|V80X30]
CVDUENABLE	.EQU	FALSE		; CVDU: ENABLE CVDU VIDEO/KBD DRIVER (CVDU.ASM)
CVDUMODE	.EQU	CVDUMODE_MBC	; CVDU: CVDU MODE: CVDUMODE_[NONE|ECB|MBC]
CVDUMON		.EQU	CVDUMON_CGA	; CVDU: CVDU MONITOR SETUP: CVDUMON_[NONE|CGA|EGA]
GDCENABLE	.EQU	FALSE		; GDC: ENABLE 7220 GDC VIDEO/KBD DRIVER (GDC.ASM)
TMSENABLE	.EQU	FALSE		; TMS: ENABLE TMS9918 VIDEO/KBD DRIVER (TMS.ASM)
TMSMODE		.EQU	TMSMODE_MBC	; TMS: DRIVER MODE: TMSMODE_[SCG|N8|MBC|MSX|MSX9958|MSXKBD|COLECO]
TMSTIMENABLE	.EQU	FALSE		; TMS: ENABLE TIMER INTERRUPTS (REQUIRES IM1)
VGAENABLE	.EQU	FALSE		; VGA: ENABLE VGA VIDEO/KBD DRIVER (VGA.ASM)
VGASIZ		.EQU	V80X25		; VGA: DISPLAY FORMAT [V80X25|V80X30|V80X43]
VRCENABLE	.EQU	FALSE		; VRC: ENABLE VGARC VIDEO/KBD DRIVER (VRC.ASM)
SCONENABLE	.EQU	FALSE		; SCON: ENABLE S100 CONSOLE DRIVER (SCON.ASM)
;
MDENABLE	.EQU	TRUE		; MD: ENABLE MEMORY (ROM/RAM) DISK DRIVER (MD.ASM)
MDROM		.EQU	TRUE		; MD: ENABLE ROM DISK
MDRAM		.EQU	TRUE		; MD: ENABLE RAM DISK
MDTRACE		.EQU	1		; MD: TRACE LEVEL (0=NO,1=ERRORS,2=ALL)
MDFFENABLE	.EQU	FALSE		; MD: ENABLE FLASH FILE SYSTEM
;
;
FDENABLE	.EQU	TRUE		; FD: ENABLE FLOPPY DISK DRIVER (FD.ASM)
FDMODE		.EQU	FDMODE_DUO	; FD: DRIVER MODE: FDMODE_[DIO|ZETA|ZETA2|DIDE|N8|DIO3|RCSMC|RCWDC|DYNO|EPFDC|MBC]
FDCNT		.EQU	2		; FD: NUMBER OF FLOPPY DRIVES ON THE INTERFACE (1-2)
FDTRACE		.EQU	1		; FD: TRACE LEVEL (0=NO,1=FATAL,2=ERRORS,3=ALL)
FDMAUTO		.EQU	TRUE		; FD: AUTO SELECT DEFAULT/ALTERNATE MEDIA FORMATS
FD0TYPE		.EQU	FDT_3HD		; FD 0: DRIVE TYPE: FDT_[3DD|3HD|5DD|5HD|8]
FD1TYPE		.EQU	FDT_3HD		; FD 1: DRIVE TYPE: FDT_[3DD|3HD|5DD|5HD|8]
;
RFENABLE	.EQU	FALSE		; RF: ENABLE RAM FLOPPY DRIVER
RFCNT		.EQU	1		; RF: NUMBER OF RAM FLOPPY UNITS (1-4)
;
IDEENABLE	.EQU	FALSE		; IDE: ENABLE IDE DISK DRIVER (IDE.ASM)
IDETRACE	.EQU	1		; IDE: TRACE LEVEL (0=NO,1=ERRORS,2=ALL)
IDECNT		.EQU	1		; IDE: NUMBER OF IDE INTERFACES TO DETECT (1-3), 2 DRIVES EACH
IDE0MODE	.EQU	IDEMODE_DIO	; IDE 0: DRIVER MODE: IDEMODE_[DIO|DIDE|MK4|RC]
IDE0BASE	.EQU	$20		; IDE 0: IO BASE ADDRESS
IDE0DATLO	.EQU	$20		; IDE 0: DATA LO PORT FOR 16-BIT I/O
IDE0DATHI	.EQU	$28		; IDE 0: DATA HI PORT FOR 16-BIT I/O
IDE0A8BIT	.EQU	FALSE		; IDE 0A (MASTER): 8 BIT XFER
IDE0B8BIT	.EQU	FALSE		; IDE 0B (MASTER): 8 BIT XFER
IDE1MODE	.EQU	IDEMODE_NONE	; IDE 1: DRIVER MODE: IDEMODE_[DIO|DIDE|MK4|RC]
IDE1BASE	.EQU	$00		; IDE 1: IO BASE ADDRESS
IDE1DATLO	.EQU	$00		; IDE 1: DATA LO PORT FOR 16-BIT I/O
IDE1DATHI	.EQU	$00		; IDE 1: DATA HI PORT FOR 16-BIT I/O
IDE1A8BIT	.EQU	TRUE		; IDE 1A (MASTER): 8 BIT XFER
IDE1B8BIT	.EQU	TRUE		; IDE 1B (MASTER): 8 BIT XFER
IDE2MODE	.EQU	IDEMODE_NONE	; IDE 2: DRIVER MODE: IDEMODE_[DIO|DIDE|MK4|RC]
IDE2BASE	.EQU	$00		; IDE 2: IO BASE ADDRESS
IDE2DATLO	.EQU	$00		; IDE 2: DATA LO PORT FOR 16-BIT I/O
IDE2DATHI	.EQU	$00		; IDE 2: DATA HI PORT FOR 16-BIT I/O
IDE2A8BIT	.EQU	TRUE		; IDE 2A (MASTER): 8 BIT XFER
IDE2B8BIT	.EQU	TRUE		; IDE 2B (MASTER): 8 BIT XFER
;
PPIDEENABLE	.EQU	TRUE		; PPIDE: ENABLE PARALLEL PORT IDE DISK DRIVER (PPIDE.ASM)
PPIDETRACE	.EQU	1		; PPIDE: TRACE LEVEL (0=NO,1=ERRORS,2=ALL)
PPIDECNT	.EQU	1		; PPIDE: NUMBER OF PPI CHIPS TO DETECT (1-3), 2 DRIVES PER CHIP
PPIDE0BASE	.EQU	$88		; PPIDE 0: PPI REGISTERS BASE ADR
PPIDE0A8BIT	.EQU	FALSE		; PPIDE 0A (MASTER): 8 BIT XFER
PPIDE0B8BIT	.EQU	FALSE		; PPIDE 0B (SLAVE): 8 BIT XFER
PPIDE1BASE	.EQU	$20		; PPIDE 1: PPI REGISTERS BASE ADR
PPIDE1A8BIT	.EQU	FALSE		; PPIDE 1A (MASTER): 8 BIT XFER
PPIDE1B8BIT	.EQU	FALSE		; PPIDE 0B (SLAVE): 8 BIT XFER
PPIDE2BASE	.EQU	$14		; PPIDE 2: PPI REGISTERS BASE ADR
PPIDE2A8BIT	.EQU	FALSE		; PPIDE 2A (MASTER): 8 BIT XFER
PPIDE2B8BIT	.EQU	FALSE		; PPIDE 0B (SLAVE): 8 BIT XFER
;
SDENABLE	.EQU	TRUE		; SD: ENABLE SD CARD DISK DRIVER (SD.ASM)
SDMODE		.EQU	SDMODE_MT	; SD: DRIVER MODE: SDMODE_[JUHA|N8|CSIO|PPI|UART|DSD|MK4|SC|MT|PIO|Z80R|USR]
SDPPIBASE	.EQU	$60		; SD: BASE I/O ADDRESS OF PPI FOR PPI MODDE
SDCNT		.EQU	1		; SD: NUMBER OF SD CARD DEVICES (1-2), FOR DSD/SC/MT ONLY
SDTRACE		.EQU	1		; SD: TRACE LEVEL (0=NO,1=ERRORS,2=ALL)
SDCSIOFAST	.EQU	FALSE		; SD: ENABLE TABLE-DRIVEN BIT INVERTER IN CSIO MODE
SDMTSWAP	.EQU	TRUE		; SD: SWAP THE LOGICAL ORDER OF THE SPI PORTS OF THE MT011
;
CHENABLE	.EQU	TRUE		; CH: ENABLE CH375/376 USB SUPPORT
CHTRACE		.EQU	1		; CH: TRACE LEVEL (0=NO,1=ERRORS,2=ALL)
CHUSBTRACE	.EQU	1		; CHUSB: TRACE LEVEL (0=NO,1=ERRORS,2=ALL)
CHSDTRACE	.EQU	1		; CHSD: TRACE LEVEL (0=NO,1=ERRORS,2=ALL)
CHCNT		.EQU	1		; CH: NUMBER OF BOARDS TO DETECT (1-2)
CH0BASE		.EQU	$4E		; CH 0: BASE I/O ADDRESS
CH0USBENABLE	.EQU	TRUE		; CH 0: ENABLE USB DISK
CH0SDENABLE	.EQU	TRUE		; CH 0: ENABLE SD DISK
CH1BASE		.EQU	$FF		; CH 1: BASE I/O ADDRESS
CH1USBENABLE	.EQU	FALSE		; CH 1: ENABLE USB DISK
CH1SDENABLE	.EQU	FALSE		; CH 1: ENABLE SD DISK
;
PRPENABLE	.EQU	FALSE		; PRP: ENABLE ECB PROPELLER IO BOARD DRIVER (PRP.ASM)
PRPSDENABLE	.EQU	TRUE		; PRP: ENABLE PROPIO DRIVER SD CARD SUPPORT
PRPSDTRACE	.EQU	1		; PRP: SD CARD TRACE LEVEL (0=NO,1=ERRORS,2=ALL)
PRPCONENABLE	.EQU	TRUE		; PRP: ENABLE PROPIO DRIVER VIDEO/KBD SUPPORT
;
PPPENABLE	.EQU	FALSE		; PPP: ENABLE ZETA PARALLEL PORT PROPELLER BOARD DRIVER (PPP.ASM)
;
ESPENABLE	.EQU	FALSE		; ESP: ENABLE ESP32 IO BOARD DRIVER (ESP.ASM)
ESPCONENABLE	.EQU	TRUE		; ESP: ENABLE ESP32 CONSOLE IO DRIVER VIDEO/KBD SUPPORT
;
HDSKENABLE	.EQU	FALSE		; HDSK: ENABLE SIMH HDSK DISK DRIVER (HDSK.ASM)
HDSKTRACE	.EQU	1		; HDSK: TRACE LEVEL (0=NO,1=ERRORS,2=ALL)
;
PIOENABLE	.EQU	TRUE		; PIO: ENABLE ZILOG PIO DRIVER (PIO.ASM)
PIOCNT		.EQU	2		; PIO: NUMBER OF CHIPS TO DETECT (1-2), 2 CHANNELS PER CHIP
PIO0BASE	.EQU	$68		; PIO 0: REGISTERS BASE ADR
PIO1BASE	.EQU	$6C		; PIO 1: REGISTERS BASE ADR
;
LPTENABLE	.EQU	TRUE		; LPT: ENABLE CENTRONICS PRINTER DRIVER (LPT.ASM)
LPTMODE		.EQU	LPTMODE_SPP	; LPT: DRIVER MODE: LPTMODE_[NONE|SPP|MG014]
LPTCNT		.EQU	1		; LPT: NUMBER OF CHIPS TO DETECT (1-2)
LPTTRACE	.EQU	1		; LPT: TRACE LEVEL (0=NO,1=ERRORS,2=ALL)
LPT0BASE	.EQU	$48		; LPT 0: REGISTERS BASE ADR
LPT1BASE	.EQU	$EC		; LPT 1: REGISTERS BASE ADR
;
PPAENABLE	.EQU	FALSE		; PPA: ENABLE PPA DISK DRIVER (PPA.ASM)
PPACNT		.EQU	1		; PPA: NUMBER OF PPA DEVICES (1-2)
PPATRACE	.EQU	1		; PPA: TRACE LEVEL (0=NO,1=ERRORS,2=ALL)
PPAMODE		.EQU	PPAMODE_SPP	; PPA: DRIVER MODE: PPAMODE_[NONE|MG014]
PPA0BASE	.EQU	LPT0BASE	; PPA 0: BASE I/O ADDRESS OF PPI FOR PPA
PPA1BASE	.EQU	LPT1BASE	; PPA 1: BASE I/O ADDRESS OF PPI FOR PPA
;
IMMENABLE	.EQU	FALSE		; IMM: ENABLE IMM DISK DRIVER (IMM.ASM)
IMMCNT		.EQU	1		; IMM: NUMBER OF IMM DEVICES (1-2)
IMMTRACE	.EQU	1		; IMM: TRACE LEVEL (0=NO,1=ERRORS,2=ALL)
IMMMODE		.EQU	IMMMODE_SPP	; IMM: DRIVER MODE: IMMMODE_[NONE|SPP|MG014]
IMM0BASE	.EQU	LPT0BASE	; IMM 0: BASE I/O ADDRESS OF PPI FOR IMM
IMM1BASE	.EQU	LPT1BASE	; IMM 1: BASE I/O ADDRESS OF PPI FOR IMM
;
SYQENABLE	.EQU	FALSE		; SYQ: ENABLE IMM DISK DRIVER (SYQ.ASM)
SYQCNT		.EQU	1		; SYQ: NUMBER OF SYQ DEVICES (1-2)
SYQTRACE	.EQU	1		; SYQ: TRACE LEVEL (0=NO,1=ERRORS,2=ALL)
SYQMODE		.EQU	IMMMODE_SPP	; SYQ: DRIVER MODE: SYQMODE_[NONE|SPP|MG014]
SYQ0BASE	.EQU	LPT0BASE	; SYQ 0: BASE I/O ADDRESS OF PPI FOR SYQ
SYQ1BASE	.EQU	LPT1BASE	; SYQ 1: BASE I/O ADDRESS OF PPI FOR SYQ
;
PIO_4P		.EQU	FALSE		; PIO: ENABLE PARALLEL PORT DRIVER FOR ECB 4P BOARD
PIO4BASE	.EQU	$90		; PIO: PIO REGISTERS BASE ADR FOR ECB 4P BOARD
PIO_ZP		.EQU	FALSE		; PIO: ENABLE PARALLEL PORT DRIVER FOR ECB ZILOG PERIPHERALS BOARD (PIO.ASM)
PIOZBASE	.EQU	$88		; PIO: PIO REGISTERS BASE ADR FOR ECB ZP BOARD
PIO_SBC		.EQU	FALSE		; PIO: ENABLE PARALLEL PORT DRIVER FOR 8255 CHIP
PIOSBASE	.EQU	$60		; PIO: PIO REGISTERS BASE ADR FOR SBC PPI
;
UFENABLE	.EQU	FALSE		; UF: ENABLE ECB USB FIFO DRIVER (UF.ASM)
UFBASE		.EQU	$0C		; UF: REGISTERS BASE ADR
;
SN76489ENABLE	.EQU	FALSE		; SN: ENABLE SN76489 SOUND DRIVER
AUDIOTRACE	.EQU	FALSE		; ENABLE TRACING TO CONSOLE OF SOUND DRIVER
SN7CLK		.EQU	3579545		; SN: PSG CLOCK FREQ, ASSUME MSX STD
SNMODE		.EQU	SNMODE_NONE	; SN: DRIVER MODE: SNMODE_[NONE|RC|VGM]
;
AY38910ENABLE	.EQU	FALSE		; AY: ENABLE AY-3-8910 / YM2149 SOUND DRIVER
AY_CLK		.EQU	1789772		; AY: PSG CLOCK FREQ, ASSUME MSX STD
AYMODE		.EQU	AYMODE_MBC	; AY: DRIVER MODE: AYMODE_[SCG|N8|RCZ80|RCZ180|MSX|LINC|MBC]
;
SPKENABLE	.EQU	TRUE		; SPK: ENABLE RTC LATCH IOBIT SOUND DRIVER (SPK.ASM)
;
DMAENABLE	.EQU	TRUE		; DMA: ENABLE DMA DRIVER (DMA.ASM)
DMABASE		.EQU	$40		; DMA: DMA BASE ADDRESS
DMAMODE		.EQU	DMAMODE_DUO	; DMA: DMA MODE (NONE|ECB|Z180|Z280|RC|MBC|DUO)
;
YM2612ENABLE	.EQU	FALSE		; YM2612: ENABLE YM2612 DRIVER
VGMBASE		.EQU	$C0		; YM2612: BASE ADDRESS FOR VGM BOARD (YM2612/SN76489s/CTC)
