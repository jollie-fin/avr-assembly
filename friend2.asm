
.include "C:\Program Files\Atmel\AVR Tools\AvrAssembler2\Appnotes\1200def.inc"
.def    TRAVAIL2=r16
.def	FINE	=r16	;loop delay counters
.def	MEDIUM	=r17	;loop delay counters
.def 	COARSE	=r18	;loop delay counters
.def    BOUCLE  =r19	;boucle
.def	BOUCLE2 =r20	;boucle n°2
.def    TRAVAIL =r21	;variable de travail pour la génération du PWM
.def    NO      =r22	;luminosité du N(nibble bas) et O(nibble haut)
.def    ALLERRET=r22
.def    RA      =r23	;luminosité du R(nibble haut) et A(nibble bas)

.def    PWMHAUT =r25	;compteur haut pour le PWM
.def    CHENILLB=r25
.def    CHENILLD=r26
.def    PWMBAS  =r26	;compteur bas pour le PWM
.def    PWMBOUC =r27	;boucle du PWM
.def    CHENBOUC=r27
.def	DELAI1  =r28   ;variable indiquant le délai dans la sub Delay
.def	DELAI2  =r29
.def    BOUCLE3 =r29     
.def	SORTIE  =r30
.def    reg10     =r31



ldi SORTIE,$FF
out DDRB,SORTIE
out DDRD,SORTIE
ldi reg10,$10

Debut:
ldi BOUCLE,$00
ldi BOUCLE2,$00

Allumage1:
inc BOUCLE
add BOUCLE2,reg10
mov NO,BOUCLE
mov RA,BOUCLE
add NO,BOUCLE2
add RA,BOUCLE2
rcall Pwm
cpi BOUCLE,15
brne Allumage1

ldi DELAI2,10
ldi SORTIE,$00
out PORTB,SORTIE
out PORTD,SORTIE
rcall Delay2

ldi BOUCLE,3
rcall Clignotement

rcall Delay2

ldi DELAI1,1
ldi SORTIE,$FF
out PORTD,SORTIE
out PORTB,SORTIE
ldi DELAI2,10

ldi BOUCLE,3
Chenillard2:
rcall Chenillard
dec BOUCLE
brne Chenillard2

Chenillardperm:
sbis PORTD,0
rjmp FinChenillardperm
cbi PORTD,0
rcall Delay1
sbis PORTD,1
rjmp Chenillardperm
sbi PORTD,0
cbi PORTD,1
rcall Delay1
sbis PORTD,2
rjmp Chenillardperm
sbi PORTD,1
cbi PORTD,2
rcall Delay1
sbis PORTD,3
rjmp Chenillardperm
sbi PORTD,2
cbi PORTD,3
rcall Delay1
sbis PORTD,4
rjmp Chenillardperm
sbi PORTD,3
cbi PORTD,4
rcall Delay1
sbis PORTD,5
rjmp Chenillardperm
sbi PORTD,4
cbi PORTD,5
rcall Delay1
sbis PORTB,7
rjmp Chenillardperm
sbi PORTD,5
cbi PORTB,7
rcall Delay1
sbis PORTB,6
rjmp Chenillardperm
sbi PORTB,7
cbi PORTB,6
rcall Delay1
sbis PORTB,5
rjmp Chenillardperm
sbi PORTB,6
cbi PORTB,5
rcall Delay1
sbis PORTB,4
rjmp Chenillardperm
sbi PORTB,5
cbi PORTB,4
rcall Delay1
sbis PORTB,3
rjmp Chenillardperm
sbi PORTB,4
cbi PORTB,3
rcall Delay1
sbis PORTB,2
rjmp Chenillardperm
sbi PORTB,3
cbi PORTB,2
rcall Delay1
rjmp Chenillardperm

FinChenillardperm:

rcall Delay2

ldi BOUCLE,3

rcall Clignotement
rcall Delay2

ldi SORTIE,$FF
out PORTB,SORTIE
out PORTD,SORTIE

DebAllumageEteignage2:
ldi BOUCLE3,2
ldi BOUCLE,$0F
ldi BOUCLE2,$00
ldi SORTIE,$07
out PORTD,SORTIE
ldi SORTIE,$E0
out PORTB,SORTIE
ldi DELAI1,20
rcall Delay1

Allumage2:
dec BOUCLE
add BOUCLE2,reg10
mov NO,BOUCLE
mov RA,BOUCLE
add NO,BOUCLE2
add RA,BOUCLE2
rcall Pwm
cpi BOUCLE,0
brne Allumage2

Eteignage2:
inc BOUCLE
sub BOUCLE2,reg10
mov NO,BOUCLE
mov RA,BOUCLE
add NO,BOUCLE2
add RA,BOUCLE2
rcall Pwm
cpi BOUCLE,15
brne Eteignage2

