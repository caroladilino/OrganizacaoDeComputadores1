.globl contador1seg

.data
tabela7seg:
    .byte 0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F

.text
contador1seg:
    li $t0, 0
loop_1s:
    li $v0, 30
    syscall
    move $t1, $a0

espera1:
    li $v0, 30
    syscall
    move $t2, $a0
    subu $t3, $t2, $t1
    blt  $t3, 1000, espera1     # espera 1 segundo

    addi $t0, $t0, 1
    li $t9, 10
    blt $t0, $t9, ok1
    li $t0, 0
ok1:
    move $a0, $t0
    jal mostra_display_direito
    j loop_1s

# Mostra no display direito (0xFFFF0010)
mostra_display_direito:
    li $t5, 0xFFFF0010
    la $t4, tabela7seg
    add $t1, $t4, $a0
    lbu $t1, 0($t1)
    sb $t1, 0($t5)
    jr $ra
