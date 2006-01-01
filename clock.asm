.include "m8535def.inc"

.def SORTIE = r17
.def COARSE = r18
.def MEDIUM = r19
.def FINE   = r20
.def DELAI  = r21

.equ BOBINE1 = 0
.equ BOBINE2 = 1
.equ BOBINE3 = 2
.equ BOBINE4 = 3
.equ MOTEUR1 = 4
.equ MOTEUR2 = 5
.equ MOTEUR3 = 6
.equ MOTEUR4 = 7

ldi SORTIE,$FF
out DDRB,SORTIE
ldi DELAI,20 ; 1/2sec
ldi SORTIE,$70
out SPL,SORTIE
ldi SORTIE,$00
out SPH,SORTIE


Debut:
ldi SORTIE,(1<<BOBINE1)+(0<<BOBINE2)+(0<<BOBINE3)+(0<<BOBINE4)+(1<<MOTEUR1)+(0<<MOTEUR2)+(0<<MOTEUR3)+(0<<MOTEUR4)
out PORTB,SORTIE
rcall Delay

ldi SORTIE,(1<<BOBINE1)+(1<<BOBINE2)+(0<<BOBINE3)+(0<<BOBINE4)+(1<<MOTEUR1)+(0<<MOTEUR2)+(0<<MOTEUR3)+(0<<MOTEUR4)
out PORTB,SORTIE
rcall Delay

ldi SORTIE,(0<<BOBINE1)+(1<<BOBINE2)+(0<<BOBINE3)+(0<<BOBINE4)+(1<<MOTEUR1)+(0<<MOTEUR2)+(0<<MOTEUR3)+(0<<MOTEUR4)
out PORTB,SORTIE
rcall Delay

;rjmp Suite

ldi SORTIE,(1<<BOBINE1)+(1<<BOBINE2)+(0<<BOBINE3)+(0<<BOBINE4)+(1<<MOTEUR1)+(0<<MOTEUR2)+(0<<MOTEUR3)+(0<<MOTEUR4)
out PORTB,SORTIE
rcall Delay

rjmp Debut

Suite:

ldi SORTIE,(0<<BOBINE1)+(1<<BOBINE2)+(1<<BOBINE3)+(0<<BOBINE4)+(1<<MOTEUR1)+(0<<MOTEUR2)+(0<<MOTEUR3)+(0<<MOTEUR4)
out PORTB,SORTIE
rcall Delay

ldi SORTIE,(0<<BOBINE1)+(0<<BOBINE2)+(1<<BOBINE3)+(0<<BOBINE4)+(1<<MOTEUR1)+(0<<MOTEUR2)+(0<<MOTEUR3)+(0<<MOTEUR4)
out PORTB,SORTIE
rcall Delay

ldi SORTIE,(0<<BOBINE1)+(0<<BOBINE2)+(1<<BOBINE3)+(1<<BOBINE4)+(1<<MOTEUR1)+(0<<MOTEUR2)+(0<<MOTEUR3)+(0<<MOTEUR4)
out PORTB,SORTIE
rcall Delay

ldi SORTIE,(0<<BOBINE1)+(0<<BOBINE2)+(0<<BOBINE3)+(1<<BOBINE4)+(1<<MOTEUR1)+(0<<MOTEUR2)+(0<<MOTEUR3)+(0<<MOTEUR4)
out PORTB,SORTIE
rcall Delay

ldi SORTIE,(1<<BOBINE1)+(0<<BOBINE2)+(0<<BOBINE3)+(1<<BOBINE4)+(1<<MOTEUR1)+(0<<MOTEUR2)+(0<<MOTEUR3)+(0<<MOTEUR4)
out PORTB,SORTIE
rcall Delay

rjmp Debut

Delay:
	mov COARSE,DELAI	;Délai provoqué = 1/40 * DELAI1 à 8MHZ
Cagain1:
         ldi MEDIUM,200		;
Magain1:
	  ldi FINE,249		; 500
Fagain1:
	   dec FINE
           cpi FINE,0
	   brne Fagain1
	  dec MEDIUM
          cpi MEDIUM,0
          brne Magain1
	 dec COARSE
         cpi COARSE,0
	 brne Cagain1
	ret
