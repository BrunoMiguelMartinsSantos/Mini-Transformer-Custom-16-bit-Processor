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
  # TODO: Implement the dot product function here

ble a3, zero, Error_50 # if SIZE <= 0
li t0, 0 # t0 -> Loop counter
li t5, 0 # t5 -> Total sum

Loop:   
        beq t0, a3, End # Counter != SIZE
        lw t2, 0(a1)    # t2 -> Load Vector A -- a1[i]
        lw t3, 0(a2)    # t3 -> Load Vector B -- a2[i]
        mul t4, t3, t2  # Multiply loaded values -- a1[i] * a2[i]
        
        div t6, t4, t3        # t6 -> (a1[i] * a2[i]) / a2[i]
        bne t6, t2, Error_200 # if t6 != a1[i]
        
        add t1, t5, t4  # Temporary sum -- t5 += t4
        
        # Different signs -> No overflow possible
        xor t6, t5, t4
        blt t6, zero, No_Overflow  
        
        # Same sign but different from sum's sign -> Overflow detected
        # Eg: (+a) + (+b) = (-c) OR (-a) + (-b) = (+c)
        xor t6, t1, t5
        blt t6, zero, Error_200

No_Overflow:
        mv t5, t1       # t5 = Temporary sum
        addi t0, t0, 1  # Increment counter -- t0++
        
        #Step 1 value foward -- i++
        addi a1, a1, 4
        addi a2, a2, 4
        j Loop


End: 
        li a0, 0        # Return state
        mv a1, t5       # Return final value
        j dot_end

Error_50: 
        li a0, 50       # Return Error_50 state
        j dot_end
        
Error_200: 
        li a0, 200      # Return Error_200 state
        j dot_end

dot_end:
  jr ra               # return to the caller
