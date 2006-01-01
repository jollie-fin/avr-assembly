.include "m8535def.inc"
.def SORTIE = r16

ldi SORTIE,$FF
out DDRD,SORTIE

Raz:
sbi PORTD,0
nop
nop
cbi PORTD,0
rjmp Raz
