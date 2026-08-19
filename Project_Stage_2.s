###########################################################################
# Upper bound constants for static memory reservation
###########################################################################
.equ CONST_DIMENSION 4
.equ CONST_BUFFER_SIZE 1024
.equ CONST_MAX_VOCAB_TOKENS 100
.equ CONST_MAX_INPUT_TOKENS 10

###########################################################################
# System call constants
###########################################################################
.equ CONST_SYSCALL_PRINT_INT 1
.equ CONST_SYSCALL_PRINT_STRING 4
.equ CONST_SYSCALL_PRINT_CHAR 11
.equ CONST_SYSCALL_EXIT 10
.equ CONST_SYSCALL_EXIT2 93
.equ CONST_SYSCALL_OPEN 1024
.equ CONST_SYSCALL_CLOSE 57
.equ CONST_SYSCALL_READ 63
.equ CONST_SYSCALL_WRITE 64

###########################################################################
# ASCII character constants
###########################################################################
.equ CONST_CHAR_EOF 0
.equ CONST_CHAR_SPACE 32
.equ CONST_CHAR_NEWLINE 10
.equ CONST_CHAR_HYPHEN 45
.equ CONST_CHAR_ZERO 48

.data
###########################################################################
# Data section with static memory reservations.
# Feel free to add more if needed.
###########################################################################
VOCABULARY_FILENAME:     .string "vocab.txt"
EMBEDDINGS_FILENAME:     .string "embeddings.txt"
INPUT_FILENAME:          .string "input.txt"

W_Q_FILENAME:            .string "W_Q.txt"
W_K_FILENAME:            .string "W_K.txt"
W_V_FILENAME:            .string "W_V.txt"

VOCAB_BUFFER:            .zero CONST_BUFFER_SIZE                              # Contents of the vocabulary file
INPUT_BUFFER:            .zero CONST_BUFFER_SIZE                              # Contents of the input file
MATRIX_BUFFER:           .zero CONST_BUFFER_SIZE                              # Contents of a matrix file (used for W_Q, W_K, W_V, and embeddings)

INPUT_INDICES_VECTOR:    .zero (CONST_MAX_INPUT_TOKENS * 4)                   # Vector of input token indices (#inputs x 4 bytes)
SCORES_VECTOR:           .zero (CONST_MAX_INPUT_TOKENS * 4)                   # Vector of scores (#tokens x 4 bytes)

INPUT_TOTAL_TOKENS:      .word 0                                              # Number of tokens in the input
VOCAB_TOTAL_TOKENS:      .word 0                                              # Number of tokens in the vocabulary

VOCAB_EMBEDDINGS_MATRIX: .zero (CONST_MAX_VOCAB_TOKENS * CONST_DIMENSION * 4) # Embedding matrix (#tokens x dimension x 4 bytes)
INPUT_EMBEDDINGS_MATRIX: .zero (CONST_MAX_INPUT_TOKENS * CONST_DIMENSION * 4) # Embedding matrix (#tokens x dimension x 4 bytes)
W_Q_MATRIX:              .zero (CONST_DIMENSION * CONST_DIMENSION * 4)        # W_Q matrix (dimension x dimension x 4 bytes)
W_K_MATRIX:              .zero (CONST_DIMENSION * CONST_DIMENSION * 4)        # W_K matrix (dimension x dimension x 4 bytes)
W_V_MATRIX:              .zero (CONST_DIMENSION * CONST_DIMENSION * 4)        # W_V matrix (dimension x dimension x 4 bytes)
Q_MATRIX:                .zero (CONST_MAX_INPUT_TOKENS * CONST_DIMENSION * 4) # Q matrix (#tokens x dimension x 4 bytes)
K_MATRIX:                .zero (CONST_MAX_INPUT_TOKENS * CONST_DIMENSION * 4) # K matrix (#tokens x dimension x 4 bytes)
V_MATRIX:                .zero (CONST_MAX_INPUT_TOKENS * CONST_DIMENSION * 4) # V matrix (#tokens x dimension x 4 bytes)

