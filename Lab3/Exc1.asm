 
.data
	msg1: .asciiz "Decida o número a ser calculado"
	msg2: .asciiz "Decida o número de iterações"

.text
main:

	#-----------------------------------------------------#
	# Recebendo do usuário o número que calcularemos a raiz
	#-----------------------------------------------------#
	
	li		$v0, 4			#comando 4:escrever sting
	la		$a0, msg1		#carregando um ponteiro para o endereço doq queremos escrever
	syscall
	
	li		$v0, 6			# comando 6: read float
    syscall
    move	$f1, $f0		#movendo para o reg f1 o valor inserido pelo usuário	
	
	
	#---------------------------------------------#
	# Recebendo do usuário o valor de iterações (n) 
	#---------------------------------------------#
	
	li		$v0, 4			#comando 4:escrever sting
	la		$a0, msg2		#carregando um ponteiro para o endereço doq queremos escrever
	syscall
	
	li		$v0, 5			# comando 5: read int
    syscall
    move	$t0, $v0		#movendo para o reg s0 o valor inserido pelo usuário		
    
    
    li		$f0, 1			#salvando o número 1 no reg f0 (valor inicial da estimativa)
    li		$t1, 0			#inicializando o contador de iterações
	jal		raiz_quadrada	#chama a função raiz quadrada
	 
	 
	 #--------------------------------------------------------#
	 # Função calcula raiz quadrada através do método de newton
	 #--------------------------------------------------------#
	 
	 raiz_quadrada:
	 	div		$f2, $f1, $f1	#x/estimativa
	 	add		$f3, $f2, $f0	#somando o resultado da linha anterior com a estimativa
	 	srl 	$f4, $f3, 1		#divindo por dois através de um shift right
	 	move	$f0, $f4		#movendo p reg da estimativa o novo valor da estimativa
	 	
	 	addi	$t1, $t1, 1		#adicionando um ao contador de iterações
	 	
	 	bne		$t1, $t0, raiz_quadrada	#if (numero de iterações != n inserido pelo usuario) then repete procedimento
	 	
	 
	 
	 sqrt.d 
	 	
	 	
	
	
	
	
	
	
