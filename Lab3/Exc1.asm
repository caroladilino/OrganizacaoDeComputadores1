.data
	msg1: .asciiz "Decida o número a ser calculado"
	msg2: .asciiz "Decida o número de iterações"
	
	numeroUm: .float 1.00
	numeroDois: .float 2.00

.text
main:

	#--------------------------------------------------------#
	# Recebendo do usuário o número que calcularemos a raiz
	#--------------------------------------------------------#
	
	li		$v0, 4			# comando 4:escrever sting
	la		$a0, msg1		# carregando um ponteiro para o endereço doq queremos escrever
	syscall
	
	li		$v0, 6			# comando 6: read float
    syscall
    mov.d  	$f2, $f0		# movendo para o reg f2 o valor inserido pelo usuário	
	
	
	#---------------------------------------------#
	# Recebendo do usuário o valor de iterações (n) 
	#---------------------------------------------#
	
	li		$v0, 4			#comando 4:escrever sting
	la		$a0, msg2		#carregando um ponteiro para o endereço doq queremos escrever
	syscall
	
	li		$v0, 5			# comando 5: read int
    syscall
    mov.d  	$f4, $f0		#movendo para o reg f4 o valor inserido pelo usuário		
    
    
    l.d  	$f6, numeroUm	#salvando o número 1 no reg f5 (valor inicial da estimativa)
    l.s 	$f14, numeroDois
    li		$t1, 0			#inicializando o contador de iterações
	jal		raiz_quadrada	#chama a função raiz quadrada
	 
	 
	 #--------------------------------------------------------#
	 # Função calcula raiz quadrada através do método de newton
	 #--------------------------------------------------------#
	 
	 raiz_quadrada:
	 	div.d 	$f8, $f2, $f4		# x/estimativa
	 	add.d 	$f10, $f8, $f6		# somando o resultado da linha anterior com a estimativa
	 	div.d  	$f12, $f10, $f14	# divindo por dois
	 	mov.d 	$f6, $f12			# movendo p reg da estimativa o novo valor da estimativa
	 	
	 	addi	$t1, $t1, 1				#adicionando um ao contador de iterações
	 	
	 	bne		$t1, $t0, raiz_quadrada	#if (numero de iterações != n inserido pelo usuario) then repete procedimento
	 	
	
	mov.d 	$f12, $f6
	li		$v0, 2			# comando 2:escrever float
	syscall
	 	
	 	
	
	
	
	
	
	