dec BOUCLE3
cpi BOUCLE3,0
brne Allumage2

ldi SORTIE,$07
out PORTD,SORTIE
ldi SORTIE,$E0
out PORTB,SORTIE
rcall Delay1

Eteignagedeb3:
ldi BOUCLE,$0F
ldi BOUCLE2,$00

Eteignage3:
dec BOUCLE
mov NO,BOUCLE
mov RA,BOUCLE
add NO,BOUCLE2
add RA,BOUCLE2
rcall Pwm
cpi BOUCLE,0
brne Eteignage3

ldi DELAI1,20
rcall Delay1

ldi DELAI1,1
rcall Chenillard
rcall Chenillard

ldi ALLERRET,0
ChenillardRebondissantAller:
cbi PORTD,0
rcall Delay1
sbis PORTD,1
rjmp FinChenillardRebondissantAller
sbi PORTD,0
cbi PORTD,1
rcall Delay1
sbis PORTD,2
rjmp ChenRebA10
sbi PORTD,1
cbi PORTD,2
rcall Delay1
sbis PORTD,3
rjmp ChenRebA9
sbi PORTD,2
cbi PORTD,3
rcall Delay1
sbis PORTD,4
rjmp ChenRebA8
sbi PORTD,3
cbi PORTD,4
rcall Delay1
sbis PORTD,5
rjmp ChenRebA7
sbi PORTD,4
cbi PORTD,5
rcall Delay1
sbis PORTB,7
rjmp ChenRebA6
sbi PORTD,5
cbi PORTB,7
rcall Delay1
sbis PORTB,6
rjmp ChenRebA5
sbi PORTB,7
cbi PORTB,6
rcall Delay1
sbis PORTB,5
rjmp ChenRebA4
sbi PORTB,6
cbi PORTB,5
rcall Delay1
sbis PORTB,4
rjmp ChenRebA3
sbi PORTB,5
cbi PORTB,4
rcall Delay1
sbis PORTB,3
rjmp ChenRebA2
sbi PORTB,4
cbi PORTB,3
rcall Delay1
sbis PORTB,2
rjmp ChenRebA1
sbi PORTB,3
cbi PORTB,2
rcall Delay1
rjmp ChenRebA0
FinChenillardRebondissantAller:

ldi DELAI2,20
rcall Delay2

ldi ALLERRET,1
ChenillardRebondissantRetour:
cbi PORTD,0
rcall Delay1
sbis PORTD,1
rjmp ChenRebR11
sbi PORTD,0
cbi PORTD,1
rcall Delay1
sbis PORTD,2
rjmp ChenRebR10
sbi PORTD,1
cbi PORTD,2
rcall Delay1
sbis PORTD,3
rjmp ChenRebR9
sbi PORTD,2
cbi PORTD,3
rcall Delay1
sbis PORTD,4
rjmp ChenRebR8
sbi PORTD,3
cbi PORTD,4
rcall Delay1
sbis PORTD,5
rjmp ChenRebR7
sbi PORTD,4
cbi PORTD,5
rcall Delay1
sbis PORTB,7
rjmp ChenRebR6
sbi PORTD,5
cbi PORTB,7
rcall Delay1
sbis PORTB,6
rjmp ChenRebR5
sbi PORTB,7
cbi PORTB,6
rcall Delay1
sbis PORTB,5
rjmp ChenRebR4
sbi PORTB,6
cbi PORTB,5
rcall Delay1
sbis PORTB,4
rjmp ChenRebR3
sbi PORTB,5
cbi PORTB,4
rcall Delay1
sbis PORTB,3
rjmp ChenRebR2
sbi PORTB,4
cbi PORTB,3
rcall Delay1
sbis PORTB,2
rjmp ChenRebR1

FinChenillardRebondissantRetour:
ldi DELAI2,15
ldi BOUCLE,2
rcall Clignotement
ldi SORTIE,$FF
out PORTB,SORTIE
rcall Chenillard
rcall Chenillard

ldi SORTIE,(1<<SE)+(1<<SM)
out MCUCR,SORTIE
sleep
rjmp Debut

Pwm:
     ldi PWMBOUC,20

Pwminit:
     ldi SORTIE,$FF
     ldi PWMHAUT,$F0
     ldi PWMBAS,$0F
     out PORTB,SORTIE
     out PORTD,SORTIE

Compn   :
	  mov TRAVAIL,NO
	  andi TRAVAIL,$F0
	  cp TRAVAIL,PWMHAUT
	  breq Setn
	  nop
	  rjmp Compo
