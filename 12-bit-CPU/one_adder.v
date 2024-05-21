module one_adder(A, B, CI, Y, CO);
	input A, B, CI;
	output Y, CO;
	
	assign Y = A ^ B ^ CI;
	assign CO = ((A ^ B) && CI) || (A & B);
endmodule