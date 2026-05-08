.data
ARRAY: .word 42
SIZE:  .word 1
INDEX: .word 1

.text
main:
  la a1, ARRAY      # a1 = pointer to array
  lw a2, SIZE       # a2 = array length
  lw a3, INDEX      # a3 = element index
  jal ra, select    # call select function
exit:
  li a7, 10         # exit syscall code
  ecall             # terminate the program

# ==========================================================================
# FUNCTION: select
#   This function selects an element from an integer array.
# Arguments:
#   a1 = pointer to int array
#   a2 = array length
#   a3 = element index
# Returns:
#   a0 = status code
#   a1 = value of the selected element
# ===========================================================================
select:
     li t3, 1 # starts min array size
     li t2, 0 # starts final value
     blt a2, t3, select_invalid # error if a2<t3
     blt a3, x0, select_invalid_2 # error if a3<0
     bge a3, a2, select_invalid_2 # error if a3>=a2
     slli t0, a3, 2 # index in bytes, word is 4 bytes
     add t0, a1, t0 # shifts array a1 to index t0
     lw t2, 0(t0) # t2 is array[i]
     li a0, 0 # returns code 0 -> success
     mv a1, t2 # moves value of t2 to the selected element
     j select_end
  
select_invalid:
    li a0, 50    # returns code 50 -> argument invalid
    li a1, 0
    j select_end
    
select_invalid_2:
    li a0, 100    # returns code 100 -> index out of limit
    li a1, 0
    j select_end

select_end:
     jr ra               # return to the caller

select_end:
     jr ra               # return to the caller
