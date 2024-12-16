;
;==================================================================================================
;   ROMWBW CUSTOM USER BUILD SETTINGS EXAMPLE FOR RCBUS Z80
;==================================================================================================
;
; THIS FILE IS AN EXAMPLE OF A CUSTOM USER SETTINGS FILE.  THESE
; SETTINGS OVERRIDE THE DEFAULT SETTINGS OF THE INHERITED FILES AS
; DESIRED BY A USER.
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
; THIS FILE EXEMPLIFIES THE IDEAL WAY TO CREATE A USER SPECIFIC BUILD
; CONFIGURATION.  NOTICE THAT IT INCLUDES THE DEFAULT BUILD SETTINGS
; FILE AND OVERRIDES SOME DESIRED SETTINGS.
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
; THIS EXAMPLE CUSTOM USER SETTINGS FILE DOES THE FOLLOWING:
;
; 1. SETS A CUSTOM NAME USED IN THE BOOT LOADER BANNER
; 2. BOOTS ZSDOS BY DEFAULT AFTER 10 SECOND DELAY
; 3. ENABLES LPT PRINTER SUPPORT
;
#DEFINE PLATFORM_NAME "My Custom RCBus Computer", " [", CONFIG, "]"
#DEFINE	BOOT_DEFAULT	"H"		; DEFAULT BOOT LOADER CMD FOR EMPTY CMD LINE
#DEFINE AUTO_CMD	""		; AUTO CMD WHEN BOOT_TIMEOUT IS ENABLED
;
#INCLUDE "Config/RCZ80_std.asm"		; INHERIT FROM OFFICIAL BUILD SETTINGS
;
BOOT_TIMEOUT	.SET	10		; AUTO BOOT TIMEOUT IN SECONDS, -1 TO DISABLE, 0 FOR IMMEDIATE
;
LPTENABLE	.SET	TRUE		; LPT: ENABLE CENTRONICS PRINTER DRIVER (LPT.ASM)