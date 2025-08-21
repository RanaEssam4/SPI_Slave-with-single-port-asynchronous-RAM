module TopModule(MOSI,clk,SS_n,rst_n,MISO);

    input MOSI,clk,SS_n,rst_n;
    output MISO;
   
    wire [9:0] rx_data;
    wire rx_valid,tx_valid;
    wire [7:0] tx_data;

    SPI_Slave spi_slave (MOSI,clk,SS_n,tx_data,tx_valid,rst_n,MISO,rx_valid,rx_data);
    
    SPI_RAM ram(rx_data,clk,rst_n,rx_valid,tx_data,tx_valid);

endmodule