.text
main:
    ###########################################################################
    # Read vocabulary
    ###########################################################################
    # TODO
    
    la a0, VOCABULARY_FILENAME
    la a1, VOCAB_BUFFER
    li a2, CONST_BUFFER_SIZE
    jal ra, read_file

    ###########################################################################
    # Read input
    ###########################################################################
    # TODO
    
    la a0, INPUT_FILENAME
    la a1, INPUT_BUFFER
    li a2, CONST_BUFFER_SIZE
    jal ra, read_file

    ###########################################################################
    # Read W_Q matrix
    ###########################################################################
    # TODO
    
    la a0, W_Q_FILENAME
    la a1, MATRIX_BUFFER
    li a2, CONST_BUFFER_SIZE
    jal ra, read_file

    ###########################################################################
    # Parse W_Q matrix from buffer
    ###########################################################################
    # TODO

    la a0, W_Q_MATRIX
    la a1, MATRIX_BUFFER
    jal ra, parse_matrix_buffer

    ###########################################################################
    # Read W_K matrix
    ###########################################################################
    # TODO

    la a0, W_K_FILENAME
    la a1, MATRIX_BUFFER
    li a2, CONST_BUFFER_SIZE
    jal ra, read_file

    ###########################################################################
    # Parse W_K matrix from buffer
    ###########################################################################
    # TODO

    la a0, W_K_MATRIX
    la a1, MATRIX_BUFFER
    jal ra, parse_matrix_buffer

    ###########################################################################
    # Read W_V matrix
    ###########################################################################
    # TODO

    la a0, W_V_FILENAME
    la a1, MATRIX_BUFFER
    li a2, CONST_BUFFER_SIZE
    jal ra, read_file
    
    ###########################################################################
    # Parse W_V matrix from buffer
    ###########################################################################
    # TODO
    
    la a0, W_V_MATRIX
    la a1, MATRIX_BUFFER
    jal ra, parse_matrix_buffer

    ###########################################################################
    # Read embeddings matrix
    ###########################################################################
    # TODO

    la a0, EMBEDDINGS_FILENAME
    la a1, MATRIX_BUFFER
    li a2, CONST_BUFFER_SIZE
    jal ra, read_file

    ###########################################################################
    # Parse vocabulary embeddings matrix from buffer
    ###########################################################################
    # TODO
    
    la a0, VOCAB_EMBEDDINGS_MATRIX
    la a1, MATRIX_BUFFER
    jal ra, parse_matrix_buffer

    mv s1, a1        # s1 = number of vocabulary tokens

    ###########################################################################
    # Convert input tokens to indices
    ###########################################################################
    # TODO

    la a0, INPUT_INDICES_VECTOR
    la a2, INPUT_BUFFER
    la a3, VOCAB_BUFFER
    jal ra, tokens_to_indices

    mv s0, a1        # s0 = number of input tokens

    ###########################################################################
    # Build input embeddings matrix
    ###########################################################################
    # TODO
    
    la a0, INPUT_EMBEDDINGS_MATRIX
    la a1, VOCAB_EMBEDDINGS_MATRIX
    la a2, INPUT_INDICES_VECTOR
    mv a3, s0
    jal ra, build_input_embeddings_matrix

    ###########################################################################
    # Build matrix Q
    ###########################################################################
    # TODO
    
    la a0, Q_MATRIX
    la a1, INPUT_EMBEDDINGS_MATRIX
    mv a2, s0                    # number of input tokens
    li a3, CONST_DIMENSION       # columns of input embeddings
    la a4, W_Q_MATRIX
    li a5, CONST_DIMENSION       # rows of W_Q
    li a6, CONST_DIMENSION       # columns of W_Q
    jal ra, matrix_multiply
    

    ###########################################################################
    # Build matrix K
    ###########################################################################
    # TODO
    
    la a0, K_MATRIX
    la a1, INPUT_EMBEDDINGS_MATRIX
    mv a2, s0                    # number of input tokens
    li a3, CONST_DIMENSION       # columns of input embeddings
    la a4, W_K_MATRIX
    li a5, CONST_DIMENSION       # rows of W_K
    li a6, CONST_DIMENSION       # columns of W_K
    jal ra, matrix_multiply

    ###########################################################################
    # Build matrix V
    ###########################################################################
    # TODO
    
    la a0, V_MATRIX
    la a1, INPUT_EMBEDDINGS_MATRIX
    mv a2, s0                    # number of input tokens
    li a3, CONST_DIMENSION       # columns of input embeddings
    la a4, W_V_MATRIX
    li a5, CONST_DIMENSION       # rows of W_V
    li a6, CONST_DIMENSION       # columns of W_V
    jal ra, matrix_multiply

    ###########################################################################
    # Compute scores for the last input token
    ###########################################################################
    # TODO

    la a0, SCORES_VECTOR
    la a1, Q_MATRIX
    la a2, K_MATRIX
    mv a3, s0                    # number of rows of Q and K
    li a4, CONST_DIMENSION       # number of columns of Q and K
    addi a5, s0, -1              # target token = last input token
    
    jal ra, compute_scores
    
    ###########################################################################
    # Get the highest score index using argmax
    ###########################################################################
    # TODO
    
    la a1, SCORES_VECTOR
    mv a2, s0                    # number of input tokens
    jal ra, argmax

    mv t0, a1                    # t0 = index returned by argmax

    ###########################################################################
    # Select chosen vector in V using the index from argmax
    ###########################################################################
    # TODO

    la a1, V_MATRIX
    mv a2, s0                    # number of rows of V
    li a3, CONST_DIMENSION       # number of columns of V
    mv a4, t0                    # target row
    
    jal ra, select_vector_in_matrix

    ###########################################################################
    # Pick the next token in the vocabulary with the highest score
    ###########################################################################
    # TODO
    
    la a1, VOCAB_EMBEDDINGS_MATRIX
    mv a2, s1                    # number of vocabulary tokens
       
    jal ra, decide_next_token

    ###########################################################################
    # Print predicted token
    ###########################################################################

    la a1, VOCAB_BUFFER
    jal ra, get_target_token_address # Set a0 value to print
    
    jal ra, print_predicted_token

    ###########################################################################
    # Terminate program successfully
    ###########################################################################
    li a0, 0
    j exit_with_code                                # Exit with code 0
    
    
