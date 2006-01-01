.include "m8535def.inc"
.include "C:\Elie\Afficheurgeant\caractere.inc"

.def SORTIE = r16
.def TRAVAIL = r17
.def CLIGNOTANT =r18
.def CENTIEMES = r19
.def SECONDES = r20
.def MINUTES = r21
.def SAUVREG = r1
.def CHRONOALLUME = r0
.def COMPTEURCLAVIER = r22
.def REGISTRECLAVIER = r23
.def VALIDATICLAVIER = r24
.def POINTEURCLAVIER = r25
.def OCTET_A_ENVOYER = r26
.def HAUT = r27
.def MOY = r28
.def BAS = r29



.equ  Memoire_Caractere = $90

rjmp Raz
rjmp INT_0
rjmp CARACTERE_ENTRE
nop
nop
nop
rjmp CentiSeconde
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop

Raz:
ldi SORTIE,high($79)
out SPH,SORTIE
ldi SORTIE,low($79)
out SPL,SORTIE

ldi SORTIE,$FF
out DDRB,SORTIE
ldi SORTIE,$FF-(1<<PD2)-(1<<PD3)-(1<<PD4)
out DDRD,SORTIE
ldi SORTIE,$FF
out DDRA,SORTIE
ldi SORTIE,$FF
out DDRC,SORTIE

; Génération du 1Mhz nécessaire au AT90S2313 sur PD7
ldi SORTIE,(1<<WGM21)+(0<<WGM20)+(0<<COM21)+(1<<COM20)+(0<<CS22)+(0<<CS21)+(1<<CS20)
out TCCR2,SORTIE
ldi SORTIE,3
out OCR2,SORTIE

; Génération du 100Hz
ldi SORTIE,high(9999)
ldi TRAVAIL,low(9999)
out OCR1AL,TRAVAIL
out OCR1AH,SORTIE

ldi SORTIE,(0<<CS12)+(1<<CS11)+(0<<CS10)+(0<<WGM13)+(1<<WGM12)
out TCCR1B,SORTIE
ldi SORTIE,(0<<COM1A1)+(0<<COM1A0)+(0<<WGM11)
out TCCR1A,SORTIE

ldi SORTIE,(1<<OCF1A)
out TIMSK,SORTIE

;Usart
ldi SORTIE,0
out UBRRH,SORTIE
ldi SORTIE,15
out UBRRL,SORTIE
ldi SORTIE,0
out UCSRA,SORTIE
ldi SORTIE,(1<<TXEN)
out UCSRB,SORTIE
ldi SORTIE,(1<<URSEL)+(1<<UCSZ1)+(1<<UCSZ0)
out UCSRC,SORTIE


;ldi SORTIE,(1<<ISC01)+(1<<ISC00)
;out MCUCR,SORTIE
;ldi SORTIE,(1<<INT0)+(1<<INT1)
;out GICR,SORTIE

in SORTIE,SFIOR
ori SORTIE,$03
out SFIOR,SORTIE

sei

ldi CENTIEMES,00
ldi CLIGNOTANT,00
ldi SECONDES,00
ldi MINUTES,00
ldi TRAVAIL,1
mov CHRONOALLUME,TRAVAIL
ldi REGISTRECLAVIER,00
ldi COMPTEURCLAVIER,00
ldi OCTET_A_ENVOYER,00

Debut:

rjmp Debut


CentiSeconde:
cli
push TRAVAIL
push SORTIE
in SAUVREG,SREG

mov TRAVAIL,CHRONOALLUME
cpi TRAVAIL,0
breq CSSuite
inc CENTIEMES 
cpi CENTIEMES,100
brne CSSuite
ldi CENTIEMES,0

rcall Transmission
inc OCTET_A_ENVOYER
cpi OCTET_A_ENVOYER,52
brlo TransSuite
ldi OCTET_A_ENVOYER,0
TransSuite:

inc SECONDES 
cpi SECONDES,60
brne CSSuite
ldi SECONDES,0
inc MINUTES
;out PORTA,CENTIEMES

CSSuite:


out SREG,SAUVREG
pop SORTIE
pop TRAVAIL

reti


INT_0:

cli

push TRAVAIL
push SORTIE
in SAUVREG,SREG

inc COMPTEURCLAVIER

cpi COMPTEURCLAVIER,1
brne I0Suite
sbic PIND,PIND3
rjmp I0Erreur
ldi VALIDATICLAVIER,0
rjmp I0Fin

I0Suite:

cpi COMPTEURCLAVIER,10
brsh I0PresqueFin
cpi COMPTEURCLAVIER,2
brsh I0Suite2

ldi REGISTRECLAVIER,0

I0Suite2:
ldi TRAVAIL,0

sbic PIND,PIND3

ldi TRAVAIL,$80

lsr REGISTRECLAVIER
or REGISTRECLAVIER,TRAVAIL

rjmp I0Fin

I0PresqueFin:
cpi COMPTEURCLAVIER,10
breq I0Fin

sbis PIND,PIND3
rjmp I0Erreur

ldi VALIDATICLAVIER,1
ldi COMPTEURCLAVIER,0
out PORTA,REGISTRECLAVIER
rjmp I0Fin

I0Erreur:
ldi VALIDATICLAVIER,2
ldi COMPTEURCLAVIER,0

I0Fin:
out SREG,SAUVREG
pop SORTIE
pop TRAVAIL

reti

CARACTERE_ENTRE:
reti




Transmission:
sbis UCSRA,UDRE
rjmp Transmission

out UDR,OCTET_A_ENVOYER

ret


