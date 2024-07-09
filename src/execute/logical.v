module logical(A, B, FC, Y):
	
	//inputs
  input [31:0] A, B;
  input [2:0] FC;
	
	//output
	output wire [31:0] Y;
	
	assign Y = (FC == 3'h2) ? A & B : (FC == 3'h3) ? A | B : A ^ B;
	
endmodule