# Turns an index into a pointer separating indexes by a '\n' 
# (in)  a0: target token index (int)
# (in)  a1: address of vocabulary buffer (char*)
# (out) a0: address of target token (char*)
get_target_token_address:

    mv t0, zero    # i = 0

get_target_token_address_loop:

    beq t0, a0, get_target_token_address_end  # i == a0 -> terminate loop and return
    lb t1, 0(a1)                       # t1 = a1[i]
    addi a1, a1, 1                     # (i++) -> set a1 at next byte
    
    li t2, CONST_CHAR_NEWLINE
    bne t2, t1, get_target_token_address_loop  # a1[i] != '\n' -> iterate
    
    addi t0, t0, 1                     # i++
    
    j get_target_token_address_loop            # Iterate

get_target_token_address_end:
    
    mv a0, a1 # Set return value
    jr ra     # Return

# Read from a text file into a buffer.
# (in)     a0: filename address (char*)
# (in/out) a1: destination buffer
# (in)     a2: maximum number of bytes to read
read_file:
    # TODO
    
    # OPEN FILE
    mv t0, a1                   # t0 -> destination buffer
    mv t1, a2                   # t1 -> max number of bytes to read
    
    li a7, CONST_SYSCALL_OPEN   # Syscall open value
    li a1, 0                    # Read-only flag
    ecall
    
    mv t2, a0                   # t2 -> file descriptor
    
    # Restore original values
    mv a1, t0
    mv a2, t1

    # READ FILE
    li a7, CONST_SYSCALL_READ   # Syscall read value
    mv a1, t0                   # Reload destination buffer
    ecall
    
    add t3, t0, a0              # t3 = t0 + a0 -> new buffer address
    sb zero, 0(t3)              # 
    
    # CLOSE FILE
    mv a0, t2                   # a0 -> filename address
    li a7, CONST_SYSCALL_CLOSE  # Syscall close value
    ecall
    
    mv a1, t3                   # Return value
    
    jr ra                       # Return

# Assumes the matrix is stored in the buffer as space-separated integers.
# Assumes columns are separated by 1 space (' '), and rows by 1 newline ('\n').
# Assumes only signed integers are provided.
# (in/out) a0: address of the matrix to fill (int*)
# (out)    a1: number of rows in the matrix (int)
# (in)     a1: address of the buffer containing the matrix data (char*)
parse_matrix_buffer:
    # TODO
    
    add t0, zero, zero          # Row counter
    mv t1, a1                   # t1 -> Address of buffer w/matrix data
    add t2, zero, zero          # Sign flag
    mv t3, a0                   # t3 -> matrix
    
    add t4, zero, zero          # t4 -> Number storer
    
parse_matrix_buffer_loop:
    
    lb t5, 0(t1)                # t5 -> current char
    

    beq t5, zero, parse_end     # if t5 == EOF -> parse_end
    
    li t6, CONST_CHAR_SPACE     # if t5 == ' ' -> save_number
    beq t5, t6, save_number

    li t6, CONST_CHAR_NEWLINE   # if t5 == '\n' -> process_newline
    beq t5, t6, process_newline

    li t6, CONST_CHAR_HYPHEN    # if t5 == '-' -> process_negative
    beq t5, t6, process_negative
    
    li t6, 10                   # t6 = 10
    addi t5, t5, -48            # Convert ASCII code into value
    mul t4, t4, t6              # Multiply existing sum by 10
    add t4, t4, t5              # Add curr byte value to sum
    
    j load_next_char            # Iterate to next char
    
load_next_char:
    addi t1, t1, 1              # add '1' to read next byte
    j parse_matrix_buffer_loop  # Jump back into loop

    
save_number:
    beq t2, zero, store_number  # if number is >= 0 -> store it
    sub t4, zero, t4            # Turn t4 into its symetric
    
