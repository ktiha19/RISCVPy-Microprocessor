module adder(A, B, FUNCT_SEVEN, Y, C, V, N, Z)):

  //inputs
  input [31:0]  A, B;
  input [6:0]  FUNCT_SEVEN;
  
  //outputs
  output wire [31:0] Y;
  output wire C;
  output wire V;
  output wire N;
  output wire Z;
  
  wire [32:0] Y_VALUE;
  assign Y_VALUE = (FUNCT_SEVEN == 7'h20) ? A - B : A + B;
  
  assign Y = Y_VALUE[31:0];
  assign C = Y_VALUE[32];
  assign V = (A[31] == B[31]) && (Y_VALUE[31] != A[31]);
  assign N = Y[31];
  assign Z = (Y == 32'b0);

endmodule
