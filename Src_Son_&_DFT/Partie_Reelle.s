		thumb 
		area moncode, code, readonly
		export partie_reelle
	
partie_reelle proc
	; r0 adresse signal, r1 valeur k, r2 adresse tab
	mov		r3, #0x00
	push	{r6, r5}
	
DebutDeBoucle
; multiplication i par k
	mul		r12, r3, r1
	
; ik remis dans la plage 0..N-1 grâce à un modulo
	and 	r12, #63
	ldrsh	r12, [r2,r12, lsl #1]
	ldrsh	r5,	[r0, r3, lsl #1]
	mul		r12, r12, r5
	add		r6, r6, r12
	
; on enlève 1 à k jusqu'à ce qu'on arrive à 0
	add		r3, r3, #1
	cmp		r3, #64
	BNE		DebutDeBoucle
	
	mov		r0,r6
	pop		{r5, r6}
	bx		lr
	endp
	end