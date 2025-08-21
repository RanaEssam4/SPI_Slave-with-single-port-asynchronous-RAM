vlib work
vlog SPI_Slave.v RAM.v TopModule.v SPI_Slave_tb.v
vsim -voptargs=+acc work.SPI_Slave_tb
add wave *
run -all
#quit -sim