store_number:
    sw t4, 0(t3)                # Store value in matrix
    addi t3, t3, 4              # Iterate to next number
    
    # Reset flag and sum
    add t2, zero, zero
    add t4, zero, zero
    
    j load_next_char    
    
process_newline:
    addi t0, t0, 1               # Increment row counter
    j save_number
    
process_negative:
    
    li t2, 1                     # Set flag as '1'
    j load_next_char             # Iterate to next char

parse_end:
    mv a1, t0                    # a1 -> row counter
    
    jr ra                        # Return

# Converts the input tokens into their corresponding indices in the vocabulary.
# (in/out) a0: address of input indices vector to fill (int*)
# (out)    a1: size of input indices vector (number of tokens in input)
# (in)     a2: address to input buffer
# (in)     a3: address to vocabulary buffer

tokens_to_indices:
    mv t0, a0                # t0 -> pointer to store address
    mv t1, a2                # t1 -> pointer to input buffer address
    add t2, zero, zero       # t2 = 0 -> Token counter
    
tokens_to_indices_loop:
    lb t3, 0(t1)             # t3 -> first byte
    beq t3, zero, tokens_end # if t3 == 0 -> tokens_end (EOF)
    
    mv t4, a3                # t4 -> pointer to vocab address
    add t5, zero, zero       # Indice counter

tokens_vocabulary_loop:
    mv a4, t1                # a4 -> cursor to compare input token
    mv a5, t4                # a5 -> cursor to compare vocab token
    
tokens_compare_loop:
    lb t6, 0(a5)             # t6 -> curr vocab char
    lb a6, 0(a4)             # a6 -> curr input char
    
    li a7, CONST_CHAR_NEWLINE # a7 -> ASCII code for '\n'
    beq a6, a7, tokens_to_indices_end # input == '\n'
    beq a6, zero, tokens_to_indices_end # input == EOF
    
    bne a6, t6, tokens_dont_match
    
    addi a5, a5, 1           # Iterate to next vocab char
    addi a4, a4, 1           # Iterate to next input char
    
    j tokens_compare_loop

tokens_dont_match:
vocab_next:
    addi a5, a5, 1
    lb t6, 0(a5)             # t6 -> curr vocab char
    li a7, CONST_CHAR_NEWLINE
    bne t6, a7, vocab_next
    
    mv t4, a5                # Move base pointer to the \n
    addi t4, t4, 1           # Skip the \n
    addi t5, t5, 1           # Increment vocab index
    
    j tokens_vocabulary_loop

tokens_to_indices_end:
    li a7, CONST_CHAR_NEWLINE
    beq t6, a7, tokens_match  # Success
    beq t6, zero, tokens_match
    j tokens_dont_match

tokens_match:
    sw t5, 0(t0)              # t0[i] -> curr vocab index
    addi t0, t0, 4            # i++
    addi t2, t2, 1            # Increment token counter
    
    mv t1, a4                 # t1 -> a4
    addi t1, t1, 1            # Skip '\n'
    j tokens_to_indices_loop  # Iterate
    
tokens_end:
    mv a1, t2                 # Set return value
    jr ra                     # Return

# (in/out) a0: address of the output matrix to fill (int*)
# (in)     a1: address of the vocabulary embeddings matrix (int*)
# (in)     a2: address of the input indices array (int*)
# (in)     a3: number of tokens in the input (int)
build_input_embeddings_matrix:
    # TODO
    
    mv t0, a0        # t0 = a0
    mv t1, a1        # t1 = a1
    
build_input_embeddings_matrix_loop:

    beq a3, zero, build_input_embeddings_matrix_end    # a3 == 0
    lw t2, 0(a2)                                       # t2 = a2[i]
    addi a2, a2, 4                                     # i++
    addi a3, a3, -1                                    # a3--
    li t4, CONST_DIMENSION                             # t4 = Column number

    mul t3, t4, t2                                     # t3 = t4 * t2
    slli t3, t3, 2                                     # t3 *= 4 (indices * 4)
    add t6, t1, t3                                     # t6 = t1 * t3 (advance {t2} rows)
    
store_embedding_in_matrix_loop:
    
    lw t5, 0(t6)                                        # t5 = t1[i]
    sw t5, 0(t0)                                        # a0[i] = t5
    
    addi t4, t4, -1                                     # t4--
    addi t0, t0, 4                                      # i++
    addi t6, t6, 4                                      # i++
    
    bne t4, zero, store_embedding_in_matrix_loop    # t4 != 0 -> iterate
    j build_input_embeddings_matrix_loop                    # Next token
    
build_input_embeddings_matrix_end:
    
    jr ra    # Return
    
