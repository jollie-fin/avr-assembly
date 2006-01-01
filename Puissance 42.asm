.include "m8535def.inc"
.def ADRLECONBAS = r0
.def ADRLECONHAUT = r1
.def TEMPOCLIGN = r7
.def TEMPOBOUTON2 = r12
.def TEMPOBOUTON  = r8
.def CLIGNOTEMENT = r2
.def COULEUR = r3 ; 1 = rouge et 2 = vert
.def NBCOUPS = r4
.def MEMBOUTONDESC = r5
.def EXISTENCEPION = r6
.def VALEURLECON = r9
.def LECONPAUSE = r10
.def BOUCLELECON = r11
.def TEMPOOFF = r13
.def MODESAUV = r14

.def LIGNEACT = r16
.def SORTIE   = r17
.def TRAVAIL2 = r18
.def COLONNEAFF= r19
.def SAUVREG  = r20
.def BOUCLE   = r21
.def COLONNEACT= r22
.def TRAVAIL  = r23
.def ADRB     = r24
.def ADRH     = r25
.def XL       = r26
.def XH       = r27
.def YL       = r28
.def YH       = r29
.def ZL       = r30
.def ZH       = r31
.def LIGNEMASCX4= r28
.def COLONNEMASCX4 = r29
.def NBPIONSALIGNES= r24
.def NBX4 = r25
.def MODE = r24

.equ BOFF = $04
.equ BHAUT = $03
.equ BBAS = $02
.equ BDROITE = $01
.equ BGAUCHE = $00




.equ DIODESROUGES1 = $0080
.equ DIODESVERTES1 = $0087
.equ DIODESROUGES2 = $008E
.equ DIODESVERTES2 = $0095
.equ DIODESROUGES1bis = $009C
.equ DIODESVERTES1bis = $00A3
.equ DIODESROUGES2bis = $00AA
.equ DIODESVERTES2bis = $00B1

rjmp Raz
nop
nop
nop
rjmp Compteur
nop
nop
nop
rjmp Compteur2
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
ldi TRAVAIL,0
out TCCR1A,TRAVAIL
ldi TRAVAIL,(1<<CS10)+(0<<CS11)+(0<<CS12)
out TCCR1B,TRAVAIL

ldi TRAVAIL,(1<<CS20)+(1<<CS21)+(0<<CS22);initialisation du compteur 2 en compteur permanent, à une fréquence de CkMCU div 32
out TCCR2,TRAVAIL ; 00000011 


ldi TRAVAIL,(0<<TOIE2)+(1<<TICIE1)+(1<<TOIE1)   ;Active l'interruption de débordement du compteur2 et du compteur1
out TIMSK,TRAVAIL 
ldi TRAVAIL,100
out OCR2,TRAVAIL    
rcall EffCompteur2
sei               ;Active le drapeau d'interruption

ldi TRAVAIL,0
mov CLIGNOTEMENT,TRAVAIL
ldi TRAVAIL,$FF
mov TEMPOCLIGN,TRAVAIL
ldi TRAVAIL,01
mov COULEUR,TRAVAIL


ldi SORTIE,(0<<PUD)    ;Autorise les résistance de pull-up
out SFIOR,SORTIE  ;

ldi SORTIE,$FF    ;Configure le portA en sortie (Anodes Rouges)
out DDRA,SORTIE

ldi SORTIE,$FF    ;Configure le portB en sortie (Anodes Vertes)
out DDRB,SORTIE

ldi SORTIE,$FF    ;Configure le portC en sortie (Cathodes)(colonnes)
out DDRC,SORTIE

ldi SORTIE,$C0    ;Configure le portD en entrée sauf pour son bit fort(PIND7)
out DDRD,SORTIE

ldi SORTIE,high($007F)
out SPH,SORTIE
ldi SORTIE,low($007F)    ;Positionne le pointeur de pile à 96 + 32 (8 instructions rcall max + 16 registres "pushés")
out SPL,SORTIE

