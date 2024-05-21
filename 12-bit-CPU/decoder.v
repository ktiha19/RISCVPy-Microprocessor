module decoder(INST, DR, SA, SB, IMM, MB, FS, MD, LD, MW, HLT, BS, OFF); // add outputs

input [15:0] INST;

/* ADD YOUR CODE BELOW THIS LINE */

// declare outputs

/* ADD YOUR CODE ABOVE THIS LINE */

// parse the instruction feilds
wire [3:0] OP;
wire [2:0] RS;
wire [2:0] RT;
wire [2:0] RD;
wire [2:0] FUNCT;
wire [5:0] IMM_INST;

assign OP = INST[15:12];
assign RS = INST[11:9];
assign RT = INST[8:6];
assign RD = INST[5:3];
assign FUNCT = INST[2:0];
assign IMM_INST = INST[5:0];

/* ADD YOUR CODE BELOW THIS LINE */

output reg [2:0] DR;
output reg [2:0] SA;
output reg [2:0] SB;
output reg [5:0] IMM;
output reg MB;
output reg [2:0] FS;
output reg MD;
output reg LD;
output reg MW;
output reg HLT;
output reg [2:0] BS;
output reg [5:0] OFF;

always @(*) begin
	case (OP)
	// implement decoder logic here
		4'b0000: begin 
			if (FUNCT == 3'b001) begin
			  DR = 3'b000; 
			  SA = 3'b000; 
			  SB = 3'b000; 
			  IMM = 6'b000000; 
			  MB = 1'b0; 
			  FS = FUNCT; 
			  MD = 1'b0; 
			  LD = 1'b0;
			  MW = 1'b0; 
			  HLT = 1'b1;
			  BS = 3'b100;
			  OFF = 6'b000000;
			end
			else begin
			  DR = 3'b000; 
			  SA = 3'b000; 
			  SB = 3'b000; 
			  IMM = 6'b000000; 
			  MB = 1'b0; 
			  FS = FUNCT; 
			  MD = 1'b0; 
			  LD = 1'b0;
			  MW = 1'b0;
			  HLT = 1'b0;
			  BS = 3'b100;
			  OFF = 6'b000000;
			end
		end
		4'b0010: begin 
		  DR = RT; 
		  SA = RS; 
		  SB = 3'bxxx; 
		  IMM = IMM_INST; 
		  MB = 1'b1; 
		  FS = 3'b000; 
		  MD = 1'b1; 
		  LD = 1'b1;
		  MW = 1'b0; 
		  HLT = 1'b0;
		  BS = 3'b100;
		  OFF = 6'b000000;
		end
		4'b0100: begin 
		  DR = 3'bxxx;  
		  SA = RS; 
		  SB = RT; 
		  IMM = IMM_INST; 
		  MB = 1'b1; 
		  FS = 3'b000; 
		  MD = 1'bx; 
		  LD = 1'b0;
		  MW = 1'b1; 
		  HLT = 1'b0;
		  BS = 3'b100;
		  OFF = 6'b000000;
		end
		4'b0101: begin 
		  DR = RT; 
		  SA = RS; 
		  SB = 3'bxxx; 
		  IMM = IMM_INST; 
		  MB = 1'b1; 
		  FS = 3'b000;
		  MD = 1'b0; 
		  LD = 1'b1;
		  MW = 1'b0; 
		  HLT = 1'b0;
		  BS = 3'b100;
		  OFF = 6'b000000;
		end
		4'b0110: begin 
		  DR = RT; 
		  SA = RS; 
		  SB = 3'bxxx; 
		  IMM = IMM_INST; 
		  MB = 1'b1; 
		  FS = 3'b101;
		  MD = 1'b0; 
		  LD = 1'b1;
		  MW = 1'b0; 
		  HLT = 1'b0;
		  BS = 3'b100;
		  OFF = 6'b000000;
		end
		4'b1111: begin 
			// When OP is 1111 DR, IMM, MD, LD, SA, and MW will be same values no matter what FUNCT
			DR = RD; 
			SA = RS;
			SB = (FUNCT == 3'b000 || FUNCT == 3'b001 || FUNCT == 3'b101 || FUNCT == 3'b110) ? RT : 3'bxxx;
			IMM = 6'bxxxxxx;
			MB = 1'b0; 
			FS = FUNCT; 
			MD = 1'b0; 
			LD = 1'b1;
			MW = 1'b0; 
			HLT = 1'b0;
		   BS = 3'b100;
		   OFF = 6'b000000;
		end
		4'b1000: begin // BEQ
		  DR = 3'bxxx; 
		  SA = RS; 
		  SB = RT; 
		  IMM = 6'b000000; 
		  MB = 1'b0; 
		  FS = 3'b001;
		  MD = 1'b0; 
		  LD = 1'b0;
		  MW = 1'b0; 
		  HLT = 1'b0;
		  BS = 3'b000;
		  OFF = IMM_INST;
		end
		4'b1001: begin // BNE
		  DR = 3'bxxx; 
		  SA = RS; 
		  SB = RT; 
		  IMM = 6'b000000; 
		  MB = 1'b0;
		  FS = 3'b001;
		  MD = 1'b0; 
		  LD = 1'b0;
		  MW = 1'b0; 
		  HLT = 1'b0;
		  BS = 3'b001;
		  OFF = IMM_INST;
		end
		4'b1010: begin // BGEZ
			DR = 3'bxxx; 
			SA = RS;
			SB = 3'bxxx;
			IMM = 6'b000000; 
			MB = 1'b1; 
			FS = 3'b001; 
			MD = 1'b0; 
			LD = 1'b0;
			MW = 1'b0; 
			HLT = 1'b0;
		   BS = 3'b010;
		   OFF = IMM_INST;
		end
		4'b1011: begin // BLTZ
		  DR = 3'bxxx; 
		  SA = RS; 
		  SB = 3'bxxx; 
		  IMM = 6'b000000; 
		  MB = 1'b1; 
		  FS = 3'b001; 
		  MD = 1'b0; 
		  LD = 1'b0;
		  MW = 1'b0; 
		  HLT = 1'b0;
		  BS = 3'b011;
		  OFF = IMM_INST;
		end
		default: begin /* NOP */ 
		  DR = 3'b000; 
		  SA = 3'b000; 
		  SB = 3'b000; 
		  IMM = 6'b000000; 
		  MB = 1'b0; 
		  FS = FUNCT; 
		  MD = 1'b0; 
		  LD = 1'b0;
		  MW = 1'b0; 
		  HLT = 1'b0;
		  BS = 3'b100;
		  OFF = 6'b000000;
		end
	endcase

end

/* ADD YOUR CODE ABOVE THIS LINE */

endmodule