# (in/out) a0: address of the output matrix to fill (int*)
# (in)     a1: address of the first matrix (int*)
# (in)     a2: #rows of the first matrix (int)
# (in)     a3: #columns of the first matrix (int)
# (in)     a4: address of the second matrix (int*)
# (in)     a5: #rows of the second matrix (int)
# (in)     a6: #columns of the second matrix (int)
matrix_multiply:
    # TODO
    
    # SAVE NECESSARY VALUES TO THE STACK
    addi sp, sp, -12
    sw s0, 0(sp)
    sw s5, 4(sp)
    sw s8, 8(sp)
    
    mv s0, a0 # s0 is a pointer to a0
    
    slli s8, a6, 2 # s8 -> number of bytes to jump to next row of B
    mv s5, zero    # i = 0

# for (i; ; i++)
row_matrix_multiply_loop:
    
    beq s5, a2, matrix_multiply_end
    mv a7, zero    # j = 0
    
    mul a5, s5, a3    # t1 -> A[i][0] (amount of bytes to jump)
    slli a5, a5, 2    # jump bytes (coords * 4)
    add a5, a5, a1    # t1 is the address of A[i][0] here

# for (j; ; j++)
column_matrix_multiply_loop:
    
    beq a7, a6, next_row_multiply_matrix
    mv t0, zero    # Sum of multiplications
    mv t3, zero    # k = 0
    
    mv t1, a5
    
    slli t2, a7, 2    # t2 -> jump bytes (nmb of columns * 4)
    add t2, a4, t2    # t2 is the address of B[0][i]

# for (k; ; k++)
k_matrix_multiply_loop:
    
    beq t3, a3, store_matrix_multiply
    
    # K STARTS ALWAYS AT 0
    lw t4, 0(t1)    # t4 = A[i][k]
    lw t5, 0(t2)    # t5 = B[k][j]
    
    mul t6, t4, t5  # t6 = t4 * t5
    add t0, t0, t6  # t0 += t6 (add t6 to sum)
    
    addi t1, t1, 4  # t1 -> Next value in row
    add t2, t2, s8  # t2 -> Next value in column
    
    addi t3, t3, 1  # k++
    j k_matrix_multiply_loop

store_matrix_multiply:
    
    sw t0, 0(s0)   # Store dot product between a line from A and column from B
    addi s0, s0, 4 # Iterate to next address to store
    addi a7, a7, 1 # j++
    j column_matrix_multiply_loop

next_row_multiply_matrix:
    
    addi s5, s5, 1 # i++
    j row_matrix_multiply_loop
    
matrix_multiply_end:
    
    # REALOAD ALL SAVED VALUES IN THE STACK
    lw s0, 0(sp)
    lw s5, 4(sp)
    lw s8, 8(sp)

    addi sp, sp, 12
    
    jr ra    # Return

# (in/out) a0: address of the output scores vector to fill (int*)
# (in)     a1: address of Q matrix (int*)
# (in)     a2: address of K matrix (int*)
# (in)     a3: #rows of Q and K (int)
# (in)     a4: #columns of Q and K (int)
# (in)     a5: target token index for which we want to compute the score (int)
compute_scores:
    # TODO
    
    # SAVE ALL VALUES TO STACK
    addi sp, sp, -36
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    
    # LOAD INPUTS TO S REGISTERS
    mv s0, a0   # s0 -> Address to fill
    mv s1, a1   # s1 -> Q
    mv s2, a2   # s2 -> K
    mv s3, a3   # s3 -> Number of rows
    mv s4, a4   # s4 -> Number of columns
    mv s5, a5   # s5 -> target index
    
    mv s6, zero # i = 0
    
    mul t0, s5, s4    # t0 -> number of indexes to jump
    slli t0, t0, 2    # t0 -> number of bytes to jump
    add s7, s1, t0    # s7 = Q[s5][0]
    
compute_scores_loop:
    
    beq s6, s3, compute_scores_end
    
    mv a1, s7 # a1 = Q[s5][0]
    
    mul t1, s6, s4    # t1 -> number of indexes to jump
    slli t1, t1, 2    # t1 -> i * 4 -> (number of bytes to jump)
    add a2, s2, t1    # a2 = K[i]
    
    mv a3, s4         # a3 -> size of vectors
    
    # dot(Q[target], K[i], Ncolumns)
    jal ra, dot
    
    sw a1, 0(s0)      # s0[i] -> dot(Q[s5], K[i])
    
    # i++
    addi s0, s0, 4
    addi s6, s6, 1
    
    j compute_scores_loop
    
compute_scores_end:
    
    # RELOAD ORIGINAL VALUES IN S REGISTERS
    lw s7, 32(sp)
    lw s6, 28(sp)
    lw s5, 24(sp)
    lw s4, 20(sp)
    lw s3, 16(sp)
    lw s2, 12(sp)
    lw s1, 8(sp)
    lw s0, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 36
    
    jr ra    # Return

