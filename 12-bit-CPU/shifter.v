module shifter(A, LA, LR, Y, C);

  // inputs
  input [7:0] A;
  input LA, LR;

  // outputs
  output [7:0] Y;
  output C;

  /* ADD YOUR CODE BELOW THIS LINE */
  
  assign Y[0] = LR == 0 ? 0 : A[1];
  assign Y[1] = LR == 0 ? A[0] : A[2];
  assign Y[2] = LR == 0 ? A[1] : A[3];
  assign Y[3] = LR == 0 ? A[2] : A[4];
  assign Y[4] = LR == 0 ? A[3] : A[5];
  assign Y[5] = LR == 0 ? A[4] : A[6];
  assign Y[6] = LR == 0 ? A[5] : A[7];
  assign Y[7] = LR == 0 ? A[6] : (LA == 0 ? 0 : A[7]);
  assign C = LR == 0 ? A[7] : A[0];

  /* ADD YOUR CODE ABOVE THIS LINE */

endmodule
