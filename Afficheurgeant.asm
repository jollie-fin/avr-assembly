.include "2313def.inc"
.include "caractere.inc"

.def HAUT = r16
.def MOY = r17
.def BAS = r18
.def SORTIE = r19
.def TRAVAIL = r20
.def NUMERO_AFF = r21
.def BOUCLE = r22
.def SAUVREG = r23
.def CARACT_AFF = r24
.def NUMERO_PAGE = r25

rjmp Raz
nop
nop
nop
rjmp Compteur
nop
nop
rjmp Reception
nop
nop
nop

Raz:
ldi SORTIE,$69
out SPL,SORTIE
ldi TRAVAIL,0
ldi SORTIE,$FC
out DDRD,SORTIE
ldi SORTIE,$FF
out DDRB,SORTIE

ldi SORTIE,low(1000)
out OCR1AL,SORTIE
ldi SORTIE,high(1000)
out OCR1AH,SORTIE
ldi SORTIE,$00
out TCCR1A,SORTIE
ldi SORTIE,(1<<CTC1)+(1<<CS10)
out TCCR1B,SORTIE

ldi SORTIE,(1<<OCIE1A)
out TIMSK,SORTIE

ldi SORTIE,(1<<RxCIE)+(1<<RxEN)
out UCR,SORTIE
ldi SORTIE,1
out UBRR,SORTIE



Sei

ldi NUMERO_AFF,0
ldi CARACT_AFF,0
ldi NUMERO_PAGE,0

ldi ZL,$70
ldi ZH,00
ldi TRAVAIL,0

Init:
st Z+,TRAVAIL
cpi ZL,$E0
brne Init

Debut:
rjmp Debut

Delay:
ldi HAUT,5
Cagain:
ldi MOY,255
Magain:
ldi BAS,255
Fagain:
dec BAS
brne Fagain
dec MOY
brne Magain
dec HAUT
brne Cagain
ret

Delay2:
ldi BAS,255
Fagain2:
dec BAS
brne Fagain2
ret

Caractere:
.db 94,233 ;A
.db 31,229 ;B
.db 44,172 ;C
.db 93,229 ;D
.db 47,236 ;E
.db 47,224 ;F
.db 109,237 ;G
.db 123,233 ;H
.db 167,92 ;I
.db 167,80 ;J
.db 59,233 ;K
.db 9,236 ;L
.db 249,233 ;M
.db 93,233 ;N
.db 125,237 ;O
.db 127,224 ;P
.db 92,56 ;Q
.db 31,233 ;R
.db 46,69 ;S
.db 167,20 ;T
.db 121,237 ;U
.db 121,165 ;V
.db 121,249 ;W
.db 59,201 ;X
.db 59,20 ;Y
.db 55,204 ;Z

.db 87,237 ;a
.db 75,237 ;b
.db 66,236 ;c
.db 114,237 ;d
.db 62,172 ;e
.db 110,224 ;f
.db 108,173 ;g
.db 11,233 ;h
.db 06,124 ;i
.db 130,80 ;j
.db 75,248 ;k
.db 134,20 ;l
.db 66,233 ;m
.db 02,233 ;n
.db 66,237 ;o
.db 216,241 ;p
.db 216,185 ;q
.db 66,224 ;r
.db 46,69 ;s
.db 11,236 ;t
.db 64,237 ;u
.db 64,165 ;v
.db 88,249 ;w
.db 64,120 ;x
.db 90,109 ;y
.db 216,92 ;z

.db 35,124 ;ï
.db 99,237 ;ö
.db 97,237 ;ü
.db 39,124 ;î
.db 103,237 ;ô
.db 101,237 ;û
.db 80,01 ;e dans l'o (rajouter :)
.db 110,172 ;euro

.db 92,165 ;0
.db 142,92 ;1
.db 23,204 ;2
.db 23,69 ;3
.db 91,41 ;4
.db 47,101 ;5
.db 46,165 ;6
.db 55,20 ;7
.db 30,133 ;8
.db 94,69 ;9

.db 00,00 ;Spc
.db 00,04 ;.
.db 00,72 ;..
.db 00,8  ; .
.db 02,80 ;,
.db 06,80 ;;
.db 02,04 ;:
.db 162,24 ;(
.db 131,80 ;)
.db 166,28 ;[
.db 135,84 ;]
.db 164,60 ;{
.db 197,84 ;}
.db 160,56 ;<
.db 193,80 ;>
.db 92,20 ;?
.db 134,04 ;!
.db 121,104 ;!!
.db 50,192 ;/
.db 11,9 ;\
.db 51,200 ;%
.db 57,00 ;"
.db 00,201 ;" en bas
.db 132,00 ;'
.db 00,20 ;' en bas
.db 127,32 ;°
.db 28,00 ;^
.db 00,76 ;_

.db 66,32 ;-
.db 194,48 ;+
.db 26,129 ;*
.db 70,36 ;diviser
.db 152,145 ;=

.db 161,88 ;Guirlande (activer deux points)
.db 224,112 ;Double Guirlande (activer deux points)

.db 255,253 ;Test

Correspondance:
.db 8,15
.db 9,7
.db 2,6
.db 10,5
.db 0,13
.db 11,14
.db 3,4
.db 1,12

Compteur:
cli
push ZL
push ZH
push TRAVAIL
push SORTIE
in SAUVREG,SREG

ldi SORTIE,$FF
out PORTB,SORTIE

ldi ZL,low(Correspondance<<1)
ldi ZH,high(Correspondance<<1)
add ZL,NUMERO_AFF
ldi TRAVAIL,0
adc ZH,TRAVAIL

lpm
mov SORTIE,r0
lsl SORTIE
lsl SORTIE
ori SORTIE,$43
out PORTD,SORTIE

ldi ZL,$70
ldi ZH,$00
mov TRAVAIL,NUMERO_AFF
lsr TRAVAIL
add ZL,TRAVAIL

lsl NUMERO_PAGE
lsl NUMERO_PAGE
lsl NUMERO_PAGE
add ZL,NUMERO_PAGE
lsr NUMERO_PAGE
lsr NUMERO_PAGE
lsr NUMERO_PAGE

ld CARACT_AFF,Z

ldi TRAVAIL,0
ldi ZL,low(Caractere<<1)
ldi ZH,high(Caractere<<1)
add ZL,CARACT_AFF
adc ZH,TRAVAIL
add ZL,CARACT_AFF
adc ZH,TRAVAIL

mov TRAVAIL,NUMERO_AFF
andi TRAVAIL,$01

add ZL,TRAVAIL
ldi TRAVAIL,0
adc ZH,TRAVAIL

lpm
mov SORTIE,r0
com SORTIE
out PORTB,SORTIE

inc NUMERO_AFF
cpi NUMERO_AFF,16
brne CompteurFin
ldi NUMERO_AFF,0
CompteurFin:

out SREG,SAUVREG
pop SORTIE
pop TRAVAIL
pop ZH
pop ZL
reti


Reception:
cli
push TRAVAIL

in TRAVAIL,UDR
sts $70,TRAVAIL

pop TRAVAIL
reti
