		thumb 
		area moncode, code, readonly
		export timer_callback
GPIOB_BSRR	equ		0x40010C10
		extern variable

timer_callback proc
	;charge l'adresse variable dans r2
		ldr 	r2,=variable
	; charge valeur de variable dans r0
		ldr		r0,[r2]
	; condition si r0==0 allez à cond
		cbnz		r0, cond
	
	;mise à 0

	
		ldr		r3, =GPIOB_BSRR
	;on met ce qu'il y a dans r2 dans r1 donc adresse variable
		mov		r1, #0x00000002
	;store ce qu'il y a dans r1 vers r3 adresse variable dans r3
		str		r1, [r3]
	;on met r1 à 1
		mov 	r1, #1
	; on met 1 dans variable
		str 	r1,[r2]
		bx		lr
		
cond	ldr 	r3, =GPIOB_BSRR
		mov		r1, #0x00020000
		str		r1, [r3]
		mov  	r1,#0
		str		r1,[r2]
		bx		lr

		endp
		end
	