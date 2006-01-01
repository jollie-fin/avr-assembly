.include "1200def.inc"

.def ROUGEANC = r0
.def VERTANC  = r1
.def BLEUANC  = r2
.def ROUGEACT = r3
.def VERTACT  = r4
.def BLEUACT  = r5

.def COMPTEURMLI = r16
.def SORTIE = r20
.def COMPTEURTEMPO = r21
.def PHASE = r22

.def NBTRANS = r23
.def COMPTEURTRANS = r24
.def ETAPETRANS = r25
.def TRAVAIL = r26
.def TRAVAIL2 = r27
.def ROUGE = r28
.def VERT = r29
.def BLEU = r30
.def COMPTEURTEMPO2 =r31

;.def	drem8u	=r15		;remainder
;.def	dres8u	=r24		;result
;.def	dd8u	=r24		;dividend
;.def	dv8u	=r25		;divisor
;.def	dcnt8u	=r26		;loop counter

Debut:
ldi SORTIE,$FF
out DDRB,SORTIE

ldi PHASE,0
ldi TRAVAIL,3
mov ROUGEACT,TRAVAIL
mov VERTACT,TRAVAIL
mov BLEUACT,TRAVAIL
mov ROUGEANC,TRAVAIL
mov VERTANC,TRAVAIL
mov BLEUANC,TRAVAIL
ldi COMPTEURTEMPO2,1

MLI:
ldi COMPTEURTEMPO,1
ldi COMPTEURTRANS,5

Trans:
dec COMPTEURTRANS
breq MLISuite

ldi NBTRANS,5

TransGrosseBoucle:
dec NBTRANS
breq Trans

ldi ETAPETRANS,5

TransBoucle:
dec ETAPETRANS
breq TransGrosseBoucle

cp ETAPETRANS,COMPTEURTRANS
brlo TransAnc
mov ROUGE,ROUGEACT
mov VERT,VERTACT
mov BLEU,BLEUACT
rjmp TransSuite

TransAnc:
mov ROUGE,ROUGEANC
mov VERT,VERTANC
mov BLEU,BLEUANC

TransSuite:
sbi PORTB,5
sbi PORTB,6
sbi PORTB,7
ldi COMPTEURMLI,0

TransBoucleMLI:
cp COMPTEURMLI,ROUGE
brne TransBoucleMLIvert
cbi PORTB,5
TransBoucleMLIvert:
cp COMPTEURMLI,VERT
brne TransBoucleMLIbleu
cbi PORTB,6
TransBoucleMLIbleu:
cp COMPTEURMLI,BLEU
brne TransBoucleMLIfin
cbi PORTB,7
TransBoucleMLIfin:
inc COMPTEURMLI
cpi COMPTEURMLI,00
breq TransBoucle
rjmp TransBoucleMLI

MLISuite:
dec COMPTEURTEMPO
brne MLITempoFin
ldi COMPTEURTEMPO,64

dec COMPTEURTEMPO2
breq Chgt

MLITempoFin:
sbi PORTB,5
sbi PORTB,6
sbi PORTB,7
ldi COMPTEURMLI,0

BoucleMLI:
cp COMPTEURMLI,ROUGE
brne BoucleMLIvert
cbi PORTB,5
BoucleMLIvert:
cp COMPTEURMLI,VERT
brne BoucleMLIbleu
cbi PORTB,6
BoucleMLIbleu:
cp COMPTEURMLI,BLEU
brne BoucleMLIfin
cbi PORTB,7
BoucleMLIfin:
inc COMPTEURMLI
cpi COMPTEURMLI,00
breq MLISuite
rjmp BoucleMLI


Chgt:
mov ROUGEANC,ROUGEACT
mov BLEUANC,BLEUACT
mov VERTANC,VERTACT

Chgt0:
cpi PHASE,0
brne Chgt1

mov TRAVAIL,ROUGEACT
rcall Inctravail
mov ROUGEACT,TRAVAIL
mov TRAVAIL,VERTACT
rcall Inctravail
mov VERTACT,TRAVAIL
mov TRAVAIL,BLEUACT
rcall Inctravail
mov BLEUACT,TRAVAIL

ldi COMPTEURTEMPO2,1
cpi TRAVAIL,255
breq Chgt0Suite
rjmp MLI
Chgt0Suite:
ldi PHASE,1
rjmp MLI
;Blanc

Chgt1:
cpi PHASE,1
brne Chgt2
mov TRAVAIL,BLEUACT
rcall Dectravail
mov BLEUACT,TRAVAIL

ldi COMPTEURTEMPO2,6
cpi TRAVAIL,3
breq Chgt1Suite
rjmp MLI
Chgt1Suite:
ldi PHASE,2
rjmp MLI
;Jaune

Chgt2:
cpi PHASE,2
brne Chgt3
mov TRAVAIL,VERTACT
rcall Dectravail
mov VERTACT,TRAVAIL
ldi COMPTEURTEMPO2,6
cpi TRAVAIL,3
breq Chgt2Suite
rjmp MLI
Chgt2Suite:
ldi PHASE,3
rjmp MLI
;Rouge

Chgt3:
cpi PHASE,3
brne Chgt4
mov TRAVAIL,BLEUACT
rcall Inctravail
mov BLEUACT,TRAVAIL
ldi COMPTEURTEMPO2,6
cpi TRAVAIL,255
breq Chgt3Suite
rjmp MLI
Chgt3Suite:
ldi PHASE,4
rjmp MLI
;Violet

