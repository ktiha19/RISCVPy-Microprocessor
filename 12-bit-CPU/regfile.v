module regfile (CLK, RESET, SA, SB, LD, DR, D_in, DataA, DataB);
    input CLK, RESET;
    input [2:0] SA, SB;
    output [7:0] DataA, DataB;
    input LD;
    input [2:0] DR;
    input [7:0] D_in;

    reg [7:0] storage [7:0];

    assign DataA = storage[SA];
    assign DataB = storage[SB];

    integer i;

    always @(posedge CLK) begin
        if (RESET)
            for (i = 0; i < 8; i = i + 1)
                storage[i] <= 8'd0;
        else if (LD)
            storage[DR] <= D_in;
    end

endmodule
