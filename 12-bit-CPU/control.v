module control(FS, BSEL, CISEL, OSEL, SHIFT_LA, SHIFT_LR, LOGICAL_OA, CSEL); // add other outputs here

  // inputs
  input  [2:0]  FS;

  // constants for the function select
  // good practice that helps readablity
  // and save you from typing lots of numerical constants
  localparam FS_ADD = 3'b000;
  localparam FS_SUB = 3'b001;
  localparam FS_SRA = 3'b010;
  localparam FS_SRL = 3'b011;
  localparam FS_SLL = 3'b100;
  localparam FS_AND = 3'b101;
  localparam FS_OR  = 3'b110;

  /* ADD YOUR CODE BELOW THIS LINE */

  // outputs (add others here)
  output reg BSEL;
  output reg CISEL;
  output reg [1:0] OSEL;
  output reg SHIFT_LA;
  output reg SHIFT_LR;
  output reg LOGICAL_OA;
  output reg [1:0] CSEL;

  // constants for outputs (you can add more)
  // good practice that helps readablity
  // and save you from typing lots of numerical constants
  localparam BSEL_B  = 1'b0;
  localparam BSEL_BN = 1'b1;

  // internal variables (you can add more)

  // implement control logic here
  always @(*) begin
    case (FS)
      FS_ADD: begin
        BSEL = BSEL_B;
		  CISEL = 1'b0;
		  OSEL = 2'b00;
		  SHIFT_LA = 1'b0;
		  SHIFT_LR = 1'b0;
		  LOGICAL_OA = 1'b0;
		  CSEL = 2'b00;
      end
      FS_SUB: begin
        BSEL = BSEL_BN;
		  CISEL = 1'b1;
		  OSEL = 2'b00;
		  SHIFT_LA = 1'b0;
		  SHIFT_LR = 1'b0;
		  LOGICAL_OA = 1'b0;
		  CSEL = 2'b00;
      end
		FS_SRA: begin
        BSEL = BSEL_B;
		  CISEL = 1'b1;
		  OSEL = 2'b01;
		  SHIFT_LA = 1'b1;
		  SHIFT_LR = 1'b1;
		  LOGICAL_OA = 1'b0;
		  CSEL = 2'b10;
      end
		FS_SRL: begin
        BSEL = BSEL_B;
		  CISEL = 1'b1;
		  OSEL = 2'b01;
		  SHIFT_LA = 1'b0;
		  SHIFT_LR = 1'b1;
		  LOGICAL_OA = 1'b0;
		  CSEL = 2'b10;
      end
		FS_SLL: begin
        BSEL = BSEL_B;
		  CISEL = 1'b1;
		  OSEL = 2'b01;
		  SHIFT_LA = 1'b0;
		  SHIFT_LR = 1'b0;
		  LOGICAL_OA = 1'b0;
		  CSEL = 2'b10;
      end
		FS_AND: begin
        BSEL = BSEL_B;
		  CISEL = 1'b1;
		  OSEL = 2'b10;
		  SHIFT_LA = 1'b0;
		  SHIFT_LR = 1'b0;
		  LOGICAL_OA = 1'b1;
		  CSEL = 2'b01;
      end
		FS_OR: begin
        BSEL = BSEL_B;
		  CISEL = 1'b1;
		  OSEL = 2'b10;
		  SHIFT_LA = 1'b0;
		  SHIFT_LR = 1'b0;
		  LOGICAL_OA = 1'b0;
		  CSEL = 2'b01;
      end
      default: begin
        BSEL = 1'b0;
		  CISEL = 1'b0;
		  OSEL = 2'b00;
		  SHIFT_LA = 1'b0;
		  SHIFT_LR = 1'b0;
		  LOGICAL_OA = 1'b0;
		  CSEL = 2'b00;
      end
    endcase
  end

  /* ADD YOUR CODE ABOVE THIS LINE */

endmodule