# (out) a0: address of the selected vector (int*)
# (in)  a1: address of matrix (int*)
# (in)  a2: #rows (int)
# (in)  a3: #cols (int)
# (in)  a4: target row
select_vector_in_matrix:
    # TODO
    
    mul t0, a3, a4    # t0 -> how many ints to jump
    slli t0, t0, 2    # t0 -> number of bytes to jump
    add a0, t0, a1    # a0 -> desired row address
    
    jr ra             # Return
 

# (out) a0: index of the predicted token in the vocabulary (int)
# (in)  a0: address of target vector (int*)
# (in)  a1: vocabulary embeddings address (int*)
# (in)  a2: number of tokens in vocabulary (int)
decide_next_token:
    # TODO
    
    # SAVE ALL VALUES TO THE STACK
    addi sp, sp, -28
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    
    mv s5, zero    # best_index = 0
    mv s4, zero    # i = 0
    mv s2, a2      # s2 = max_index
    mv s1, a1      # vocab embeddings address
    mv s0, a0      # target vector address
    
    # Setup values for dot()
    li a3, CONST_DIMENSION
    mv a2, s1
    mv a1, s0
    
    jal ra, dot    # call dot on curr index
    mv s3, a1      # best_value = s1[0]
    addi s4, s4, 1 # i++

decide_next_token_loop:
    
    beq s2, s4, decide_next_token_end    # i == max_index --> end (return)
    
    # Setup values for dot()
    # s6 = address of vocab[i][0]
    li a3, CONST_DIMENSION
    mul t1, s4, a3    # t1 -> Actual index
    slli t1, t1, 2    # t1 -> Number of bytes to jump
    add t2, s1, t1    # s6 -> Address of curr vector

    # current_score = dot(target_vector, vocab[i])
    mv a1, s0
    mv a2, t2
    
    jal ra, dot
    
    bgt a1, s3, new_index_token # new_value > best_value --> new_index_token
    addi s4, s4, 1 # i++
    
    j decide_next_token_loop    # Iterate
    
new_index_token:
    
    mv s3, a1      # s3 = new_value
    mv s5, s4      # s5 = new_index
    addi s4, s4, 1 # i++
    j decide_next_token_loop    
    
decide_next_token_end:
    
    mv a0, s5  # Setup return value
    
    # RELOAD ALL SAVED VALUES
    lw s5, 24(sp)
    lw s4, 20(sp)
    lw s3, 16(sp)
    lw s2, 12(sp)
    lw s1, 8(sp)
    lw s0, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 28
    
    jr ra      # Return

#############################################################################################################
# Dot product and argmax helper functions.
#############################################################################################################

# (in)  a1: address of first vector (int*)
# (in)  a2: address of second vector (int*)
# (in)  a3: length of the vectors (int)
# (out) a0: status code (0 for success, non-zero for error)
# (out) a1: dot product result (int)
dot:
    addi sp, sp, -4
    sw ra, 0(sp)                                    # Save return address on the stack
    # Initialize the result and the loop index.
    mv t0, zero                                     # t0 will hold the result (dot product)
    mv t1, zero                                     # t1 will be our loop index
    # Let's see first if SIZE < 1, and jump to dot_end if that's the case.
    slti t2, a3, 1                                  # t2 = (SIZE < 1)
    beq t2, zero, dot_loop                          # If SIZE >= 1, we can proceed to the loop
    li a0, 50                                       # Set a0 to 50 to indicate an error (invalid size)
    j dot_end                                       # If SIZE < 1, jump to dot_end
dot_loop:
    beq t1, a3, dot_end_loop                        # If t1 == SIZE, we are done
    lw t2, 0(a1)                                    # Load A[t1] into t2
    lw t3, 0(a2)                                    # Load B[t1] into t3
    mul t4, t2, t3                                  # t4 = A[t1] * B[t1]
    # Check if the multiplication of A[t1] and B[t1] overflows
    mulh t5, t2, t3                                 # t5 = high 32 bits of A[t1] * B[t1] (signed)
    srai t6, t4, 31                                 # t6 = sign extension of low 32 bits (0 or -1)
    bne t5, t6, overflow                            # Overflow if high bits != sign extension of low bits
    mv t6, t0                                       # Store the current result in t6 for overflow checking
    add t0, t0, t4                                  # t0 += A[t1] * B[t1]
    # Check if the previous addition caused an overflow
    # Careful: adding negative numbers will correctly result in a negative number, so we need to check for overflow in both directions.
    bgt t6, zero, check_positive_overflow           # If previous result was positive, check for positive overflow
    blt t6, zero, check_negative_overflow           # If previous result was negative, check for negative overflow
    j dot_continue_loop
