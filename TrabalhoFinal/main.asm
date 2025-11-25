.data
#----------------------------#
#			MENSAGENS
#----------------------------#
    mem_inicio : .asciiz "\n\nESCOLHA SUA BEBIDA \nCafé puro (1)\nCafé com leite (2) \nMoccachino (3) \nEncerrar compra (13)"
    mem_EscTamanho : .asciiz "\n\nESCOLHA O TAMANHO \nPequeno (4)\nGrande (5)"
    mem_EscAcucar : .asciiz "\n\nGOSTARIA DE ACUCAR \nSim (6)\nNao (7)"
    memEscCafe : .asciiz "\nBEBIDA SELECIONADA : CAFE"
    memEscLeite : .asciiz "\nVOCE ESCOLHEU : CAFE COM LEITE"
    memEscMoca : .asciiz "\nVOCE ESCOLHEU : MOCA"
    memEscTamPeq:.asciiz "\nVOCE ESCOLHEU : TAMANHO PEQUENO"
    memEscTamGra:.asciiz "\nVOCE ESCOLHEU : TAMANHO GRANDE"
    memEscAcucarSim : .asciiz "\nVOCE ESCOLHEU : QUERO ACUCAR"
    memEscAcucarNao : .asciiz "\nVOCE ESCOLHEU : NAO QUERO ACUCAR"
    memDosagemLeite : .asciiz "\nQUANTIDADE DE LEITE DISPONIVEL : "
    memDosagemCafe : .asciiz "\n\nQUANTIDADE DE CAFE DISPONIVEL : "
    memDosagemChocolate : .asciiz "\nQUANTIDADE DE CHOCOLATE DISPONIVEL : "
    memDosagemAcucar : .asciiz "\nQUANTIDADE DE ACUCAR DISPONIVEL : "
    memAcabou : .asciiz "\nINGREDIENTE(S) FALTANDO! , PARA REABASTECER APERTE 8: "
    memReabastecer : .asciiz "\nQUAL ITEM VOCE QUER REABASTECER?: \nCafé (9) \nLeite (10) \nChocolate(11) \nAcucar(12)"
    memReaCafe : .asciiz "\nCafé agora tem 20 doses"
    memReaLeite : .asciiz "\nLeite agora tem 20 doses"
    memReaChoco : .asciiz "\nChocolate agora tem 20 doses"
    memReaAcucar : .asciiz "\nAcucar agora tem 20 doses"
    memDosagem: .asciiz "\n\nliberando as doses"
    memValvula: .asciiz "\nliberando a válvula de água"
    
    filename: .asciiz "Recibo.txt"
    memTituloRecibo: .asciiz "                    Maquina de cafe - Trabalho final Organizacao de Computadores                    \n"
	memAutores: .asciiz "                            Autores: Ana Julia Botega e Carolina Adilino                            \n\n"
	memLinha: .asciiz "----------------------------------------------------------------------------------------------------\n"
	memCabecalho: .asciiz 	"#Cód                                  Descricao                                                Valor\n"
	
	memReciboCafePeq:		"01                                    Café Puro Pequeno                                      R$ 2,00\n"
	memReciboCafeLeitePeq:	"02                                    Café com leite Pequeno                                 R$ 3,00\n"
	memReciboMocaPeq:		"03                                    Moccachino Pequeno                                     R$ 6,00\n"
	memReciboCafeGra:		"04                                    Café Puro Grande                                       R$ 4,00\n"
	memReciboCafeLeiteGra:	"05                                    Café com leite Grande                                  R$ 6,00\n"
	memReciboMocaGra:		"06                                    Moccachino Grande                                     R$ 12,00\n"
	memTerminouCompra: .asciiz "\n\nObrigado por comprar conosco!\nColete seu recibo e volte sempre\n"
	
#----------------------------#
#			VARIÁVEIS
#----------------------------#
	
    dose : .word 4
    read_keyboard:   .word 0xFFFF0014
    line:            .word 0xFFFF0012

