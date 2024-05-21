module adder(A, B, CI, Y, C, V);

  // inputs
  input [7:0] A, B;
  input CI;

  // outputs
  output [7:0] Y;
  output C, V;

  /* ADD YOUR CODE BELOW THIS LINE */
  
  	wire [6:0] carry;
  
   one_adder first_adder(
	.A(A[0]),
	.B(B[0]),
	.CI(CI),
	.Y(Y[0]),
	.CO(carry[0])
  );

  one_adder second_adder(
	.A(A[1]),
	.B(B[1]),
	.CI(carry[0]),
	.Y(Y[1]),
	.CO(carry[1])
  );
  
  one_adder third_adder(
	.A(A[2]),
	.B(B[2]),
	.CI(carry[1]),
	.Y(Y[2]),
	.CO(carry[2])
  );
  
  one_adder fourth_adder(
	.A(A[3]),
	.B(B[3]),
	.CI(carry[2]),
	.Y(Y[3]),
	.CO(carry[3])
  );
  
  one_adder fifth_adder(
	.A(A[4]),
	.B(B[4]),
	.CI(carry[3]),
	.Y(Y[4]),
	.CO(carry[4])
  );
  
  one_adder sixth_adder(
	.A(A[5]),
	.B(B[5]),
	.CI(carry[4]),
	.Y(Y[5]),
	.CO(carry[5])
  );
  
  one_adder seventh_adder(
	.A(A[6]),
	.B(B[6]),
	.CI(carry[5]),
	.Y(Y[6]),
	.CO(carry[6])
  );
  
  one_adder eighth_adder(
	.A(A[7]),
	.B(B[7]),
	.CI(carry[6]),
	.Y(Y[7]),
	.CO(C)
  );
  
  assign V = (C != carry[6]);

  /* ADD YOUR CODE ABOVE THIS LINE */

endmodule
