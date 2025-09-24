#Objetivo do programa: dada as matrizes A e B, calcular A*B^t e disponibilizar essa matriz em um arquivo .txt cujo nome é escolhido pelo usuário
#Projeto em dupla com Ana Julia Botega

.data
A: .word 1, 2, 3,
          0, 1, 4,
          0, 0, 1

B: .word 1, -2, 5,
          0,  1, -4,
          0,  0,  1

C: .word 0, 0, 0,
          0, 0, 0,
          0, 0, 0       # transposta de B

D: .word 0, 0, 0,
          0, 0, 0,
          0, 0, 0       # resultado A × C	
          
ascii_buffer: .space 64  #aloca 64 bytes de memoria para o buffer
filename: .space 32 #aloca 32 bots pro nome do arquivo
buffer_temp: .space 10 #para a inversão dos digitos
extensao: .asciiz ".txt"



.text
.globl main

main:
    
    	la   $a0, A         # arg1 = endereço de A
    	la   $a1, B         # arg2 = endereço de B
    	la   $a2, D         # arg3 = endereço de D
    	li   $a3, 3         # arg4 = dimensão n=3
    	
    	jal  PROC_MUL	    # Chama PROC_MUL(A, B, D)
    	
 
	jal  PROC_NOME	#chama a função para nomear o arquivo
	
	la	$s2, D				#carregando o endereço de inicio de D em s2
	li	$t5, 0				#contador de iterações
	li	$t6, 9				#carregando 9 em t9
	la	$s0, ascii_buffer	#salvar o endereço do buffer em s0
	la	$s1, buffer_temp	#salva o endereco do buffer temporario/auxiliar
	li 	$t8, 0				#contador de bytes do buffer principal
	li	$t7, 0				#contador de bytes do buffer temporario
		
	matriz_loop:
		beq	$t5, $t6, buffer_done	#checando se já percorremos toda a matriz
		
		lw   $t0, 0($s2)        #valor numerico armazenado no endereço
    		move $t9, $t0    	#passando esse valor pro t9       
    		li   $t2, 10		#botando 10 em t2

		bgez 	$t9, convert_loop
    			addi 	$t3, $zero, 45    # printando o "-"
    			sb 	$t3, 0($s0)    # store ASCII char in buffer
    			addi 	$s0, $s0, 1    # ir pro proximo espaço do buffer
    			addi 	$t8, $t8, 1        # contador de bytes no buffer
    			
    			neg	$t9, $t9	#transformando o numero em positivo
    		
    		convert_loop:
    			divu 	$t9, $t2        # dividindo o item atual da matriz por 10
    			mfhi 	$t3             # resto = digito atual
    			mflo 	$t4             # quociente = prox numero

    			#Convert digit to ASCII
    			
    			addi 	$t3, $t3, 48    # somar o ultimo digito com 48 do ASCII
    			move 	$t9, $t4		#carregando em t9 o proximo digito para repetir o loop com ele
			
			sb	$t3, 0($s1)		#salvando o caracter em ascii no buffer auxiliar
			addi 	$s1, $s1, 1
			addi	$t7, $t7, 1 	# contador de bytes no buffer auxiliar
			
    			bne  $t9, $zero, convert_loop #se o numero tiver mais de um digito, roda dnv
			
			
			saving_loop:
			
			addi	$s1, $s1, -1	#voltando uma casa no buffer auxiliar
			addi	$t7, $t7, -1 	# contador de bytes no buffer auxiliar
			lb 	$t1, 0($s1)	#armazenando em t1 o valor do digito
			
			sb 	$t1, 0($s0)    # store ASCII char in buffer
    			addi 	$s0, $s0, 1    # ir pro proximo espaço do buffer
    			addi 	$t8, $t8, 1        # contador de bytes no buffer
    			
    			bne	$t7, $zero, saving_loop #se ainda tiver digitos no buffer auxiliar, roda dnv
    			
			
			beq $t5, 2, prox_linha
			beq $t5, 5, prox_linha
			beq $t5, 8, prox_linha
		
			
  			li $t9, 32      # ASCII do espaço
			sb $t9, ($s0)
			addi $s0, $s0, 1	#endereço do buffer principal
			addi 	$t8, $t8, 1        # contador de bytes no buffer

			
  			addi	$t5, $t5, 1	#incrementando 1 ao nosso contador
  			addi	$s2, $s2, 4	#somando 4 ao endereço de D, isso vai nos dar o prox numero

  			la $s1, buffer_temp	#resetando o ponteiro do inicio do buffer temporario e de deu contador
			li $t7, 0
    			j matriz_loop		#passar pro próximo numero da matriz
    			
    			prox_linha:
    				li $t9, 10      # ASCII do \n
				sb $t9, ($s0)
				addi $s0, $s0, 1
				addi 	$t8, $t8, 1  
				
				addi	$t5, $t5, 1	#incrementando 1 ao nosso contador
  				addi	$s2, $s2, 4	#somando 4 ao endereço de D, isso vai nos dar o prox numero
				
				j	matriz_loop
    			
    			
    		
    	buffer_done:
    	
  
		li $t0, 0
		sb $t0, 0($s0)
		#abrindo o arquivo para a escrita
		li 	$v0, 13		#Comando para abrir um novo arquivo
		la	$a0, filename	#Carrega o nome do arquivo a ser aberto
		li	$a1, 1		#Aberto para a escrita
		li	$a2, 0
		syscall
		move	$s6, $v0	#Salva o descritor do arquivo
	
		#escrever no arquivo aberto
		
		li 	$v0, 15		
		move	$a0, $s6	#descritor do arquivo é passado	
		la	$a1, ascii_buffer	#o que vai ser escrito
		move $a2, $t8	#tamanho do buffer = contador t8
		syscall
		
		#fechar o arquivo
		li	$v0, 16		#comando para fechamento do arquivo
		move	$a0, $s6	#descritor do arquivo é passado
		syscall			#arquivo é fechado pelo sistema operacional
	
	
    		# Encerrar programa
    		li   $v0, 10
    		syscall

