🚀 RISC-V 5-Stage Pipeline CPU

📌 Overview

This project implements a 32-bit RISC-V (RV32I) 5-stage pipelined CPU in Verilog.
It demonstrates how pipelining improves performance by executing multiple instructions concurrently across different stages.

⚙️ Features

RV32I instruction set

5 pipeline stages:

- IF (Instruction Fetch)

- ID (Instruction Decode)

- EX (Execute)

- MEM (Memory)

- WB (Write Back)

Hazard handling:

- Data hazards (forwarding, stalling)

- Control hazards (pipeline flushing)

Modular Verilog design (datapath, control, hazard unit)

🏗️ Architecture

IF → ID → EX → MEM → WB

Pipeline registers between stages

ALU and Register File

Control Unit and Hazard Unit
