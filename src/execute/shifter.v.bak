module shifter(A, FUNCT_SEVEN, FUNCT_THREE Y, C);

  // inputs
  input wire [31:0] A;
  input [6:0] FUNCT_SEVEN;
  input [2:0] FUNCT_THREE;

  // outputs
  output wire [31:0] Y;
  output wire C;

  assign C = (FUNCT_THREE == 3'h5) ? A[0] : A[7];
  assign Y = (FUNCT_THREE == 3'h1) ? A << 1 : (FUNCT_SEVEN == 7'h0) ? A >> 1 : A >>> 1;

endmodule