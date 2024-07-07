`timescale 1 ns / 1 ps

module test_pcbranch();

    // for all of your input pins, declare them as type reg, and name them identically to the pins
    reg CLK;

    reg [31:0] OFFSET;
    reg [2:0] FUNCT_THREE; // used for determining beq, jal, jalr, etc...
    reg Z;
    reg N;
    reg [31:0] PC;

    wire [31:0] NEXTPC;


    pcbranch UUT(
             .CLK(CLK), 
             .PC(PC), 
             .OFFSET(OFFSET), 
             .FUNCT_THREE(FUNCT_THREE), 
             .Z(Z), 
             .N(N),
             .NEXTPC(NEXTPC)
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
        $display("Running Test Bench for PC");

        $display("Testing default");

        FUNCT_THREE = 3'b011;
        OFFSET = 32'd0;
        Z = 1'b0;
        N = 1'b0;

        #100;
        assign PC = NEXTPC;
        
        if(PC == 32'd4) begin
            $display("PC Correct, PC = %2d", PC);
        end
        else begin
            $display("ERROR, PC incorrect, PC = %2d", PC);
            $stop;
        end

        $display("Testing BEQ #1");
        FUNCT_THREE = 3'b000;
        OFFSET = 32'd8;
        Z = 1'b1;
        N = 1'b0;

        #100;
        assign PC = NEXTPC;
        
        if(PC == 32'd12) begin
            $display("PC Correct, PC = %2d", PC);
        end
        else begin
            $display("ERROR, PC incorrect, PC = %2d", PC);
            $stop;
        end

        $display("Testing BEQ #2");
        FUNCT_THREE = 3'b000;
        OFFSET = 32'd8;
        Z = 1'b0;
        N = 1'b0;

        #100;
        assign PC = NEXTPC;
        
        if(PC == 32'd16) begin
            $display("PC Correct, PC = %2d", PC);
        end
        else begin
            $display("ERROR, PC incorrect, PC = %2d", PC);
            $stop;
        end

        $display("Testing BNE #1");
        FUNCT_THREE = 3'b001;
        OFFSET = 32'd8;
        Z = 1'b0;
        N = 1'b0;

        #100;
        assign PC = NEXTPC;
        
        if(PC == 32'd24) begin
            $display("PC Correct, PC = %2d", PC);
        end
        else begin
            $display("ERROR, PC incorrect, PC = %2d", PC);
            $stop;
        end

        $display("Testing BNE #2");
        FUNCT_THREE = 3'b001;
        OFFSET = 32'd8;
        Z = 1'b1;
        N = 1'b0;

        #100;
        assign PC = NEXTPC;
        
        if(PC == 32'd28) begin
            $display("PC Correct, PC = %2d", PC);
        end
        else begin
            $display("ERROR, PC incorrect, PC = %2d", PC);
            $stop;
        end     

        $display("Testing BLT #1");
        FUNCT_THREE = 3'b0100;
        OFFSET = 32'd8;
        Z = 1'b0;
        N = 1'b1;

        #100;
        assign PC = NEXTPC;
        
        if(PC == 32'd36) begin
            $display("PC Correct, PC = %2d", PC);
        end
        else begin
            $display("ERROR, PC incorrect, PC = %2d", PC);
            $stop;
        end

        $display("Testing BLT #2");
        FUNCT_THREE = 3'b100;
        OFFSET = 32'd8;
        Z = 1'b1;
        N = 1'b0;

        #100;
        assign PC = NEXTPC;
        
        if(PC == 32'd40) begin
            $display("PC Correct, PC = %2d", PC);
        end
        else begin
            $display("ERROR, PC incorrect, PC = %2d", PC);
            $stop;
        end     
        
        $display("Testing BGE #1");
        FUNCT_THREE = 3'b0100;
        OFFSET = 32'd8;
        Z = 1'b0;
        N = 1'b0;

        #100;
        assign PC = NEXTPC;
        
        if(PC == 32'd44) begin
            $display("PC Correct, PC = %2d", PC);
        end
        else begin
            $display("ERROR, PC incorrect, PC = %2d", PC);
            $stop;
        end

        $display("Testing BGE #2");
        FUNCT_THREE = 3'b100;
        OFFSET = 32'd8;
        Z = 1'b0;
        N = 1'b1;

        #100;
        assign PC = NEXTPC;
        
        if(PC == 32'd52) begin
            $display("PC Correct, PC = %2d", PC);
        end
        else begin
            $display("ERROR, PC incorrect, PC = %2d", PC);
            $stop;
        end     

                
        $display("Testing JAL, JALR #1");
        FUNCT_THREE = 3'b0010;
        OFFSET = 32'd8;
        Z = 1'bx;
        N = 1'bx;

        #100;
        assign PC = NEXTPC;
        
        if(PC == 32'd60) begin
            $display("PC Correct, PC = %2d", PC);
        end
        else begin
            $display("ERROR, PC incorrect, PC = %2d", PC);
            $stop;
        end

        $display("Testing JAL, JALR #2");
        FUNCT_THREE = 3'b010;
        OFFSET = 32'd12;
        Z = 1'bx;
        N = 1'bx;

        #100;
        assign PC = NEXTPC;
        
        if(PC == 32'd72) begin
            $display("PC Correct, PC = %2d", PC);
        end
        else begin
            $display("ERROR, PC incorrect, PC = %2d", PC);
            $stop; // exits sim with error
        end     
        
        $display("ALL PC TEST PASSED");

        $finish; // need this gracefully end sim
        end
endmodule
