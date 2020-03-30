		thumb 
		area moncode, code, readonly
		export partie_reelle
		import TabCos
		

partie_reelle proc
	; r0 adresse signal, r1 valeur k, r2 adresse tab
	mov		r3, #8
	
DebutDeBoucle
; multiplication i par k
	mul		r12, r3, r1
; ik remis dans la plage 0..N-1 gr�ce � un modulo
	and 	r12, #8
	push	{r6}
	push	{r4}
	push	{r5}
	ldr		r4, =TabCos
	ldrsh	r12, [r4,r12, lsl #1]
	ldrsh	r5,	[r0, r3, lsl #1]
	mul		r12, r12, r5
	add		r6, r6, r12
	
; on enl�ve 1 � k jusqu'� ce qu'on arrive � 0
	subs	r3, r3, #1
	BNE		DebutDeBoucle
	
	mov		r0,r6
	pop		{r5}
	pop		{r4}
	pop		{r6}
	bx		lr
	endp
	end