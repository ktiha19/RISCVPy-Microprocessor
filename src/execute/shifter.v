module shifter(A, FC, Y, C);

  // inputs
  input wire [31:0] A;
  input [2:0] FUNCT_THREE;

  // outputs
  output wire [31:0] Y;
  output wire C;

  assign C = (FC == 3'h5) ? A[0] : A[7];
  assign Y = (FC == 3'h5) ? A << 1 : (FC == 3'h6) ? A >> 1 : A >>> 1;

endmodule