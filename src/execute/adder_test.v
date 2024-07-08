`timescale 1 ns / 1 ps

module execute_test();

  // for all of your input pins, declare them as type reg, and name them identically to the pins
  reg [5:0] SA;  // 5-bit addresses
  reg [5:0] SB;  // 5-bit addresses
  reg [2:0] DR;  // 5-bit addresses
  reg [31:0] D_IN;  // 32-bit data words
  reg LD;

  wire [31:0] DATA_A;
  wire [31:0] DATA_B;

  reg CLK;

  adder UUT(
        .A(A), 
        .B(B), 
        .FUNCT_SEVEN(FUNCT_SEVEN), 
        .Y(Y), 
        .C(C), 
        .V(V), 
        .N(N), 
        .Z(Z)
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
      SA = 32'bx;
      SB = 32'bx;
      FUNCT_SEVEN = 7'bx;
      
      #100;  // wait for input signals to propagate through circuit
      $display("Result is = %b", DATA_A);
      $display("Result is = %b", DATA_B);


      SA = 32'bx;
      SB = 32'bx;
      FUNCT_SEVEN = 7'bx;

      #100;  // wait for input signals to propagate through circuit
      $display("Result is = %b", DATA_A);
      $display("Result is = %b", DATA_B);

    end

endmodule