tabela_codigos:
    .byte 0x11,0x21,0x41,0x81
    .byte 0x12,0x22,0x42,0x82
    .byte 0x14,0x24,0x44,0x84
    .byte 0x18,0x28,0x48,0x88

tabela_valores:
    .byte 0,1,2,3
    .byte 4,5,6,7
    .byte 8,9,10,11
    .byte 12,13,14,15
    
tabela7seg:
    .byte 0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F


.text 
.globl main

main:

	#abrindo o arquivo para a escrita
	li 	$v0, 13			#Comando para abrir um novo arquivo
	la	$a0, filename	#Carrega o nome do arquivo a ser aberto
	li	$a1, 1			#Aberto para a escrita
	li	$a2, 0
	syscall
	move	$s7, $v0	#Salva o descritor do arquivo
	
	
	#escrever no arquivo aberto nosso titulo
	li 		$v0, 15		
	move	$a0, $s7				#descritor do arquivo é passado	
	la		$a1, memTituloRecibo	#o que vai ser escrito
	li 		$a2, 101				#tamanho do buffer 
	syscall
	
	#escrever no arquivo aberto os autores
	li 		$v0, 15		
	move	$a0, $s7			#descritor do arquivo é passado	
	la		$a1, memAutores		#o que vai ser escrito
	li 		$a2, 102			#tamanho do buffer 
	syscall
	
	#escrever no arquivo aberto a linha pontilhada
	li 		$v0, 15		
	move	$a0, $s7			#descritor do arquivo é passado	
	la		$a1, memLinha		#o que vai ser escrito
	li 		$a2, 101			#tamanho do buffer 
	syscall
	
	#escrever no arquivo aberto o Cabeçalho
	li 		$v0, 15		
	move	$a0, $s7			#descritor do arquivo é passado	
	la		$a1, memCabecalho	#o que vai ser escrito
	li 		$a2, 101			#tamanho do buffer 
	syscall

	li $s3 , 20 #Quantidade de cafe
	li $s4 , 20 #Qunatidade de leite
	li $s5 , 20 #Quantidade de chocolate
	li $s6 , 20 #Qauntidade de acucar 
	
inicio:	
	#PRINTA MENSAGEM ESCOLHA SUA BEBIDA
	li 	      $v0, 4     
	la 	      $a0, mem_inicio    
	syscall
	
loop_principal:
    li  $s0, 0            # zera acumulador antes de nova entrada
    
coleta_loop:
    # --- rotina de leitura de tecla (varredura) ---
    lw  $t1, read_keyboard
    lw  $t0, line
    li  $t3, 1
    
lendo_teclado:
    sb  $t3, 0($t0)
    lb  $t4, 0($t1)
    bne $t4, $zero, tecla_detectada
    sll $t3, $t3, 1
    ble $t3, 8, lendo_teclado
    j   coleta_loop        # continua coletando
    
# --- tecla detectada: traduz para índice (0..15) ---
tecla_detectada:
    li  $t3, 0
    la  $t5, tabela_codigos
    
traduzir:
    lb  $t6, 0($t5)
    beq $t6, $t4, encontrou
    addi $t3, $t3, 1
    addi $t5, $t5, 1
    blt $t3, 16, traduzir
    j   coleta_loop        # não encontrada -> volta
    
encontrou:
    la  $t7, tabela_valores
    add $t7, $t7, $t3
    lb  $t9, 0($t7)        # t9 = valor 0..15

    # Se t9 == 10 (tecla 'A'), trata como ENTER
    li  $t8, 12
    beq $t9, $t8, terminou_coleta
    
    # Se t9 <= 9 -> é dígito decimal, acumula: s0 = s0*10 + t9
    li  $t6, 9
    ble $t9, $t6, acumula_decimal
    # Se for A-F mas não enter, ignora (ou trate como erro)
    j   espera_solta

acumula_decimal:
    # s0 = s0 * 10
    li  $t2, 10
    mul $s0, $s0, $t2    # pseudo-instr mul disponível no MARS
    addu $s0, $s0, $t9   # s0 += digit
    # (opcional) imprimir o dígito ecoado:
    li  $a0, '0'
    add $a0, $a0, $t9
    li  $v0, 11
    syscall

