# SPI_Slave-with-single-port-asynchronous-RAM

This project implements an **SPI Slave module** interfaced with a **Single-Port Synchronous RAM** using Verilog.  
It enables read and write operations via SPI communication, with the internal RAM serving as the storage for transferred data.  
The design ensures synchronous operation with the SPI clock while maintaining reliable data integrity between the communication and memory blocks.

---

## Features

- **SPI Slave with FSM Control**
  - Finite State Machine (FSM) with **5 states**:
    - `IDLE`
    - `CHK_CMD`
    - `WRITE`
    - `READ_ADD`
    - `READ_DATA`

- **FSM Encoding Experiments**
  - Sequential encoding (`(* fsm_encoding = "sequential" *)`)
  - One-Hot encoding
  - Gray encoding  
  - Each encoding style evaluated for **timing performance** and **FPGA area utilization**.  
  - Best approach selected based on synthesis results.

- **RX Data Tagging (2-bit MSB)**
  - `2'b00` → Address  
  - `2'b01` → Write Data  
  - `2'b10` → Read Address  
  - `2'b11` → Read Data  

- **Single-Port Synchronous RAM**
  - 8-bit data width  
  - 256 memory locations  
  - Read/Write operations controlled by `rx_valid`  

- **Verification and Deployment**
  - Simulation testbenches included  
  - Timing analysis completed  
  - FPGA bitstream successfully generated  


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
The full design documentation `spi_slave_document.pdf` includes:

- RTL Design  
- Testbench description  
- Simulation results  
- DO file  
- Constraint file  
- RTL Schematic
- Netlist file 
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
- `SPI_Slave.v` : Verilog module for SPI slave implementation.  
- `RAM.v` : Verilog module for single-port RAM.  
- `TopModule.v` : Top-level Verilog module integrating SPI slave and RAM.  
- `SPI_Slave_tb.v` : Testbench for simulation and verification of the SPI wrapper.  
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
