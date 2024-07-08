module ALU(A, B, FUNCT_SEVEN, FUNCT_THREE, OPCODE, Y, C, V, N, Zero):
  input [31:0] A, B;
  input [6:0]  FUNCT_SEVEN;
  input [2:0]  FUNCT_THREE;
  input [7:0]  OPCODE;

  output wire [31:0] Y;
  output wire C;
  output wire V;
  output wire N;
  output wire Zero;
  
  wire [31:0] ADDERY;
  wire ADDERC;
  wire ADDERV;

  wire [31:0] SHIFTY;
  wire SHIFTC;

  wire [31:0] LOGICALY;

  reg [1:0] OSEL; // determines which module Y should come from
  reg [3:0] CSEL; // determines which module C should come from
  reg [2:0] FC; // Determines add, sub, xor, or, and, etc

  // sequential logic here to find out what OSEL, CSEL, and FS
  // should be from the FUNCT_SEVEN, THREE, & OPCODE

  adder ad(
    .A(A),
    .B(B),
    .FC(FC),
    .Y(ADDERY),
    .C(ADDERC),
    .V(ADDERV)
  );

  shifter sh(
    .A(A),
    .FC(FC),
    .Y(SHIFTY),
    .C(SHIFTC)
  );

  logical lo(
    .A(A),
    .B(B),
    .FS(FS),
    .Y(LOGICALY)
  );

  assign Y = (OSEL == 2'b00) ? ADDERY : ((OSEL == 2'b01) ? SHIFTY : LOGICALY);
  assign C = (CSEL == 2'b00) ? ADDERC : ((CSEL == 1'b01) ? 1'b0 : SHIFTC);
  assign V = (OSEL == 2'b00) ? ADDERV : 1'b0;
  assign N = Y[7];
  assign Zero = (Y == 8'b0);

endmodule
