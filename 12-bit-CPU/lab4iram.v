module lab4iram(CLK, RESET, ADDR, Q);
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
    Store a sequence of numbers between 0 and 5 to memory address 255.
   */
  always @(posedge CLK) begin
    if(RESET) begin
      mem[0]   <= 16'b 1111010010010001;   // SUB  R2, R2, R2
      mem[1]   <= 16'b 1111001001001001;   // SUB  R1, R1, R1
      mem[2]   <= 16'b 0101010010111111;   // ADDI R2, R2, -1
      mem[3]   <= 16'b 1111010010010000;   // ADD  R2, R2, R2
      mem[4]   <= 16'b 0101010010111111;   // ADDI R2, R2, -1
      mem[5]   <= 16'b 0101010010111111;   // ADDI R2, R2, -1
      mem[6]   <= 16'b 1111010001010001;   // SUB  R2, R2, R1
      mem[7]   <= 16'b 0101010010000011;   // ADDI R2, R2, 3
      mem[8]   <= 16'b 0100010001000000;   // SB   R1, 0(R2)
      mem[9]   <= 16'b 0101001001000001;   // ADDI R1, R1, 1
      mem[10]  <= 16'b 0100010001000000;   // SB   R1, 0(R2)
      mem[11]  <= 16'b 0101001001000001;   // ADDI R1, R1, 1
      mem[12]  <= 16'b 0100010001000000;   // SB   R1, 0(R2)
      mem[13]  <= 16'b 0101001001000001;   // ADDI R1, R1, 1
      mem[14]  <= 16'b 0100010001000000;   // SB   R1, 0(R2)
      mem[15]  <= 16'b 0101001001000001;   // ADDI R1, R1, 1
      mem[16]  <= 16'b 0100010001000000;   // SB   R1, 0(R2)
      mem[17]  <= 16'b 0101001001000001;   // ADDI R1, R1, 1
      mem[18]  <= 16'b 0100010001000000;   // SB   R1, 0(R2)

      for(i = 19; i < 128; i = i + 1) begin
        mem[i] <= 16'b0000000000000000;
      end
    end
  end

endmodule