check_positive_overflow:
    blt t4, zero, dot_continue_loop                 # If we added a negative number, we can't have a positive overflow
    blt t0, zero, overflow                          # If t0 < 0 after adding a positive number, we have an overflow
    j dot_continue_loop
check_negative_overflow:
    bgt t4, zero, dot_continue_loop                 # If we added a positive number, we can't have a negative overflow
    bgt t0, zero, overflow                          # If t0 > 0 after adding a negative number, we have an overflow
    j dot_continue_loop
dot_continue_loop:
    addi a1, a1, 4                                  # Move to the next element in A
    addi a2, a2, 4                                  # Move to the next element in B
    addi t1, t1, 1                                  # t1++
    j dot_loop                                      # Repeat the loop
dot_end_loop:
    li a0, 0                                        # Set a0 to 0 to indicate success
    mv a1, t0                                       # Move the result into a1 for return
    j dot_end                                       # Jump to the end of the function
overflow:
    li a0, 200                                      # Set a0 to 200 to indicate an overflow error
    j dot_end                                       # Jump to the end of the function
dot_end:
    lw ra, 0(sp)                                    # Restore return address
    addi sp, sp, 4                                  # Deallocate stack space
    ret                                             # Return to the caller

# (in)  a1: pointer to int array
# (in)  a2: array length
# (out) a0: status code
# (out) a1: index of the largest element
argmax:
    # Get the index of the maximum value in A, which is of size SIZE.
    # The result will be stored in a0.
    # If here's a draw, return the smallest index among the maximum values.
    addi sp, sp, -4
    sw ra, 0(sp)                                    # Save return address on the stack
    # Initialize the max value and the index of the max value.
    lw t0, 0(a1)                                    # t0 will hold the max value
    mv t1, zero                                     # t1 will hold the index of the max value
    mv t2, zero                                     # t2 will be our loop index
    # Error checking first: if SIZE < 1, we should return 50 to indicate an error.
    slti t3, a2, 1                                  # t3 = (SIZE < 1)
    beq t3, zero, argmax_loop                       # if SIZE >= 1, we can proceed to the loop
    li a0, 50                                       # set a0 to 50 to indicate an error (invalid size)
    j argmax_end                                    # if SIZE < 1, jump to argmax_end
argmax_loop:
    # The actual loop logic.
    beq t2, a2, argmax_end_loop                     # if t2 == SIZE, we are done
    lw t3, 0(a1)                                    # load A[t2] into t3
    ble t3, t0, argmax_next                         # if A[t2] <= max_value, skip to next
    mv t0, t3                                       # max_value = A[t2]
    mv t1, t2                                       # index_of_max = t2
argmax_next:
    addi a1, a1, 4                                  # move to the next element in A
    addi t2, t2, 1                                  # t2++
    j argmax_loop                                   # repeat the loop
argmax_end_loop:
    mv a1, t1                                       # move the index of the max value into a1 for return
    li a0, 0                                        # set a0 to 0 to indicate success
argmax_end:
    lw ra, 0(sp)                                    # Restore return address
    addi sp, sp, 4                                  # Deallocate stack space
    ret                                             # return to the caller

exit_with_code:
    li a7, CONST_SYSCALL_EXIT2
    ecall

#############################################################################################################
# Helper functions for printing and debugging.
#############################################################################################################

.data
PRINT_HEADER_VOCABULARY:    .string "=== Vocabulary ==="
PRINT_HEADER_INPUT:         .string "=== Input ==="
PRINT_HEADER_INPUT_INDICES: .string "=== Input Indices ==="
PRINT_HEADER_MATRIX:        .string "=== Matrix ==="
PRINT_HEADER_SCORES:        .string "=== Scores ==="
PRINT_HEADER_NEXT_TOKEN:    .string "=== Decision ==="
PRINT_VECTOR_LB:            .string "[ "
PRINT_VECTOR_RB:            .string "]"

.text
# Prints a null-terminated string followed by a newline.
# (in) a0: buffer to print (char*)
println:
    li a7, CONST_SYSCALL_PRINT_STRING
    ecall
    li a0, CONST_CHAR_NEWLINE
    li a7, CONST_SYSCALL_PRINT_CHAR
    ecall
    ret

# Prints the vocabulary buffer.
# (in) a0: address of the vocabulary buffer (char*)
print_vocabulary:
    addi sp, sp, -8
    sw ra, 0(sp)
    sw s0, 4(sp)
    mv s0, a0
    la a0, PRINT_HEADER_VOCABULARY
    jal println
    mv a0, s0
    jal println
    lw ra, 0(sp)
    lw s0, 4(sp)
    addi sp, sp, 8
    ret

