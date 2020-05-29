		thumb 
		area moncode, code, readonly
		export timer_callback
GPIOB_BSRR	equ		0x40010C10
		extern variable
		extern etat
		
E_POS	equ	0
E_TAI	equ	4
E_SON	equ	8
E_RES	equ	12
E_PER	equ	16
	
TIM3_CCR3	equ	0x4000043C	; adresse registre PWM
GPIOB_BSRF	equ	0x40010C10

timer_callback proc
	; charge l'adresse de etat dans r2
		ldr 	r2,=etat
	; charge valeur de etat.position dans r0
		ldr		r0,[r2, #E_POS]
	; charge dans r1 la valeur de etat.taille
		ldr		r1, [r2, #E_TAI]
	; condition si r0==0 allez à cond
		cmp		r0, r1
		blt		cond
	; position>taille emettre silence
		push{r4, r5}
		mov		r4, #3
		ldr 	r5, =TIM3_CCR3
		str		r4, [r5]
		pop{r5, r4}
		bx		lr

	; position<taille incrementer position
cond	
	; stocke la valeur de etat.son à la bonne position dans r3
		ldr 	r3, [r2, #E_SON]
		ldrsh		r3, [r3, r0, LSL #1]
		push{r4, r5, r6, r7}
		; ajout composante continue
		add		r3, #32768
		; 1/65536 = 0.0000153 
		ldr		r6, [r2, #E_RES]
		mov		r7, #65536
		mul		r3, r6
		udiv	r3, r7
		
		; r5 = resolution/65336
		
		; (ax+b)*resolution/65335
		
		
		ldr 	r7, =TIM3_CCR3
		str		r3, [r7]
		
		add		r0, #1
		str		r0, [r2, #E_POS]
		pop{r7, r6, r5, r4}
		bx		lr

		endp
		end
	