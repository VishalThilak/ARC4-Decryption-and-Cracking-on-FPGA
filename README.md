# ARC4 Decryption and Cracking on FPGA

## Overview

This project implements an ARC4 decryption and cracking system on the DE1-SoC FPGA board using Verilog. ARC4, a symmetric stream cipher, provides a foundation for understanding cryptographic algorithms and FPGA design. The project integrates multiple on-chip memory modules and a ready-enable microprotocol for efficient communication between components. The system features decryption, brute-force key cracking, and parallel processing.

## Core Functionality

### ARC4 Decryption
- **Initialization:** Initializes the ARC4 state array (`S`) with values `[0..255]`.
- **Key-Scheduling Algorithm (KSA):** Mixes the encryption key into the state array to ensure secure randomness.
- **Pseudo-Random Generation Algorithm (PRGA):** Generates a byte stream to decrypt the ciphertext.
- **Decryption:** XORs the pseudo-random byte stream with ciphertext to produce plaintext.

### Key Cracking
- **Brute-Force Key Search:** Systematically searches the key space to decrypt encrypted messages, stopping when a valid plaintext is found.
- **Parallel Cracking:** Utilizes two cracking units to speed up the search by processing different parts of the key space concurrently.

## Features
1. **Efficient Memory Management:** Implements on-chip memories (`S`, `CT`, `PT`) for state, ciphertext, and plaintext.
2. **Ready-Enable Protocol:** Ensures precise synchronization between modules with variable latencies.
3. **FPGA Deployment:** Synthesized and tested on the DE1-SoC FPGA, using hardware switches and LEDs for user interaction and debugging.

## Getting Started

### Prerequisites
- Quartus Prime for synthesis and programming.
- ModelSim for simulation and testing.
- DE1-SoC FPGA board.

### How to Run
1. **Clone the Repository:** Ensure all necessary Verilog files and memory initialization files are available.
2. **Simulate the Design:** Use ModelSim to verify the functionality of individual modules and test cases.
3. **Synthesize and Deploy:** Program the FPGA using Quartus Prime.
4. **Interact with Hardware:** Use switches to input the key and observe results on LEDs and seven-segment displays.


## Author
Vishal Thilak
