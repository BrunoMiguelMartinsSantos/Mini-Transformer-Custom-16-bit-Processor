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

 
ble a2, zero, Error_50   # SIZE < 1  -----> Error_50
bge a3, a2, Error_100    # INDEX >= SIZE -> Error_100
blt a3, zero, Error_100  # INDEX < 0 -----> Error_100

li t0, 4         # .word size
mul t0, t0, a3   # t1 -> right step size for index

add a1, a1, t0   # Put in right index
lw a1, 0(a1)     # Return value
li a0, 0         # Return success state
j select_end

Error_50: 
        li a0, 50   # Return Error_50 state
        j select_end

Error_100:
        li a0, 100  # Return Error_100 state
        j select_end

select_end:
  jr ra               # return to the caller
