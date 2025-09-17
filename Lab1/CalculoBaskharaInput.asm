#Realizando o cálculo da fórmula de Bhaskhara com números digitados no terminal

.data 
	mem1: .asciiz "Digite um numero para a"
	mem2: .asciiz "Digite mais um  numero para b"
	mem3: .asciiz "Digite mais um  numero para c"
	memresult1: .asciiz "Resultado de X1 \n"
	memresult2: .asciiz "Resultado de X2 "
	newline: .asciiz "\n"
	
	a : .word 1
	b : .word -5
	c : .word 6

.text
main:

	li 	      $v0, 4       #Comando
	la 	      $a0, mem1    #Carrega string (endereço).
	syscall
	
	li 	      $v0, 5       #Comando para ler inteiro.
	syscall
	move 	  $t1, $v0
	
	li 	      $v0, 4       #Comando.
	la 	      $a0, mem2    #Carrega string (endereço).
	syscall
	
	li 	      $v0, 5       #Comando para ler inteiro.
	syscall
	move 	  3$t0, $v0
	
	li 	      $v0, 4       #Comando
	la 	      $a0, mem3    #Carrega string (endereço).
	syscall
	
	li 	      $v0, 5       #Comando para ler inteiro.
	syscall
	move 	  $t2, $v0
	
	#Registradores $t0 até $t2 para variaveis 
	
	mul 	  $t4, $t0, $t0        #b²
	
	sll       $t5, $t1,  2 		   #4a
	
	mul       $t6 , $t2 , $t5 	   #4a . c
	
	sub       $t7 , $t4 , $t6	   #b² - 4ac
	
	mtc1      $t7, $f1		       #converte int para float
	cvt.s.w   $f1, $f1
	
	sqrt.s    $f2,$f1		      #raiz quadrada 
	
	cvt.w.s   $f3, $f2            #converte o float em $f0 para inteiro no formato float em $f2
	mfc1      $t8, $f3            #move o valor inteiro de $f2 para $t0
	
	neg       $t9,  $t0	          #converte b para -b
	
	#x1
	add       $t3, $t9, $t8
	sll       $t4, $t1,  1       #2a
	div       $t5, $t3,  $t4
	
	#espaco
	li        $v0, 4             #código da syscall para imprimir string
	la        $a0, newline       #carrega o endereço da string "\n"
	syscall   
	
	#x2 
	sub       $t3, $t9, $t8
	sll       $t4, $t1, 1        #2a
	div       $t6, $t3, $t4
	
	
	li 	      $v0, 4             #Comando.
	la 	      $a0, memresult1    #Carrega string (endereço).
	syscall
	
	move 	  $a0, $t5
	li 	      $v0, 1
	syscall
	
	li 	      $v0, 4             #Comando.
	la 	      $a0, memresult2    #Carrega string (endereço).
	syscall
	
	move	  $a0, $t6
	li		  $v0, 1
	syscall