# Prints the input buffer as a string.
# (in) a0: address of the input buffer (char*)
print_input:
    addi sp, sp, -8
    sw ra, 0(sp)
    sw s0, 4(sp)
    mv s0, a0
    la a0, PRINT_HEADER_INPUT
    jal println
    mv a0, s0
    jal println
    lw ra, 0(sp)
    lw s0, 4(sp)
    addi sp, sp, 8
    ret

# Prints the input indices vector.
# (in) a0: address of the input indices vector (int*)
# (in) a1: size of the input indices vector (int)
print_indices:
    addi sp, sp, -12
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    mv s0, a0
    mv s1, a1
    la a0, PRINT_HEADER_INPUT_INDICES
    jal println
    mv a0, s0
    mv a1, s1
    jal print_vector
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    addi sp, sp, 12
    ret

print_scores:
    addi sp, sp, -4
    sw ra, 0(sp)
    la a0, PRINT_HEADER_SCORES
    jal println
    la a0, SCORES_VECTOR
    lw a1, INPUT_TOTAL_TOKENS
    jal print_vector
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# a0: address of matrix to print (int*)
# a1: number of rows
# a2: number of columns
print_matrix:
    addi sp, sp, -24
    sw ra, 0(sp)                                    # return address
    sw s0, 4(sp)                                    # matrix pointer
    sw s1, 8(sp)                                    # row index
    sw s2, 12(sp)                                   # col index
    sw s3, 16(sp)                                   # number of rows
    sw s4, 20(sp)                                   # number of columns
    mv s0, a0                                       # s0 = pointer to matrix
    mv s3, a1                                       # s3 = number of rows
    mv s4, a2                                       # s4 = number of columns
    li s1, 0                                        # s1 = current row index
    la a0, PRINT_HEADER_MATRIX
    jal println
print_matrix_row_loop:
    beq s1, s3, print_matrix_done
    li s2, 0
print_matrix_col_loop:
    beq s2, s4, print_matrix_next_row
    lw a0, 0(s0)
    li a7, CONST_SYSCALL_PRINT_INT
    ecall
    addi s0, s0, 4
    addi s2, s2, 1
    li a0, CONST_CHAR_SPACE
    li a7, CONST_SYSCALL_PRINT_CHAR
    ecall
    j print_matrix_col_loop
print_matrix_next_row:
    li a0, CONST_CHAR_NEWLINE
    li a7, CONST_SYSCALL_PRINT_CHAR
    ecall
    addi s1, s1, 1
    j print_matrix_row_loop
print_matrix_done:
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 24
    ret

# a0: address of vector to print (int*)
# a1: number of elements (int)
print_vector:
    addi sp, sp, -8
    sw s0, 0(sp)
    sw s1, 4(sp)
    mv s0, a0                                       # s0 = pointer to vector
    mv s1, a1                                       # s1 = number of elements
    la a0, PRINT_VECTOR_LB                          # Print "[ "
    li a7, CONST_SYSCALL_PRINT_STRING
    ecall
print_vector_loop:
    beq s1, zero, print_vector_done
    lw a0, 0(s0)
    li a7, CONST_SYSCALL_PRINT_INT
    ecall
    li a0, CONST_CHAR_SPACE
    li a7, CONST_SYSCALL_PRINT_CHAR
    ecall
    addi s0, s0, 4
    addi s1, s1, -1
    j print_vector_loop
print_vector_done:
    la a0, PRINT_VECTOR_RB                          # Print "]"
    li a7, CONST_SYSCALL_PRINT_STRING
    ecall
    li a0, CONST_CHAR_NEWLINE
    li a7, CONST_SYSCALL_PRINT_CHAR
    ecall
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8
    ret

# (in) a0: address of the predicted token (char*)
print_predicted_token:
    addi sp, sp, -8
    sw ra, 0(sp)
    sw s0, 4(sp)
    mv s0, a0
    la a0, PRINT_HEADER_NEXT_TOKEN
    jal println
    # s0 = start of target token, print it char by char until newline or null
print_predicted_token_char:
    lb t0, 0(s0)
    beq t0, zero, print_predicted_token_nl          # null terminator
    li t1, CONST_CHAR_NEWLINE
    beq t0, t1, print_predicted_token_nl            # newline terminator
    mv a0, t0
    li a7, CONST_SYSCALL_PRINT_CHAR
    ecall
    addi s0, s0, 1
    j print_predicted_token_char
print_predicted_token_nl:
    li a0, CONST_CHAR_NEWLINE
    li a7, CONST_SYSCALL_PRINT_CHAR
    ecall
    lw ra, 0(sp)
    lw s0, 4(sp)
    addi sp, sp, 8
    ret
