.data
	msg1: .asciiz "Decida o número a ser calculado: "
	msg2: .asciiz "Decida o número de iterações: "
	msgdebug: .asciiz " loop rodou "
	espaco: .asciiz "  "
	
	numeroUm: .double 1.00
	numeroDois: .double 2.00


.text
main:

	#--------------------------------------------------------#
	# Recebendo do usuário o número que calcularemos a raiz
	#--------------------------------------------------------#
	
	li		$v0, 4			# comando 4:escrever sting
	la		$a0, msg1		# carregando um ponteiro para o endereço doq queremos escrever
	syscall
	
	li		$v0, 6			# comando 6: read double
    syscall
    
    mov.d	$f12, $f0
   

	#---------------------------------------------#
	# Recebendo do usuário o valor de iterações (n) 
	#---------------------------------------------#
	
	li		$v0, 4			#comando 4:escrever sting
	la		$a0, msg2		#carregando um ponteiro para o endereço doq queremos escrever
	syscall
	
	li		$v0, 5			# comando 5: read int
    syscall
    move 	$a0, $v0		#movendo para o reg a0 o valor inserido pelo usuário (p/ passar como parâmetro)	
    	
    
    
    l.d  	$f6, numeroUm	#salvando o número 1 no reg f6 (valor inicial da estimativa)
    l.d 	$f14, numeroDois
    li		$a1, 0			#inicializando o contador de iterações como parâmetro
    
	sqrt.d $f20, $f12
    
    
	jal		raiz_quadrada	#chama a função raiz quadrada
	

	
	mov.d 	$f12, $f0		#movedo para f12 o valor de retorno da função
	li		$v0, 3			# comando 2:escrever double
	syscall
	
	li		$v0, 4			# comando 4:escrever sting
	la		$a0, espaco		# carregando um ponteiro para o endereço doq queremos escrever
	syscall
	
	mov.d 	$f12, $f20
	li		$v0, 3			# comando 2:escrever double
	syscall
	 
	li		$v0, 10
	syscall
	 
	 #------------------------------------------------------------#
	 # Função calcula raiz quadrada através do método de newton 
	 #------------------------------------------------------------#
	 
	 raiz_quadrada:
	 	div.d  	$f8, $f12, $f6		# x/estimativa
	 	add.d 	$f10, $f8, $f6		# somando o resultado da linha anterior com a estimativa
	 	div.d  	$f16, $f10, $f14	# divindo por dois		
	 	
	 	mov.d 	$f6, $f16			# movendo p reg da estimativa o novo valor da estimativa
	 	
	 	addi	$a1, $a1, 1				#adicionando um ao contador de iterações
	 	bne		$a1, $a0, raiz_quadrada	#if (numero de iterações != n inserido pelo usuario) then repete procedimento
	 	
	 	mov.d	$f0, $f6				#movendo pro reg de retorno de double o valor da estimativa
	 	
	 	jr	$ra

	 	
	 	
	
	
	
	
	
	