# -------------------------------------------------------
# PROC_MUL(A, B, D, n)
# -------------------------------------------------------
PROC_MUL:
    addi $sp, $sp, -12
    sw   $ra, 8($sp)
    sw   $s0, 4($sp)
    sw   $s1, 0($sp)

    move $s0, $a0   # s0 = A
    move $s1, $a2   # s1 = D
    move $t7, $a3   # t7 = n

    # Chama PROC_TRANS(B, C, n)
    la   $a0, B
    la   $a1, C
    move $a2, $t7
    jal  PROC_TRANS

    # Agora C já está transposta de B
    la   $t0, C     # base de C
    move $t1, $s0   # base de A
    move $t2, $s1   # base de D
    move $t3, $t7   # n

    li   $t4, 0     # i
for_i:
    beq  $t4, $t3, fim_mul

    li   $t5, 0     # j
for_j:
    beq  $t5, $t3, fim_j

    li   $t6, 0     # acumulador soma
    li   $t8, 0     # k
    li   $t8, 0     # k
for_k:
    beq  $t8, $t3, fim_k   # se k == n, sai do loop

    # A[i][k]
    mul  $t9, $t4, $t3
    add  $t9, $t9, $t8
    sll  $t9, $t9, 2
    add  $t9, $t1, $t9
    lw   $s2, 0($t9)

    # C[k][j]
    mul  $t9, $t8, $t3
    add  $t9, $t9, $t5
    sll  $t9, $t9, 2
    add  $t9, $t0, $t9
    lw   $s3, 0($t9)

    # soma parcial
    mul  $t9, $s2, $s3
    add  $t6, $t6, $t9

    addi $t8, $t8, 1
    j for_k

