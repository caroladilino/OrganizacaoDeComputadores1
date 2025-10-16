.data

	newline: .asciiz "\n"
	

	msg3: .asciiz "Digite o tamanho do vetor:"
	msg4: .asciiz "Digite "
	msg5: .asciiz " números para o vetor:"
	msg6: .asciiz "Digite o número a procurar: "
	
	msgAchamos: .asciiz "Número encontrado!"
	msgNaoAchamos: .asciiz "Número não encontrado."
	
	.align 2
	array: .space 400

.text
#------------------------------------------------------#
# Programa 2
#------------------------------------------------------#
	
	#escevendo a msg no terminal
	li		$v0, 4			# comando 4:escrever sting
	la		$a0, msg3		# carregando um ponteiro para o endereço doq queremos escrever
	syscall
	
	
	#lendo a resposta do teclado
	li		$v0, 5			# comando 5: read int
    syscall
    move	$t0, $v0		# movendo o valor pro reg t0
    
    #int array[size]
    
    
    #"digite"
    li		$v0, 4			
	la		$a0, msg4		
	syscall
    
    # "X"
	li		$v0, 1			
	move  	$a0, $t0		
	syscall
	
	# " números para o vetor:"
	li		$v0, 4			
	la		$a0, msg5		
	syscall
	
	#new line
	li		$v0, 4			
	la		$a0, newline	
	syscall
	
	li		$t1, 0			# inicializando i
	la		$a2, array		# ponteiro pro inicio do array 
	la		$a3, array		# ponteiro móvel do array
	
	loop_preenchimento:
		#lendo a resposta do teclado
		li		$v0, 5			
   	 	syscall
    	move	$t2, $v0
    	
    	sw  	$t2, 0($a3)		#salvando na posição atual do array o valor digitado
		addi	$a3, $a3, 4		#indo pro próximo endereço do array
		
		addi	$t1, $t1, 1		#i++
		bne		$t1, $t0, loop_preenchimento	#se (i != do tamanho do vetor) repete o loop
		
		
	# printando a prox msg
	li		$v0, 4			
	la		$a0, msg6		
	syscall
	
	#lendo a resposta do teclado
	li		$v0, 5			
    syscall
    move	$t3, $v0
    
    li		$t4, 0	# inicializando found
    li		$t5, 0	#i
    
    
    loop_procurar:
    	
    	lw 		$t6, 0($a2)		#carregando em t6 o valor do endereço do array
		beq 	$t6, $t3, achamos
        	
    	addi	$a2, $a2, 4		#indo pro prox item do array
    	addi	$t5, $t5, 1		#i++
    	bne		$t5, $t0, loop_procurar	# caso (i != tamanho do array) repete o loop
    	
    	la	$a0, msgNaoAchamos
    	j	final		#caso não tenha achado, vai direto pro final
    	
    achamos:	
		li		$t4, 1	
		la		$a0, msgAchamos 	
	
	final:
		li		$v0, 4
		syscall
