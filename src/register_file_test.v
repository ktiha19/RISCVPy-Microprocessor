`timescale 1 ns / 1 ps

module register_file_test();

  // for all of your input pins, declare them as type reg, and name them identically to the pins
  reg [5:0] SA;  // 5-bit addresses
  reg [5:0] SB;  // 5-bit addresses
  reg [5:0] DR;  // 5-bit addresses
  reg [31:0] D_IN;  // 32-bit data words
  reg LD;

  wire [31:0] DATA_A;
  wire [31:0] DATA_B;

  reg CLK;

  register_file UUT(
        .CLK(CLK), 
        .LD(LD), 
        .SA(SA), 
        .SB(SB), 
        .DR(DR), 
        .D_IN(D_IN), 
        .DATA_A(DATA_A), 
        .DATA_B(DATA_B)
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
      LD = 1'b1;
      SA = 5'bx;
      SB = 5'bx;
      DR = 5'b000;
      D_IN = 32'd123;
      
      #100;  // wait for input signals to propagate through circuit
      $display("Result is = %b", DATA_A);
      $display("Result is = %b", DATA_B);


      LD = 1'b0;
      SA = 5'b000;
      SB = 5'b001;
      DR = 5'b000;
      D_IN = 32'd123;

      #100;  // wait for input signals to propagate through circuit
      $display("Result is = %b", DATA_A);
      $display("Result is = %b", DATA_B);

      
    end
endmodule
