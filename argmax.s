# You can change these values to test your solution.
.data
ARRAY: .word -6 -1 6 1
SIZE:  .word 4

.text
main:
  la a1, ARRAY        # a1 = pointer to array
  lw a2, SIZE         # a2 = number of elements in the array
  jal ra, argmax      # call argmax function
exit:
  li a7, 10           # exit syscall code
  ecall               # terminate the program

# ==========================================================================
# FUNCTION: argmax
#   Takes an array of integers and returns the index of the largest element.
#   If there are multiple elements with the same maximum value, 
#   it should return the smallest index among them.
# Arguments:
#   a1 = pointer to int array
#   a2 = array length
# Returns:
#   a0 = status code
#   a1 = index of the largest element
# ===========================================================================
argmax:
    li t0, 0 #start index
    li t1, 0 #start max index
    lw t2 ,0(a1) #start max value
    ble a2, 1, argmax_error #Verification of error
  # TODO: Implement the argmax function here
argmax_loop:
    bge t0, a2, argmax_finish # if(t0 >= s2) then done
    li t3, 4
    mul t3, t0, t3 #index in bytes, word is 4 so always jump in 4
    add t4, a1, t3 # t4 is adress to value so &array[i]
    lw t5 , 0(t4) # t5 is array[i]

    ble t5, t2, argmax_next #if less then it skips
    mv t2 , t5
    mv t1, t0
rgmax_next:
  addi t0, t0, 1; # t0 = t1 + 1
  j argmax_loop
  argmax_error:
  li a0, 50
  ret

argmax_finish:

    li a0, 0 #status code 
    mv a1 ,t1 #move the max index to a1
argmax_end:
  jr ra               # return to the caller