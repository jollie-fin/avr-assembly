.include "1200def.inc"
.def TRAVAILACTU2 = r16
.def BOUCLEACTU   = r17
.def COARSE   = r18
.def MEDIUM   = r19
.def FINE     = r20
.def TRAVAILACTU  = r21
.def BOUCLE  = r22
.def BOUCLE2  = r23
.def TRAVAIL = r24
.def TRAVAIL2 = r25
.def ZSAUV    = r29
.def ZB       = r30
.def ZH       = r31

.equ DONNEE = PD1
.equ VALID = PD2
.equ HORLOGEB = PD3
.equ HORLOGEA = PD4
.equ HORLOGEC = PD5
.equ HORLOGED = PD6

ldi TRAVAIL,$FF
out DDRD,TRAVAIL
ldi TRAVAIL,$00
out PORTD,TRAVAIL
ldi TRAVAIL,$C3
out DDRB,TRAVAIL
ldi TRAVAIL,$3C
out PORTB,TRAVAIL
ldi ZH,0

rjmp Debut ; Saute la phase de test
ldi BOUCLE2,10
Test:
ldi BOUCLE,255
Test2:
rcall Rempli
rcall Actualisation
rcall Raz
rcall Actualisation
dec BOUCLE
brne Test2
dec BOUCLE2
brne Test


rcall Delay
rcall Delay

Debut:
rcall Raz
rcall Actualisation

ldi BOUCLE,12
ldi ZB,0

BoucleDeb:
ldi TRAVAIL,$01
st Z,TRAVAIL
rcall Actualisation
rcall Pause
rcall Delay
Boucle2Deb:
cpi TRAVAIL,$80
breq FinBoucle2
lsl TRAVAIL
st Z,TRAVAIL
rcall Actualisation
rcall Pause
rcall Delay
rjmp Boucle2Deb
FinBoucle2:
ldi TRAVAIL,$00
st Z,TRAVAIL
inc ZB
dec BOUCLE
brne BoucleDeb
rjmp Debut

Delay:
ldi COARSE,6
Cagain:
ldi MEDIUM,238
Magain:
ldi FINE,250
Fagain:
dec FINE
brne Fagain
dec MEDIUM
brne Magain
dec COARSE
brne Cagain
ret

Actualisation:
mov ZSAUV,ZB
ldi ZB,0

ldi BOUCLEACTU,3
ActualisationA:
ldi TRAVAILACTU2,$80

ActualisationABOUCLEACTU:
ld TRAVAILACTU,Z
and TRAVAILACTU,TRAVAILACTU2
cpi TRAVAILACTU,0

brne ActualisationABOUCLEACTU1
cbi PORTD,DONNEE
rjmp ActualisationABOUCLEACTU0
ActualisationABOUCLEACTU1:
sbi PORTD,DONNEE
ActualisationABOUCLEACTU0:

sbi PORTD,HORLOGEA
cbi PORTD,HORLOGEA

lsr TRAVAILACTU2
cpi TRAVAILACTU2,0
brne ActualisationABOUCLEACTU

inc ZB
dec BOUCLEACTU
brne ActualisationA

ldi BOUCLEACTU,3
ActualisationB:
ldi TRAVAILACTU2,$80

ActualisationBBOUCLEACTU:
ld TRAVAILACTU,Z
and TRAVAILACTU,TRAVAILACTU2
cpi TRAVAILACTU,0

brne ActualisationBBOUCLEACTU1
cbi PORTD,DONNEE
rjmp ActualisationBBOUCLEACTU0
ActualisationBBOUCLEACTU1:
sbi PORTD,DONNEE
ActualisationBBOUCLEACTU0:

sbi PORTD,HORLOGEB
cbi PORTD,HORLOGEB

lsr TRAVAILACTU2
cpi TRAVAILACTU2,0
brne ActualisationBBOUCLEACTU

inc ZB
dec BOUCLEACTU
brne ActualisationB

ldi BOUCLEACTU,3
ActualisationC:
ldi TRAVAILACTU2,$80

ActualisationCBOUCLEACTU:
ld TRAVAILACTU,Z
and TRAVAILACTU,TRAVAILACTU2
cpi TRAVAILACTU,0

brne ActualisationCBOUCLEACTU1
cbi PORTD,DONNEE
rjmp ActualisationCBOUCLEACTU0
ActualisationCBOUCLEACTU1:
sbi PORTD,DONNEE
ActualisationCBOUCLEACTU0:

sbi PORTD,HORLOGEC
cbi PORTD,HORLOGEC

lsr TRAVAILACTU2
cpi TRAVAILACTU2,0
brne ActualisationCBOUCLEACTU

inc ZB
dec BOUCLEACTU
brne ActualisationC

ldi BOUCLEACTU,3
ActualisationD:
ldi TRAVAILACTU2,$80

ActualisationDBOUCLEACTU:
ld TRAVAILACTU,Z
and TRAVAILACTU,TRAVAILACTU2
cpi TRAVAILACTU,0

brne ActualisationDBOUCLEACTU1
cbi PORTD,DONNEE
rjmp ActualisationDBOUCLEACTU0
ActualisationDBOUCLEACTU1:
sbi PORTD,DONNEE
ActualisationDBOUCLEACTU0:

sbi PORTD,HORLOGED
cbi PORTD,HORLOGED

lsr TRAVAILACTU2
cpi TRAVAILACTU2,0
brne ActualisationDBOUCLEACTU

inc ZB
dec BOUCLEACTU
brne ActualisationD

mov ZB,ZSAUV
sbi PORTD,VALID
cbi PORTD,VALID
ret

Raz:
ldi TRAVAIL,0
mov r0,TRAVAIL
mov r1,TRAVAIL
mov r2,TRAVAIL
mov r3,TRAVAIL
mov r4,TRAVAIL
mov r5,TRAVAIL
mov r6,TRAVAIL
mov r7,TRAVAIL
mov r8,TRAVAIL
mov r9,TRAVAIL
mov r10,TRAVAIL
mov r11,TRAVAIL
ret

Rempli:
ldi TRAVAIL,$FF
mov r0,TRAVAIL
mov r1,TRAVAIL
mov r2,TRAVAIL
mov r3,TRAVAIL
mov r4,TRAVAIL
mov r5,TRAVAIL
mov r6,TRAVAIL
mov r7,TRAVAIL
mov r8,TRAVAIL
mov r9,TRAVAIL
mov r10,TRAVAIL
mov r11,TRAVAIL
ret

Pause:
sbic PINB,PINB2
rjmp Pause
ret
