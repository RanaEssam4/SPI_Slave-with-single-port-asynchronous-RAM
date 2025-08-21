module SPI_RAM(din,clk,rst_n,rx_valid,dout,tx_valid);
input [9:0] din;
input clk,rst_n,rx_valid;
output reg [7:0] dout;
output reg tx_valid;
parameter MEM_DEPTH=256;
parameter ADDR_SIZE=8;

reg [ADDR_SIZE-1:0] wr_addr;
reg [ADDR_SIZE-1:0] rd_addr;
reg [7:0] mem [MEM_DEPTH-1:0];
integer i;


always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        dout<=0;
        tx_valid<=0;
        wr_addr<=0;
        rd_addr<=0;
    end
    else if(rx_valid) begin

        case(din[9:8])
        'b00: wr_addr <= din[7:0];
        'b01: mem[wr_addr] <= din[7:0];
        'b10: rd_addr <= din[7:0];
        'b11: begin 
            dout<= mem[rd_addr];
            tx_valid <= 1;
        end
    endcase
    end
    
    else 
        tx_valid <= 0;
end
endmodule