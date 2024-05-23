module lab4iram1A(CLK, RESET, ADDR, Q);
  input         CLK;
  input         RESET;
  input  [7:0]  ADDR;
  output [15:0] Q;

  reg    [15:0] mem[0:127]; // instruction memory with 16 bit entries

  wire   [6:0]  saddr;
  integer       i;


  assign saddr = ADDR[7:1];
  assign Q = mem[saddr];

  /*
   This program takes the inputs from IOA and IOB, XORs the two 8-bit
   values together, and then counts the number of ones and zeros in
   the result. The number of ones is stored in memory address 255,
   and the number of zeros is stored to address 254.
   */
  always @(posedge CLK) begin
    if(RESET) begin
      mem[0]   <= 16'b 1111000000000001;   // SUB R0, R0, R0
      mem[1]   <= 16'b 0101000101111111;   // ADDI R5, R0, -1
      mem[2]   <= 16'b 0010101001111010;   // LB R1, -6(R5)
      mem[3]   <= 16'b 0010101010111011;   // LB R2, -5(R5)
      mem[4]   <= 16'b 1111000001011001;   // SUB R3, R0, R1
      mem[5]   <= 16'b 0101011011111111;   // ADDI R3, R3, -1
      mem[6]   <= 16'b 1111000010100001;   // SUB R4, R0, R2
      mem[7]   <= 16'b 0101100100111111;   // ADDI R4, R4, -1
      mem[8]   <= 16'b 0000000000000000;   // NOP
      mem[9]   <= 16'b 1111001100101101;   // AND R5, R1, R4
      mem[10]  <= 16'b 1111011010110101;   // AND R6, R3, R2
      mem[11]  <= 16'b 1111101110111110;   // OR R7, R5, R6
      mem[12]  <= 16'b 0101000101000100;   // ADDI R5, R0, 4
      mem[13]  <= 16'b 0100101111111000;   // SB R7, -8(R5)
      mem[14]  <= 16'b 0110111101000001;   // ANDI R5, R7, 1
      mem[15]  <= 16'b 1111000101110000;   // ADD R6, R0, R5
      mem[16]  <= 16'b 1111111000111011;   // SRL R7, R7
      mem[17]  <= 16'b 0110111101000001;   // ANDI R5, R7, 1
      mem[18]  <= 16'b 1111110101110000;   // ADD R6, R6, R5
      mem[19]  <= 16'b 1111111000111011;   // SRL R7, R7
      mem[20]  <= 16'b 0110111101000001;   // ANDI R5, R7, 1
      mem[21]  <= 16'b 1111110101110000;   // ADD R6, R6, R5
      mem[22]  <= 16'b 1111111000111011;   // SRL R7, R7
      mem[23]  <= 16'b 0110111101000001;   // ANDI R5, R7, 1
      mem[24]  <= 16'b 1111110101110000;   // ADD R6, R6, R5
      mem[25]  <= 16'b 1111111000111011;   // SRL R7, R7
      mem[26]  <= 16'b 0110111101000001;   // ANDI R5, R7, 1
      mem[27]  <= 16'b 1111110101110000;   // ADD R6, R6, R5
      mem[28]  <= 16'b 1111111000111011;   // SRL R7, R7
      mem[29]  <= 16'b 0110111101000001;   // ANDI R5, R7, 1
      mem[30]  <= 16'b 1111110101110000;   // ADD R6, R6, R5
      mem[31]  <= 16'b 1111111000111011;   // SRL R7, R7
      mem[32]  <= 16'b 0110111101000001;   // ANDI R5, R7, 1
      mem[33]  <= 16'b 1111110101110000;   // ADD R6, R6, R5
      mem[34]  <= 16'b 1111111000111011;   // SRL R7, R7
      mem[35]  <= 16'b 0110111101000001;   // ANDI R5, R7, 1
      mem[36]  <= 16'b 1111110101110000;   // ADD R6, R6, R5
      mem[37]  <= 16'b 0100000110111111;   // SB R6, -1(R0)
      mem[38]  <= 16'b 0101000101111000;   // ADDI R5, R0, -8
      mem[39]  <= 16'b 0101000001001000;   // ADDI R1, R0, 8
      mem[40]  <= 16'b 1111001110100001;   // SUB R4, R1, R6
      mem[41]  <= 16'b 0100101100000110;   // SB R4, 6(R5)

      for(i = 42; i < 128; i = i + 1) begin
        mem[i] <= 16'b0000000000000000;
      end
    end
  end

endmodule
