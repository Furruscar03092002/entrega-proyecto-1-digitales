;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  _______  _______ _________ _______  _______  _______  _______ ;  
;(       )(  ____ \\__   __/(  ____ \(  ___  )(  ____ )(  ___  ) ;
;| () () || (    \/   ) (   | (    \/| (   ) || (    )|| (   ) | ; 
;| || || || (__       | |   | (__    | |   | || (____)|| |   | | ; 
;| |(_)| ||  __)      | |   |  __)   | |   | ||     __)| |   | | ; 
;| |   | || (         | |   | (      | |   | || (\ (   | |   | | ;
;| )   ( || (____/\   | |   | (____/\| (___) || ) \ \__| (___) | ; 
;|/     \|(_______/   )_(   (_______/(_______)|/   \__/(_______) ; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
;    Filename: ROBOT SEGUIDOR DE LINEA                           ;
;    Designed by: JUAN JOSE ARDILA C. 2420191028		 ;
;		  HUGO MARIO RODRIGUEZ 2420191008                ;
;    Date:  13/03/2021                                           ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


PROCESSOR 16F877A

#include <xc.inc>

; CONFIGURATION WORD PG 144 datasheet

CONFIG CP=OFF ; PFM and Data EEPROM code protection disabled
CONFIG DEBUG=OFF ; Background debugger disabled
CONFIG WRT=OFF
CONFIG CPD=OFF
CONFIG WDTE=OFF ; WDT Disabled; SWDTEN is ignored
CONFIG LVP=ON ; Low voltage programming enabled, MCLR pin, MCLRE ignored
CONFIG FOSC=XT
CONFIG PWRTE=ON
CONFIG BOREN=OFF
PSECT udata_bank0

max:
DS 1 ;reserve 1 byte for max

tmp:
DS 1 ;reserve 1 byte for tmp
PSECT resetVec,class=CODE,delta=2

resetVec:
    PAGESEL INISYS ;jump to the main routine
    goto INISYS

PSECT code

INISYS:
    ;Cambio a Banco N1
    BCF STATUS, 6
    BSF STATUS, 5 ; Bank1
   
    ; Modificar TRIS
    BSF TRISC, 0    ; PortB0 <- entrada SA 
    BSF TRISC, 1    ; PortB1 <- entrada SB1
    BSF TRISC, 2    ; PortB2 <- entrada SB2
    BSF TRISC, 3    ; PortB3 <- entrada SC1
    BSF TRISC, 4    ; PortB4 <- entrada SC2

    BCF TRISD, 0    ; PortD0 <- salida ML1
    BCF TRISD, 1    ; PortD1 <- salida MR1
    BCF TRISD, 2    ; PortD2 <- salida ML2
    BCF TRISD, 3    ; PortD3 <- salida MR2
    BCF TRISD, 4    ; PortD2 <- salida LL 
    BCF TRISD, 5    ; PortD3 <- salida LR 
    BCF TRISD, 6    ; portD4 <- salida DYR
    
    ; Regresar a banco 
    BCF STATUS, 5 ; Bank0

Main:
    
    MOVF PORTC,0
    MOVWF 0X20
    
    ;SA=31
    MOVF   0X20,0
    ANDLW 0b00000001
    MOVWF 0X31
    MOVF  0X31,0
    ANDLW 0b00000001
    MOVWF 0X31
    
    ;SB1=32
    MOVF    0X20,0
    ANDLW 0b00000010
    MOVWF 0x32
    RRF   0x32,1
    MOVF  0x32,0
    ANDLW 0b00000001
    MOVWF 0x32
    
    ;SB2=33
    MOVF    0X20,0
    ANDLW   0b00000100
    MOVWF   0x33
    RRF	    0x33,1
    RRF	    0x33,1
    MOVF    0x33,0
    ANDLW   0b00000001
    MOVWF   0x33
    
    ;SC1=34
    MOVF    0X20,0
    ANDLW  0b00001000
    MOVWF   0X34
    RRF	    0X34,1
    RRF	    0X34,1
    RRF	    0X34,1
    MOVF    0X34,0
    ANDLW   0b00000001
    MOVWF   0X34
    
    ;SC2=35
    MOVF    0X20,0
    ANDLW  0b00010000
    MOVWF   0X35
    RRF	    0X35,1
    RRF	    0X35,1
    RRF	    0X35,1
    RRF	    0X35,1
    MOVF    0X35,0
    ANDLW   0b00000001
    MOVWF   0X35
    
     ;SA!=36
    MOVF    0X20,0
    ANDLW   0b00000001
    MOVWF   0X36
    COMF    0X36,1
    MOVF  0X36,0
    ANDLW 0b00000001
    MOVWF 0X36
    
     ;SB1!=37
    MOVF    0X20,0
    ANDLW 0b00000010
    MOVWF   0X37
    RRF	    0X37,1
    COMF    0X37
    MOVF    0X37,0
    ANDLW 0b00000001
    MOVWF   0X37
    
    ;SB2!=38
    MOVF    0X20,0
    ANDLW 0b00000100
    MOVWF   0X38
    RRF	    0X38,1
    RRF	    0X38,1
    COMF    0X38
    MOVF    0X38,0
    ANDLW 0b00000001
    MOVWF   0X38
    
    ;SC1!=39
    MOVF    0X20,0
    ANDLW 0b00001000
    MOVWF   0X39
    RRF	    0X39,1
    RRF	    0X39,1
    RRF	    0X39,1
    COMF    0X39
    MOVF    0X39,0
    ANDLW 0b00000001
    MOVWF   0X39
      
    ;SC2!=40
    MOVF    0X20,0
    ANDLW 0b00010000
    MOVWF   0X40
    RRF	    0X40,1
    RRF	    0X40,1
    RRF	    0X40,1
    RRF	    0X40,1
    COMF    0X40
    MOVF    0X40,0
    ANDLW 0b00000001
    MOVWF   0X40
    
;--------------------------------------------------------------------------
    
; Operaciones
    
; SB2! & SC2
    MOVF  0X38,0
    ANDWF 0X35,0
    MOVWF 0X41
    
; SB2 & SC1!
    MOVF  0X33,0
    ANDWF 0X39,0
    MOVWF 0X42
    
; SA & SB1!
    MOVF  0X31,0
    ANDWF 0X37,0
    MOVWF 0X43
	
    MOVF  0X41,0
    IORWF 0X42,0 
    MOVWF 0X44   ;RESULTADO 
	
    ; ML1: SB2!&SC2+SB2&SC1!+SA & SB1!
    MOVF  0X43,0
    IORWF 0X44,0
    MOVWF 0X45   ;RESULTADO DE ML1
    
;--------------------------------------------------------------------------

    ; SA & SB2! & SC1
    MOVF  0X31,0
    ANDWF 0X38,0
    ANDWF 0X34,0
    MOVWF 0X46   
    
     ; SA! & SB1! & SB2! & SC2!
    MOVF  0X36,0
    ANDWF 0X37,0
    ANDWF 0X38,0
    ANDWF 0X40,0
    MOVWF 0X47
	
; ML2: SA & SB2! & SC1+SA! & SB1! & SB2! & SC2!
    MOVF  0X46,0
    IORWF 0X47,0
    MOVWF 0X48      ;RESULTADO DE ML2
    
;--------------------------------------------------------------------------
    
    ; SC1 & SC2!
    MOVF  0X34,0
    ANDWF 0X40,0
    MOVWF 0X49
    
    ; SA & SB2!
    MOVF  0X31,0
    ANDWF 0X38,0
    MOVWF 0X50
    
    ; SB1 & SB2!
    MOVF  0X32,0
    ANDWF 0X38,0
    MOVWF 0X51
    
    MOVF  0X49,0
    IORWF 0X50,0
    MOVWF 0X52 
	
    ; MR1: SC1 & SC2!+SA & SB2!+SB1 & SB2!
    MOVF  0X51,0
    IORWF 0X52,0
    MOVWF 0X53 ;RESULTADO DE MR1
    
;--------------------------------------------------------------------------
    
    ; SA & SB1! & SC2
    MOVF  0X31,0
    ANDWF 0X37,0
    ANDWF 0X35,0
    MOVWF 0X54
    
    ; SA! & SB1! & SB2! & SC1!
    MOVF  0X36,0
    ANDWF 0X37,0
    ANDWF 0X38,0
    ANDWF 0X39,0
    MOVWF 0X55
    
    ; MR2: SA & SB1! & SC2+SA! & SB1! & SB2! & SC1!
    MOVF  0X54,0
    IORWF 0X55,0
    MOVWF 0X56		;RESULTADO MR2
    
;-----------------------------------------------------------------

    ;LL: SC1 & SC2!+SB1 & SB2!
    MOVF  0X49,0
    IORWF 0X51,0
    MOVWF 0X57
    
;-----------------------------------------------------------------
    
    ;LR: SB2! & SC2+SB2 & SC1!
    MOVF  0X41,0
    IORWF 0X42,0
    MOVWF 0X58

;-----------------------------------------------------------------
    
    ;SC1 & SC2
    MOVF  0X34,0
    ANDWF 0X35,0
    MOVWF 0X59
    
    ;SA! & SB1! & SB2! & SC1! & SC2!
    MOVF  0X36,0
    ANDWF 0X37,0
    ANDWF 0X38,0
    ANDWF 0X39,0
    ANDWF 0X40,0
    MOVWF 0X60
    
    ;DYR: SC1 & SC2+SA! & SB1! & SB2! & SC1! & SC2!
    MOVF  0X59,0
    IORWF 0X60,0
    MOVWF 0X61
    
;-----------------------------------------------------------------

    CLRF    PORTD
    BTFSC 0X45,0	;PARA ML1
    BSF PORTD,0		
    
    BTFSC 0X48,0	;MR1
    BSF PORTD,1		
    
    BTFSC 0X53,0	;ML2
    BSF PORTD,2		
    
    BTFSC 0X56,0	;MR2
    BSF PORTD,3		
    
    BTFSC 0X57,0	;LL
    BSF PORTD,4		
    
    BTFSC 0X58,0	;LR
    BSF PORTD,5		
    
    BTFSC 0X61,0	;DYR
    BSF PORTD,6		
 
GOTO Main
END