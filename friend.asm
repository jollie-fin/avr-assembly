
.include "1200def.inc"
.def    TRAVAIL2=r16
.def	FINE	=r16	;loop delay counters
.def	MEDIUM	=r17	;loop delay counters
.def 	COARSE	=r18	;loop delay counters
.def    BOUCLE  =r19	;boucle
.def	BOUCLE2 =r20	;boucle n°2
.def    TRAVAIL =r21	;variable de travail pour la génération du PWM
.def    BR      =r22	;luminosité du B(nibble haut) et R(nibble bas)
.def    ALLERRET=r22
.def    IC      =r23	;luminosité du I(nibble haut) et C(nibble bas)
.def    E       =r24	;luminosité du E(nibble haut)
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
.def    R10     =r31



ldi SORTIE,$FF
out DDRB,SORTIE
out DDRD,SORTIE
ldi R10,$10

Debut:
ldi BOUCLE,$00
ldi BOUCLE2,$00

Allumage1:
inc BOUCLE
add BOUCLE2,R10
mov BR,BOUCLE
mov IC,BOUCLE
mov E,BOUCLE
add BR,BOUCLE2
add IC,BOUCLE2
add E,BOUCLE2
rcall Pwm
cpi BOUCLE,15
brne Allumage1

ldi DELAI2,10
ldi SORTIE,$FF
out PORTB,SORTIE
out PORTD,SORTIE
rcall Delay2

ldi BOUCLE,3
rcall Clignotement

rcall Delay2

ldi DELAI1,1
ldi SORTIE,$00
out PORTD,SORTIE
out PORTB,SORTIE
ldi DELAI2,10

ldi BOUCLE,3
Chenillard2:
dec BOUCLE
rcall Chenillard
cpi BOUCLE,0
brne Chenillard2

Chenillardperm:
sbic PORTD,0
rjmp FinChenillardperm
sbi PORTD,0
rcall Delay1
sbic PORTD,1
rjmp Chenillardperm
cbi PORTD,0
sbi PORTD,1
rcall Delay1
sbic PORTD,2
rjmp Chenillardperm
cbi PORTD,1
sbi PORTD,2
rcall Delay1
sbic PORTD,3
rjmp Chenillardperm
cbi PORTD,2
sbi PORTD,3
rcall Delay1
sbic PORTD,4
rjmp Chenillardperm
cbi PORTD,3
sbi PORTD,4
rcall Delay1
sbic PORTD,5
rjmp Chenillardperm
cbi PORTD,4
sbi PORTD,5
rcall Delay1
sbic PORTD,6
rjmp Chenillardperm
cbi PORTD,5
sbi PORTD,6
rcall Delay1
sbic PORTB,7
rjmp Chenillardperm
cbi PORTD,6
sbi PORTB,7
rcall Delay1
sbic PORTB,0
rjmp Chenillardperm
cbi PORTB,7
sbi PORTB,0
rcall Delay1
sbic PORTB,1
rjmp Chenillardperm
cbi PORTB,0
sbi PORTB,1
rcall Delay1
sbic PORTB,2
rjmp Chenillardperm
cbi PORTB,1
sbi PORTB,2
rcall Delay1
sbic PORTB,3
rjmp Chenillardperm
cbi PORTB,2
sbi PORTB,3
rcall Delay1
sbic PORTB,4
rjmp Chenillardperm
cbi PORTB,3
sbi PORTB,4
rcall Delay1
sbic PORTB,5
rjmp Chenillardperm
cbi PORTB,4
sbi PORTB,5
rcall Delay1
sbic PORTB,6
rjmp Chenillardperm
cbi PORTB,5
sbi PORTB,6
rcall Delay1
rjmp Chenillardperm

FinChenillardperm:

rcall Delay2

ldi BOUCLE,3

rcall Clignotement
rcall Delay2

ldi SORTIE,$00
out PORTB,SORTIE
out PORTD,SORTIE

DebAllumageEteignage2:
ldi BOUCLE3,2
ldi BOUCLE,$0F
ldi BOUCLE2,$00
ldi SORTIE,$38
out PORTD,SORTIE
ldi SORTIE,$E
out PORTB,SORTIE
ldi DELAI1,20
rcall Delay1

Allumage2:
dec BOUCLE
add BOUCLE2,R10
mov BR,BOUCLE
mov IC,BOUCLE
mov E,BOUCLE
add BR,BOUCLE2
add IC,BOUCLE2
add E,BOUCLE2
rcall Pwm
cpi BOUCLE,0
brne Allumage2

Eteignage2:
inc BOUCLE
sub BOUCLE2,R10
mov BR,BOUCLE
mov IC,BOUCLE
mov E,BOUCLE
add BR,BOUCLE2
add IC,BOUCLE2
add E,BOUCLE2
rcall Pwm
cpi BOUCLE,15
brne Eteignage2