espera_solta:
    # espera liberação da tecla
    lb  $t4, 0($t1)
    bne $t4, $zero, espera_solta
    j   coleta_loop

terminou_coleta:
    # tecla ENTER detectada -> chama rotina para usar o número em $s0
    jal processa_num
    # após processar, volta para início e permite nova entrada
    j   loop_principal


# rotina de exemplo: processa_num (aqui apenas imprime inteiro no console)
processa_num:
	addi $sp, $sp, -4
    sw $ra, 0($sp)
   
    beq $s0 , 1 , cafe_puro
    beq $s0 , 2 , cafe_com_leite
    beq $s0 , 3 , moca
    beq $s0 , 4 , pequeno
    beq $s0 , 5 , grande
    beq $s0 , 6 , acucarSim
    beq $s0 , 7 , acucarNao
    beq $s0 , 8 , reabastecer
    beq $s0 , 9 , reabastecer_cafe
    beq $s0 , 10 , reabastecer_leite
    beq $s0 , 11, reabastecer_choco
    beq $s0 , 12 , reabastecer_acucar
    
    move	$a0, $s7	#mandando o descritor do arq como argumento
    beq 	$s0, 13, finalizar_compra
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    
    jr $ra
reabastecer : 
	li 	      $v0, 4       #Comando
	la 	      $a0, memReabastecer   #Carrega string (endereço).
	syscall
	
	j loop_principal
	
reabastecer_cafe : 
	li $s3 , 20
	
	li 	      $v0, 4       #Comando
	la 	      $a0, memReaCafe #Carrega string (endereço).
	syscall
	
	li 	      $v0, 4       #Comando
	la 	      $a0, memDosagemCafe
	syscall
	
	li $v0, 1        # syscall para imprimir inteiro
	move $a0, $s3    # copia o valor de $s4 para $a0
	syscall
	
	j inicio
reabastecer_leite : 
	li $s4 , 20
	
	li 	      $v0, 4       #Comando
	la 	      $a0, memReaLeite #Carrega string (endereço).
	syscall
	j inicio
	
reabastecer_choco : 
	li $s5 , 20
	
	li 	      $v0, 4       #Comando
	la 	      $a0, memReaChoco #Carrega string (endereço).
	syscall
	j inicio
	
reabastecer_acucar : 
	li $s6 , 20
	
	li 	      $v0, 4       #Comando
	la 	      $a0, memReaAcucar #Carrega string (endereço).
	syscall
	j inicio
	
cafe_puro : 
	li 	      $v0, 4       #Comando
	la 	      $a0, memEscCafe    #Carrega string (endereço).
	syscall
	
	li	$s1, 1		#quantidade de pós
	
	j escolherAcucar
	
	
	
cafe_com_leite :
	li 	      $v0, 4       #Comando
	la 	      $a0, memEscLeite #Carrega string (endereço).
	syscall
	
	li	$s1, 2		#quantidade de pós
	j escolherAcucar

moca : 
	li 	      $v0, 4       #Comando
	la 	      $a0, memEscMoca    #Carrega string (endereço).
	syscall
	
	li	$s1, 3		#quantidade de pós
	
	
escolherAcucar: 
	li 	      $v0, 4     
	la 	      $a0, mem_EscAcucar   
	syscall
	
	
	j loop_principal
	
acucarSim : 
	li 	      $v0, 4       #Comando
	la 	      $a0, memEscAcucarSim
	syscall
	
	li $t1 , 1 #se t9 igual a 1 ajusta a dose 
	j escolherBebida
	
acucarNao : 
	li 	      $v0, 4       #Comando
	la 	      $a0, memEscAcucarNao
	syscall
	
escolherBebida: 
	li 	      $v0, 4     
	la 	      $a0, mem_EscTamanho   
	syscall
	
	j loop_principal	
	
	
