module lab4iramHRM(CLK, RESET, ADDR, Q);
  input         CLK;
  input         RESET;
  input  [7:0]  ADDR;
  output [15:0] Q;

  reg    [15:0] mem[0:127]; // instruction memory with 16 bit entries

  wire   [6:0]  saddr;
  integer       i;

  assign saddr = ADDR[7:1];
  assign Q = mem[saddr];

  always @(posedge CLK) begin
    if(RESET) begin
      mem[0]  <= 16'b1111000000000001; //SUB   R0, R0, R0
      mem[1]  <= 16'b1111010010010001; //SUB   R2, R2, R2
      mem[2]  <= 16'b1111111111111001; //SUB   R7, R7, R7
      mem[3]  <= 16'b1111110110110001; //SUB   R6, R6, R6
      mem[4]  <= 16'b0101000101111111; //ADDI  R5, R0, -1
      mem[5]  <= 16'b1111101000101011; //SRL   R5, R5
      mem[6]  <= 16'b0010000011111011; //LB    R3, -5(R0)
      mem[7]  <= 16'b0110011011000001; //ANDI  R3, R3, 1
      mem[8]  <= 16'b0010000100111011; //LB    R4, -5(R0)
      mem[9]  <= 16'b0110100100000001; //ANDI  R4, R4, 1
      mem[10]  <= 16'b1111100011011000; //ADD   R3, R4, R3
      mem[11]  <= 16'b0110011011000001; //ANDI  R3, R3, 1
      mem[12]  <= 16'b1111011100011101; //AND   R3, R3, R4
      mem[13]  <= 16'b1111010011010000; //ADD   R2, R2, R3
      mem[14]  <= 16'b1111100000011000; //ADD   R3, R4, R0
      mem[15]  <= 16'b0101111111111111; //ADDI  R7, R7, -1
      mem[16]  <= 16'b1001000111111000; //BNE   R7, R0, -8
      mem[17]  <= 16'b0101110110111111; //ADDI  R6, R6, -1
      mem[18]  <= 16'b1001000110110110; //BNE   R6, R0, -10
      mem[19]  <= 16'b0101101101111111; //ADDI  R5, R5, -1
      mem[20]  <= 16'b1001000101110011; //BNE   R5, R0, -13
      mem[21]  <= 16'b0101010100100010; //ADDI  R4, R2, -30
      mem[22]  <= 16'b1011100000000001; //BLTZ  R4, 1
      mem[23]  <= 16'b0101000010011101; //ADDI  R2, R0, 29
      mem[24]  <= 16'b1111010000010100; //SLL   R2, R2
      mem[25]  <= 16'b0010010011000000; //LB    R3, 0(R2)
      mem[26]  <= 16'b0100000011111110; //SB    R3, -2(R0)
      mem[27]  <= 16'b0010010011000001; //LB    R3, 1(R2)
      mem[28]  <= 16'b0100000011111111; //SB    R3, -1(R0)

    
      for(i = 29; i < 128; i = i + 1) begin
        mem[i] <= 16'b0000000000000000;
      end
    end
  end

endmodule
