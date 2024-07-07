module dram(CLK, ADDR, DATA_SEL, DATA_WRITE, DATA_LOW_12BIT, DATA_UPPER_20BIT, DATA_BYTE, MW);
	input CLK;
	input [9:0] ADDR;  // 10-bit addresses
	input [1:0] DATA_SEL;

	input MW;
	input [7:0] DATA_WRITE;
  
	output [31:20] DATA_LOW_12BIT;
	output [19:0] DATA_UPPER_20BIT;
	output [7:0] DATA_BYTE;


	reg DATA_LOW_12BIT;
	reg DATA_UPPER_20BIT;
	reg DATA_BYTE;
  

	reg [7:0] mem[0:1023];
  
	integer i;

	initial begin
		for (i = 0; i < 1024; i = i + 1) begin
			mem[i] = 8'b00000000;
		end
	end

	always @(posedge CLK) begin
		// memory is currently initialized with a LUT in 2-byte BCD words
		//   for the heart rate monitor (big endian)

		if (MW  == 1'b0 & DATA_SEL == 2'b00) begin
			DATA_LOW_12BIT <= {mem[ADDR][7:0], mem[ADDR+1][7:4]};
			DATA_UPPER_20BIT <= 20'bx;
			DATA_BYTE <= 8'bx;
		end

		if (MW  == 1'b0 & DATA_SEL == 2'b01) begin
			DATA_UPPER_20BIT <= 20'bx;
			DATA_LOW_12BIT <= 12'bx;
			DATA_BYTE <= 8'bx;

		end

		if (MW  == 1'b0 & DATA_SEL == 2'b10) begin
			DATA_UPPER_20BIT <= 20'bx;
			DATA_LOW_12BIT <= 12'bx;
			DATA_BYTE <= mem[ADDR];

		end

		if (MW == 1'b1) begin
			mem[ADDR] <= DATA_WRITE;
			DATA_LOW_12BIT <= 12'bx;
			DATA_UPPER_20BIT <= 20'bx;
		end
	end
	
endmodule
