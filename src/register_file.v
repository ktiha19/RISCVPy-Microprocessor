module register_file(CLK, LD, SA, SB, DR, D_IN, DATA_A, DATA_B);
	input CLK;
    input LD;
	input [2:0] SA;  // 3-bit addresses
    input [2:0] SB;  // 3-bit addresses
    input [2:0] DR;  // 3-bit addresses
	input [31:0] D_IN;  // 32-bit data words
    
    wire CLK;
    wire LD;
    wire SA;
    wire SB;
    wire DR;
    wire D_IN;
  
	output [31:0] DATA_A;
    output [31:0] DATA_B;

    reg DATA_A;
    reg DATA_B;
  
	reg [31:0] register[0:7];
  
	integer i;

	initial begin
		for (i = 0; i < 16; i = i + 1) begin
			register[i] = 32'd0;
		end
	end

	always @(posedge CLK) begin
		if (LD  == 1'b1) begin
			register[DR] <= D_IN;

            DATA_A <= 32'bx;
            DATA_B <= 32'bx;
		end

		if (LD  == 1'b0) begin
            DATA_A <= register[SA];
            DATA_B <= register[SB];
		end
	end
	
endmodule
