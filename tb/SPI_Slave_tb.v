module SPI_Slave_tb();

    reg clk,rst_n;
    reg MOSI,SS_n;
    wire MISO;

    reg [9:0] master_tx_data;
    reg [7:0] expected_data;
    reg [7:0] received;         //recieved from the Slave
    integer i;

    TopModule dut(MOSI,clk,SS_n,rst_n,MISO); 

    initial begin
        clk = 0;
        forever 
        #1 clk = ~clk;
    end

initial begin
    rst_n = 0;
    SS_n  = 1;
    MOSI  = 0;
    master_tx_data = 0;
    expected_data  = 0;
    received       = 0;

    @(negedge clk);
    rst_n = 1;
    @(negedge clk);

    //Test1     Write address command(00)
        $display("Test 1 : Write Address Command");

        master_tx_data = 10'b0010101010;   // Address = 8'hAA
        SS_n = 0;
        MOSI = 0;
        repeat(2)@(negedge clk);

            for (i = 10; i >= 1; i = i - 1) begin
                MOSI = master_tx_data[i-1];
                @(negedge clk);
            end

            repeat(3) @(negedge clk);
            SS_n = 1;

        $display("TEST 1 IS COMPLETED");
/////////////////////////////////////////////////////
    //Self Checking
            $display(" Verify RAM Address");
            if (dut.ram.wr_addr !== 8'hAA) begin
            $display("ERROR...Correct value is 0xCC but incorrect value 0x%h", dut.ram.wr_addr);
            $stop;
        end
            $display("Verfication is completed");
        
        @(negedge clk);
////////////////////////////////////////////////////
     //Test2        Write Data command(01)
        $display("Test 2 : Write Data Command");

        master_tx_data = 10'b0111001100;   // Data = 8'hCC
        SS_n = 0;
        MOSI = 0;
        repeat(2) @(negedge clk);

            for (i = 10; i >= 1; i = i - 1) begin
                MOSI = master_tx_data[i-1];
                @(negedge clk);
            end

            repeat(3)@(negedge clk);
            SS_n = 1;
            @(negedge clk);  
        $display("TEST 2 IS COMPLETED");
////////////////////////////////////////////////////
    //Self Checking
        $display(" Verify RAM Content");
        if (dut.ram.mem[8'hAA] !== 8'hCC) begin
            $display("ERROR...Correct value is 0xCC but incorrect value 0x%h", dut.ram.mem[8'hAA]);
            $stop;
        end
        else
            $display("Verfication is completed");
/////////////////////////////////////////////////////
    //Test3         Read Address command(10)
        $display("Test 3 : Read Address Command");
        master_tx_data = 10'b10_10101010; 
        SS_n = 0;
        MOSI = 1;
        repeat(2) @(negedge clk);

            for (i = 10; i >= 1; i = i - 1) begin
                MOSI = master_tx_data[i-1];
                @(negedge clk);
            end

            SS_n = 1;
            @(negedge clk);
        $display("TEST 3 IS COMPLETED");
/////////////////////////////////////////////////////
    //Test4         Read Data command(11) 
        $display("Test 4 : Read Data Command");
        master_tx_data = 10'b11_00000000; 
        expected_data  = 8'b11001100;
        SS_n = 0;
        MOSI = 1;
        repeat(2)@(negedge clk);

            for (i = 10; i >= 1; i = i - 1) begin
                MOSI = master_tx_data[i-1];
                @(negedge clk);
            end

            repeat(4)@(negedge clk);

            for (i = 8; i >= 1; i = i - 1) begin
                received[i-1] = MISO;
                @(negedge clk);
            end

            repeat(6)@(negedge clk);
            SS_n = 1;
            @(negedge clk);
        $display("TEST 4 IS COMPLETED");
////////////////////////////////////////////////////////
        //Self Checking
         if (received != expected_data) begin
                $display("ERROR in read operation");
                $display("Expected: 0x%h, Received: 0x%h", expected_data, received);
                $stop;
            end
        else 
                $display("Testbench is completed");

$stop;
end
endmodule