dec BOUCLE3
cpi BOUCLE3,0
brne Allumage2

ldi SORTIE,$38
out PORTD,SORTIE
ldi SORTIE,$E
out PORTB,SORTIE
rcall Delay1

Eteignagedeb3:
ldi BOUCLE,$0F
ldi BOUCLE2,$00

Eteignage3:
dec BOUCLE
mov BR,BOUCLE
mov IC,BOUCLE
mov E,BOUCLE
add BR,BOUCLE2
add IC,BOUCLE2
add E,BOUCLE2
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
sbi PORTD,0
rcall Delay1
sbic PORTD,1
rjmp FinChenillardRebondissantAller
cbi PORTD,0
sbi PORTD,1
rcall Delay1
sbic PORTD,2
rjmp ChenRebA13
cbi PORTD,1
sbi PORTD,2
rcall Delay1
sbic PORTD,3
rjmp ChenRebA12
cbi PORTD,2
sbi PORTD,3
rcall Delay1
sbic PORTD,4
rjmp ChenRebA11
cbi PORTD,3
sbi PORTD,4
rcall Delay1
sbic PORTD,5
rjmp ChenRebA10
cbi PORTD,4
sbi PORTD,5
rcall Delay1
sbic PORTD,6
rjmp ChenRebA9
cbi PORTD,5
sbi PORTD,6
rcall Delay1
sbic PORTB,7
rjmp ChenRebA8
cbi PORTD,6
sbi PORTB,7
rcall Delay1
sbic PORTB,0
rjmp ChenRebA7
cbi PORTB,7
sbi PORTB,0
rcall Delay1
sbic PORTB,1
rjmp ChenRebA6
cbi PORTB,0
sbi PORTB,1
rcall Delay1
sbic PORTB,2
rjmp ChenRebA5
cbi PORTB,1
sbi PORTB,2
rcall Delay1
sbic PORTB,3
rjmp ChenRebA4
cbi PORTB,2
sbi PORTB,3
rcall Delay1
sbic PORTB,4
rjmp ChenRebA3
cbi PORTB,3
sbi PORTB,4
rcall Delay1
sbic PORTB,5
rjmp ChenRebA2
cbi PORTB,4
sbi PORTB,5
rcall Delay1
sbic PORTB,6
rjmp ChenRebA1
cbi PORTB,5
sbi PORTB,6
rcall Delay1
rjmp ChenRebA0
FinChenillardRebondissantAller:

ldi DELAI2,20
rcall Delay2

ldi ALLERRET,1
ChenillardRebondissantRetour:
sbi PORTD,0
rcall Delay1
sbic PORTD,1
rjmp ChenRebR14
cbi PORTD,0
sbi PORTD,1
rcall Delay1
sbic PORTD,2
rjmp ChenRebR13
cbi PORTD,1
sbi PORTD,2
rcall Delay1
sbic PORTD,3
rjmp ChenRebR12
cbi PORTD,2
sbi PORTD,3
rcall Delay1
sbic PORTD,4
rjmp ChenRebR11
cbi PORTD,3
sbi PORTD,4
rcall Delay1
sbic PORTD,5
rjmp ChenRebR10
cbi PORTD,4
sbi PORTD,5
rcall Delay1
sbic PORTD,6
rjmp ChenRebR9
cbi PORTD,5
sbi PORTD,6
rcall Delay1
sbic PORTB,7
rjmp ChenRebR8
cbi PORTD,6
sbi PORTB,7
rcall Delay1
sbic PORTB,0
rjmp ChenRebR7
cbi PORTB,7
sbi PORTB,0
rcall Delay1
sbic PORTB,1
rjmp ChenRebR6
cbi PORTB,0
sbi PORTB,1
rcall Delay1
sbic PORTB,2
rjmp ChenRebR5
cbi PORTB,1
sbi PORTB,2
rcall Delay1
sbic PORTB,3
rjmp ChenRebR4
cbi PORTB,2
sbi PORTB,3
rcall Delay1
sbic PORTB,4
rjmp ChenRebR3
cbi PORTB,3
sbi PORTB,4
rcall Delay1
sbic PORTB,5
rjmp ChenRebR2
cbi PORTB,4
sbi PORTB,5
rcall Delay1
sbic PORTB,6
rjmp ChenRebR1

FinChenillardRebondissantRetour:
ldi DELAI2,15
ldi BOUCLE,2
rcall Clignotement
ldi SORTIE,$00
out PORTB,SORTIE
rcall Chenillard
rcall Chenillard

ldi BOUCLE,3
rcall Clignotement
ldi SORTIE,$00
out PORTB,SORTIE
out PORTD,SORTIE
rcall Delay2