pequeno: 
	li 	      $v0, 4       #Comando
	la 	      $a0, memEscTamPeq
	syscall
	
	li $t0 , 1
	li	$s2, 5	#carregando em $s2 o tempo que a valvula de água vai ficar aberta
	j Ajusta_Dosagem	
	
grande: 
	li 	      $v0, 4       #Comando
	la 	      $a0, memEscTamGra
	syscall
	
	li 		$t0 , 2
	li		$s2, 10			#carregando em $s2 o tempo que a valvula de água vai ficar aberta
	

Ajusta_Dosagem : 
 	
	sub $s3 , $s3 , $t0 # todos devem tirar do cafe
	blt $s3 , 0 , reabastecer_mem
	li $t9 , 0 #zera o t9 
	add $t9 , $t9 , $t0 # soma a dose do café nele
	beq $s1 , 2 , dosagem_cafe_leite
	beq $s1 , 3 , dosagem_cafe_moca
	beq $t1 , 1 , dosagem_acucar
	j bebidaDecidida
	

dosagem_cafe_leite: 
	sub $s4 , $s4 , $t0 #tira do leite
	blt $s4 , 0 , reabastecer_mem
	add $t9 , $t9 , $t0 # soma a dose do leite nele
	beq $t1 , 1 , dosagem_acucar
	j bebidaDecidida
	

dosagem_cafe_moca: 
	
	sub $s4 , $s4 , $t0 #tira do leite
	blt $s4 , 0 , reabastecer_mem
	sub $s5 , $s5 , $t0 #tira do chocolate
	blt $s5 , 0 , reabastecer_mem
	add $t9 , $t9 , $t0 # soma a dose do leite nele
	add $t9 , $t9 , $t0 # soma a dose do chocolate nele
	beq $t1 , 1 , dosagem_acucar
	j bebidaDecidida
	
dosagem_acucar : 
	sub $s6 , $s6 , $t0 #tira do acucar
	add $t9, $t9 , $t0 # soma a dose do acucar nele
	j bebidaDecidida
	
reabastecer_mem: 
	li 	      $v0, 4       #Comando
	la 	      $a0, memAcabou
	syscall
	
	j loop_principal

	

bebidaDecidida:
	
	li 	      $v0, 4       #Comando
	la 	      $a0, memDosagemCafe
	syscall
	
	li $v0, 1        # syscall para imprimir inteiro
	move $a0, $s3    # copia o valor de $s4 para $a0
	syscall
	
	li 	      $v0, 4       #Comando
	la 	      $a0, memDosagemLeite
	syscall
	
	li $v0, 1        # syscall para imprimir inteiro
	move $a0, $s4    # copia o valor de $s4 para $a0
	syscall
	
	li 	      $v0, 4       #Comando
	la 	      $a0, memDosagemChocolate
	syscall
	
	li $v0, 1        # syscall para imprimir inteiro
	move $a0, $s5    # copia o valor de $s4 para $a0
	syscall
	
	li 	      $v0, 4       #Comando
	la 	      $a0, memDosagemAcucar
	syscall
	
	li $v0, 1        # syscall para imprimir inteiro
	move $a0, $s6    # copia o valor de $s4 para $a0
	syscall
	
	
	li 	      $v0, 4       #Comando
	la 	      $a0, memDosagem
	syscall
	
	move	$a0, $t9
	jal		timer
	
	li 	      $v0, 4       #Comando
	la 	      $a0, memValvula
	syscall
	
	move	$a0, $s2
	jal		timer
	
	#chamando a função para imprimir o recibo
	
	move	$a0, $s1	# manda como arg a qtd de pós
	move 	$a1, $t0	# manda como arg o tamanho da bebida
	move	$a2, $s7	#manda como arg o descritor do arquivo
	jal		recibo
	
	
    j inicio



