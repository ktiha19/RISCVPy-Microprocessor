`timescale 1 ns / 1 ps

module dram_test();

    // for all of your input pins, declare them as type reg, and name them identically to the pins
    reg [9:0] ADDR;
    reg [1:0] DATA_SEL;
    reg [7:0] DATA_WRITE;
    reg MW;

    wire [11:0] DATA_LOW_12BIT;
    wire [19:0] DATA_UPPER_20BIT;
    wire [7:0] DATA_BYTE;


    reg CLK;

    dram UUT(
        .CLK(CLK), 
        .ADDR(ADDR), 
        .DATA_SEL(DATA_SEL), 
        .DATA_WRITE(DATA_WRITE),
        .DATA_LOW_12BIT(DATA_LOW_12BIT), 
        .DATA_UPPER_20BIT(DATA_UPPER_20BIT),
        .DATA_BYTE(DATA_BYTE),
        .MW(MW)
    );

    // CLK: generate a 10 MHz clock (rising edge does not start until
    //     50 ticks (50 ns) into simulation, and each clock cycle lasts for
    //     100 ticks (100 ns)
    initial begin
        CLK = 1'b0;
        forever begin
            #50
            CLK = ~CLK;
        end
    end


    initial begin
        $display("Testing DRAM");

        $display("Writing 0b11111111 to 0x1");

        // it includes input values...
        ADDR = 10'h0;
        DATA_WRITE = 8'b11111111;
        MW = 1'b1;
        DATA_SEL = 2'bx;

        #100;    // wait for input signals to propagate through circuit

        $display("Writing 0b00000000 to 0x2");
        ADDR = 10'h1;
        DATA_WRITE = 8'b00000000;
        MW = 1'b1;
        DATA_SEL = 2'bx;

        #100;    // wait for input signals to propagate through circuit
    
        $display("Writing 0b11111111 to 0x3");
        ADDR = 10'h2;
        DATA_WRITE = 8'b11111111;
        MW = 1'b1;
        DATA_SEL = 2'bx;

        #100;    // wait for input signals to propagate through circuit

        $display("Writing 0b00000000 to 0x4");
        ADDR = 10'h3;
        DATA_WRITE = 8'b00000000;
        MW = 1'b1;
        DATA_SEL = 2'bx;

        #100;    // wait for input signals to propagate through circuit

        $display("Testing lower 12bit read at 0x1");

        ADDR = 10'h0;
        DATA_WRITE = 8'bx;
        MW = 1'b0;
        DATA_SEL = 2'b00;

        #100;
        if(DATA_LOW_12BIT == 12'b111111110000) begin
            $display("CORRECT, data read is = %12b", DATA_LOW_12BIT);
        end
        else begin
            $display("ERROR, data read is = %12b", DATA_LOW_12BIT);
            $stop;
        end     

        $display("Testing upper 20 bit read at 0x1");

        ADDR = 10'h0;
        DATA_WRITE = 8'bx;
        MW = 1'b0;
        DATA_SEL = 2'b01;

        #100;
        if(DATA_UPPER_20BIT == 20'b00001111111100000000) begin
            $display("CORRECT, data read is = %20b", DATA_UPPER_20BIT);
        end
        else begin
            $display("ERROR, data read is = %20b", DATA_UPPER_20BIT);
            $stop;
        end     
        
        $display("Testing byte read at 0x0");

        ADDR = 10'h0;
        DATA_WRITE = 8'bx;
        MW = 1'b0;
        DATA_SEL = 2'b10;

        #100;
        if(DATA_BYTE == 8'b11111111) begin
            $display("CORRECT, data read is = %8b", DATA_BYTE);
        end
        else begin
            $display("ERROR, data read is = %8b", DATA_BYTE);
            $stop;
        end     
        

        $display("ALL DRAM TEST PASSED");


        $finish;
        
    end
endmodule