Chgt4:
cpi PHASE,4
brne Chgt5
mov TRAVAIL,ROUGEACT
rcall Dectravail
mov ROUGEACT,TRAVAIL
ldi COMPTEURTEMPO2,6
cpi TRAVAIL,3
breq Chgt4Suite
rjmp MLI
Chgt4Suite:
ldi PHASE,5
rjmp MLI
;Bleu

Chgt5:
cpi PHASE,5
brne Chgt6
mov TRAVAIL,VERTACT
rcall Inctravail
mov VERTACT,TRAVAIL
ldi COMPTEURTEMPO2,6
cpi TRAVAIL,255
breq Chgt5Suite
rjmp MLI
Chgt5Suite:
ldi PHASE,6
rjmp MLI
;Cyan

Chgt6:
cpi PHASE,6
brne Chgt7
mov TRAVAIL,BLEUACT
rcall Dectravail
mov BLEUACT,TRAVAIL
ldi COMPTEURTEMPO2,6
cpi TRAVAIL,3
breq Chgt6Suite
rjmp MLI
Chgt6Suite:
ldi PHASE,7
rjmp MLI
;Vert

Chgt7:
cpi PHASE,7
brne Chgt8
mov TRAVAIL,BLEUACT
rcall Inctravail
mov BLEUACT,TRAVAIL
mov TRAVAIL,ROUGEACT
rcall Inctravail
mov ROUGEACT,TRAVAIL
ldi COMPTEURTEMPO2,6
cpi TRAVAIL,255
breq Chgt7Suite
rjmp MLI
Chgt7Suite:
ldi PHASE,8
rjmp MLI
;Blanc

Chgt8:
cpi PHASE,8
brne Chgt9
ldi COMPTEURTEMPO2,43
ldi PHASE,9
rjmp MLI
;Pause

Chgt9:
cpi PHASE,9
brne Chgt10
mov TRAVAIL,VERTACT
rcall Dectravail
mov VERTACT,TRAVAIL
mov TRAVAIL,ROUGEACT
rcall Dectravail
mov ROUGEACT,TRAVAIL
ldi COMPTEURTEMPO2,6
cpi TRAVAIL,3
breq Chgt9Suite
rjmp MLI
Chgt9Suite:
ldi PHASE,10
rjmp MLI
;Bleu

Chgt10:
cpi PHASE,10
brne Chgt11
mov TRAVAIL,ROUGEACT
rcall Inctravail
mov ROUGEACT,TRAVAIL
mov TRAVAIL,BLEUACT
rcall Dectravail
mov BLEUACT,TRAVAIL
ldi COMPTEURTEMPO2,6
cpi TRAVAIL,3
breq Chgt10Suite
rjmp MLI
Chgt10Suite:
ldi PHASE,11
rjmp MLI
;Rouge

Chgt11:
cpi PHASE,11
brne Chgt12
mov TRAVAIL,VERTACT
rcall Inctravail
mov VERTACT,TRAVAIL
mov TRAVAIL,ROUGEACT
rcall Dectravail
mov ROUGEACT,TRAVAIL
ldi COMPTEURTEMPO2,6
cpi TRAVAIL,3
breq Chgt11Suite
rjmp MLI
Chgt11Suite:
ldi PHASE,12
rjmp MLI
;Vert

Chgt12:
mov TRAVAIL,ROUGEACT
rcall Inctravail
mov ROUGEACT,TRAVAIL
mov TRAVAIL,BLEUACT
rcall Inctravail
mov BLEUACT,TRAVAIL
ldi COMPTEURTEMPO2,6
cpi TRAVAIL,255
breq Chgt12Suite
rjmp MLI
Chgt12Suite:
;Blanc
ldi PHASE,1
rjmp Chgt


Inctravail:
cpi TRAVAIL,7
brsh Inctravail1
inc TRAVAIL
ret
Inctravail1:
cpi TRAVAIL,15
brsh Inctravail2
ldi TRAVAIL2,2
add TRAVAIL,TRAVAIL2
ret
Inctravail2:
cpi TRAVAIL,31
brsh Inctravail3
ldi TRAVAIL2,4
add TRAVAIL,TRAVAIL2
ret
Inctravail3:
cpi TRAVAIL,63
brsh Inctravail4
ldi TRAVAIL2,8
add TRAVAIL,TRAVAIL2
ret
Inctravail4:
cpi TRAVAIL,127
brsh Inctravail5
ldi TRAVAIL2,16
add TRAVAIL,TRAVAIL2
ret
Inctravail5:
ldi TRAVAIL2,32
add TRAVAIL,TRAVAIL2
ret

Dectravail:
cpi TRAVAIL,8
brsh Dectravail1
dec TRAVAIL
ret
Dectravail1:
cpi TRAVAIL,16
brsh Dectravail2
subi TRAVAIL,2
ret
Dectravail2:
cpi TRAVAIL,32
brsh Dectravail3
subi TRAVAIL,4
ret
Dectravail3:
cpi TRAVAIL,64
brsh Dectravail4
subi TRAVAIL,8
ret
Dectravail4:
cpi TRAVAIL,128
brsh Dectravail5
subi TRAVAIL,16
ret
Dectravail5:
subi TRAVAIL,32
ret
