.globl contador3seg

.data
tabela7seg:
    .byte 0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F

.text
contador3seg:
    li $t0, 0
loop_3s:
    li $v0, 30
    syscall
    move $t1, $a0

espera3:
    li $v0, 30
    syscall
    move $t2, $a0
    subu $t3, $t2, $t1
    blt  $t3, 3000, espera3     # espera 3 segundos

    addi $t0, $t0, 1
    li $t9, 10
    blt $t0, $t9, ok3
    li $t0, 0
ok3:
    move $a0, $t0
    jal mostra_display_esquerdo
    j loop_3s

# Mostra no display esquerdo (0xFFFF0011)
mostra_display_esquerdo:
    li $t6, 0xFFFF0011
    la $t4, tabela7seg
    add $t2, $t4, $a0
    lbu $t2, 0($t2)
    sb $t2, 0($t6)
    jr $ra