rjmp Debut

Pwm:
     ldi PWMBOUC,20

Pwminit:
     ldi SORTIE,0
     ldi PWMHAUT,$F0
     ldi PWMBAS,$0F
     out PORTB,SORTIE
     out PORTD,SORTIE

Compb   : mov TRAVAIL,BR
	  andi TRAVAIL,$F0
	  cp TRAVAIL,PWMHAUT
	  breq Setb
	  nop
	  rjmp Compr
Setb    : sbi PORTD,0
	  sbi PORTD,1
	  sbi PORTD,2

Compr   : mov TRAVAIL,BR
	  andi TRAVAIL,$0F
	  cp TRAVAIL,PWMBAS
	  breq Setr
	  nop
	  rjmp Compi
Setr    : sbi PORTD,3
	  sbi PORTD,4
	  sbi PORTD,5

Compi   : mov TRAVAIL,IC
	  andi TRAVAIL,$F0
	  cp TRAVAIL,PWMHAUT
	  breq Seti
	  nop
	  rjmp Compc
Seti    : sbi PORTD,6
	  sbi PORTB,7
	  sbi PORTB,0

Compc   : mov TRAVAIL,IC
	  andi TRAVAIL,$0F
	  cp TRAVAIL,PWMBAS
	  breq Setc
	  nop
	  rjmp Compe
Setc    : sbi PORTB,1
	  sbi PORTB,2
	  sbi PORTB,3

Compe   : mov TRAVAIL,E
	  andi TRAVAIL,$F0
	  cp TRAVAIL,PWMHAUT
	  breq Sete
	  nop
	  rjmp Delaipwm
Sete    : sbi PORTB,4
	  sbi PORTB,5
	  sbi PORTB,6

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
	    brne Compb
	
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

ldi SORTIE,$01

ldi CHENBOUC,7
ChenillardD:
dec CHENBOUC
out PORTD,SORTIE
rcall Delay1
lsl SORTIE
cpi CHENBOUC,0
brne ChenillardD

ldi SORTIE,$00
out PORTD,SORTIE
ldi SORTIE,$01

ldi CHENBOUC,8
ChenillardB:
dec CHENBOUC
mov TRAVAIL,SORTIE
lsr TRAVAIL
sbrc SORTIE,0
ori TRAVAIL,$80
out PORTB,TRAVAIL
rcall Delay1
lsl SORTIE
cpi CHENBOUC,0
brne ChenillardB

ldi SORTIE,$00
out PORTB,SORTIE

ret

Clignotement:
dec BOUCLE
ldi SORTIE,$00
out PORTB,SORTIE
out PORTD,SORTIE
rcall Delay2
ldi SORTIE,$FF
out PORTB,SORTIE
out PORTD,SORTIE
rcall Delay2
cpi BOUCLE,0
brne Clignotement
ret


ChenRebR1:
cbi PORTB,6
ChenRebA0:
sbi PORTB,5
rcall Delay1
ChenRebR2:
cbi PORTB,5
ChenRebA1:
sbi PORTB,4
rcall Delay1
ChenRebR3:
cbi PORTB,4
ChenRebA2:
sbi PORTB,3
rcall Delay1
ChenRebR4:
cbi PORTB,3
ChenRebA3:
sbi PORTB,2
rcall Delay1
ChenRebR5:
cbi PORTB,2
ChenRebA4:
sbi PORTB,1
rcall Delay1
ChenRebR6:
cbi PORTB,1
ChenRebA5:
sbi PORTB,0
rcall Delay1
ChenRebR7:
cbi PORTB,0
ChenRebA6:
sbi PORTB,7
rcall Delay1
ChenRebR8:
cbi PORTB,7
ChenRebA7:
sbi PORTD,6
rcall Delay1
ChenRebR9:
cbi PORTD,6
ChenRebA8:
sbi PORTD,5
rcall Delay1
ChenRebR10:
cbi PORTD,5
ChenRebA9:
sbi PORTD,4
rcall Delay1
ChenRebR11:
cbi PORTD,4
ChenRebA10:
sbi PORTD,3
rcall Delay1
ChenRebR12:
cbi PORTD,3
ChenRebA11:
sbi PORTD,2
rcall Delay1
ChenRebR13:
cbi PORTD,2
ChenRebA12:
sbi PORTD,1
rcall Delay1
ChenRebR14:
cbi PORTD,1
ChenRebA13:
sbi PORTD,0
rcall Delay1
cbi PORTD,0
rcall Delay1
cpi ALLERRET,0
brne RetourChenRebRetour
rjmp ChenillardRebondissantAller
RetourChenRebRetour:
rjmp ChenillardRebondissantRetour
