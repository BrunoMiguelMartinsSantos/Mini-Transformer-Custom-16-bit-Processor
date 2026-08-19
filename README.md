# Mini-Transformer & Custom 16-bit Processor

A three-part Computer Architecture project exploring the implementation of core **Transformer operations from software to hardware**.

The project begins with low-level vector operations written in **RISC-V Assembly**, builds upon them to implement a simplified **Transformer attention pipeline**, and concludes with the design of a **custom 16-bit single-cycle processor** in Logisim with dedicated instructions for accelerating dot-product operations.

## Overview

The project is divided into three interconnected stages:

### Project 1 — RISC-V Vector Operations

Implementation of fundamental vector operations in **RISC-V Assembly**:

* `dot` — computes the dot product of two integer vectors
* `argmax` — returns the index of the maximum element in a vector
* `select` — retrieves an element from a vector given its index

These functions involve:

* pointer arithmetic
* memory access
* loops and conditional branches
* register management
* integer arithmetic
* error and overflow handling

These operations serve as building blocks for the attention mechanism implemented in Project 2.

---

### Project 2 — Mini-Transformer in RISC-V

The second stage combines the low-level operations from Project 1 into a simplified **Transformer-based next-token prediction pipeline**, implemented entirely in RISC-V Assembly.

The program:

1. Reads the vocabulary, input tokens, embeddings and weight matrices.

2. Converts the input tokens into vocabulary indices.

3. Builds the corresponding input embedding matrix.

4. Computes the Transformer matrices:

   `Q = Embeddings × W_Q`

   `K = Embeddings × W_K`

   `V = Embeddings × W_V`

5. Computes attention scores using dot products between the query and key vectors.

6. Selects the most relevant token using `argmax`.

7. Retrieves the corresponding value vector.

8. Compares the resulting vector with the vocabulary embeddings.

9. Predicts the next token.

This project required implementing several low-level components such as:

* file parsing
* token processing
* matrix multiplication
* vector operations
* memory management
* function calls and stack management
* attention-score computation

The implementation uses fixed-size integer vectors with an embedding dimension of **4**, supporting a vocabulary of up to **100 tokens** and input sequences of up to **10 tokens**.

---

### Project 3 — Custom 16-bit AI Processor

The final stage moves from software to hardware.

A custom **16-bit single-cycle processor** was designed and implemented using **Logisim Evolution**.

The processor uses a custom Instruction Set Architecture (ISA) and includes specialized instructions designed to accelerate vector operations used by the previous Mini-Transformer implementation.

#### Instruction Set

| Instruction | Purpose                                      |
| ----------- | -------------------------------------------- |
| `li`        | Load an immediate value into a register      |
| `add`       | Add register values                          |
| `dot`       | Perform a specialized dot-product operation  |
| `dota`      | Perform a dot-product accumulation operation |

The processor contains **8 registers**, encoded using 3-bit register addresses.

Example instruction formats:

```text
li   -> OPCODE [15:13] | RD [12:10] | IMM [9:0]

add  -> OPCODE [15:13] | RD [12:10] | RS1 [9:7]

dot  -> OPCODE [15:13] | RD [12:10] | RS1 [9:7]

dota -> OPCODE [15:13] | RD [12:10] | RS1 [9:7] | RS2 [6:4]
```

The architecture was designed using several modular components:

* **Program Counter (PC)** — selects the next instruction
* **Register Bank** — stores and provides operands
* **ALU** — performs arithmetic operations
* **Dot unit** — executes specialized dot-product operations
* **DotA unit** — executes dot-product accumulation
* **Multiplexers** — select the appropriate result according to the instruction opcode

All functional units operate in parallel and the correct result is selected according to the current instruction.

The modular design also allows the architecture to be extended with additional instructions in the future.

---

## Project Evolution

The three projects progressively move down the computing stack:

```text
Project 1
RISC-V vector operations
        │
        ▼
Project 2
Mini-Transformer in RISC-V
        │
        ▼
Project 3
Custom processor with
hardware DOT acceleration
```

This progression demonstrates how a high-level machine-learning operation such as **attention** can ultimately be decomposed into basic arithmetic operations and implemented directly in processor hardware.

---

## Technologies

* **RISC-V Assembly**
* **Computer Architecture**
* **Assembly Programming**
* **Logisim Evolution**
* **Digital Logic**
* **Processor Design**
* **Matrix & Vector Operations**
* **Transformer Attention**

---

## Repository Structure

```text
.
├── project1/
│   ├── argmax.s
│   ├── dot.s
│   └── select.s
│
├── project2/
│   └── mini_transformer.s
│
├── project3/
│   ├── processor.circ
│   └── README.txt
│
└── README.md
```

## Key Concepts

Throughout the three stages, the project explores:

* RISC-V instruction-level programming
* memory addressing and pointers
* calling conventions
* stack management
* matrix multiplication
* dot products
* vector similarity
* Transformer attention
* instruction-set design
* datapath design
* register files
* ALUs
* single-cycle processors
* hardware acceleration

## Academic Context

Developed as part of the **Introduction to Computer Architecture** course at Instituto Superior Técnico (IST), University of Lisbon.

The project focuses on understanding how computations used by modern AI models can be implemented progressively from low-level software to dedicated hardware.
