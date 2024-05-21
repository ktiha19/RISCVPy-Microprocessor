module sign_extender (INPUT, OUT);
  input [5:0] INPUT;
  output wire [7:0] OUT;

  assign OUT = (INPUT[5] == 1) ? {2'b11, INPUT} : {2'b00, INPUT};
	
endmodule
