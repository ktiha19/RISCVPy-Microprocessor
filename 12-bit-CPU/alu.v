module alu(A, B, FS, Y, C, V, N, Z);
  input  [7:0]  A;
  input  [7:0]  B;
  input  [2:0]  FS;

  output [7:0]  Y;
  output        C;
  output        V;
  output        N;
  output        Z;


  /* ADD YOUR CODE BELOW THIS LINE */

  wire BSEL;
  wire CISEL;
  wire [1:0] OSEL;
  wire SHIFT_LA;
  wire SHIFT_LR;
  wire LOGICAL_OA;
  wire [1:0] CSEL;
  
  wire [7:0] ADDERY;
  wire ADDERC;
  wire ADDERV;
  
  wire [7:0] SHIFTY;
  wire SHIFTC;
  
  wire [7:0] LOGICALY;
  
  control cl(
	.FS(FS),
	.BSEL(BSEL),
	.CISEL(CISEL),
	.OSEL(OSEL),
	.SHIFT_LA(SHIFT_LA),
	.SHIFT_LR(SHIFT_LR),
	.LOGICAL_OA(LOGICAL_OA),
	.CSEL(CSEL)
  );

  adder ad(
   .A(A),
   .B(BSEL == 1'b0 ? B : ~B),
   .CI(CISEL == 1'b0 ? 1'b0 : 1'b1),
   .Y(ADDERY),
   .C(ADDERC),
   .V(ADDERV)
  );
  
  shifter sh(
   .A(A),
   .LA(SHIFT_LA),
   .LR(SHIFT_LR),
   .Y(SHIFTY),
   .C(SHIFTC)
  );
  
  logical lc(
   .A(A),
   .B(BSEL == 1'b0 ? B : ~B),
   .OA(LOGICAL_OA),
   .Y(LOGICALY)
  );
  
  assign Y = (OSEL == 2'b00) ? ADDERY : ((OSEL == 2'b01) ? SHIFTY : LOGICALY);
  assign C = (CSEL == 2'b00) ? ADDERC : ((CSEL == 1'b01) ? 1'b0 : SHIFTC);
  assign V = (OSEL == 2'b00) ? ADDERV : 1'b0;
  assign N = Y[7];
  assign Z = (Y == 8'b0);


  /* ADD YOUR CODE ABOVE THIS LINE */


endmodule
