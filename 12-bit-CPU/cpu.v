module cpu(CLK, RESET, EN_L, Iin, Din, PC, NextPC, DataA, DataB, DataC, DataD, MW);
  input         CLK;
  input         RESET;
  input         EN_L;
  input  [15:0] Iin;
  input  [7:0]  Din;

  output [7:0]  PC;
  output [7:0]  NextPC;
  output [7:0]  DataA;
  output [7:0]  DataB;
  output [7:0]  DataC;
  output [7:0]  DataD;
  output        MW;

  /* ADD YOUR CODE BELOW THIS LINE */
  
  reg [7:0] PC;
  wire[7:0] NextPC;
  
  wire [2:0] DR;
  wire [2:0] SA;
  wire [2:0] SB;
  wire [5:0] IMM;
  wire MB;
  wire [2:0] FS;
  wire MD;
  wire LD;
  wire MW;
  wire HLT;
  wire [2:0] BS;
  wire [5:0] OFF;
  
  wire C;
  wire V;
  wire N;
  wire Z;
  
  wire [7:0] IMM_EIGHT_BIT;
  
  reg prev_EN_L;
  wire H;
  wire MP;
  wire [1:0] PCSEL;
  
  assign H = HLT && ~(prev_EN_L && ~EN_L);
  
  // wires for calculating next PC
  wire [7:0] EXT_OUT;
  wire [7:0] SHFT_OUT;
  wire SHFTC;
  wire [7:0] ADDY;
  wire ADDC;
  wire ADDV;
  
  // MP Logic
  assign MP = (BS == 3'd4) ? 0 : ((BS == 3'd3) ? N : ((BS == 3'd2) ? ~N : ((BS == 3'd1) ? ~Z : Z)));
  
  // PCSEL Logic
  assign PCSEL = (H == 1'b1) ? 2'b10 : ((MP == 1'b1) ? 2'b01 : 2'b00);
  
  assign NextPC = (PCSEL == 2'b00) ? PC + 8'd2 : (PCSEL == 2'b01) ? ADDY : PC;
  assign DataC = (MD == 1'b1) ? Din : DataD;
     
  always @(posedge CLK) begin
    if (RESET) begin
		PC = 8'b00000000;
	 end
	 else begin
	   PC = NextPC;
	 end
  end
  
  always @ (posedge CLK) begin
	prev_EN_L = EN_L;
  end
  
  decoder dec(
	 .INST(Iin),
	 .DR(DR),
	 .SA(SA),
	 .SB(SB),
	 .IMM(IMM),
	 .MB(MB),
	 .FS(FS),
	 .MD(MD),
	 .LD(LD),
	 .MW(MW),
	 .HLT(HLT),
	 .BS(BS),
	 .OFF(OFF)
  );

   sign_extender se(
	  .INPUT(IMM),
	  .OUT(IMM_EIGHT_BIT)
  );
  
  alu exe(
    .A(DataA),
	 .B((MB == 1'b1) ? IMM_EIGHT_BIT : DataB),
	 .FS(FS),
	 .Y(DataD),
	 .C(C),
	 .V(V),
	 .N(N),
	 .Z(Z)
  );
  
  sign_extender pc_extender(
	 .INPUT(OFF),
	 .OUT(EXT_OUT)
  );
  
  shifter pc_shifter(
   .A(EXT_OUT),
   .LA(1'b0),
   .LR(1'b0),
   .Y(SHFT_OUT),
   .C(SHFTC)
  );
  
  adder pc_adder(
	 .A(PC + 8'd2), 
	 .B(SHFT_OUT), 
	 .CI(1'b0), 
	 .Y(ADDY), 
	 .C(ADDC), 
	 .V(ADDV)
  );
  
  regfile regfile(
    .CLK(CLK), 
	 .RESET(RESET), 
	 .SA(SA), 
	 .SB(SB), 
	 .LD(LD), 
	 .DR(DR), 
	 .D_in(DataC), 
	 .DataA(DataA), 
	 .DataB(DataB));
  
  /* ADD YOUR CODE ABOVE THIS LINE */

endmodule