fim_k:

    # D[i][j] = soma
    mul  $t9, $t4, $t3
    add  $t9, $t9, $t5
    sll  $t9, $t9, 2
    add  $t9, $t2, $t9
    sw   $t6, 0($t9)

    addi $t5, $t5, 1
    j for_j
fim_j:
    addi $t4, $t4, 1
    j for_i
fim_mul:

    lw   $ra, 8($sp)
    lw   $s0, 4($sp)
    lw   $s1, 0($sp)
    addi $sp, $sp, 12
    jr   $ra

# -------------------------------------------------------
# PROC_TRANS(B, C, n)
# -------------------------------------------------------
PROC_TRANS:
    li   $t0, 0        # i
loop_i:
    beq  $t0, $a2, end_trans
    li   $t1, 0        # j
loop_j:
    beq  $t1, $a2, end_j

    # B[i][j]
    mul  $t2, $t0, $a2
    add  $t2, $t2, $t1
    sll  $t2, $t2, 2
    add  $t2, $a0, $t2
    lw   $t3, 0($t2)

    # C[j][i] = B[i][j]
    mul  $t2, $t1, $a2
    add  $t2, $t2, $t0
    sll  $t2, $t2, 2
    add  $t2, $a1, $t2
    sw   $t3, 0($t2)

    addi $t1, $t1, 1
    j loop_j
end_j:
    addi $t0, $t0, 1
    j loop_i
end_trans:
    jr $ra

# -------------------------------------------------------
# PRINT_MAT(mat, n)
# -------------------------------------------------------
PRINT_MAT:
    move $t0, $a0   # base da matriz
    move $t1, $a1   # n
    li   $t2, 0     # i

print_i:
    beq  $t2, $t1, fim_print

    li   $t3, 0     # j
print_j:
    beq  $t3, $t1, fim_print_j

    mul  $t4, $t2, $t1
    add  $t4, $t4, $t3
    sll  $t4, $t4, 2
    add  $t4, $t0, $t4
    lw   $t5, 0($t4)

    # print int
    move $a0, $t5
    li   $v0, 1
    syscall

    # print space
    li   $a0, 32
    li   $v0, 11
    syscall

    addi $t3, $t3, 1
    j print_j
fim_print_j:
    # print newline
    li   $a0, 10
    li   $v0, 11
    syscall

    addi $t2, $t2, 1
    j print_i
fim_print:
    jr $ra
 
 
#----------------------------------------
#PROC_NOME
#----------------------------------------
PROC_NOME:
    	# Leitura do nome do arquivo 
	li   $v0, 8            # syscall 8 = read string
    	la   $a0, filename     # endereço de destino
    	li   $a1, 28           # deixar espaço para a extensão ".txt"
    	syscall

    	# Remover o '\n' (newline) se estiver presente
	la   $t0, filename     # ponteiro para o buffer do nome
remover_enter:
    	lb   $t1, 0($t0)
    	beq  $t1, 10, substituir_zero   # se for '\n', substitui pelo caractere do fim
    	beq  $t1, 0, fim_remover        # se já for o caractere do fim, acaba
    	addi $t0, $t0, 1
    	j    remover_enter		#repetir o loop, ir pro prox caractere

substituir_zero:
    	li   $t1, 0
    	sb   $t1, 0($t0)
    	j    fim_remover

fim_remover:

    	# Adiciona a extensão ".txt"
    	la   $t0, filename         # ponteiro para início do nome
	achar_fim:
    		lb   $t1, 0($t0)
    		beq  $t1, 0, pronto_para_anexar
    		addi $t0, $t0, 1
    		j    achar_fim

	pronto_para_anexar:
    		la   $t2, extensao         # ponteiro para ".txt"
	copiar_extensao:
    		lb   $t3, 0($t2)
    		sb   $t3, 0($t0)
    		beq  $t3, 0, fim_copia_extensao
   		addi $t0, $t0, 1
    		addi $t2, $t2, 1
    		j    copiar_extensao

fim_copia_extensao:
    jr   $ra


