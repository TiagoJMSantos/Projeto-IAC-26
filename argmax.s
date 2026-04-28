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
    li t0, 1
    li t1, 0 #start index
    li t2, 0 #start max index
    lw t3 ,0(a1) #start max value
    blt a2, t0, argmax_error #Verification of error
  # TODO: Implement the argmax function here
argmax_loop:
    bge t1, a2, argmax_finish # if(t1 >= a2) then done
    li t4, 4
    mul t4, t1, t4 #index in bytes, word is 4 so always jump in 4
    add t5, a1, t4 # t5 is adress to value so &array[i]
    lw t6 , 0(t5) # t6 is array[i]

    ble t6, t3, argmax_next #if less then it skips
    mv t3 , t6
    mv t2, t1
argmax_next:
  addi t1, t1, 1; # t1 = t1 + 1
  j argmax_loop
argmax_error:
  li a0, 50
  ret

argmax_finish:
    li a0, 0 #status code 
    mv a1 ,t2 #move the max index to a1

argmax_end:
  jr ra               # return to the caller