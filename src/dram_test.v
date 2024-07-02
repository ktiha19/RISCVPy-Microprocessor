`timescale 1 ns / 1 ps

module dram_test();

  // for all of your input pins, declare them as type reg, and name them identically to the pins
  reg [7:0] ADDR;
  reg [31:0] DATA;
  reg MW;
  wire [31:0] Q;


  reg CLK;

  dram UUT(
        .CLK(CLK), 
        .ADDR(ADDR), 
        .DATA(DATA), 
        .MW(MW), 
        .Q(Q)
  );

  // CLK: generate a 10 MHz clock (rising edge does not start until
  //   50 ticks (50 ns) into simulation, and each clock cycle lasts for
  //   100 ticks (100 ns)
  initial begin
    CLK = 1'b0;
    forever begin
      #50
      CLK = ~CLK;
    end
  end

  
  initial begin
      // it includes input values...
      ADDR = 8'b0000000;
      DATA = 32'b1;
      MW = 1'b1;

      #100;  // wait for input signals to propagate through circuit
      $display("Result is = %b", Q);

      ADDR = 8'b0000000;
      MW = 1'b0;

      #100;  // wait for input signals to propagate through circuit
      $display("Result is = %b", Q);

      ADDR = 8'd255;
      DATA = 32'd21;
      MW = 1'b1;

      #100;  // wait for input signals to propagate through circuit
      $display("Result is = %d", Q);

      ADDR = 8'd255;
      MW = 1'b0;

      #100;  // wait for input signals to propagate through circuit
      $display("Result is = %d", Q);
      
    end
endmodule
