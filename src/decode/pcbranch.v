module pcbranch(CLK, PC, OFFSET, BRANCH, TYPE_CODE, Z, N, NEXTPC):
    input CLK;
    input [31:0] PC, OFFSET;
    input [2:0] FUNCT_THREE; // used for determining beq, jal, jalr, etc...
    input Z;
    input N;

    output reg [31:0] NEXTPC;

    always @ (posedge CLK) begin
        case(FUNCT_THREE) begin
	    3'b000: Z ? NEXTPC = PC + OFFSET : NEXTPC = PC + 4; // beq 
            3'b001: ~Z ? NEXTPC = PC + OFFSET : NEXTPC = PC + 4; // bne
	    3'b100: N ? NEXTPC = PC + OFFSET : NEXTPC = PC + 4; // blt
	    3'b101: ~N ? NEXTPC = PC + OFFSET : NEXTPC = PC + 4; // bge
            3'b010: NEXTPC = PC + OFFSET; // jal, jalr
	    default: NEXTPC = PC + 4; // default is go to next line
	    // no support yet for bltu and bgeu     
	end
    end

endmodule
    