ldi SORTIE,$00   ;Initialise les port A, B, C à 0 (port connectés à la matrice de Dels
out PORTA,SORTIE
out PORTB,SORTIE
out PORTC,SORTIE

ldi SORTIE,$FF
out PORTD,SORTIE ; Activation des résistances de pull-up

ldi COLONNEACT,0 ; Initialise la variable indiquant la colonne actuellemnt choisie par l'utilisateur à 6

ldi TRAVAIL,0
mov NBCOUPS,TRAVAIL
rcall RazReg     ; Initialise à 0 les registres de R0 à R13 (Registre concernant l'image à affichée
rcall RazRegBis
;rcall DetectionPion

;ldi ADRH,$00
;ldi ADRB,$00
;ldi COLONNE,0
ldi TRAVAIL,$FF
mov TEMPOBOUTON,TRAVAIL
;rcall Acquisition
;rcall RazRegRouges1     ; Initialise à 0 les registres de R0 à R13 (Registre concernant l'image à affichée
;rcall RazRegVertes1

;ldi MODE,4
;rjmp Lecon

;ldi TRAVAIL,$FF
;mov TEMPOBOUTON,TRAVAIL
;ldi TRAVAIL,04
;mov TEMPOBOUTON2,TRAVAIL

;LeconTempo3:
;mov TRAVAIL,TEMPOBOUTON
;cpi TRAVAIL,0
;brne LeconTempo3
;dec TEMPOBOUTON2
;ldi TRAVAIL,$FF
;mov TEMPOBOUTON,TRAVAIL
;mov TRAVAIL,TEMPOBOUTON2
;cpi TRAVAIL,0
;brne LeconTempo3



ldi MODE,1
ldi TRAVAIL,0
mov MODESAUV,TRAVAIL
rcall PreludeChg

Prelude:
mov TRAVAIL,TEMPOBOUTON
cpi TRAVAIL,0
brne Prelude
sbis PIND,BGAUCHE
rcall PreludeChg
sbis PIND,BDROITE
rcall PreludeChg
sbis PIND,BBAS
rjmp PreludeAccept
sbis PIND,BOFF
rjmp Fin
rjmp Prelude

PreludeChg:
rcall EffCompteur2
ldi TRAVAIL,$FF
mov TEMPOBOUTON,TRAVAIL
sbis PIND,BDROITE
inc MODE
sbis PIND,BGAUCHE
dec MODE
cpi MODE,0
brne PreludeChgDeb
ldi MODE,12
PreludeChgDeb:
cpi MODE,13
brne PreludeChg0
ldi MODE,1

PreludeChg0:

cpi MODE,1
brne PreludeChg1
ldi ZL,low(AffJE<<1)
ldi ZH,high(AffJE<<1)
rcall ChargementImg

PreludeChg1:
cpi MODE,2
brne PreludeChg2
ldi ZL,low(AffCH<<1)
ldi ZH,high(AffCH<<1)
rcall ChargementImg

PreludeChg2:
cpi MODE,3
brne PreludeChg3
ldi ZL,low(AffL0<<1)
ldi ZH,high(AffL0<<1)
rcall ChargementImg

PreludeChg3:
cpi MODE,4
brne PreludeChg4
ldi ZL,low(AffL1<<1)
ldi ZH,high(AffL1<<1)
rcall ChargementImg

PreludeChg4:
cpi MODE,5
brne PreludeChg5
ldi ZL,low(AffL2<<1)
ldi ZH,high(AffL2<<1)
rcall ChargementImg

PreludeChg5:
cpi MODE,6
brne PreludeChg6
ldi ZL,low(AffL3<<1)
ldi ZH,high(AffL3<<1)
rcall ChargementImg

PreludeChg6:
cpi MODE,7
brne PreludeChg7
ldi ZL,low(AffL4<<1)
ldi ZH,high(AffL4<<1)
rcall ChargementImg

PreludeChg7:
cpi MODE,8
brne PreludeChg8
ldi ZL,low(AffL5<<1)
ldi ZH,high(AffL5<<1)
rcall ChargementImg

PreludeChg8:
cpi MODE,9
brne PreludeChg9
ldi ZL,low(AffL6<<1)
ldi ZH,high(AffL6<<1)
rcall ChargementImg

PreludeChg9:
cpi MODE,10
brne PreludeChg10
ldi ZL,low(AffL7<<1)
ldi ZH,high(AffL7<<1)
rcall ChargementImg

PreludeChg10:
cpi MODE,11
brne PreludeChg11
ldi ZL,low(AffL8<<1)
ldi ZH,high(AffL8<<1)
rcall ChargementImg

PreludeChg11:
cpi MODE,12
brne PreludeChg12
ldi ZL,low(AffL9<<1)
ldi ZH,high(AffL9<<1)
rcall ChargementImg

PreludeChg12:

ret

PreludeAccept:
rcall EffCompteur2
mov MODESAUV,MODE
ldi TRAVAIL,1
mov CLIGNOTEMENT,TRAVAIL
ldi TRAVAIL,$FF
mov TEMPOBOUTON,TRAVAIL
ldi TRAVAIL,00
mov MEMBOUTONDESC,TRAVAIL

cpi MODE,1
brne PreludeAccept2
PreludeAccept1:
rcall RazReg
ldi TRAVAIL,$01 ;Initialise le 1eme registre des diodes rouges de telle manière que la diode du "bas" soit allumée
sts DIODESROUGES1,TRAVAIL
rjmp Debut

PreludeAccept2:
cpi MODE,2
brne PreludeAccept3
rcall Ouverture
rjmp Debut

PreludeAccept3:
rjmp Lecon

;ldi TRAVAIL,(1<<5)+(1<<4)+(1<<3)+(0<<2)+(0<<0)
;sts DIODESROUGES2,TRAVAIL
;ldi TRAVAIL,(1<<5)+(1<<4)+(1<<3)+(0<<2)+(1<<0)
;sts DIODESROUGES1,TRAVAIL
;ldi TRAVAIL,(1<<2)
;sts DIODESROUGES2+1,TRAVAIL
;sts DIODESROUGES1+1,TRAVAIL
;ldi TRAVAIL,(1<<2)
;sts DIODESROUGES2+2,TRAVAIL
;sts DIODESROUGES1+2,TRAVAIL
;ldi TRAVAIL,(1<<2)
;sts DIODESROUGES2+3,TRAVAIL
;sts DIODESROUGES1+3,TRAVAIL
;ldi LIGNEMASCX4,3
;ldi COLONNEMASCX4,0
;ldi LIGNEACT,3
;ldi COLONNEACT,0
;rcall DetectX4
;rcall ExistencePion



Debut:
;;rjmp Debut
;;rjmp Debut
mov TRAVAIL,TEMPOBOUTON
cpi TRAVAIL,0
brne Debut
sbis PIND,BOFF
rcall Off
;sbis PIND,PIND4
;rcall Ouverture
sbis PIND,BGAUCHE
rcall DecalGauche
sbis PIND,BDROITE
rcall DecalDroite

mov TRAVAIL,MEMBOUTONDESC
andi TRAVAIL,(1<<0)
cpi TRAVAIL,0
breq DescBas

sbic PIND,BBAS
rjmp DebSuite
rcall EffCompteur2
rcall DescPion

mov TRAVAIL,MEMBOUTONDESC
andi TRAVAIL,$FF-(1<<0)
mov MEMBOUTONDESC,TRAVAIL
rjmp DebSuite

DescBas:
sbis PIND,BBAS
rjmp Debut
ldi TRAVAIL,$FF
mov TEMPOBOUTON,TRAVAIL

mov TRAVAIL,MEMBOUTONDESC
ori TRAVAIL,(1<<0)
mov MEMBOUTONDESC,TRAVAIL

DebSuite:
mov TRAVAIL,MEMBOUTONDESC
andi TRAVAIL,(1<<1)
cpi TRAVAIL,0
breq DescBas2

sbic PIND,BHAUT
rjmp Debut

rcall EffCompteur2
mov TRAVAIL,NBCOUPS
cpi TRAVAIL,0
breq InversionCouleur

ldi TRAVAIL,$FF
mov TEMPOBOUTON,TRAVAIL

rcall CopieAffbisInv

lds COLONNEACT,DIODESROUGES1bis+28
lds COULEUR,DIODESROUGES1bis+29

mov TRAVAIL,MEMBOUTONDESC
andi TRAVAIL,$FF-(1<<1)
mov MEMBOUTONDESC,TRAVAIL
dec NBCOUPS
rjmp Debut

DescBas2:
sbis PIND,BHAUT
rjmp Debut

ldi TRAVAIL,$FF
mov TEMPOBOUTON,TRAVAIL

mov TRAVAIL,MEMBOUTONDESC
ori TRAVAIL,(1<<1)
mov MEMBOUTONDESC,TRAVAIL
rjmp Debut

InversionCouleur:
ldi Boucle,7
ldi XL,low(DiodesRouges1)
ldi XH,high(DiodesRouges1)
ldi YL,low(DiodesVertes1)
ldi YH,high(DiodesVertes1)
InversionCouleurBoucle1:
ld TRAVAIL,X
ld TRAVAIL2,Y
st X+,TRAVAIL2
st Y+,TRAVAIL
dec Boucle
cpi Boucle,0
brne InversionCouleurBoucle1

ldi Boucle,7
ldi XL,low(DiodesRouges2)
ldi XH,high(DiodesRouges2)
ldi YL,low(DiodesVertes2)
ldi YH,high(DiodesVertes2)
InversionCouleurBoucle2:
ld TRAVAIL,X
ld TRAVAIL2,Y
st X+,TRAVAIL2
st Y+,TRAVAIL
dec Boucle
cpi Boucle,0
brne InversionCouleurBoucle2

ldi Boucle,7
ldi XL,low(DiodesRouges1bis)
ldi XH,high(DiodesRouges1bis)
ldi YL,low(DiodesVertes1bis)
ldi YH,high(DiodesVertes1bis)
InversionCouleurBoucle3:
ld TRAVAIL,X
ld TRAVAIL2,Y
st X+,TRAVAIL2
st Y+,TRAVAIL
dec Boucle
cpi Boucle,0
brne InversionCouleurBoucle3

ldi Boucle,7
ldi XL,low(DiodesRouges2bis)
ldi XH,high(DiodesRouges2bis)
ldi YL,low(DiodesVertes2bis)
ldi YH,high(DiodesVertes2bis)
InversionCouleurBoucle4:
ld TRAVAIL,X
ld TRAVAIL2,Y
st X+,TRAVAIL2
st Y+,TRAVAIL
dec Boucle
cpi Boucle,0
brne InversionCouleurBoucle4

ldi TRAVAIL,3
sub TRAVAIL,COULEUR
mov COULEUR,TRAVAIL
rjmp Debut

;cpi TEMPOBOUTON,0
;brne Debut
;ldi TEMPOBOUTON,$FF
;rcall Acquisition
;rjmp Debut



;Acquisition:
;cpi ADRH,1
;breq AcqTestFin
;
;AcqTestFinNon:
;ldi BOUCLE,14
;ldi XL,0
;ldi XH,0
;
;AcquisitionBoucle:
;sbic EECR,EEWE
;rjmp AcquisitionBoucle
;out EEARH,ADRH
;out EEARL,ADRB
;sbi EECR,EERE
;in TRAVAIL,EEDR
;st X+,TRAVAIL

;cpi ADRB,$FF
;brne AcqSuite
;ldi ADRB,$00
;ldi ADRH,$01
;rjmp AcqSuite2

;AcqSuite:
;inc ADRB
;
;AcqSuite2:
;dec BOUCLE
;cpi BOUCLE,0
;brne AcquisitionBoucle
;
;AcqFin:
;ret
;
;AcqTestFin:
;cpi ADRB,246
;brsh AcqFin
;rjmp AcqTestFinNon
;
Affichage:
ldi TRAVAIL,$00
out PORTA,TRAVAIL
out PORTB,TRAVAIL
out PORTC,TRAVAIL

mov TRAVAIL,TEMPOCLIGN
cpi TRAVAIL,0
breq AffSuite2
dec TEMPOCLIGN
AffSuite2:
mov TRAVAIL,CLIGNOTEMENT
cpi TRAVAIL,2
breq AffDiodes2

ldi XH,high(DIODESROUGES1)
ldi XL,low(DIODESROUGES1)
add XL,COLONNEAFF
ld TRAVAIL,X
out PORTA,TRAVAIL

ldi XH,high(DIODESVERTES1)
ldi XL,low(DIODESVERTES1)
add XL,COLONNEAFF
ld TRAVAIL,X
out PORTB,TRAVAIL

mov TRAVAIL,TEMPOCLIGN
cpi TRAVAIL,0
brne AffSuite

mov TRAVAIL,CLIGNOTEMENT
cpi TRAVAIL,0
breq AffSuite

ldi TRAVAIL,$2
mov CLIGNOTEMENT,TRAVAIL
ldi TRAVAIL,$FF
mov TEMPOCLIGN,TRAVAIL
rjmp AffSuite

AffDiodes2:
ldi XH,high(DIODESROUGES2)
ldi XL,low(DIODESROUGES2)
add XL,COLONNEAFF
ld TRAVAIL,X
out PORTA,TRAVAIL

ldi XH,high(DIODESVERTES2)
ldi XL,low(DIODESVERTES2)
add XL,COLONNEAFF
ld TRAVAIL,X
out PORTB,TRAVAIL
mov TRAVAIL,TEMPOCLIGN
cpi TRAVAIL,0
brne AffSuite
ldi TRAVAIL,1
mov CLIGNOTEMENT,TRAVAIL
ldi TRAVAIL,$FF
mov TEMPOCLIGN,TRAVAIL

AffSuite:
mov TRAVAIL,COLONNEAFF
ldi TRAVAIL2,01

AffichageBoucle:
cpi TRAVAIL,0
breq AffichageBoucleFin
dec TRAVAIL
lsl TRAVAIL2
rjmp AffichageBoucle

AffichageBoucleFin:
out PORTC,TRAVAIL2

ret

Compteur:

cli
push SAUVREG
push TRAVAIL
push XL
push XH
push TRAVAIL2

in SAUVREG,SREG
mov TRAVAIL,TEMPOBOUTON
cpi TRAVAIL,0
breq BoucleAff
dec TRAVAIL
mov TEMPOBOUTON,TRAVAIL
rjmp BoucleAff

BoucleAff:

rcall Affichage

inc COLONNEAFF
cpi COLONNEAFF,7
brne BoucleAffSuite
ldi COLONNEAFF,0

BoucleAffSuite:
out SREG,SAUVREG

pop TRAVAIL2
pop XH
pop XL
pop TRAVAIL
pop SAUVREG
sei
reti

Compteur2:

cli
push SAUVREG
push TRAVAIL
push XL
push XH
push TRAVAIL2

in SAUVREG,SREG

ldi TRAVAIL,00
out TCNT1H,TRAVAIL
out TCNT1L,TRAVAIL

inc TEMPOOFF
mov TRAVAIL,TEMPOOFF
cpi TRAVAIL,15
brne Compteur2suite

mov TRAVAIL,MODESAUV

cpi TRAVAIL,3
brsh Compteur2Sauv

Compteur2fin:
cbi PORTD,PD7
rjmp Compteur2fin

Compteur2Sauv:
rcall Off

Compteur2suite:

out SREG,SAUVREG

pop TRAVAIL2
pop XH
pop XL
pop TRAVAIL
pop SAUVREG
sei
reti

EffCompteur2:
ldi TRAVAIL,00
out TCNT1H,TRAVAIL
out TCNT1L,TRAVAIL
mov TEMPOOFF,TRAVAIL
ret

DecalGauche:
rcall EffCompteur2
ldi TRAVAIL,$FF
mov TEMPOBOUTON,TRAVAIL

mov TRAVAIL,COULEUR
cpi TRAVAIL,2
breq DecalGaucheVert

ldi XH,high(DIODESROUGES1)
ldi XL,low(DIODESROUGES1)
add XL,COLONNEACT
ld TRAVAIL,X
ldi TRAVAIL2,$FE
and TRAVAIL,TRAVAIL2
st X,TRAVAIL

DecalColonneActGaucheRouge:
cpi COLONNEACT,0
breq RazColonneActGaucheRouge
dec COLONNEACT
rjmp DecalGaucheSuiteRouge
RazColonneActGaucheRouge:
ldi COLONNEACT,06
DecalGaucheSuiteRouge:
rcall DetectionPion
cpi LIGNEACT,6
brsh DecalColonneActGaucheRouge

ldi XH,high(DIODESROUGES1)
ldi XL,low(DIODESROUGES1)
add XL,COLONNEACT
ld TRAVAIL,X
ldi TRAVAIL2,$01
or TRAVAIL,TRAVAIL2
st X,TRAVAIL
ret

DecalGaucheVert:
ldi XH,high(DIODESVERTES1)
ldi XL,low(DIODESVERTES1)
add XL,COLONNEACT
ld TRAVAIL,X
ldi TRAVAIL2,$FE
and TRAVAIL,TRAVAIL2
st X,TRAVAIL

DecalColonneActGaucheVert:
cpi COLONNEACT,$0
breq RazColonneActGaucheVert
dec COLONNEACT
rjmp DecalGaucheSuiteVert
RazColonneActGaucheVert:
ldi COLONNEACT,06
DecalGaucheSuiteVert:
rcall DetectionPion
cpi LIGNEACT,6
brsh DecalColonneActGaucheVert

ldi XH,high(DIODESVERTES1)
ldi XL,low(DIODESVERTES1)
add XL,COLONNEACT
ld TRAVAIL,X
ldi TRAVAIL2,$01
or TRAVAIL,TRAVAIL2
st X,TRAVAIL
ret

DecalDroite:
rcall EffCompteur2
ldi TRAVAIL,$FF
mov TEMPOBOUTON,TRAVAIL

mov TRAVAIL,COULEUR
cpi TRAVAIL,2
breq DecalDroiteVert

ldi XH,high(DIODESROUGES1)
ldi XL,low(DIODESROUGES1)
add XL,COLONNEACT
ld TRAVAIL,X
ldi TRAVAIL2,$FE
and TRAVAIL,TRAVAIL2
st X,TRAVAIL

DecalColonneActDroiteRouge:
cpi COLONNEACT,6
breq RazColonneActDroiteRouge
inc COLONNEACT
rjmp DecalDroiteSuiteRouge
RazColonneActDroiteRouge:
ldi COLONNEACT,00
DecalDroiteSuiteRouge:
rcall DetectionPion
cpi LIGNEACT,6
brsh DecalColonneActDroiteRouge

ldi XH,high(DIODESROUGES1)
ldi XL,low(DIODESROUGES1)
add XL,COLONNEACT
ld TRAVAIL,X
ldi TRAVAIL2,$01
or TRAVAIL,TRAVAIL2
st X,TRAVAIL
ret

DecalDroiteVert:
ldi XH,high(DIODESVERTES1)
ldi XL,low(DIODESVERTES1)
add XL,COLONNEACT
ld TRAVAIL,X
ldi TRAVAIL2,$FE
and TRAVAIL,TRAVAIL2
st X,TRAVAIL

DecalColonneActDroiteVert:
cpi COLONNEACT,6
breq RazColonneActDroiteVert
inc COLONNEACT
rjmp DecalDroiteSuiteVert
RazColonneActDroiteVert:
ldi COLONNEACT,00
DecalDroiteSuiteVert:
rcall DetectionPion
cpi LIGNEACT,6
brsh DecalColonneActDroiteVert

ldi XH,high(DIODESVERTES1)
ldi XL,low(DIODESVERTES1)
add XL,COLONNEACT
ld TRAVAIL,X
ldi TRAVAIL2,$01
or TRAVAIL,TRAVAIL2
st X,TRAVAIL
ret

RazRegRouges1:
ldi TRAVAIL,00
ldi XL,low(DIODESROUGES1)
ldi XH,high(DIODESROUGES1)
ldi TRAVAIL2,7
RazRegRouges1Boucle:
st X+,TRAVAIL
dec TRAVAIL2
brne RazRegRouges1Boucle
ret

RazRegVertes1:
ldi TRAVAIL,00
ldi XL,low(DIODESVERTES1)
ldi XH,high(DIODESVERTES1)
ldi TRAVAIL2,7
RazRegVertes1Boucle:
st X+,TRAVAIL
dec TRAVAIL2
brne RazRegVertes1Boucle
ret

RazRegRouges2:
ldi TRAVAIL,00
ldi XL,low(DIODESROUGES2)
ldi XH,high(DIODESROUGES2)
ldi TRAVAIL2,7
RazRegRouges2Boucle:
st X+,TRAVAIL
dec TRAVAIL2
brne RazRegRouges2Boucle
ret

RazRegVertes2:
ldi TRAVAIL,00
ldi XL,low(DIODESVERTES2)
ldi XH,high(DIODESVERTES2)
ldi TRAVAIL2,7
RazRegVertes2Boucle:
st X+,TRAVAIL
dec TRAVAIL2
brne RazRegVertes2Boucle
ret

RazReg:
rcall RazRegRouges1
rcall RazRegVertes1
rcall RazRegRouges2
rcall RazRegVertes2
ret

RazRegbis:
ldi TRAVAIL,00
ldi XL,low(DIODESROUGES1bis)
ldi XH,high(DIODESROUGES1bis)
ldi TRAVAIL2,28
RazRegBisBoucle:
st X+,TRAVAIL
dec TRAVAIL2
brne RazRegBisBoucle
ret

DetectionPion:
ldi LIGNEACT,$06
ldi TRAVAIL2,$01
rjmp DetectPionBoucleSuite2

DetectPionTEMPOBOUTON:
lsl TRAVAIL2
dec LIGNEACT

DetectPionBoucleSuite2:
ldi XL,low(DiodesRouges2)
ldi XH,high(DiodesRouges2)
add XL,COLONNEACT
ld TRAVAIL,X
and TRAVAIL,TRAVAIL2
cpi TRAVAIL,0
brne DetectPionFin

ldi XL,low(DiodesVertes2)
ldi XH,high(DiodesVertes2)
add XL,COLONNEACT
ld TRAVAIL,X
and TRAVAIL,TRAVAIL2
cpi TRAVAIL,0
brne DetectPionFin

cpi LIGNEACT,0
brne DetectPionTEMPOBOUTON

DetectPionFin:

ret



AjoutPion:
mov TRAVAIL,COULEUR
cpi TRAVAIL,2
breq AjoutPionVert

AjoutPionRouge:
ldi XH,high(DiodesRouges2)
ldi XL,low(DiodesRouges2)
rjmp AjoutPionSuite

AjoutPionVert:
ldi XH,high(DiodesVertes2)
ldi XL,low(DiodesVertes2)

AjoutPionSuite:
mov TRAVAIL,LIGNEACT
ldi TRAVAIL2,$20

AjoutPionBoucle:
cpi TRAVAIL,0
breq AjoutPionBoucleFin

lsr TRAVAIL2
dec TRAVAIL
rjmp AjoutPionBoucle

AjoutPionBoucleFin:

add XL,COLONNEACT
ld TRAVAIL,X
or TRAVAIL,TRAVAIL2
st X,TRAVAIL
ret

EffacePion:
mov TRAVAIL,COULEUR
cpi TRAVAIL,2
breq EffacePionVert

EffacePionRouge:
ldi XH,high(DiodesRouges2)
ldi XL,low(DiodesRouges2)
rjmp EffacePionSuite

EffacePionVert:
ldi XH,high(DiodesVertes2)
ldi XL,low(DiodesVertes2)

EffacePionSuite:
mov TRAVAIL,LIGNEMASCX4
ldi TRAVAIL2,$20

EffacePionBoucle:
cpi TRAVAIL,0
breq EffacePionBoucleFin

lsr TRAVAIL2
dec TRAVAIL
rjmp EffacePionBoucle

EffacePionBoucleFin:

add XL,COLONNEMASCX4
ld TRAVAIL,X
com TRAVAIL2
and TRAVAIL,TRAVAIL2
st X,TRAVAIL
ret


DescPion:
inc NBCOUPS
ldi TRAVAIL,$FF
mov TEMPOBOUTON,TRAVAIL

rcall CopieAffBis
sts DIODESROUGES1bis+28,COLONNEACT
sts DIODESROUGES1bis+29,COULEUR

rcall DetectionPion
rcall AjoutPion
rcall CopieAff
rcall DetectX4
cpi NBX4,1
brlo DescPionSuite
pop TRAVAIL
pop TRAVAIL
rjmp Fin

DescPionSuite:


rcall DetectionPion

mov TRAVAIL,NBCOUPS
cpi TRAVAIL,42
brne DescPionRetour
rcall RazRegRouges1
rcall RazRegVertes1
pop TRAVAIL
pop TRAVAIL
rjmp Fin

DescPionRetour:

cpi LIGNEACT,6
brne DescPionFin

DescPionDecal:
inc COLONNEACT
cpi COLONNEACT,7
brne DescPionSuite2

ldi COLONNEACT,0

DescPionSuite2:
rcall DetectionPion
cpi LIGNEACT,6
breq DescPionDecal

DescPionFin:
mov TRAVAIL,COULEUR
cpi TRAVAIL,2
brne DescPionRouge

ldi XH,high(DIODESROUGES1)
ldi XL,low(DIODESROUGES1)
ldi TRAVAIL,1
mov COULEUR,TRAVAIL
rjmp DescPionFin2
DescPionRouge:
ldi XH,high(DIODESVERTES1)
ldi XL,low(DIODESVERTES1)
ldi TRAVAIL,2
mov COULEUR,TRAVAIL

DescPionFin2:
add XL,COLONNEACT
ld TRAVAIL,X
ori TRAVAIL,$01
st X,TRAVAIL

ret



CopieAff:
ldi BOUCLE,14
ldi XH,high(DIODESROUGES1)
ldi XL,low(DIODESROUGES1)
ldi YH,high(DIODESROUGES2)
ldi YL,low(DIODESROUGES2)

CopieAffBoucle:
ld TRAVAIL,Y+
st X+,TRAVAIL
dec BOUCLE
cpi BOUCLE,0
brne CopieAffBoucle
ret

CopieAffBis:
ldi BOUCLE,28
ldi XH,high(DIODESROUGES1Bis)
ldi XL,low(DIODESROUGES1Bis)
ldi YH,high(DIODESROUGES1)
ldi YL,low(DIODESROUGES1)

CopieAffBoucleBis:
ld TRAVAIL,Y+
st X+,TRAVAIL
dec BOUCLE
cpi BOUCLE,0
brne CopieAffBoucleBis
ret

CopieAffbisInv:
ldi BOUCLE,28
ldi XH,high(DIODESROUGES1)
ldi XL,low(DIODESROUGES1)
ldi YH,high(DIODESROUGES1bis)
ldi YL,low(DIODESROUGES1bis)

CopieAffBoucleBisInv:
ld TRAVAIL,Y+
st X+,TRAVAIL
dec BOUCLE
cpi BOUCLE,0
brne CopieAffBoucleBisInv
ret

Fin:
sbis PIND,BOFF
cbi PORTD,PD7
rjmp Fin

DetectX4:
mov LIGNEMASCX4,LIGNEACT
mov COLONNEMASCX4,COLONNEACT
ldi NBPIONSALIGNES,0
ldi NBX4,0

DetectX4Vertical:
rcall ExistencePion
mov TRAVAIL,EXISTENCEPION
cpi TRAVAIL,0
breq DetectX4VerticalFin
inc NBPIONSALIGNES

cpi LIGNEMASCX4,0
breq DetectX4VerticalFin
dec LIGNEMASCX4
rjmp DetectX4Vertical

DetectX4VerticalFin:
cpi NBPIONSALIGNES,4
brlo DetectX4HorizontalDeb

ldi NBX4,1

mov LIGNEMASCX4,LIGNEACT
mov COLONNEMASCX4,COLONNEACT

DetectX4VerticalFinBoucle:
cpi NBPIONSALIGNES,0
breq DetectX4HorizontalDeb
dec LIGNEMASCX4
dec NBPIONSALIGNES
rcall EffacePion
rjmp DetectX4VerticalFinBoucle

DetectX4HorizontalDeb:
ldi NBPIONSALIGNES,0
mov LIGNEMASCX4,LIGNEACT
ldi COLONNEMASCX4,0

DetectX4Horizontal:

rcall ExistencePion
mov TRAVAIL,EXISTENCEPION
cpi TRAVAIL,0
breq DetectX4Horizontal0
inc NBPIONSALIGNES
inc COLONNEMASCX4
cpi COLONNEMASCX4,7
breq DetectX4HorizontalPresqueFin

rjmp DetectX4Horizontal

DetectX4Horizontal0:
cpi NBPIONSALIGNES,4
brsh DetectX4HorizontalPresqueFin
ldi NBPIONSALIGNES,0

inc COLONNEMASCX4
cpi COLONNEMASCX4,7
breq DetectX4HorizontalFin

rjmp DetectX4Horizontal

DetectX4HorizontalPresqueFin:
dec COLONNEMASCX4

DetectX4HorizontalFin:
cpi NBPIONSALIGNES,4
brlo DetectX4DiagonalHGDeb

mov TRAVAIL,NBPIONSALIGNES
subi TRAVAIL,3
add NBX4,TRAVAIL

DetectX4HorizontalFinBoucle:
rcall ExistencePion
mov TRAVAIL,EXISTENCEPION
cpi TRAVAIL,0
breq DetectX4DiagonalHGDeb

DetectX4HorizontalFinBoucleSuite:
cp COLONNEMASCX4,COLONNEACT
breq DetectX4HorizontalFinBoucleSuite2
rcall EffacePion

DetectX4HorizontalFinBoucleSuite2:
cpi COLONNEMASCX4,0
breq DetectX4DiagonalHGDeb
dec COLONNEMASCX4
rjmp DetectX4HorizontalFinBoucle

DetectX4DiagonalHGDeb:
ldi NBPIONSALIGNES,0
mov LIGNEMASCX4,LIGNEACT
mov COLONNEMASCX4,COLONNEACT

DetectX4DiagonalHGDebSuite:
cpi LIGNEMASCX4,5
breq DetectX4DiagonalHG
cpi COLONNEMASCX4,0
breq DetectX4DiagonalHG
dec COLONNEMASCX4
inc LIGNEMASCX4
rjmp DetectX4DiagonalHGDebSuite

DetectX4DiagonalHG:

rcall ExistencePion
mov TRAVAIL,EXISTENCEPION
cpi TRAVAIL,1
brne DetectX4DiagonalHG0
inc NBPIONSALIGNES

cpi COLONNEMASCX4,6
breq DetectX4DiagonalHGFin
cpi LIGNEMASCX4,0
breq DetectX4DiagonalHGFin

dec LIGNEMASCX4
inc COLONNEMASCX4

rjmp DetectX4DiagonalHG

DetectX4DiagonalHG0:
cpi NBPIONSALIGNES,4
brsh DetectX4DiagonalHGPresqueFin
ldi NBPIONSALIGNES,0

cpi COLONNEMASCX4,6
breq DetectX4DiagonalHGFin
cpi LIGNEMASCX4,0
breq DetectX4DiagonalHGFin

dec LIGNEMASCX4
inc COLONNEMASCX4

rjmp DetectX4DiagonalHG

DetectX4DiagonalHGPresqueFin:
dec COLONNEMASCX4
inc LIGNEMASCX4

DetectX4DiagonalHGFin:
cpi NBPIONSALIGNES,4
brlo DetectX4DiagonalHDDeb

mov TRAVAIL,NBPIONSALIGNES
subi TRAVAIL,3
add NBX4,TRAVAIL

DetectX4DiagonalHGFinBoucle:
rcall ExistencePion
mov TRAVAIL,EXISTENCEPION
cpi TRAVAIL,0
breq DetectX4DiagonalHDDeb

DetectX4DiagonalHGFinBoucleSuite:
cp COLONNEMASCX4,COLONNEACT
breq DetectX4DiagonalHGFinBoucleSuite2
rcall EffacePion

DetectX4DiagonalHGFinBoucleSuite2:
cpi COLONNEMASCX4,0
breq DetectX4DiagonalHDDeb
cpi LIGNEMASCX4,5
breq DetectX4DiagonalHDDeb

dec COLONNEMASCX4
inc LIGNEMASCX4
rjmp DetectX4DiagonalHGFinBoucle

DetectX4DiagonalHDDeb:
ldi NBPIONSALIGNES,0
mov LIGNEMASCX4,LIGNEACT
mov COLONNEMASCX4,COLONNEACT

DetectX4DiagonalHDDebSuite:
cpi LIGNEMASCX4,0
breq DetectX4DiagonalHD
cpi COLONNEMASCX4,0
breq DetectX4DiagonalHD
dec COLONNEMASCX4
dec LIGNEMASCX4
rjmp DetectX4DiagonalHDDebSuite

DetectX4DiagonalHD:

rcall ExistencePion
mov TRAVAIL,EXISTENCEPION
cpi TRAVAIL,1
brne DetectX4DiagonalHD0
inc NBPIONSALIGNES

cpi COLONNEMASCX4,6
breq DetectX4DiagonalHDFin
cpi LIGNEMASCX4,5
breq DetectX4DiagonalHDFin

inc LIGNEMASCX4
inc COLONNEMASCX4

rjmp DetectX4DiagonalHD

DetectX4DiagonalHD0:
cpi NBPIONSALIGNES,4
brsh DetectX4DiagonalHDPresqueFin
ldi NBPIONSALIGNES,0

cpi COLONNEMASCX4,6
breq DetectX4DiagonalHDFin
cpi LIGNEMASCX4,5
breq DetectX4DiagonalHDFin

inc LIGNEMASCX4
inc COLONNEMASCX4

rjmp DetectX4DiagonalHD

DetectX4DiagonalHDPresqueFin:
dec COLONNEMASCX4
dec LIGNEMASCX4

DetectX4DiagonalHDFin:
cpi NBPIONSALIGNES,4
brlo DetectX4Fin

mov TRAVAIL,NBPIONSALIGNES
subi TRAVAIL,3
add NBX4,TRAVAIL

DetectX4DiagonalHDFinBoucle:
rcall ExistencePion
mov TRAVAIL,EXISTENCEPION
cpi TRAVAIL,0
breq DetectX4Fin

DetectX4DiagonalHDFinBoucleSuite:
cp COLONNEMASCX4,COLONNEACT
breq DetectX4DiagonalHDFinBoucleSuite2
rcall EffacePion

DetectX4DiagonalHDFinBoucleSuite2:
cpi COLONNEMASCX4,0
breq DetectX4Fin
cpi LIGNEMASCX4,0
breq DetectX4Fin

dec COLONNEMASCX4
dec LIGNEMASCX4
rjmp DetectX4DiagonalHDFinBoucle

DetectX4Fin:

cpi NBX4,0
breq DetectX4Fin0X4
mov COLONNEMASCX4,COLONNEACT
mov LIGNEMASCX4,LIGNEACT
rcall EffacePion
rjmp Fin
DetectX4Fin0X4:
ret




ExistencePion:
ldi TRAVAIL,0
mov EXISTENCEPION,TRAVAIL

mov TRAVAIL,LIGNEMASCX4
ldi TRAVAIL2,$20
rjmp ExistencePionBoucleSuite
ExistencePionBoucle:
dec TRAVAIL
lsr TRAVAIL2

ExistencePionBoucleSuite:
cpi TRAVAIL,0
brne ExistencePionBoucle

mov TRAVAIL,COULEUR
cpi TRAVAIL,1
brne ExistencePionVert

ExistencePionRouge:
ldi XL,low(DiodesRouges2)
ldi XH,high(DiodesRouges2)
add XL,COLONNEMASCX4
ld TRAVAIL,X
and TRAVAIL,TRAVAIL2
cpi TRAVAIL,0
breq ExistencePionFin
ldi TRAVAIL,1
mov EXISTENCEPION,TRAVAIL
rjmp ExistencePionFin

ExistencePionVert:
ldi XL,low(DiodesVertes2)
ldi XH,high(DiodesVertes2)
add XL,COLONNEMASCX4
ld TRAVAIL,X
and TRAVAIL,TRAVAIL2
cpi TRAVAIL,0
breq ExistencePionFin
ldi TRAVAIL,1
mov EXISTENCEPION,TRAVAIL
rjmp ExistencePionFin

ExistencePionFin:
ret

Off:
ldi ADRB,$00
ldi ADRH,$00
ldi BOUCLE,28
ldi XL,low(DIODESROUGES1)
ldi XH,high(DIODESROUGES1)


OffEnreg:
sbic EECR,EEWE
rjmp OffEnreg
out EEARH,ADRH
out EEARL,ADRB
ld TRAVAIL,X+
out EEDR,TRAVAIL
sbi EECR,EEMWE
sbi EECR,EEWE
adiw ADRH:ADRB,$1
dec BOUCLE
cpi BOUCLE,0
brne OffEnreg

OffEnregSuite:
sbic EECR,EEWE
rjmp OffEnregSuite
out EEARH,ADRH
out EEARL,ADRB
out EEDR,COLONNEACT
sbi EECR,EEMWE
sbi EECR,EEWE
adiw ADRH:ADRB,$1

OffEnregSuite2:
sbic EECR,EEWE
rjmp OffEnregSuite2
out EEARH,ADRH
out EEARL,ADRB
out EEDR,COULEUR
sbi EECR,EEMWE
sbi EECR,EEWE
adiw ADRH:ADRB,$1

ldi BOUCLE,30

OffEnregTEMPOBOUTON:
sbic EECR,EEWE
rjmp OffEnregTEMPOBOUTON
out EEARH,ADRH
out EEARL,ADRB
ld TRAVAIL,X+
out EEDR,TRAVAIL
sbi EECR,EEMWE
sbi EECR,EEWE
adiw ADRH:ADRB,$1
dec BOUCLE
cpi BOUCLE,0
brne OffEnregTEMPOBOUTON

cbi PORTD,PIND7

OffEnregFin:
;ret
rjmp OffEnregFin

Ouverture:
ldi ADRB,$00
ldi ADRH,$00
ldi BOUCLE,28
ldi XL,low(DIODESROUGES1)
ldi XH,high(DIODESROUGES1)


OuvertureBoucle:
out EEARH,ADRH
out EEARL,ADRB
sbi EECR,EERE
in TRAVAIL,EEDR
st X+,TRAVAIL
adiw ADRH:ADRB,$1
dec BOUCLE
cpi BOUCLE,0
brne OuvertureBoucle

OuvertureSuite:
out EEARH,ADRH
out EEARL,ADRB
sbi EECR,EERE
in COLONNEACT,EEDR
adiw ADRH:ADRB,$1

out EEARH,ADRH
out EEARL,ADRB
sbi EECR,EERE
in COULEUR,EEDR
adiw ADRH:ADRB,$1

ldi BOUCLE,30

OuvertureTEMPOBOUTON:
out EEARH,ADRH
out EEARL,ADRB
sbi EECR,EERE
in TRAVAIL,EEDR
st X+,TRAVAIL
adiw ADRH:ADRB,$1
dec BOUCLE
cpi BOUCLE,0
brne OuvertureTEMPOBOUTON

ret

ChargementImg:
ldi BOUCLE,7
ldi XL,low(DIODESROUGES1)
ldi XH,high(DIODESROUGES1)
ChargementImgBoucle:
dec BOUCLE
lpm TRAVAIL,Z+
st X+,TRAVAIL
cpi BOUCLE,0
brne ChargementImgBoucle
ret

AffJE:
.db (1<<0)+(0<<1)+(0<<2)+(0<<3)+(1<<4),(1<<0)+(1<<1)+(1<<2)+(1<<3)+(1<<4)
.db (1<<0)+(0<<1)+(0<<2)+(0<<3)+(0<<4),0
.db (1<<0)+(1<<1)+(1<<2)+(1<<3)+(1<<4),(1<<0)+(0<<1)+(1<<2)+(0<<3)+(1<<4)
.db (1<<0)+(0<<1)+(0<<2)+(0<<3)+(1<<4),0

AffCH:
.db (0<<0)+(1<<1)+(1<<2)+(1<<3)+(0<<4),(1<<0)+(0<<1)+(0<<2)+(0<<3)+(1<<4)
.db (1<<0)+(0<<1)+(0<<2)+(0<<3)+(1<<4),0
.db (1<<0)+(1<<1)+(1<<2)+(1<<3)+(1<<4),(0<<0)+(0<<1)+(1<<2)+(0<<3)+(0<<4)
.db (1<<0)+(1<<1)+(1<<2)+(1<<3)+(1<<4),0

AffL0:
.db (1<<0)+(1<<1)+(1<<2)+(1<<3)+(1<<4),(0<<0)+(0<<1)+(0<<2)+(0<<3)+(1<<4)
.db (0<<0)+(0<<1)+(0<<2)+(0<<3)+(1<<4),0
.db (0<<0)+(1<<1)+(1<<2)+(1<<3)+(0<<4),(1<<0)+(0<<1)+(0<<2)+(0<<3)+(1<<4)
.db (0<<0)+(1<<1)+(1<<2)+(1<<3)+(0<<4),0

AffL1:
.db (1<<0)+(1<<1)+(1<<2)+(1<<3)+(1<<4),(0<<0)+(0<<1)+(0<<2)+(0<<3)+(1<<4)
.db (0<<0)+(0<<1)+(0<<2)+(0<<3)+(1<<4),0
.db (0<<0)+(1<<1)+(0<<2)+(0<<3)+(0<<4),(1<<0)+(1<<1)+(1<<2)+(1<<3)+(1<<4)
.db (0<<0)+(0<<1)+(0<<2)+(0<<3)+(0<<4),0

AffL2:
.db (1<<0)+(1<<1)+(1<<2)+(1<<3)+(1<<4),(0<<0)+(0<<1)+(0<<2)+(0<<3)+(1<<4)
.db (0<<0)+(0<<1)+(0<<2)+(0<<3)+(1<<4),0
.db (0<<0)+(1<<1)+(0<<2)+(0<<3)+(1<<4),(1<<0)+(0<<1)+(0<<2)+(1<<3)+(1<<4)
.db (0<<0)+(1<<1)+(1<<2)+(0<<3)+(1<<4),0

AffL3:
.db (1<<0)+(1<<1)+(1<<2)+(1<<3)+(1<<4),(0<<0)+(0<<1)+(0<<2)+(0<<3)+(1<<4)
.db (0<<0)+(0<<1)+(0<<2)+(0<<3)+(1<<4),0
.db (1<<0)+(0<<1)+(0<<2)+(0<<3)+(1<<4),(1<<0)+(0<<1)+(1<<2)+(0<<3)+(1<<4)
.db (0<<0)+(1<<1)+(0<<2)+(1<<3)+(0<<4),0

AffL4:
.db (1<<0)+(1<<1)+(1<<2)+(1<<3)+(1<<4),(0<<0)+(0<<1)+(0<<2)+(0<<3)+(1<<4)
.db (0<<0)+(0<<1)+(0<<2)+(0<<3)+(1<<4),0
.db (1<<0)+(1<<1)+(1<<2)+(0<<3)+(0<<4),(0<<0)+(0<<1)+(1<<2)+(0<<3)+(0<<4)
.db (1<<0)+(1<<1)+(1<<2)+(1<<3)+(1<<4),0

AffL5:
.db (1<<0)+(1<<1)+(1<<2)+(1<<3)+(1<<4),(0<<0)+(0<<1)+(0<<2)+(0<<3)+(1<<4)
.db (0<<0)+(0<<1)+(0<<2)+(0<<3)+(1<<4),0
.db (1<<0)+(1<<1)+(1<<2)+(0<<3)+(1<<4),(1<<0)+(0<<1)+(1<<2)+(0<<3)+(1<<4)
.db (1<<0)+(0<<1)+(0<<2)+(1<<3)+(0<<4),0

AffL6:
.db (1<<0)+(1<<1)+(1<<2)+(1<<3)+(1<<4),(0<<0)+(0<<1)+(0<<2)+(0<<3)+(1<<4)
.db (0<<0)+(0<<1)+(0<<2)+(0<<3)+(1<<4),0
.db (0<<0)+(1<<1)+(1<<2)+(1<<3)+(0<<4),(1<<0)+(0<<1)+(1<<2)+(0<<3)+(1<<4)
.db (1<<0)+(0<<1)+(1<<2)+(1<<3)+(0<<4),0

AffL7:
.db (1<<0)+(1<<1)+(1<<2)+(1<<3)+(1<<4),(0<<0)+(0<<1)+(0<<2)+(0<<3)+(1<<4)
.db (0<<0)+(0<<1)+(0<<2)+(0<<3)+(1<<4),0
.db (1<<0)+(0<<1)+(0<<2)+(0<<3)+(0<<4),(1<<0)+(0<<1)+(1<<2)+(1<<3)+(1<<4)
.db (1<<0)+(1<<1)+(0<<2)+(0<<3)+(0<<4),0

AffL8:
.db (1<<0)+(1<<1)+(1<<2)+(1<<3)+(1<<4),(0<<0)+(0<<1)+(0<<2)+(0<<3)+(1<<4)
.db (0<<0)+(0<<1)+(0<<2)+(0<<3)+(1<<4),0
.db (1<<0)+(1<<1)+(1<<2)+(1<<3)+(1<<4),(1<<0)+(0<<1)+(1<<2)+(0<<3)+(1<<4)
.db (1<<0)+(1<<1)+(1<<2)+(1<<3)+(1<<4),0

AffL9:
.db (1<<0)+(1<<1)+(1<<2)+(1<<3)+(1<<4),(0<<0)+(0<<1)+(0<<2)+(0<<3)+(1<<4)
.db (0<<0)+(0<<1)+(0<<2)+(0<<3)+(1<<4),0
.db (0<<0)+(1<<1)+(1<<2)+(0<<3)+(1<<4),(1<<0)+(0<<1)+(1<<2)+(0<<3)+(1<<4)
.db (0<<0)+(1<<1)+(1<<2)+(1<<3)+(0<<4),0

Lecon:
ldi TRAVAIL,1
mov CLIGNOTEMENT,TRAVAIL
subi MODE,3
ldi TRAVAIL,22
mul MODE,TRAVAIL
ldi TRAVAIL,low(LigneLecon<<1)
ldi TRAVAIL2,high(LigneLecon<<1)
add ADRLECONBAS,TRAVAIL
adc ADRLECONHAUT,TRAVAIL2
ldi TRAVAIL,21
mov BOUCLELECON,TRAVAIL
mov ZL,ADRLECONBAS
mov ZH,ADRLECONHAUT

LeconBoucle:
dec BOUCLELECON

lpm VALEURLECON,Z+

mov TRAVAIL,VALEURLECON
andi TRAVAIL,$08

mov LECONPAUSE,TRAVAIL
mov TRAVAIL,VALEURLECON
andi TRAVAIL,$07

mov COLONNEACT,TRAVAIL

rcall LeconDescPion
ldi TRAVAIL,$FF
mov TEMPOBOUTON,TRAVAIL
ldi TRAVAIL,04
mov TEMPOBOUTON2,TRAVAIL

LeconTempo:
sbis PIND,BOFF
cbi PORTD,PD7
mov TRAVAIL,TEMPOBOUTON
cpi TRAVAIL,0
brne LeconTempo
dec TEMPOBOUTON2
ldi TRAVAIL,$FF
mov TEMPOBOUTON,TRAVAIL
mov TRAVAIL,TEMPOBOUTON2
cpi TRAVAIL,0
brne LeconTempo

LeconAttenteBouton:
mov TRAVAIL,LECONPAUSE
cpi TRAVAIL,0
breq LeconAttenteBoutonFin
sbis PIND,BOFF
cbi PORTD,PD7
sbic PIND,BBAS
rjmp LeconAttenteBouton
rcall EffCompteur2

LeconAttenteBoutonFin:

mov TRAVAIL,VALEURLECON
andi TRAVAIL,$80
swap TRAVAIL
mov LECONPAUSE,TRAVAIL

mov TRAVAIL,VALEURLECON
andi TRAVAIL,$70
swap TRAVAIL
mov COLONNEACT,TRAVAIL

rcall LeconDescPion
ldi TRAVAIL,$FF
mov TEMPOBOUTON,TRAVAIL
ldi TRAVAIL,04
mov TEMPOBOUTON2,TRAVAIL

LeconTempo2:
sbis PIND,BOFF
cbi PORTD,PD7
mov TRAVAIL,TEMPOBOUTON
cpi TRAVAIL,0
brne LeconTempo2
dec TEMPOBOUTON2
ldi TRAVAIL,$FF
mov TEMPOBOUTON,TRAVAIL
mov TRAVAIL,TEMPOBOUTON2
cpi TRAVAIL,0
brne LeconTempo2

LeconAttenteBouton2:
sbis PIND,BOFF
cbi PORTD,PD7
mov TRAVAIL,LECONPAUSE
cpi TRAVAIL,0
breq LeconAttenteBoutonFin2
sbis PIND,BOFF
cbi PORTD,PD7
sbic PIND,BBAS
rjmp LeconAttenteBouton2
rcall EffCompteur2

LeconAttenteBoutonFin2:
mov TRAVAIL,BOUCLELECON
cpi TRAVAIL,0
brne VaàLeconBoucle
rjmp Fin

VaàLeconBoucle:
rjmp LeconBoucle


LeconDescPion:
inc NBCOUPS

rcall DetectionPion
rcall AjoutPion
rcall CopieAff
rcall DetectX4
cpi NBX4,1
brlo LeconDescPionSuite
pop TRAVAIL
pop TRAVAIL
rjmp Fin

LeconDescPionSuite:

mov TRAVAIL,NBCOUPS
cpi TRAVAIL,42
brne LeconDescPionRetour
rcall RazRegRouges1
rcall RazRegVertes1
pop TRAVAIL
pop TRAVAIL
rjmp Fin

LeconDescPionRetour:

mov TRAVAIL,COULEUR
cpi TRAVAIL,2
brne LeconDescPionRouge

ldi TRAVAIL,1
mov COULEUR,TRAVAIL
rjmp LeconDescPionFin2
LeconDescPionRouge:
ldi TRAVAIL,2
mov COULEUR,TRAVAIL

LeconDescPionFin2:

ret

LigneLecon:
;L0
.db (3+1*8)+16*(3+0*8),(4+0*8)+16*(4+0*8)
.db (5+1*8)+16*(6+0*8),(2+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)

;L1
.db (3+1*8)+16*(4+0*8),(4+0*8)+16*(3+1*8)
.db (3+0*8)+16*(2+0*8),(5+0*8)+16*(4+1*8)
.db (2+0*8)+16*(5+0*8),(4+0*8)+16*(1+0*8)
.db (3+0*8)+16*(2+0*8),(2+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)

;L2
.db (1+1*8)+16*(2+0*8),(2+0*8)+16*(3+0*8)
.db (6+0*8)+16*(3+0*8),(3+0*8)+16*(5+0*8)
.db (4+0*8)+16*(4+0*8),(5+1*8)+16*(5+1*8)
.db (4+0*8)+16*(3+0*8),(4+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)

;L3
.db (1+1*8)+16*(1+0*8),(2+1*8)+16*(0+1*8)
.db (2+0*8)+16*(0+0*8),(1+1*8)+16*(0+0*8)
.db (0+1*8)+16*(2+0*8),(3+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)

;L4
.db (3+1*8)+16*(4+0*8),(4+0*8)+16*(3+1*8)
.db (3+0*8)+16*(2+0*8),(4+1*8)+16*(5+0*8)
.db (1+0*8)+16*(5+0*8),(5+1*8)+16*(2+0*8)
.db (6+0*8)+16*(2+1*8),(2+0*8)+16*(1+0*8)
.db (6+1*8)+16*(6+0*8),(6+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)

;L5
.db (3+1*8)+16*(4+0*8),(4+0*8)+16*(5+0*8)
.db (3+1*8)+16*(5+0*8),(5+1*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(1+0*8),(1+0*8)+16*(1+0*8)
.db (1+0*8)+16*(1+0*8),(1+0*8)+16*(3+0*8)
.db (2+0*8)+16*(2+0*8),(2+0*8)+16*(2+0*8)
.db (2+0*8)+16*(2+0*8),(3+0*8)+16*(3+0*8)
.db (3+0*8)+16*(4+0*8),(4+0*8)+16*(4+0*8)
.db (4+0*8)+16*(5+0*8),(5+0*8)+16*(5+0*8)
.db (6+0*8)+16*(6+0*8),(6+1*8)+16*(6+0*8)
.db (6+0*8)+16*(6+0*8),(0+0*8)+16*(0+0*8)

;L6
.db (2+1*8)+16*(3+0*8),(3+0*8)+16*(4+0*8)
.db (2+0*8)+16*(4+0*8),(3+0*8)+16*(5+0*8)
.db (5+0*8)+16*(5+0*8),(5+0*8)+16*(4+1*8)
.db (4+1*8)+16*(5+0*8),(1+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)

;L7
.db (5+1*8)+16*(5+0*8),(3+0*8)+16*(3+0*8)
.db (5+0*8)+16*(4+0*8),(3+0*8)+16*(4+1*8)
.db (1+0*8)+16*(4+0*8),(4+0*8)+16*(3+0*8)
.db (3+1*8)+16*(3+0*8),(2+0*8)+16*(2+0*8)
.db (2+0*8)+16*(2+0*8),(2+0*8)+16*(2+0*8)
.db (1+0*8)+16*(1+0*8),(1+0*8)+16*(1+0*8)
.db (1+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(4+0*8)
.db (4+0*8)+16*(5+0*8),(5+0*8)+16*(5+1*8)
.db (6+0*8)+16*(6+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)

;L8
.db (1+1*8)+16*(0+0*8),(1+0*8)+16*(0+0*8)
.db (1+0*8)+16*(0+1*8),(1+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)

;L9
.db (0+1*8)+16*(1+0*8),(1+0*8)+16*(2+0*8)
.db (3+0*8)+16*(2+0*8),(2+0*8)+16*(4+0*8)
.db (6+0*8)+16*(5+0*8),(5+0*8)+16*(4+0*8)
.db (4+0*8)+16*(5+0*8),(5+0*8)+16*(6+0*8)
.db (4+0*8)+16*(6+0*8),(6+0*8)+16*(1+0*8)
.db (2+0*8)+16*(0+0*8),(1+0*8)+16*(0+0*8)
.db (0+0*8)+16*(1+0*8),(1+0*8)+16*(0+0*8)
.db (2+0*8)+16*(5+0*8),(5+0*8)+16*(2+0*8)
.db (4+0*8)+16*(0+0*8),(3+0*8)+16*(4+0*8)
.db (3+0*8)+16*(6+1*8),(3+0*8)+16*(0+0*8)
.db (0+0*8)+16*(0+0*8),(0+0*8)+16*(0+0*8)
