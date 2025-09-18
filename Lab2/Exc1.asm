.data
	                   .align 4 # alinhamento de memória
       A:     .word 3, 14, 15
              .word 2, 6, 53
              .word 89, 79, 3
              .word 84, 62, 643
              
       C:     .word 0, 1, 2
              .word 3, 4, 5
              .word 6, 7, 8

              
       B:      .word 0:9
              

         m1:         .asciiz "\nDigite um número inteiro:\t"
         m2:         .asciiz "\nM[linha][coluna]:\t"
        
         tamanho:     .word 16    # tamanho da matriz
              
              
.text 
	jal matriz_imprime
	 j FIM
	
matriz_imprime:
 
    # configurações da pilha
    subu  $sp, $sp, 32   # reserva o espaço do frame ($sp)    
    sw    $ra, 20($sp)   # salva o endereço de retorno ($ra)    
    sw    $fp, 16($sp)   # salva o frame pointer ($fp)    
    addiu $fp, $sp, 28   # prepara o frame pointer    
    sw    $a0, 0($fp)    # salva o argumento ($a0)    
 
    li       $t0, 3       # $t0: número de linhas
           li       $t1, 3       # $t1: número de colunas
           move     $s0, $zero   # $s0: contador da linha
        move     $s1, $zero   # $s1: contador da coluna
        move     $t2, $zero   # $t2: valor a ser lido/armazenado
        
    imprime_matriz:    
        # calcula o endereço correto da Matriz B 
            mult     $s0, $t1    # $s2 = linha * numero de colunas 0
            mflo     $s2            # move o resultado da multiplicação do registrador lo para $s2 
            add      $s2, $s2, $s1  # $s2 += contador de coluna 0 + 1 
            sll      $s2, $s2, 2    # $s2 *= 4 (deslocamento 2 bits para a esquerda) para deslocamento de byte    
    
        # obtem o valor do elemento armazenado
        lw    $t2, B($s2)
        
        # calcula o endereço correto da Matriz C 
            
      # obtem o valor do elemento armazenado
        lw    $t3, C($s3)
        
        
    
        # imprime no console o valor do elemento da matriz
        li     $v0, 4   
        la     $a0, m2
        syscall     
        li     $v0,1    
        move     $a0, $t3
        syscall 
            
            # incrementa o contador
            addi     $t2, $t2, 1 
      
              addi     $s1, $s1, 1            # incrementa contador de coluna
        bne      $s1, $t1, imprime_matriz       # não é o fim da linha então LOOP
        move     $s1, $zero             # reseta o contador da coluna
        addi     $s0, $s0, 1            # increment row counter
        bne      $s0, $t0, imprime_matriz      # não é o fim da matriz então LOOP
        jr $ra
        
       # configurações do procedimento    
    add     $v0, $s1, $zero # retorna para quem chamou    
    jr     $ra     
    
   FIM: 
        li $v0, 10        
        syscall    	
