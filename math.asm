section .data
xa dq 16.45
xb dq 2.8
xc dq 5.1
xd dq 14.4

section .text
global _start

calca:
fld1	; jedynka na na wiercholek
fxch	; swap st0 i st1 na stosie
fyl2x	; st1  *ln st0
fldl2e ; ln(e)
fdivp	; st0=st1/st0
ret

calcb:
fldl2e	; ln(e)
fmulp ; st0 * st1
fld1	; jedynka na na wiercholek
fscale ;     1 * 2^ int(log_2( e*x))
fxch	; swap st0 i st1 na stosie
fld1	; jedynka na na wiercholek
fxch	; swap st0 i st1 na stosie
fprem ; reszta  st0 / st1
f2xm1 ; st0 = 2 ^ st0 -1
faddp ; st0 = st0+st1
fmulp ; e*x
ret

calcc:
fld st0	;duplicate st0 to st1
call calcb	; count e^x
fxch		; swap
fldz		; 0 na stos
fxch		; swap
fsubp		; odejmuje st1-st0
call calcb	; liczy -x
fsubp		; odejmuje	st1-st0
fld1	; 1 na stos
fld1	; 1 na stos
faddp	; uklad 2, licznik
fdivp	;dzielenie st1/st0
ret

calcd:
fld st0	;duplicate st0 to st1
fmul st0, st1	; st0= st0 *st1	?moze byc bez st0
fld1		; 1 na stos
faddp	;dodaj 1 do x*x
fsqrt	;pierwiastek
faddp	;dodaj x
call calca	; licz ln
ret


_start:

finit	; inicjalizacja koprecesora
fld qword [xa]	;wczytaj na stos zmiennoprzecinkowy stos +1
call calca
fstp qword [xa] ;wpisz do xa z wierzcholka stosu

finit
fld qword [xb]
call calcb
fstp qword [xb]

finit
fld qword [xc]
call calcc
fstp qword [xc]

finit
fld qword [xd]
call calcd
fstp qword [xd]

exit:
