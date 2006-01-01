.include "1200def.inc"

.def TRAVAIL = r20
.def COARSE  = r21
.def MEDIUM  = r22
.def FINE    = r23
.def NB_A_AFFICHER =r24
.def DELAI   = r25
.equ A = 6
.equ B = 7
.equ C = 3
.equ D = 2
.equ E = 1
.equ G = 4
.equ F = 5

Raz:

ldi TRAVAIL,$FF
out DDRB,TRAVAIL

Debut:

ldi NB_A_AFFICHER,10

Boucle:
dec NB_A_AFFICHER
rcall Aff_NB
rcall Delay
cpi NB_A_AFFICHER,0
brne Boucle

rjmp Debut





Aff_NB:

Aff_NB1:
cpi NB_A_AFFICHER,1
brne Aff_NB2
ldi TRAVAIL,(0<<A)+(1<<B)+(1<<C)+(0<<D)+(0<<E)+(0<<F)+(0<<G)
out PORTB,TRAVAIL

Aff_NB2:
cpi NB_A_AFFICHER,2
brne Aff_NB3
ldi TRAVAIL,(1<<A)+(1<<B)+(0<<C)+(1<<D)+(1<<E)+(0<<F)+(1<<G)
out PORTB,TRAVAIL

Aff_NB3:
cpi NB_A_AFFICHER,3
brne Aff_NB4
ldi TRAVAIL,(1<<A)+(1<<B)+(1<<C)+(1<<D)+(0<<E)+(0<<F)+(1<<G)
out PORTB,TRAVAIL

Aff_NB4:
cpi NB_A_AFFICHER,4
brne Aff_NB5
ldi TRAVAIL,(0<<A)+(1<<B)+(1<<C)+(0<<D)+(0<<E)+(1<<F)+(1<<G)
out PORTB,TRAVAIL

Aff_NB5:
cpi NB_A_AFFICHER,5
brne Aff_NB6
ldi TRAVAIL,(1<<A)+(0<<B)+(1<<C)+(1<<D)+(0<<E)+(1<<F)+(1<<G)
out PORTB,TRAVAIL

Aff_NB6:
cpi NB_A_AFFICHER,6
brne Aff_NB7
ldi TRAVAIL,(1<<A)+(0<<B)+(1<<C)+(1<<D)+(1<<E)+(1<<F)+(1<<G)
out PORTB,TRAVAIL

Aff_NB7:
cpi NB_A_AFFICHER,7
brne Aff_NB8
ldi TRAVAIL,(1<<A)+(1<<B)+(1<<C)+(0<<D)+(0<<E)+(0<<F)+(0<<G)
out PORTB,TRAVAIL

Aff_NB8:
cpi NB_A_AFFICHER,8
brne Aff_NB9
ldi TRAVAIL,(1<<A)+(1<<B)+(1<<C)+(1<<D)+(1<<E)+(1<<F)+(1<<G)
out PORTB,TRAVAIL

Aff_NB9:
cpi NB_A_AFFICHER,9
brne Aff_NB0
ldi TRAVAIL,(1<<A)+(1<<B)+(1<<C)+(1<<D)+(0<<E)+(1<<F)+(1<<G)
out PORTB,TRAVAIL

Aff_NB0:
cpi NB_A_AFFICHER,0
brne Aff_NB_FIN
ldi TRAVAIL,(1<<A)+(1<<B)+(1<<C)+(1<<D)+(1<<E)+(1<<F)+(0<<G)
out PORTB,TRAVAIL

Aff_NB_FIN:
ret

Delay:
mov COARSE,DELAI
Cagain:
ldi MEDIUM,133
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
