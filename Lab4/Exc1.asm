.data
	msg1: .asciiz "Digite o limite do contador: "
	msg2: .asciiz "Contador: "
	newline: .asciiz "\n"

	dois: .word 2

.text
	
	#escevendo a msg no terminal
	li		$v0, 4			# comando 4:escrever sting
	la		$a0, msg1		# carregando um ponteiro para o endereço doq queremos escrever
	syscall
	
	
	#lendo a resposta do teclado
	li		$v0, 5			# comando 5: read int
    syscall
    move		$s0, $v0		#movendo o valor pro reg s0
    
    
    #inicializando variáveis
    li		$t0, 0			# inicializando a variável count
    li		$t4, 0			# inicializando i
    li		$t5, 0			# munero 0
    lw		$t2, dois		# carregando o número dois
    
    
    loop_for:
    	div		$t4, $t2	#dividindo i por dois
    	mfhi 	$t3			#salvando em t3 o resto da divisão
    	
    	
    	bne 	$t3, $t5, final_loop	#caso (i % 2) != 0, pular a parte seguinte
		
		addi	$t0, $t0, 1		# count++
		
		li		$v0, 4			# comando 4:escrever sting
		la		$a0, msg2		# carregando um ponteiro para o endereço doq queremos escrever
		syscall
		
		li		$v0, 1			# comando 1: escrever int
		move  	$a0, $t0		# movendo para a0 o que queremos escrever
		syscall
		
		li		$v0, 4			# comando 4:escrever sting
		la		$a0, newline	# carregando um ponteiro para o endereço doq queremos escrever
		syscall
		
	
		final_loop:
			addi	$t4, $t4, 1		# somando 1 ao i
			bne		$t4, $s0, loop_for
	
