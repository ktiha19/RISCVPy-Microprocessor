module dram(CLK, ADDR, DATA, MW, Q);
	input CLK;
	input [7:0] ADDR;  // 8-bit addresses
	input [31:0] DATA;  // 32-bit data words
	input MW;
  
	output [31:0] Q;
	  
	reg [31:0] Q;
  

	reg [31:0] mem[0:255];
  
	integer i;

	initial begin
		for (i = 0; i < 256; i = i + 1) begin
			mem[i] = 32'd0;
		end
	end

	always @(posedge CLK) begin
		// memory is currently initialized with a LUT in 2-byte BCD words
		//   for the heart rate monitor (big endian)

		if (MW  == 1'b0) begin
			Q <= mem[ADDR];
		end

		if (MW  == 1'b1) begin
			mem[ADDR] <= DATA;
			Q <= 32'bx;
		end
	end
	
endmodule
