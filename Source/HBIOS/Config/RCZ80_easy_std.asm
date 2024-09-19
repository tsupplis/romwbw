;
;==================================================================================================
;   ROMWBW DEFAULT BUILD SETTINGS FOR EASY Z80
;==================================================================================================
;
; THIS FILE DEFINES THE DEFAULT CONFIGURATION SETTINGS FOR THE PLATFORM
; INDICATED ABOVE.  THESE SETTINGS DEFINE THE OFFICIAL BUILD FOR THIS
; PLATFORM AS DISTRIBUTED IN ROMWBW RELEASES.
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
; MODIFIED.
;
; TO CUSTOMIZE YOUR BUILD SETTINGS YOU SHOULD MODIFY THIS FILE, THE
; DEFAULT BUILD SETTINGS (Config/<platform>_std.asm) OR PREFERABLY
; CREATE AN OPTIONAL CUSTOM USER SETTINGS FILE THAT INCLUDES THE DEFAULT
; BUILD SETTINGS FILE (SEE EXAMPLE Config/SBC_user.asm).
;
; BY CREATING A CUSTOM USER SETTINGS FILE, YOU ARE LESS LIKELY TO BE
; IMPACTED BY FUTURE CHANGES BECAUSE YOU WILL BE INHERITING MOST
; OF YOUR SETTINGS WHICH WILL BE UPDATED BY AUTHORS AS ROMWBW EVOLVES.
;
; PLEASE REFER TO THE CUSTOM BUILD INSTRUCTIONS (README.TXT) IN THE
; SOURCE DIRECTORY (TWO DIRECTORIES ABOVE THIS ONE).
;
; *** WARNING: ASIDE FROM THE MASTER CONFIGURATION FILE, YOU MUST USE
; ".SET" TO OVERRIDE SETTINGS.  THE ASSEMBLER WILL ERROR IF YOU ATTEMPT
; TO USE ".EQU" BECAUSE IT WON'T LET YOU REDEFINE A SETTING WITH ".EQU".
;
#DEFINE PLATFORM_NAME "Easy-Z80", " [", CONFIG, "]"
;
#DEFINE	BOOT_DEFAULT	"H"		; DEFAULT BOOT LOADER CMD ON <CR> OR AUTO BOOT
;
#INCLUDE "cfg_RCZ80.asm"
;
PLATFORM	.SET	PLT_EZZ80	; PLT_[SBC|ZETA|ZETA2|N8|MK4|UNA|RCZ80|RCEZ80|RCZ180|EZZ80|SCZ180|GMZ180|DYNO|RCZ280|MBC|RPH|Z80RETRO|S100|DUO|HEATH|EPITX|MON|STDZ180|NABU|FZ80]
;
CPUOSC		.SET	10000000	; CPU OSC FREQ IN MHZ
INTMODE		.SET	2		; INTERRUPTS: 0=NONE, 1=MODE 1, 2=MODE 2, 3=MODE 3 (Z280)
;
CTCENABLE	.SET	TRUE		; ENABLE ZILOG CTC SUPPORT
CTCTIMER	.SET	TRUE		; ENABLE CTC PERIODIC TIMER
CTCMODE		.SET	CTCMODE_CTR	; CTC MODE: CTCMODE_[NONE|CTR|TIM16|TIM256]
CTCOSC		.SET	921600		; CTC CLOCK FREQUENCY
WDOGMODE	.SET	WDOG_EZZ80	; WATCHDOG MODE: WDOG_[NONE|EZZ80|SKZ]
WDOGIO		.SET	$6F		; WATCHDOG REGISTER ADR
FPLED_ENABLE	.SET	TRUE		; FP: ENABLES FRONT PANEL LEDS
FPSW_ENABLE	.SET	TRUE		; FP: ENABLES FRONT PANEL SWITCHES
CRTACT		.SET	FALSE		; ACTIVATE CRT (VDU,CVDU,PROPIO,ETC) AT STARTUP
VDAEMU_SERKBD	.SET	0		; VDA EMULATION: SERIAL KBD UNIT #, OR $FF FOR HW KBD
;
DSRTCENABLE	.SET	TRUE		; DSRTC: ENABLE DS-1302 CLOCK DRIVER (DSRTC.ASM)
INTRTCENABLE	.SET	TRUE		; ENABLE PERIODIC INTERRUPT CLOCK DRIVER (INTRTC.ASM)
RP5RTCENABLE	.SET	FALSE		; RP5C01 RTC BASED CLOCK (RP5RTC.ASM)
;
DUARTENABLE	.SET	FALSE		; DUART: ENABLE 2681/2692 SERIAL DRIVER (DUART.ASM)
;
UARTENABLE	.SET	TRUE		; UART: ENABLE 8250/16550-LIKE SERIAL DRIVER (UART.ASM)
ACIAENABLE	.SET	FALSE		; ACIA: ENABLE MOTOROLA 6850 ACIA DRIVER (ACIA.ASM)
SIOENABLE	.SET	TRUE		; SIO: ENABLE ZILOG SIO SERIAL DRIVER (SIO.ASM)
SIO0MODE	.SET	SIOMODE_STD	; SIO 0: CHIP TYPE: SIOMODE_[STD|RC|SMB|ZP]
SIO0ACLK	.SET	1843200		; SIO 0A: OSC FREQ IN HZ, ZP=2457600/4915200, RC/SMB=7372800
SIO0BCLK	.SET	1843200		; SIO 0B: OSC FREQ IN HZ, ZP=2457600/4915200, RC/SMB=7372800
SIO1ACLK	.SET	7372800		; SIO 1A: OSC FREQ IN HZ, ZP=2457600/4915200, RC/SMB=7372800
SIO1BCLK	.SET	7372800		; SIO 1B: OSC FREQ IN HZ, ZP=2457600/4915200, RC/SMB=7372800
;
TMSENABLE	.SET	FALSE		; TMS: ENABLE TMS9918 VIDEO/KBD DRIVER (TMS.ASM)
TMSMODE		.SET	TMSMODE_MSX	; TMS: DRIVER MODE: TMSMODE_[SCG|N8|MSX|MSXKBD|MSXMKY|MBC|COLECO|DUO|NABU]
TMS80COLS	.SET	FALSE		; TMS: ENABLE 80 COLUMN SCREEN, REQUIRES V9958
TMSTIMENABLE	.SET	FALSE		; TMS: ENABLE TIMER INTERRUPTS (REQUIRES IM1)
VRCENABLE	.SET	FALSE		; VRC: ENABLE VGARC VIDEO/KBD DRIVER (VRC.ASM)
EFENABLE	.SET	FALSE		; EF: ENABLE EF9345 VIDEO DRIVER (EF.ASM)
;
;
FDENABLE	.SET	TRUE		; FD: ENABLE FLOPPY DISK DRIVER (FD.ASM)
FDMODE		.SET	FDMODE_RCWDC	; FD: DRIVER MODE: FDMODE_[DIO|ZETA|ZETA2|DIDE|N8|DIO3|RCSMC|RCWDC|DYNO|EPFDC|MBC]
;
IDEENABLE	.SET	TRUE		; IDE: ENABLE IDE DISK DRIVER (IDE.ASM)
;
PPIDEENABLE	.SET	TRUE		; PPIDE: ENABLE PARALLEL PORT IDE DISK DRIVER (PPIDE.ASM)
;
SDENABLE	.SET	FALSE		; SD: ENABLE SD CARD DISK DRIVER (SD.ASM)
SDCNT		.SET	1		; SD: NUMBER OF SD CARD DEVICES (1-2), FOR DSD/SC/MT ONLY
PRPENABLE	.SET	FALSE		; PRP: ENABLE ECB PROPELLER IO BOARD DRIVER (PRP.ASM)
IMMENABLE	.SET	FALSE		; IMM: ENABLE IMM DISK DRIVER (IMM.ASM)
;
SN76489ENABLE	.SET	FALSE		; SN: ENABLE SN76489 SOUND DRIVER
;
AY38910ENABLE	.SET	FALSE		; AY: ENABLE AY-3-8910 / YM2149 SOUND DRIVER
AYMODE		.SET	AYMODE_RCZ80	; AY: DRIVER MODE: AYMODE_[SCG|N8|RCZ80|RCZ180|MSX|LINC|MBC|DUO|NABU]
