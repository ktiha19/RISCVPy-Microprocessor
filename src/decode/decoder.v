module decoder(CLK, OPCODE, FUNCT_FIVE, FUNCT_THREE, FC, WREG, WMEM, RMEM, BRANCH);
    input CLK;
    input [6:0] OPCODE;
    input [4:0] FUNCT_FIVE;
    input [2:0] FUNCT_THREE;

    output reg [2:0] FC;
    output reg WREG; // write to register
    output reg WMEM; // write to memory
    output reg RMEM; // read to memory
    output reg BRANCH; // 1 if branch, 0 if no branch

    always @ (*) begin
        case (OPCODE)
            7'b0110011: begin
                case (FUNCT_THREE)
                    3'b000: begin
                        FC = (FUNCT_FIVE == 5'b00000) ? 000 : 001;
                        WREG = 1'b1;
                        WMEM = 1'b0;
                        RMEM = 1'b0;
                        BRANCH = 1'b0;
                    end
                    3'b001: begin
                        FC = 101;
                        WREG = 1'b1;
                        WMEM = 1'b0;
                        RMEM = 1'b0;
                        BRANCH = 1'b0;
                    end
                    3'b010: begin
                        FC = 3'b000; // may need to add more signals for the SLT functionality
                        WREG = 1'b1;
                        WMEM = 1'b0;
                        RMEM = 1'b0;
                        BRANCH = 1'b0;
                    end
                    3'b100: begin
                        FC = 3'b100;
                        WREG = 1'b1;
                        WMEM = 1'b0;
                        RMEM = 1'b0;
                        BRANCH = 1'b0;
                    end
                    3'b101: begin
                        FC = (FUNCT_FIVE == 5'b00000) ? 3'b110 : 3'b111;
                        WREG = 1'b1;
                        WMEM = 1'b0;
                        RMEM = 1'b0;
                        BRANCH = 1'b0;
                    end
                    3'b110: begin
                        FC = (FUNCT_FIVE == 5'b00000) ? 3'b110 : 3'b111;
                        WREG = 1'b1;
                        WMEM = 1'b0;
                        RMEM = 1'b0;
                        BRANCH = 1'b0;
                    end
                    3'b111: begin
                        FC = (FUNCT_FIVE == 5'b00000) ? 3'b110 : 3'b111;
                        WREG = 1'b1;
                        WMEM = 1'b0;
                        RMEM = 1'b0;
                        BRANCH = 1'b0;
                    end
                    default: begin
                        FC = 3'bxxx;
                        WREG = 1'b0;
                        WMEM = 1'b0;
                        RMEM = 1'b0;
                        BRANCH = 1'b0;
                    end
                endcase
            end
        endcase
    end

endmodule
    