module logical(A, B, FUNCT_THREE, Y):
	
	//inputs
	input [31:0] A, B;
	input [3:0] FUNCT_THREE;
	
	//output
	output wire [31:0] Y;
	
	assign Y = (FUNCT_THREE == 3'h4) ? A ^ B : (FUNCT_THREE == 3'h6) ? A | B : A & B;
	
endmodule