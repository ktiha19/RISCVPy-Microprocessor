module pcbranch(CLK, PC, OFFSET, FUNCT_THREE, Z, N, NEXTPC);
    input CLK;
    input [31:0] OFFSET;
    input [2:0] FUNCT_THREE; // used for determining beq, jal, jalr, etc...
    input Z;
    input N;

    input [31:0] PC;
    
    output reg [31:0] NEXTPC; 

    always @ (posedge CLK) begin
        case(FUNCT_THREE) 
            3'b000: NEXTPC <= (Z) ? (PC + OFFSET) : (PC + 4); // beq 
            3'b001: NEXTPC <= ~Z ? PC + OFFSET : PC + 4; // bne
            3'b100: NEXTPC <= N ? PC + OFFSET : PC + 4; // blt
            3'b101: NEXTPC <= ~N ?  PC + OFFSET : PC + 4; // bge
            3'b010: NEXTPC <= PC + OFFSET; // jal, jalr
	        default: NEXTPC <= PC + 4; // default is go to next line
	    // no support yet for bltu and bgeu     
        endcase
    end

endmodule
    
