module adder(A, B, FC, Y, C, V):
  input [31:0]  A, B;
  input [1:0]   FC;
  input [7:0]   OPCODE;

  output wire [31:0] Y;
  output wire C;
  output wire V;
  output wire N;
  output wire Z;
  
  wire [32:0] Y_VALUE;
  assign Y_VALUE = (FC = 2'b01) ? A - B : A + B; 
  
  assign Y = Y_VALUE[31:0];
  assign C = Y_VALUE[32];
  assign V = (A[31] == B[31]) && (Y_VALUE[31] != A[31]);
endmodule
