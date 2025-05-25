module manageScore #(
    parameter int BALL_X_W   = 10,
    parameter int X_MIN      = 0,
    parameter int X_MAX      = 639
) (
    input  logic                     clk,
    input  logic                     reset,
    input  logic [BALL_X_W-1:0]      ball_x_coords,
    output logic [1:0]               increaseScore,   // 01 → P1 scores, 10 → P2 scores
    output logic [6:0]               score1 = 0,
    output logic [6:0]               score2 = 0
);

    always_ff @(posedge clk) begin
        // default outputs
        increaseScore <= 2'b00;

        if (reset) begin
            score1        <= 0;
            score2        <= 0;
        end else begin
            if (ball_x_coords < X_MIN) begin
                if (score1 < 99)
                    score1 <= score1 + 1;
                increaseScore <= 2'b01;
            end
            else if (ball_x_coords > X_MAX) begin
                if (score2 < 99)
                    score2 <= score2 + 1;
                increaseScore <= 2'b10;
            end
        end
    end
endmodule