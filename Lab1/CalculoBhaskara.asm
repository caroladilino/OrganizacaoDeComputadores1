#Código para calcular fórmula de bhaskara com números definidos
.data 
	
	a : .word 1
	b : .word -5
	c : .word 6

.text
main:
	#Carregando as variáveis nos regristradores 
	lw      $t0, b
	lw 	    $t1, a
	lw 	    $t2, c

  #Calculando delta
	mul        $t4, $t0, $t0   #b²
	sll        $t5,$t1,2       #4a
	mul        $t6, $t2, $t5 	 #4a . c
	sub        $t7, $t4, $t6 	 #b² - 4ac

  #Raiz quadrada
	mtc1       $t7, $f1		     #converte int para float
	cvt.s.w    $f1, $f1
	sqrt.s     $f2, $f1		     #raiz quadrada 
	cvt.w.s    $f3, $f2        #converte o float em $f0 para inteiro no formato float em $f2
	mfc1       $t8, $f3        #move o valor inteiro de $f2 para $t0

  #Cálculo de bhaskara
  neg        $t9, $t0	       #converte b para -b
  add        $t3, $t9, $t8   #Primeira raiz
  sll        $t4, $t1, 1     #2a
  div        $t5, $t3, $t4
  sub        $t3, $t9, $t8   #Segunda raiz
  sll        $t4, $t1, 1     #2a
  div        $t6, $t3, $t4

#Resultado se encontra em $t6 e $t5
