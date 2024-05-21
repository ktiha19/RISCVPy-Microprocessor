module logical(A, B, OA, Y);

  // inputs
  input [7:0] A, B;
  input OA;

  // outputs
  output [7:0] Y;

  /* ADD YOUR CODE BELOW THIS LINE */
  
  assign Y = OA ? (A & B) : (A | B);

  /* ADD YOUR CODE ABOVE THIS LINE */

endmodule
