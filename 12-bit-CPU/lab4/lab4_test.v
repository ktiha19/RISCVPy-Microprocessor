/*  lab4_test.v
    ECE/ENGRD 2300, Spring 2014

    Authors: Douglas L. Long, Saugata Ghose
    Last modified: April 17, 2014

    Description: Test bench for single cycle processor.
*/

// sets the granularity at which we simulate
`timescale 1 ns / 1 ps


// define a constant for use within the test bench
`define CHECK 1


// name of the top-level module; for us it should always be <module name>_test
// this top-level module should have no inputs or outputs; only internal signals are needed
module lab4_test();

  // for all of your input pins, declare them as type reg, and name them identically to the pins
  reg        CLK;
  reg  [7:0] IOA;
  reg  [7:0] IOB;
  reg  [7:0] IOC;
  reg        EN_L;
  reg        RESET;
  reg  [7:0] finalPC;

  // for all of your output pins, declare them as type wire so ModelSim can display them
  wire [7:0]  PC;
  wire [7:0]  NextPC;
  wire [7:0]  DataA;
  wire [7:0]  DataB;
  wire [7:0]  DataC;
  wire [7:0]  DataD;
  wire [7:0]  Din;
  wire [15:0] Iin;
  wire [7:0]  IOD;
  wire [7:0]  IOE;
  wire [7:0]  IOF;
  wire [7:0]  IOG;
  wire        MW;


  // internal variables
  integer currentInstruction;
  integer currentTestCorrect;
  integer numTests;
  integer numCorrect;
  integer invalidInstructions;
  integer numTestsByOpcode[0:17];
  integer numCorrectByOpcode[0:17];
  integer numConsecutiveNOPs;       // stopping condition for test bench


  // declare a sub-circuit instance (Unit Under Test) of the circuit that you designed
  // make sure to include all ports you want to see, and connect them to the variables above
  lab4 UUT(
    .CLK(CLK),
    .RESET(RESET),
    .EN_L(EN_L),
    .PC(PC),
    .NextPC(NextPC),
    .Iin(Iin),
    .IOA(IOA),
    .IOB(IOB),
    .IOC(IOC),
    .DataA(DataA),
    .DataB(DataB),
    .DataC(DataC),
    .DataD(DataD),
    .Din(Din),
    .MW(MW),
    .IOD(IOD),
    .IOE(IOE),
    .IOF(IOF),
    .IOG(IOG)
  );

  // ALL of the initial and always blocks below will work in parallel.
  //   Starting at time t = 0, they will all start counting the number
  //   of ticks.


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


  // we tell the test bench when to stop; if a loop never reaches the
  //   last instruction, we will stop after 500 cycles to make sure the
  //   test bench doesn't run forever...
  initial begin
    finalPC = 8'd254;
    #50000 $stop;
  end


  // RESET: make sure the processor is reset at the beginning
  initial begin
    RESET = 1'b1;
    RESET = #200 1'b0;
  end


  // EN_L: we simulate some occasional events where the EN_L button
  //   is pressed in order to move on from the HALT instruction; these
  //   don't matter for any other instruction...
  initial begin
    EN_L = 1'b1;
    #200
    EN_L = 1'b0;
    #400
    EN_L = 1'b1;
    #1400
    EN_L = 1'b0;
    #200
    EN_L = 1'b1;
    #1800
    EN_L = 1'b0;
    #200
    EN_L = 1'b1;
    #1800
    EN_L = 1'b0;
    #200
    EN_L = 1'b1;
    #1800
    EN_L = 1'b0;
    #200
    EN_L = 1'b1;
    #1800
    EN_L = 1'b0;
    #200
    EN_L = 1'b1;
    #1800
    EN_L = 1'b0;
    #200
    EN_L = 1'b1;
    #1800
    EN_L = 1'b0;
    #200
    EN_L = 1'b1;
    #1800
    EN_L = 1'b0;
    #200
    EN_L = 1'b1;
  end

  // IOA: starting value for input IOA; change this if you want to
  //   test how your program operates for different values of inputs
  initial begin
    IOA = 8'b010;
  end

  // IOB: starting value for input IOB; change this if you want to
  //   test how your program operates for different values of inputs
  initial begin
    IOB = 8'b11;
  end

  // IOC: starting value for input IOC; change this if you want to
  //   test how your program operates for different values of inputs
  initial begin
    IOC = 8'b01;
  end

  // ISA EMULATOR: the following code calculates just how your processor
  //   should behave, so we can use that to compare against what your
  //   processor is actually doing

  // Fair warning: the code below looks nothing like the code you will
  //   implement for your lab.  Don't use this as a reference for what
  //   to do...

  // Meta-control for HALT logic
  reg [1:0] PS, PSNext;
  reg PC_EN;
  reg HALT;

  always @(posedge CLK) begin
    if(RESET) begin
      PS <= 2'b00;
    end
    else begin
      PS <= PSNext;
    end
  end

  always @(*) begin
    case(PS)
      2'b00: begin
        if(~EN_L) PSNext <= 2'b10;
        else PSNext <= 2'b00;
      end
      2'b01: begin
        if(EN_L) PSNext <= 2'b00;
        else PSNext <= 2'b01;
      end
      2'b10: begin
        if(HALT) PSNext <= 2'b01;
        else PSNext <= 2'b10;
      end
      default: PSNext <= 2'b00;
    endcase
  end

  always @(*) begin
    case (PS)
      2'b00 : PC_EN = 0;
      2'b01 : PC_EN = 0;    // change to 1 for enable on negative transition
      2'b10 : PC_EN = 1;
      default : PC_EN = 0;
    endcase
  end

  // the $monitor command outputs a message any time the value of one of
  //   its arguments changes (aside from the $time variable)
  initial begin
    $monitor("MSIM> --> PC_EN = %1d at time = %1d (ignore until Part C)\nMSIM> ", PC_EN, $time);
  end


  // instruction components
  reg [3:0] OP;
  reg [5:0] imm;
  integer   immSigned;
  reg [2:0] rs, rt, rd, dr;
  reg [2:0] FUNCT;
  reg [7:0] off;
  integer   offSigned;


  // registers and memory
  reg [7:0] sreg[0:7];    // shadow reg file
  reg [7:0] sdmem[0:255]; // shadow data memory
  reg [7:0] sDataA, sDataB, sDataC, sDataD; // shadow buses
  integer i;
  integer j;


  // initialize registers
  initial begin
    for(i = 0; i < 8; i = i + 1) begin
       sreg[i] = 8'b0;
    end
  end


  // initialize variables
  initial begin
    currentInstruction <= 0;
    numTests <= 0;
    numCorrect <= 0;
    numConsecutiveNOPs <= 0;
    invalidInstructions <= 0;
  end

  initial begin
    for(j = 0; j < 18; j = j + 1) begin
      numTestsByOpcode[j] = 0;
      numCorrectByOpcode[j] = 0;
    end
  end


  always @(negedge CLK) begin
    OP        = Iin[15:12];
    rs        = Iin[11:9];
    rt        = Iin[8:6];
    rd        = Iin[5:3];
    imm       = Iin[5:0];
    immSigned = (imm < 32) ? imm : imm - 7'd64;
    FUNCT     = Iin[2:0];
    off       = (imm < 32) ? imm << 1 : (imm - 7'd64) << 1;
    HALT      = 0;
    currentTestCorrect = 1;

    if(PC_EN || (~RESET && PSNext == 2'b10)) begin
      numTests = numTests + 1;

      if(OP == 4'b0000 && FUNCT == 3'b000) begin
        numConsecutiveNOPs = numConsecutiveNOPs + 1;
      end
      else begin
        numConsecutiveNOPs = 0;
      end

      case(OP)
        4'b0000: begin
          case(FUNCT)
            3'b000: begin
              $display("MSIM> Instr. %3d (PC = %3d): NOP", currentInstruction, PC);
              if(MW) begin
                $display("MSIM> --> ERROR: MW is enabled (should be disabled)");
                currentTestCorrect = 0;
              end
              $display("MSIM> --> The test bench cannot observe NOP.  You should manually check that you haven't written to the register file.");
              numTestsByOpcode[0] = numTestsByOpcode[0] + 1;
            end
            3'b001: begin
              $display("MSIM> Instr. %3d (PC = %3d): HALT", currentInstruction, PC);
              HALT = 1;
              if(MW) begin
                $display("MSIM> --> ERROR: MW is enabled (should be disabled)");
                currentTestCorrect = 0;
              end
              numTestsByOpcode[13] = numTestsByOpcode[13] + 1;
            end
            default: begin
              $display("MSIM> Instr. %3d (PC = %3d): Unknown instruction %h", currentInstruction, PC, Iin);
              if(MW) begin
                $display("MSIM> --> ERROR: MW is enabled (should be disabled)");
                currentTestCorrect = 0;
              end
              invalidInstructions = invalidInstructions + 1;
            end
          endcase
        end
        4'b0010: begin
          $display("MSIM> Instr. %3d (PC = %3d): LB   R%1d, %3d(R%1d)", currentInstruction, PC, rt, immSigned, rs);
          sDataA   = sreg[rs];
          sDataD   = sreg[rs] + {imm[5], imm[5], imm[5:0]};
          sreg[rt] = read_mem(DataD);
          sDataC   = sreg[rt];
          if(DataD != sDataD) begin
            $display("MSIM> --> ERROR: Incorrectly reading from memory address %3d (should be %3d)", DataD, sDataD);
            currentTestCorrect = 0;
          end
          else if(DataC != sDataC) begin
            $display("MSIM> --> ERROR: Incorrectly reading %2h (should be %2h) from memory address %3d", DataC, sDataC, DataD);
            currentTestCorrect = 0;
          end
          if(MW) begin
            $display("MSIM> --> ERROR: MW is enabled (should be disabled)");
            currentTestCorrect = 0;
          end
          numTestsByOpcode[1] = numTestsByOpcode[1] + 1;
          if(currentTestCorrect == 1) begin
            $display("MSIM> --> Memory read appears correct (unable to verify that your register file was correctly updated).");
            numCorrect = numCorrect + 1;
            numCorrectByOpcode[1] = numCorrectByOpcode[1] + 1;
          end
        end
        4'b0100: begin
          $display("MSIM> Instr. %3d (PC = %3d): SB   R%1d, %3d(R%1d)", currentInstruction, PC, rt, immSigned, rs);
          sDataA = sreg[rs];
          sDataB = sreg[rt];
          sDataD = sreg[rs] + {imm[5], imm[5], imm[5:0]};
          write_mem(DataD, DataB);
          numTestsByOpcode[2] = numTestsByOpcode[2] + 1;
          if(currentTestCorrect == 1) begin
            $display("MSIM> --> Memory write appears correct (unable to verify that your register file was not modified).");
            numCorrect = numCorrect + 1;
            numCorrectByOpcode[2] = numCorrectByOpcode[2] + 1;
          end
        end
        4'b0101: begin
          $display("MSIM> Instr. %3d (PC = %3d): ADDI R%1d, R%1d, %3d", currentInstruction, PC, rt, rs, immSigned);
          sDataA   = sreg[rs];
          sreg[rt] = sreg[rs] + {imm[5], imm[5], imm[5:0]};
          sDataC   = sreg[rt];
          check_imm(sDataA, sDataC, DataA, DataC);
          if(MW) begin
            $display("MSIM> --> ERROR: MW is enabled (should be disabled)");
            currentTestCorrect = 0;
          end
          numTestsByOpcode[3] = numTestsByOpcode[3] + 1;
          if(currentTestCorrect == 1) begin
            $display("MSIM> --> Appears correct (unable to verify that your register file was correctly updated).");
            numCorrect = numCorrect + 1;
            numCorrectByOpcode[3] = numCorrectByOpcode[3] + 1;
          end
        end
        4'b0110: begin
          $display("MSIM> Instr. %3d (PC = %3d): ANDI  R%1d, R%1d, %3d", currentInstruction, PC, rt, rs, immSigned);
          sDataA   = sreg[rs];
          sreg[rt] = sreg[rs] & {imm[5], imm[5], imm[5:0]};
          sDataC   = sreg[rt];
          check_imm(sDataA, sDataC, DataA, DataC);
          if(MW) begin
            $display("MSIM> --> ERROR: MW is enabled (should be disabled)");
            currentTestCorrect = 0;
          end
          numTestsByOpcode[4] = numTestsByOpcode[4] + 1;
          if(currentTestCorrect == 1) begin
            $display("MSIM> --> Appears correct (unable to verify that your register file was correctly updated).");
            numCorrect = numCorrect + 1;
            numCorrectByOpcode[4] = numCorrectByOpcode[4] + 1;
          end
        end
        4'b0111: begin
          $display("MSIM> Instr. %3d (PC = %3d): ORI  R%1d, R%1d, %3d", currentInstruction, PC, rt, rs, immSigned);
          sDataA   = sreg[rs];
          sreg[rt] = sreg[rs] | {imm[5], imm[5], imm[5:0]};
          sDataC   = sreg[rt];
          check_imm(sDataA, sDataC, DataA, DataC);
          if(MW) begin
            $display("MSIM> --> ERROR: MW is enabled (should be disabled)");
            currentTestCorrect = 0;
          end
          numTestsByOpcode[5] = numTestsByOpcode[5] + 1;
          if(currentTestCorrect == 1) begin
            $display("MSIM> --> Appears correct (unable to verify that your register file was correctly updated).");
            numCorrect = numCorrect + 1;
            numCorrectByOpcode[5] = numCorrectByOpcode[5] + 1;
          end
        end
        4'b1000: begin
          $display("MSIM> Instr. %3d (PC = %3d): BEQ  R%1d, R%1d, %3d (branches to PC = %3d)", currentInstruction, PC, rs, rt, immSigned, PC + 8'd2 + off);
          sDataA = sreg[rs];
          sDataB = sreg[rt];
          check_branch(sDataA, sDataB, DataA, DataB);
          if(DataA == DataB) begin
            if(NextPC != (PC + 8'd2 + off)) begin
              $display("MSIM> --> ERROR: Incorrect branch target %3d, expected %3d", NextPC, PC + 8'd2 + off);
              currentTestCorrect = 0;
            end
          end
          else begin
            if(NextPC != PC + 8'd2)begin
              $display("MSIM> --> ERROR: Incorrect branch target %3d, expected %3d", NextPC, PC + 8'd2);
              currentTestCorrect = 0;
            end
          end
          if(MW) begin
            $display("MSIM> --> ERROR: MW is enabled (should be disabled)");
            currentTestCorrect = 0;
          end
          numTestsByOpcode[14] = numTestsByOpcode[14] + 1;
          if(currentTestCorrect == 1) begin
            $display("MSIM> --> Appears correct (unable to verify that your register file was not modified).");
            numCorrect = numCorrect + 1;
            numCorrectByOpcode[14] = numCorrectByOpcode[14] + 1;
          end
        end
        4'b1001: begin
          $display("MSIM> Instr. %3d (PC = %3d): BNE  R%1d, R%1d, %3d (branches to PC = %3d)", currentInstruction, PC, rs, rt, immSigned, PC + 8'd2 + off);
          sDataA = sreg[rs];
          sDataB = sreg[rt];
          check_branch(sDataA, sDataB, DataA, DataB);
          if(DataA != DataB) begin
            if(NextPC != (PC + 8'd2 + off)) begin
              $display("MSIM> --> ERROR: Incorrect branch target %3d, expected %3d", NextPC, PC + 8'd2 + off);
              currentTestCorrect = 0;
            end
          end
          else begin
            if(NextPC != PC + 8'd2)begin
              $display("MSIM> --> ERROR: Incorrect branch target %3d, expected %3d", NextPC, PC + 8'd2);
              currentTestCorrect = 0;
            end
          end
          if(MW) begin
            $display("MSIM> --> ERROR: MW is enabled (should be disabled)");
            currentTestCorrect = 0;
          end
          numTestsByOpcode[15] = numTestsByOpcode[15] + 1;
          if(currentTestCorrect == 1) begin
            $display("MSIM> --> Appears correct (unable to verify that your register file was not modified).");
            numCorrect = numCorrect + 1;
            numCorrectByOpcode[15] = numCorrectByOpcode[15] + 1;
          end
        end
        4'b1010: begin
          $display("MSIM> Instr. %3d (PC = %3d): BGEZ R%1d, %3d (branches to PC = %3d)", currentInstruction, PC, rs, immSigned, PC + 8'd2 + off);
          sDataA = sreg[rs];
          sDataB = sreg[rt];
          check_branch(sDataA,sDataB,DataA,sDataB); // ignore DataB value
          if(DataA[7] == 1'b0) begin
            if(NextPC != (PC + 8'd2 + off)) begin
              $display("MSIM> --> ERROR: Incorrect branch target %3d, expected %3d", NextPC, PC + 8'd2 + off);
              currentTestCorrect = 0;
            end
          end
          else begin
            if(NextPC != PC + 8'd2)begin
              $display("MSIM> --> ERROR: Incorrect branch target %3d, expected %3d", NextPC, PC + 8'd2);
              currentTestCorrect = 0;
            end
          end
          if(MW) begin
            $display("MSIM> --> ERROR: MW is enabled (should be disabled)");
            currentTestCorrect = 0;
          end
          numTestsByOpcode[16] = numTestsByOpcode[16] + 1;
          if(currentTestCorrect == 1) begin
            $display("MSIM> --> Appears correct (unable to verify that your register file was not modified).");
            numCorrect = numCorrect + 1;
            numCorrectByOpcode[16] = numCorrectByOpcode[16] + 1;
          end
        end
        4'b1011: begin
          $display("MSIM> Instr. %3d (PC = %3d): BLTZ R%1d, %3d (branches to PC = %3d)", currentInstruction, PC, rs, immSigned, PC + 8'd2 + off);
          sDataA = sreg[rs];
          sDataB = sreg[rt];
          check_branch(sDataA, sDataB, DataA, sDataB); // ignore DataB value
          if(DataA[7] == 1'b1) begin
            if(NextPC != (PC + 8'd2 + off)) begin
              $display("MSIM> --> ERROR: Incorrect branch target %3d, expected %3d", NextPC, PC + 8'd2 + off);
              currentTestCorrect = 0;
            end
          end
          else begin
            if(NextPC != PC + 8'd2)begin
              $display("MSIM> --> ERROR: Incorrect branch target %3d, expected %3d", NextPC, PC + 8'd2);
              currentTestCorrect = 0;
            end
          end
          if(MW) begin
            $display("MSIM> --> ERROR: MW is enabled (should be disabled)");
            currentTestCorrect = 0;
          end
          numTestsByOpcode[17] = numTestsByOpcode[17] + 1;
          if(currentTestCorrect == 1) begin
            $display("MSIM> --> Appears correct (unable to verify that your register file was not modified).");
            numCorrect = numCorrect + 1;
            numCorrectByOpcode[17] = numCorrectByOpcode[17] + 1;
          end
        end
        4'b1111: begin
          case(FUNCT)
            3'b000: begin
              $display("MSIM> Instr. %3d (PC = %3d): ADD  R%1d, R%1d, R%1d", currentInstruction, PC, rd, rs, rt);
              sDataA   = sreg[rs];
              sDataB   = sreg[rt];
              sreg[rd] = sreg[rs] + sreg[rt];
              sDataC   = sreg[rd];
              check_reg2reg(sDataA, sDataB, sDataC, DataA, DataB, DataC);
              if(MW) begin
                $display("MSIM> --> ERROR: MW is enabled (should be disabled)");
                currentTestCorrect = 0;
              end
              numTestsByOpcode[6] = numTestsByOpcode[6] + 1;
              if(currentTestCorrect == 1) begin
                $display("MSIM> --> Appears correct (unable to verify that your register file was correctly updated).");
                numCorrect = numCorrect + 1;
                numCorrectByOpcode[6] = numCorrectByOpcode[6] + 1;
              end
            end
            3'b001: begin
              $display("MSIM> Instr. %3d (PC = %3d): SUB  R%1d, R%1d, R%1d", currentInstruction, PC, rd, rs, rt);
              sDataA   = sreg[rs];
              sDataB   = sreg[rt];
              sreg[rd] = sreg[rs] - sreg[rt];
              sDataC   = sreg[rd];
              check_reg2reg(sDataA, sDataB, sDataC, DataA, DataB, DataC);
              if(MW) begin
                $display("MSIM> --> ERROR: MW is enabled (should be disabled)");
                currentTestCorrect = 0;
              end
              numTestsByOpcode[7] = numTestsByOpcode[7] + 1;
              if(currentTestCorrect == 1) begin
                $display("MSIM> --> Appears correct (unable to verify that your register file was correctly updated).");
                numCorrect = numCorrect + 1;
                numCorrectByOpcode[7] = numCorrectByOpcode[7] + 1;
              end
            end
            3'b010: begin
              $display("MSIM> Instr. %3d (PC = %3d): SRA  R%1d, R%1d", currentInstruction, PC, rd, rs);
              sDataA   = sreg[rs];
              sDataB   = sreg[rt];
              sreg[rd] = {sreg[rs][7],sreg[rs][7:1]};
              sDataC = sreg[rd];
              check_reg2reg(sDataA, sDataB, sDataC, DataA, DataB, DataC);
              if(MW) begin
                $display("MSIM> --> ERROR: MW is enabled (should be disabled)");
                currentTestCorrect = 0;
              end
              numTestsByOpcode[8] = numTestsByOpcode[8] + 1;
              if(currentTestCorrect == 1) begin
                $display("MSIM> --> Appears correct (unable to verify that your register file was correctly updated).");
                numCorrect = numCorrect + 1;
                numCorrectByOpcode[8] = numCorrectByOpcode[8] + 1;
              end
            end
            3'b011: begin
              $display("MSIM> Instr. %3d (PC = %3d): SRL  R%1d, R%1d", currentInstruction, PC, rd, rs);
              sDataA   = sreg[rs];
              sDataB   = sreg[rt];
              sreg[rd] = {1'b0, sreg[rs][7:1]};
              sDataC   = sreg[rd];
              check_reg2reg(sDataA, sDataB, sDataC, DataA, DataB, DataC);
              if(MW) begin
                $display("MSIM> --> ERROR: MW is enabled (should be disabled)");
                currentTestCorrect = 0;
              end
              numTestsByOpcode[9] = numTestsByOpcode[9] + 1;
              if(currentTestCorrect == 1) begin
                $display("MSIM> --> Appears correct (unable to verify that your register file was correctly updated).");
                numCorrect = numCorrect + 1;
                numCorrectByOpcode[9] = numCorrectByOpcode[9] + 1;
              end
            end
            3'b100: begin
              $display("MSIM> Instr. %3d (PC = %3d): SLL  R%1d, R%1d", currentInstruction, PC, rd, rs);
              sDataA   = sreg[rs];
              sDataB   = sreg[rt];
              sreg[rd] = {sreg[rs][6:0], 1'b0};
              sDataC   = sreg[rd];
              check_reg2reg(sDataA, sDataB, sDataC, DataA, DataB, DataC);
              if(MW) begin
                $display("MSIM> --> ERROR: MW is enabled (should be disabled)");
                currentTestCorrect = 0;
              end
              numTestsByOpcode[10] = numTestsByOpcode[10] + 1;
              if(currentTestCorrect == 1) begin
                $display("MSIM> --> Appears correct (unable to verify that your register file was correctly updated).");
                numCorrect = numCorrect + 1;
                numCorrectByOpcode[10] = numCorrectByOpcode[10] + 1;
              end
            end
            3'b101: begin
              $display("MSIM> Instr. %3d (PC = %3d): AND  R%1d, R%1d, R%1d", currentInstruction, PC, rd, rs, rt);
              sDataA   = sreg[rs];
              sDataB   = sreg[rt];
              sreg[rd] = sreg[rs] & sreg[rt];
              sDataC   = sreg[rd];
              check_reg2reg(sDataA, sDataB, sDataC, DataA, DataB, DataC);
              if(MW) begin
                $display("MSIM> --> ERROR: MW is enabled (should be disabled)");
                currentTestCorrect = 0;
              end
              numTestsByOpcode[11] = numTestsByOpcode[11] + 1;
              if(currentTestCorrect == 1) begin
                $display("MSIM> --> Appears correct (unable to verify that your register file was correctly updated).");
                numCorrect = numCorrect + 1;
                numCorrectByOpcode[11] = numCorrectByOpcode[11] + 1;
              end
            end
            3'b110: begin
              $display("MSIM> Instr. %3d (PC = %3d): OR   R%1d, R%1d, R%1d", currentInstruction, PC, rd, rs, rt);
              sDataA   = sreg[rs];
              sDataB   = sreg[rt];
              sreg[rd] = sreg[rs] | sreg[rt];
              sDataC   = sreg[rd];
              check_reg2reg(sDataA, sDataB, sDataC, DataA, DataB, DataC);
              if(MW) begin
                $display("MSIM> --> ERROR: MW is enabled (should be disabled)");
                currentTestCorrect = 0;
              end
              numTestsByOpcode[12] = numTestsByOpcode[12] + 1;
              if(currentTestCorrect == 1) begin
                $display("MSIM> --> Appears correct (unable to verify that your register file was correctly updated).");
                numCorrect = numCorrect + 1;
                numCorrectByOpcode[12] = numCorrectByOpcode[12] + 1;
              end
            end
            default: begin
              $display("MSIM> Instr. %3d (PC = %3d): Unknown instruction %h", currentInstruction, PC, Iin);
              if(MW) begin
                $display("MSIM> --> ERROR: MW is enabled (should be disabled)");
                currentTestCorrect = 0;
              end
              invalidInstructions = invalidInstructions + 1;
            end
          endcase
        end
        default: begin
          $display("MSIM> Instr. %3d (PC = %3d): Unknown instruction %h", currentInstruction, PC, Iin);
          if(MW) begin
            $display("MSIM> --> ERROR: MW is enabled (should be disabled)");
            currentTestCorrect = 0;
          end
          invalidInstructions = invalidInstructions + 1;
        end
      endcase

      if((PC == finalPC) || (numConsecutiveNOPs == 5)) begin
        $display("MSIM> ");
        $display("MSIM> ----------------------------------------------------------------------");
        $display("MSIM> ");
        $display("MSIM> PROGRAM EXECUTION SUMMARY");
        $display("MSIM> =========================");
        $display("MSIM> ");
        $display("MSIM> OPCODE |  #Tests  | #Correct ");
        $display("MSIM> -------+----------+----------");
        $display("MSIM> NOP    |      %3d |      N/A", numTestsByOpcode[0]);
        $display("MSIM> LB     |      %3d |      %3d", numTestsByOpcode[1], numCorrectByOpcode[1]);
        $display("MSIM> SB     |      %3d |      %3d", numTestsByOpcode[2], numCorrectByOpcode[2]);
        $display("MSIM> ADDI   |      %3d |      %3d", numTestsByOpcode[3], numCorrectByOpcode[3]);
        $display("MSIM> ANDI   |      %3d |      %3d", numTestsByOpcode[4], numCorrectByOpcode[4]);
        $display("MSIM> ORI    |      %3d |      %3d", numTestsByOpcode[5], numCorrectByOpcode[5]);
        $display("MSIM> ADD    |      %3d |      %3d", numTestsByOpcode[6], numCorrectByOpcode[6]);
        $display("MSIM> SUB    |      %3d |      %3d", numTestsByOpcode[7], numCorrectByOpcode[7]);
        $display("MSIM> SRA    |      %3d |      %3d", numTestsByOpcode[8], numCorrectByOpcode[8]);
        $display("MSIM> SRL    |      %3d |      %3d", numTestsByOpcode[9], numCorrectByOpcode[9]);
        $display("MSIM> SLL    |      %3d |      %3d", numTestsByOpcode[10], numCorrectByOpcode[10]);
        $display("MSIM> AND    |      %3d |      %3d", numTestsByOpcode[11], numCorrectByOpcode[11]);
        $display("MSIM> OR     |      %3d |      %3d", numTestsByOpcode[12], numCorrectByOpcode[12]);
        $display("MSIM> -------+----------+----------");
        $display("MSIM> HALT   |      %3d |      N/A", numTestsByOpcode[13]);
        $display("MSIM> BEQ    |      %3d |      %3d", numTestsByOpcode[14], numCorrectByOpcode[14]);
        $display("MSIM> BNE    |      %3d |      %3d", numTestsByOpcode[15], numCorrectByOpcode[15]);
        $display("MSIM> BGEZ   |      %3d |      %3d", numTestsByOpcode[16], numCorrectByOpcode[16]);
        $display("MSIM> BLTZ   |      %3d |      %3d", numTestsByOpcode[17], numCorrectByOpcode[17]);
        $display("MSIM> ");
        $display("MSIM>      Correct Instructions: %3d", numCorrect);
        $display("MSIM>    Incorrect Instructions: %3d", numTests - numCorrect - numTestsByOpcode[0] - numTestsByOpcode[13] - invalidInstructions);
        $display("MSIM>   Unverified Instructions: %3d", numTestsByOpcode[0] + numTestsByOpcode[13]);
        $display("MSIM>      Invalid Instructions: %3d", invalidInstructions);
        $display("MSIM> Total Instructions Tested: %3d", numTests);
        $display("MSIM> ");
        $display("MSIM> *****************************************************************");
        $display("MSIM> **  You should manually verify that your register file is not  **");
        $display("MSIM> **    being updated incorrectly!  Use the waveform to check    **");
        $display("MSIM> **    this.  Also use the waveform to make sure that when a    **");
        $display("MSIM> **   HALT instruction is reached, that the PC does not change  **");
        $display("MSIM> **   until the active low button EN_L is pressed by the user.  **");
        $display("MSIM> *****************************************************************");
        $stop;
      end

      currentInstruction = currentInstruction + 1;
      $display("MSIM> ");

    end
  end


  // TASKS AND FUNCTIONS: helpers to assist with checking the correct values

  task check_reg2reg(input [7:0] ss, st, sd, dataa, datab, datac);
    begin
      if(`CHECK) begin
        if(ss != dataa) begin
          $display("MSIM> --> ERROR: Source Reg RS = %3d, should be %3d (did you write it correctly before?)", dataa, ss);
          currentTestCorrect = 0;
        end
        if(st != datab) begin
          $display("MSIM> --> ERROR: Source Reg RT = %3d, should be %3d (did you write it correctly before?)", datab, st);
          currentTestCorrect = 0;
        end
        if(sd != datac) begin
          $display("MSIM> --> ERROR: Dest Reg RD = %3d, should be %3d", datac, sd);
          currentTestCorrect = 0;
        end
      end
    end
  endtask


  task check_imm(input [7:0] ss, st, dataa, datac);
    begin
      if(`CHECK) begin
        if(ss !== dataa) begin
          $display("MSIM> --> ERROR: Source Reg RS = %3d, expecting %3d", dataa, ss);
          currentTestCorrect = 0;
        end
        if(st !== datac) begin
          $display("MSIM> --> ERROR: Dest Reg RT = %3d, expecting %3d", datac, st);
          currentTestCorrect = 0;
        end
      end
    end
  endtask


  task check_branch(input [7:0] ss, st, dataa, datab);
    begin
      if(`CHECK) begin
        if(ss !== dataa) begin
          $display("MSIM> --> ERROR: Source Reg RS = %3d, expecting %3d", dataa, ss);
          currentTestCorrect = 0;
        end
        if(st !== datab) begin
          $display("MSIM> --> ERROR: Source Reg RT = %3d, expecting %3d", datab, st);
          currentTestCorrect = 0;
        end

        // check correctness after PC jump condition is verified above
      end
    end
  endtask


  task write_mem(input [7:0] DataD, DataB);
    begin
      if(DataD !== sDataD) begin
        $display("MSIM> --> ERROR: Writing to memory address %3d (should be %3d)", DataD, sDataD);
        currentTestCorrect = 0;
      end

      if(DataB !== sDataB) begin
        $display("MSIM> --> ERROR: Writing data value %2h (should be %2h)", DataB, sDataB);
        currentTestCorrect = 0;
      end

      if(MW) begin
        casex(DataD)
          8'd249: $display("MSIM> --> ERROR: Address %3d is READ ONLY", DataD);
          8'd250: $display("MSIM> --> ERROR: Address %3d is READ ONLY", DataD);
          8'd251: $display("MSIM> --> ERROR: Address %3d is READ ONLY", DataD);
          8'd252: $display("MSIM> --> Output on IOD of %2h", DataB);
          8'd253: $display("MSIM> --> Output on IOE of %2h", DataB);
          8'd254: $display("MSIM> --> Output on IOF of %2h", DataB);
          8'd255: $display("MSIM> --> Output on IOG of %2h", DataB);
          default: begin // regular memory
            sdmem[DataD] = DataB;
            $display("MSIM> --> Writing %2h to data RAM address %3d", DataB, DataD);
          end
        endcase
      end
      else begin
        $display("MSIM> --> ERROR: MW is disabled for a memory write");
        currentTestCorrect = 0;
      end
    end
  endtask


  function [7:0] read_mem(input [7:0] DataD);
    begin
      if(DataD === 8'd249) begin
        read_mem = IOA;
        $display("MSIM> --> INPUT on IOA of %2h", IOA);
      end
      else if(DataD === 8'd250) begin
        read_mem = IOB;
        $display("MSIM> --> INPUT on IOB of %2h", IOB);
      end
      else if(DataD === 8'd251) begin
        read_mem = IOC;
        $display("MSIM> --> INPUT on IOC of %2h", IOC);
      end
      else begin
        read_mem = sdmem[DataD];
        $display("MSIM> --> Reading %2h from data RAM address %3d", read_mem, DataD);
      end
    end
  endfunction

endmodule