Setn    :
	  cbi PORTD,0
	  cbi PORTD,1
	  cbi PORTD,2

Compo   :
	  mov TRAVAIL,NO
	  andi TRAVAIL,$0F
	  cp TRAVAIL,PWMBAS
	  breq Seto
	  nop
	  rjmp Compr
Seto    :
	  cbi PORTD,3
	  cbi PORTD,4
	  cbi PORTD,5

Compr   :
	  mov TRAVAIL,RA
	  andi TRAVAIL,$F0
	  cp TRAVAIL,PWMHAUT
	  breq Setr
	  nop
	  rjmp Compa
Setr    :
	  cbi PORTB,7
	  cbi PORTB,6
	  cbi PORTB,5

Compa   :
	  mov TRAVAIL,RA
	  andi TRAVAIL,$0F
	  cp TRAVAIL,PWMBAS
	  breq Seta
	  nop
	  rjmp DelaiPwm
Seta    :
	  cbi PORTB,4
	  cbi PORTB,3
	  cbi PORTB,2


Delaipwm:
     ldi MEDIUM,1
DelaipwmM:
	  ldi FINE,156
DelaipwmF:
	   dec FINE
           cpi FINE,0
	   brne DelaipwmF
	  dec MEDIUM
          cpi MEDIUM,0
          brne DelaipwmM

Finboucle : 
	    subi PWMHAUT,$10
	    subi PWMBAS,$01
	    cpi PWMBAS,0
	    brne Compn
	
            dec PWMBOUC
	    cpi PWMBOUC,0
	    brne VaPwmInit
ret

VaPwmInit: rjmp Pwminit	


Delay1:
	mov COARSE,DELAI1	;Délai provoqué = 1/10 * DELAI1 à 1MHZ
Cagain1:
         ldi MEDIUM,100		;
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

Delay2:
	mov COARSE,DELAI2	;Délai provoqué = 1/10 * DELAI2 à 1MHZ
Cagain2:
         ldi MEDIUM,100		;
Magain2:
	  ldi FINE,249		; 500
Fagain2:
	   dec FINE
           cpi FINE,0
	   brne Fagain2
	  dec MEDIUM
          cpi MEDIUM,0
          brne Magain2
	 dec COARSE
         cpi COARSE,0
	 brne Cagain2
	ret

Chenillard:

ldi SORTIE,$FE

ldi CHENBOUC,6
ChenillardD:
out PORTD,SORTIE
rcall Delay1
lsl SORTIE
ori SORTIE,$01
dec CHENBOUC
brne ChenillardD

ldi SORTIE,$FF
out PORTD,SORTIE

ldi SORTIE,$7F

ldi CHENBOUC,6
ChenillardB:
out PORTB,SORTIE
rcall Delay1
lsr SORTIE
ori SORTIE,$80
dec CHENBOUC
brne ChenillardB

ldi SORTIE,$FF
out PORTB,SORTIE

ret

Clignotement:
dec BOUCLE
ldi SORTIE,$FF
out PORTB,SORTIE
out PORTD,SORTIE
rcall Delay2
ldi SORTIE,$00
out PORTB,SORTIE
out PORTD,SORTIE
rcall Delay2
cpi BOUCLE,0
brne Clignotement
ret


ChenRebR1:
sbi PORTB,2
ChenRebA0:
cbi PORTB,3
rcall Delay1
ChenRebR2:
sbi PORTB,3
ChenRebA1:
cbi PORTB,4
rcall Delay1
ChenRebR3:
sbi PORTB,4
ChenRebA2:
cbi PORTB,5
rcall Delay1
ChenRebR4:
sbi PORTB,5
ChenRebA3:
cbi PORTB,6
rcall Delay1
ChenRebR5:
sbi PORTB,6
ChenRebA4:
cbi PORTB,7
rcall Delay1
ChenRebR6:
sbi PORTB,7
ChenRebA5:
cbi PORTD,5
rcall Delay1
ChenRebR7:
sbi PORTD,5
ChenRebA6:
cbi PORTD,4
rcall Delay1
ChenRebR8:
sbi PORTD,4
ChenRebA7:
cbi PORTD,3
rcall Delay1
ChenRebR9:
sbi PORTD,3
ChenRebA8:
cbi PORTD,2
rcall Delay1
ChenRebR10:
sbi PORTD,2
ChenRebA9:
cbi PORTD,1
rcall Delay1
ChenRebR11:
sbi PORTD,1
ChenRebA10:
cbi PORTD,0
rcall Delay1
sbi PORTD,0
rcall Delay1
cpi ALLERRET,0
brne RetourChenRebRetour
rjmp ChenillardRebondissantAller
RetourChenRebRetour:
rjmp ChenillardRebondissantRetour
