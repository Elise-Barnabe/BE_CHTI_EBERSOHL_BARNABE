		thumb 
		area moncode, code, readonly
		export somme
		import TabSin
		import TabCos
			
somme proc
	ldr		r2, =TabCos
	ldrsh		r1, [r2,r0, lsl #1]
	mul		r3, r1, r1
	ldr		r2, =TabSin
	ldrsh		r1, [r2, r0, lsl #1]
	mul		r12, r1, r1
	add 	r3, r12
	bx		lr
	
	endp
	end