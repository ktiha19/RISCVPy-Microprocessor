module ALU(A, B, FC, OPCODE, Y, C, V, N, Zero):
  input [31:0] A, B;
  input [3:0]  FC; // Determines add, sub, xor, or, and, etc
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

  wire [2:0] OSEL; // determines which module Y and C should come from

  assign OSEL = (FC == 3'b000 || FC == 3'b001) ? 0 : (FC == 3'b101 || FC == 3'b110 || FC == 3'b111) ? 1 : 2;

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
  assign C = (OSEL == 2'b00) ? ADDERC : ((OSEL == 1'b01) ? 1'b0 : SHIFTC);
  assign V = (OSEL == 2'b00) ? ADDERV : 1'b0;
  assign N = Y[7];
  assign Zero = (Y == 8'b0);

endmodule
