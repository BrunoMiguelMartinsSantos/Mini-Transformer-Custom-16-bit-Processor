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
  # TODO: Implement the argmax function here

ble a2, zero, Error_50 # SIZE <= 0
li t0, 0               # Counter i = 0

Loop: 
        bgt t0, a2, End          # Exit if Size == Counter
        lw t1, 0(a1)             # Load current value
        beq t0, zero, SaveIndex  # Counter == 0
        bgt t1, t4, SaveIndex    # a1[i] > t4
        
Loop2:
        addi t0, t0, 1   # i++
        addi a1, a1, 4
        j Loop

SaveIndex:
        mv t3, t0    # Highest value index
        mv t4, t1    # Highest value
        j Loop2

End: 
        li a0, 0      # Return state 0 -- success
        mv a1, t3     # Return max_value's index
        j argmax_end  # End Argmax

Error_50:
        li a0, 50     # Return Error_50 state
        j argmax_end  # End Argmax
        
argmax_end:
  jr ra               # return to the caller