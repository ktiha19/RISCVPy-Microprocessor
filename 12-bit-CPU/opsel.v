module opsel(CLK, SEL_L, OP);
  input        CLK;
  input        SEL_L;
  
  output [2:0] OP;
  
  reg    [2:0] OP;
  reg          last_sel;
  
  always @(posedge CLK) begin
	if (~SEL_L & last_sel) begin
		if (OP == 3'b110)
			OP = 3'b0;
		else
			OP = OP + 3'd1;
	end
	last_sel = SEL_L;
  end
  
endmodule