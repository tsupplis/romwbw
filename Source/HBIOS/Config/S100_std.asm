;
;==================================================================================================
;   ROMWBW DEFAULT BUILD SETTINGS FOR S100
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
#DEFINE	BOOT_DEFAULT	"H"		; DEFAULT BOOT LOADER CMD FOR EMPTY CMD LINE
#DEFINE AUTO_CMD	""		; AUTO CMD WHEN BOOT_TIMEOUT IS ENABLED
;
#INCLUDE "cfg_S100.asm"
;
CPUOSC		.SET	18432000	; CPU OSC FREQ IN MHZ
;
Z180_CLKDIV	.SET	1		; Z180: CHK DIV: 0=OSC/2, 1=OSC, 2=OSC*2
Z180_MEMWAIT	.SET	1		; Z180: MEMORY WAIT STATES (0-3)
Z180_IOWAIT	.SET	2		; Z180: I/O WAIT STATES TO ADD ABOVE 1 W/S BUILT-IN (0-3)
;
CRTACT		.SET	TRUE		; ACTIVATE CRT (VDU,CVDU,PROPIO,ETC) AT STARTUP
DSRTCENABLE	.SET	FALSE		; DSRTC: ENABLE DS-1302 CLOCK DRIVER (DSRTC.ASM)
INTRTCENABLE	.SET	TRUE		; ENABLE PERIODIC INTERRUPT CLOCK DRIVER (INTRTC.ASM)
;
ASCIENABLE	.SET	TRUE		; ASCI: ENABLE Z180 ASCI SERIAL DRIVER (ASCI.ASM)
SCONENABLE	.SET	TRUE		; SCON: ENABLE S100 CONSOLE DRIVER (SCON.ASM)
;
IDEENABLE	.SET	FALSE		; IDE: ENABLE IDE DISK DRIVER (IDE.ASM)
PPIDEENABLE	.SET	FALSE		; PPIDE: ENABLE PARALLEL PORT IDE DISK DRIVER (PPIDE.ASM)
SDENABLE	.SET	TRUE		; SD: ENABLE SD CARD DISK DRIVER (SD.ASM)
SDMODE		.SET	SDMODE_SC	; SD: DRIVER MODE: SDMODE_[JUHA|N8|CSIO|PPI|UART|DSD|MK4|SC|MT|USR|PIO|Z80R|EPITX|FZ80|GM]
SDCNT		.SET	1		; SD: NUMBER OF SD CARD DEVICES (1-2), FOR DSD/SC/MT ONLY
