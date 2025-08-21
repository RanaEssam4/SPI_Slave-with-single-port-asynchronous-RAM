module SPI_Slave(MOSI,clk,SS_n,tx_data,tx_valid,rst_n,MISO,rx_valid,rx_data);

    input MOSI,clk,SS_n;
    input [7:0] tx_data;
    input tx_valid,rst_n;
    output reg MISO,rx_valid;
    output reg [9:0] rx_data;
    
parameter IDLE     = 3'b000;
parameter CHK_CMD  = 3'b001;
parameter WRITE    = 3'b010;
parameter READ_DATA= 3'b011;
parameter READ_ADD = 3'b100;

reg [2:0] cs, ns;
reg read_ctrl;           // Tracks if read address was received
reg is_read_cmd;         // Stores first command bit (1=read, 0=write)
reg [3:0] bit_count;    
reg [9:0] rx_buffer;
reg flag;

// STATE MEMORY
always @(posedge clk) begin
    if (!rst_n) 
        cs <= IDLE;
    else 
        cs <= ns;
end

// NEXT STATE LOGIC
always @(*) begin
    
    case (cs)
        IDLE: begin
            ns = (!SS_n) ? CHK_CMD : IDLE;
        end
        
        CHK_CMD: begin
            if (SS_n) 
                ns = IDLE;
            else begin
                if(is_read_cmd)
                    ns = ((!read_ctrl) ? READ_ADD : READ_DATA);
                else 
                    ns = WRITE;
            end
        end
        
        WRITE: begin
            if (SS_n) 
                ns = IDLE;
            else if (bit_count < 10) 
                ns = cs;
            else 
                ns = IDLE;
        end

        READ_ADD: begin
            if (SS_n) 
                ns = IDLE;
            else if (bit_count < 10) 
                ns = cs;
            else 
                ns = IDLE ;
        end

        READ_DATA: begin
            if (SS_n) 
                ns = IDLE;
            else if (bit_count < 10) 
                ns = cs;
            else 
                ns = IDLE;
        end
        
        default: ns = IDLE;
    endcase
end

// OUTPUT LOGIC
always @(posedge clk) begin
    if (!rst_n) begin
        rx_valid    <= 1'b0;
        rx_data     <= 10'b0;
        rx_buffer   <= 10'b0;
        MISO        <= 1'b0;
        bit_count   <= 4'b0;
        read_ctrl   <= 1'b0;
        is_read_cmd <= 1'b0;
        flag        <= 1'b0;
    end 
    else begin
        rx_valid <= 1'b0;
        if(tx_valid)
            flag<=1;
                    
        case (cs)
            IDLE: begin
                bit_count <= 4'b0;
                MISO      <= 1'b0;
                rx_valid  <= 1'b0;
            end
            
            CHK_CMD: begin
                if (!SS_n) begin
                    is_read_cmd <= MOSI; 
                    bit_count   <= 4'b0;   
                end
            end
            
            WRITE: begin
                if (!SS_n) begin
                    if (bit_count < 10) begin
                        rx_buffer[9-bit_count] <= MOSI;
                        
                        if (bit_count == 9) begin
                            rx_data<= rx_buffer;
                            rx_valid <= 1'b1;
                        end
                        else 
                            rx_valid <= 1'b0;

                        bit_count <= bit_count + 1;  
                    end
                end
            end
            
            READ_ADD: begin
                if (!SS_n && (bit_count < 10)) begin
                    rx_data[9-bit_count] <= MOSI;
                    
                    if (bit_count == 9) begin  
                        rx_valid <= 1'b1;
                        read_ctrl <= 1'b1;
                         bit_count<=0;
                    end
                    else
                       rx_valid<=0;                    
                       
                    bit_count <= bit_count + 1;
                end
            end
            
            READ_DATA: begin
                if (!SS_n && (bit_count < 10)) begin
                    rx_data[9-bit_count] <= MOSI;
                   
                    if (flag && (bit_count < 8)) 
                        MISO <= tx_data[7-bit_count];
                    else 
                        MISO <= 1'b0;  
                    
                    if (bit_count == 9) begin 
                        read_ctrl <= 1'b0;
                        flag<=0; 
                    end                    
                    
                    bit_count <= bit_count + 1;
                end
                else
                    bit_count<=0;
            end
        endcase
    end
end
endmodule


