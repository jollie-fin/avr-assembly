.include "m8535def.inc"
.def TRAVAILL = r0
.def TRAVAILH = r1
.def SORTIE = r16
.def TRAVAIL = r16
.def COARSE = r17
.def MEDIUM = r18
.def FINE = r19
.def PHASE = r20
.def ROUGEBAS = r24
.def ROUGEHAUT = r25
.def VERTBAS = r26
.def VERTHAUT = r27
.def VERT = r28
.def ROUGE = r29
.def ZL = r30
.def ZH = r31

rjmp Raz
nop
nop
rjmp Tim2Comp
rjmp Tim2OverFlow
nop
nop
nop
rjmp Tim1OverFlow
rjmp Tim0OverFlow
nop
nop
nop
nop
nop
nop
nop
nop
nop
rjmp Tim0Comp

Raz:
ldi SORTIE,high(RAMEND)
out SPH,SORTIE
ldi SORTIE,low(RAMEND)
out SPL,SORTIE
ldi SORTIE,$FF
out DDRD,SORTIE

ldi ROUGE,57
mov TRAVAIL,ROUGE
rcall DecodTravail
mov ROUGEBAS,TRAVAILL
mov ROUGEHAUT,TRAVAILH

ldi VERT,00
mov TRAVAIL,VERT
rcall DecodTravail
mov VERTBAS,TRAVAILL
mov VERTHAUT,TRAVAILH

out OCR1AH,ROUGEHAUT
out OCR1AL,ROUGEBAS
out OCR1BH,VERTHAUT
out OCR1BL,VERTBAS

ldi SORTIE,00
out TCNT1H,SORTIE
out TCNT1L,SORTIE
ldi SORTIE,$FF
out ICR1H,SORTIE
out ICR1L,SORTIE
ldi SORTIE,(1<<TOIE1)
out TIMSK,SORTIE
ldi SORTIE,(1<<COM1A1)+(1<<COM1B1)+(1<<WGM11)
out TCCR1A,SORTIE
ldi SORTIE,(1<<CS10)+(1<<WGM13)+(1<<WGM12)
out TCCR1B,SORTIE
ldi PHASE,0
sei

Debut:
ldi COARSE,40
Cagain:
ldi MEDIUM,255
Magain:
ldi FINE,255
Fagain:
dec FINE
brne Fagain
dec MEDIUM
brne Magain
dec COARSE
brne Cagain



cpi PHASE,0
brne Phase1

dec ROUGE
inc VERT

mov TRAVAIL,ROUGE
rcall DecodTravail
mov ROUGEBAS,TRAVAILL
mov ROUGEHAUT,TRAVAILH
mov TRAVAIL,VERT
rcall DecodTravail
mov VERTBAS,TRAVAILL
mov VERTHAUT,TRAVAILH
out OCR1AH,ROUGEHAUT
out OCR1AL,ROUGEBAS
out OCR1BH,VERTHAUT
out OCR1BL,VERTBAS

cpi ROUGE,0
brne Debut
ldi PHASE,1
rjmp Debut

Phase1:

inc ROUGE
dec VERT

mov TRAVAIL,ROUGE
rcall DecodTravail
mov ROUGEBAS,TRAVAILL
mov ROUGEHAUT,TRAVAILH
mov TRAVAIL,VERT
rcall DecodTravail
mov VERTBAS,TRAVAILL
mov VERTHAUT,TRAVAILH
out OCR1AH,ROUGEHAUT
out OCR1AL,ROUGEBAS
out OCR1BH,VERTHAUT
out OCR1BL,VERTBAS

cpi ROUGE,57
brne Debut
ldi PHASE,0
rjmp Debut

rjmp Debut






Tim2Comp:
Tim2OverFlow:
Tim0OverFlow:
Tim0Comp:
Tim1OverFlow:
rjmp Debut

DecodTravail:
ldi ZL,low(Exp<<1)
ldi ZH,high(Exp<<1)
lsl TRAVAIL
add ZL,TRAVAIL
ldi TRAVAIL,0
adc ZH,TRAVAIL
lpm TRAVAILL,Z+
lpm TRAVAILH,Z
ret

Exp:
.dw 3
.dw 4
.dw 5
.dw 6
.dw 7
.dw 8
.dw 10
.dw 11
.dw 13
.dw 16
.dw 19
.dw 23
.dw 27
.dw 32
.dw 38
.dw 45
.dw 54
.dw 64
.dw 76
.dw 91
.dw 108
.dw 128
.dw 152
.dw 181
.dw 215
.dw 256
.dw 304
.dw 362
.dw 431
.dw 512
.dw 609
.dw 724
.dw 861
.dw 1024
.dw 1218
.dw 1448
.dw 1722
.dw 2048
.dw 2435
.dw 2896
.dw 3444
.dw 4096
.dw 4871
.dw 5793
.dw 6889
.dw 8192
.dw 9742
.dw 11585
.dw 13777
.dw 16384
.dw 19484
.dw 23170
.dw 27554
.dw 32768
.dw 38968
.dw 46341
.dw 55109
.dw 65535
