# You can change these values to test your solution.
.data
ARRAY: .word -6 -1 6 1
SIZE:  .word 4
INDEX: .word 2

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
  # TODO: Implement the select function here

select_end:
  jr ra               # return to the caller
