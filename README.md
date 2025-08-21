# SPI_Slave-with-single-port-asynchronous-RAM

This project implements an **SPI Slave module** interfaced with a **Single-Port Synchronous RAM** using Verilog.  
It enables read and write operations via SPI communication, with the internal RAM serving as the storage for transferred data.  
The design ensures synchronous operation with the SPI clock while maintaining reliable data integrity between the communication and memory blocks.

---

## Features
- SPI Slave interface compliant with standard SPI modes.  
- Full-duplex communication via MOSI and MISO.  
- Single-Port Synchronous RAM for data storage.  
- Supports both read and write operations.  
- Synchronous operation with SCK from master.  
- Parameterized memory depth and data width.  
- Fully synthesizable Verilog code.  
- Testbench for functional verification.  

---

## Project Structure

├── bitstream/         # Bitstream file
├── constraints/       # Clock and pin constraint file (.xdc)
├── netlist/           # Netlist file
├── src/               # Verilog source files
├── tb/                # Testbench files
├── SPI_Report.pdf     # Detailed project report

---


## Tools & Technologies
- **QuestaSim** — Simulation  
- **QuestaLint** — Static analysis  
- **Xilinx Vivado** — Synthesis, Implementation, and Bitstream generation  

---

## Documentation
The full design documentation `SPI_Report.pdf` includes:

- RTL Design  
- Testbench description  
- Simulation results  
- DO file  
- Constraint file  
- RTL Schematic  
- For each encoding style (Gray, One-Hot, and Sequential):  
  - Synthesis report  
  - Implementation report  
  - Timing analysis  
  - Device utilization  
  - Comparison between the three FSM encoding styles  
- Post-debugging synthesis and implementation analysis for the most efficient encoding style  
- Linting with **0 errors and warnings**  
- Bitstream generation for FPGA configuration  

---

## Design Files
- `SPI.v` : Verilog module for SPI slave implementation.  
- `RAM.v` : Verilog module for single-port RAM.  
- `SPI_Wrapper.v` : Top-level Verilog module integrating SPI slave and RAM.  
- `SPI_Wrapper_tb.v` : Testbench for simulation and verification of the SPI wrapper.  
- `run.do` : Script file for automating the simulation process.  

---

## Getting Started

To work with this project, you’ll need a Verilog simulator. **QuestaSim** is recommended.

### 1. Quick Simulation (Recommended)
A preconfigured script `run.do` is provided to automate the simulation.

**Steps:**
1. Ensure your simulator is installed and licensed.  
2. Open a terminal or simulator console.  
3. Navigate to the project directory.  
4. Run:  
   ```tcl
   do run.do
