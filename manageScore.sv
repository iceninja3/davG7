module manageScore #(parameter ball_x_coords_width, parameter x_coords_min, parameter x_coords_max)
(
    input clk,
    input reset,
    input [ball_x_coords_width-1: 0] ball_x_coords,
    output increaseScore
);

    // Max score 99
    reg [6:0] score1 = 0;
    reg [6:0] score2 = 0;

    always @(posedge clk) begin
        if (reset) begin
            score1 <= 0;
            score2 <= 0;
        end

        if (ball_x_coords < x_coords_min)
            score1 <= score1 + 1;
        else if (ball_x_coords > x_coords_max)
            score2 <= score2 + 1;
    end

endmodule