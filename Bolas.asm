.include "1200def.inc"

.def ROUGE1 =r16
.def ROUGE2 =r17
.def VERT1  =r18
.def VERT2  =r19
.def BLEU1  =r20
.def BLEU2  =r21
.def SORTIE =r22
.def TRAVAIL=r23
.def TEMPO  =r24
.def ETAPELG  =r25
.def ETAPELT  =r28
.def MLI    =r26
.def MODE   =r27

.equ BR1 = 0
.equ BB1 = 7
.equ BV1 = 6
.equ BR2 = 5
.equ BB2 = 6
.equ BV2 = 0

.equ RR1 = PORTD
.equ RB1 = PORTB
.equ RV1 = PORTB
.equ RR2 = PORTD
.equ RB2 = PORTD
.equ RV2 = PORTB

rjmp Raz
rjmp Inter
rjmp Cmp

Raz:
ldi MODE,0
ldi ETAPELG,0
ldi ETAPELT,0

ldi ROUGE1,1
ldi ROUGE2,0
ldi BLEU1,2
ldi BLEU2,3
ldi VERT1,3
ldi VERT2,1




ldi SORTIE,(1<<BR1)+(1<<BR2)+(1<<BB2)
out DDRD,SORTIE
ldi SORTIE,(1<<BB1)+(1<<BV1)+(1<<BV2)
out DDRB,SORTIE
ldi TEMPO,26
cli
ldi SORTIE,(1<<TOIE0)
out TIMSK,SORTIE
ldi SORTIE,(0<<CS02)+(0<<CS01)+(1<<CS00)
out TCCR0,SORTIE
sei

Mliinit:
ldi Mli,0
sbi RR1,BR1
sbi RV1,BV1
sbi RB1,BB1
sbi RR2,BR2
sbi RV2,BV2
sbi RB2,BB2

MliBoucle:
 
 cp ROUGE1,MLI
 brne MliRouge1
 cbi RR1,BR1
 MliRouge1:
 cp BLEU1,MLI
 brne MliBleu1
 cbi RB1,BB1
 MliBleu1:
 cp VERT1,MLI
 brne MliVert1
 cbi RV1,BV1
 MliVert1:
 cp ROUGE2,MLI
 brne MliRouge2
 cbi RR2,BR2
 MliRouge2:
 cp BLEU2,MLI
 brne MliBleu2
 cbi RB2,BB2
 MliBleu2:
 cp VERT2,MLI
 brne MliVert2
 cbi RV2,BV2
 MliVert2:
 inc MLI
 cpi MLI,3
 brne MliBoucle
 rjmp MliInit

Inter:
nop
Cmp:
cli
In SORTIE,SREG
dec TEMPO
cpi TEMPO,0
breq ChgtEtape
out SREG,SORTIE
sei
reti

ChgtEtape:
nop
