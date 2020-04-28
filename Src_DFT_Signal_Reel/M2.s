		thumb 
		area moncode, code, readonly
		export M2
		import TabSin
		import TabCos
		import partie_reelle
			
M2 proc
	; r0 adresse signal, r1 k
	push	{lr,r4, r7, r9, r0} ; empilage de r0
	; dans r2 on met la table de cos
	ldr		r2, =TabCos ; 1.15
	; on appelle partie réelle dont le résultat est dans r0
	bl 		partie_reelle ; sortie en 5.27 ( car signal en 4.12 et cos ou sin en 1.15)
	; on met dans r7,r9 le résultat de partie reelle au carré
	smull		r7, r9, r0, r0
	;on depile r0 pour recuperer sa valeur initiale
	pop 	{r0}
	; dans r2 on met la table de sin
	ldr		r2, =TabSin
	; on appelle partie imaginaire ( c'est partie reelle mais avec tab sin)
	bl		partie_reelle
	; on met/ ajoute dans r7,r9 la partie imaginaire au carré
	smlal		r7, r9, r0, r0
	; on met le résultat en r0
	mov		r0, r9
	pop		{r9, r7, r4, pc}
	bx		lr
	
	endp
	end