#função acabou compra
#recebe como arg $a0 - descritor do arquivo
finalizar_compra:
	move $t0, $a0
	
	#escrever no arquivo aberto a linha pontilhada
	li 		$v0, 15		
	move	$a0, $t0			#descritor do arquivo é passado	
	la		$a1, memLinha		#o que vai ser escrito
	li 		$a2, 101			#tamanho do buffer 
	syscall

	#fechar o arquivo
	li	$v0, 16			#comando para fechamento do arquivo
	move	$a0, $t0	#descritor do arquivo é passado
	syscall				#arquivo é fechado pelo sistema operacional
	
	
	li 	      $v0, 4       #Comando
	la 	      $a0, memTerminouCompra   #Carrega string (endereço).
	syscall
	
	
	li		$v0, 10
	syscall
	


#função timer 
#recebe $a0 como o tempo que deve contar
timer:
	move	$t7, $a0	#salvando o tempo que vamos cronometrar em $t7
    li 		$t0, 0		#inicializando contador
    
loop:
    li 		$v0, 30	
    syscall
    move 	$t1, $a0	#salvando o valor do tempo atual em $t1

espera:
    li 		$v0, 30
    syscall
    move 	$t2, $a0			#salvando o valor do tempo atual em $t2
    subu 	$t3, $t2, $t1		#calculando a diferença dos dois tempos pra descobrir quanto tempo passou
    blt  	$t3, 1000, espera	#caso não tenha passado um segundo, repete

    addi 	$t0, $t0, 1		#somando 1 ao contador
    li 		$t8, 99
    blt 	$t0, $t8, ok	#caso tenhamos extrapolado o numero de digitos, zera o contador
    li 		$t0, 0
ok:
	li		$t9, 10
    divu    $t0, $t9
    mfhi    $t2                  # unidades  = resto
    mflo    $t3                  # dezenas   = quociente
    
    move 	$a0, $t0
    la 		$t4, tabela7seg
    
    # busca padrão do display da direita
    add     $t5, $t4, $t2
    lbu     $t5, 0($t5)

    # busca padrão do display da esquerda
    add     $t6, $t4, $t3
    lbu     $t6, 0($t6)

    #escreve nos dois displays
    li      $t9, 0xFFFF0010      # display da direita
    sb      $t5, 0($t9)

    li      $s0, 0xFFFF0011      # display da esquerda
    sb      $t6, 0($s0)
   
    
    
    beq		$t0, $t7, acabou	#caso tenhamos chegado no fim, ao invés de repetir o loop voltamos pro programa principal
    j 		loop

acabou:
    	jr $ra
    	
#função recibo 
#recebe $a0 como a quantidade de pós que serão usados
#recebe $a1 como o tamanho da bebida
#recebe $a2 como o descritor do arqv q vamos escrever
recibo:
	move	$t0, $a0	#em t0 temos o identificador da bebida
	move	$t1, $a1	#em t1 temos o tamanho
	move	$t3, $a2	#em t2 temos o descritor do arqv
	mul		$t2, $t0, $t1	#tamanho * qtd de pós = código da bebida

	beq		$t2, 5, cafe_peq_recibo
	beq		$t2, 10, bebida_recibo
	beq		$t2, 15, mocca_peq_recibo
	beq		$t2, 20, cafe_leite_gra_recibo	
	beq		$t2, 30, mocca_gra_recibo
	
	cafe_peq_recibo:
	la		$a1, memReciboCafePeq
	j	escrever_bebida
	
	bebida_recibo:
	beq		$t1, 10, cafe_gra_recibo
	la		$a1, memReciboCafeLeitePeq
	j	escrever_bebida
	
	cafe_gra_recibo:
	la		$a1, memReciboCafeGra
	j	escrever_bebida
	
	mocca_peq_recibo:
	la		$a1, memReciboMocaPeq
	j	escrever_bebida
	
	cafe_leite_gra_recibo:
	la		$a1, memReciboCafeLeiteGra
	j	escrever_bebida
	
	mocca_gra_recibo:
	la		$a1, memReciboMocaGra
	j	escrever_bebida
	
	escrever_bebida:
	li 		$v0, 15		
	move	$a0, $t3			#descritor do arquivo é passado	
	li 		$a2, 101			#tamanho do buffer 
	syscall
	
   	# Encerrar programa
   	jr	$ra
