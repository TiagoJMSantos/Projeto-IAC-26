# You can change these values to test your solution.
.data
A:    .word 6, 1, 3, 9, 12, 4, 13, 153
B:    .word 6, 1, 3, 9, 12, 4, 13, 153
SIZE: .word 8

.text
main:
  la a1, A          # a1 = pointer to array A
  la a2, B          # a2 = pointer to array B
  lw a3, SIZE       # a3 = number of elements in each array
  jal ra, dot       # call dot function
exit:
  li a7, 10         # exit syscall code
  ecall             # terminate the program


# ==========================================================================
# FUNCTION: dot
#   This function computes the dot product of two integer arrays.
# Arguments:
#   a1 = pointer to first array
#   a2 = pointer to second array
#   a3 = array length
# Returns:
#   a0 = status code
#   a1 = dot product result
# ===========================================================================
dot:
dot:
  li t0, 1              # t0 = 1, usado para testar se o tamanho ? menor que 1
  blt a3, t0, dot_size_error
                        # se a3 < 1, ent?o tamanho inv?lido ? erro 50

  li t1, 0              # t1 = i = 0, contador do ciclo
  li t2, 0              # t2 = soma = 0, acumulador do produto interno

dot_loop:
  beq t1, a3, dot_success
                        # se i == tamanho, ja percorremos todos os elementos

  lw t3, 0(a1)          # t3 = A[i], le o elemento atual do vetor A
  lw t4, 0(a2)          # t4 = B[i], le o elemento atual do vetor B

  mul t5, t3, t4        # t5 = parte baixa de A[i] * B[i], 32 bits inferiores
  mulh t6, t3, t4       # t6 = parte alta signed de A[i] * B[i], 32 bits superiores

  srai t0, t5, 31       # t0 = extensao de sinal esperada de t5
                        # se t5 for positivo, t0 = 0x00000000
                        # se t5 for negativo, t0 = 0xffffffff

  bne t6, t0, dot_overflow
                        # se parte alta real != extensao de sinal esperada,
                        # entao o produto nao cabe em 32 bits ? overflow

  add t6, t2, t5        # t6 = nova_soma = soma atual + produto

  xor t0, t2, t5        # compara sinais de soma atual e produto
                        # se sinais forem diferentes, nao ha overflow na soma

  blt t0, x0, no_add_overflow
                        # se t0 < 0, os sinais eram diferentes ? sem overflow

  xor t0, t2, t6        # se os sinais eram iguais, verifica se o sinal mudou
                        # compara soma antiga com nova soma

  blt t0, x0, dot_overflow
                        # se mudou o sinal, houve overflow na soma

no_add_overflow:
  mv t2, t6             # soma = nova_soma

  addi a1, a1, 4        # avanca ponteiro A para o proximo inteiro
  addi a2, a2, 4        # avanca ponteiro B para o proximo inteiro
  addi t1, t1, 1        # i++

  j dot_loop            # volta ao inicio do ciclo

dot_success:
  li a0, 0              # a0 = 0 ? sucesso
  mv a1, t2             # a1 = resultado final do produto interno
  ret                   # regressa a funcao chamadora

dot_size_error:
  li a0, 50             # a0 = 50 ? tamanho invalido
  li a1, 0              # limpa resultado
  ret                   # regressa a funcao chamadora

dot_overflow:
  li a0, 200            # a0 = 200 ? overflow detetado
  li a1, 0              # resultado invalido, por isso fica a 0
  ret                   # regressa a funcao chamadora

dot_end:
  jr ra               # return to the caller
