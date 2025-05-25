module collisionDetection #(parameter BIT_WIDTH, BALL_RADIUS, PADDLE_WIDTH, PADDLE_LENGTH)
(
    input logic rst,
    input logic[(BIT_WIDTH-1):0] ball_x,
    input logic[(BIT_WIDTH-1):0] ball_y,
    input logic[(BIT_WIDTH-1):0] player1_x,
    input logic[(BIT_WIDTH-1):0] player1_y,
    input logic[(BIT_WIDTH-1):0] player2_x,
    input logic[(BIT_WIDTH-1):0] player2_y,

    output logic[1:0] touchingPaddle
);

localparam closeProximity = 2;

always_comb
begin
    if (rst) begin touchingPaddle[0] = 0; end
    else if (ball_x > player1_x)
    begin
        touchingPaddle[0] = ((ball_x - BALL_RADIUS - PADDLE_WIDTH - player1_x) <= closeProximity) && ((ball_y <= (player1_y + PADDLE_LENGTH)) && (ball_y >= (player1_y - PADDLE_LENGTH)));
    end
    else
    begin
        touchingPaddle[0] = ((player1_x - PADDLE_WIDTH - BALL_RADIUS - ball_x) <= closeProximity) && ((ball_y <= (player1_y + PADDLE_LENGTH)) && (ball_y >= (player1_y - PADDLE_LENGTH)));
    end

    
    if (rst) begin touchingPaddle[1] = 0; end
    else if (ball_x > player2_x)
    begin
        touchingPaddle[1] = ((ball_x - BALL_RADIUS - PADDLE_WIDTH - player2_x) <= closeProximity) && ((ball_y <= (player2_y + PADDLE_LENGTH)) && (ball_y >= (player2_y - PADDLE_LENGTH)));
    end
    else
    begin
        touchingPaddle[1] = ((player2_x - PADDLE_WIDTH - BALL_RADIUS - ball_x) <= closeProximity) && ((ball_y <= (player2_y + PADDLE_LENGTH)) && (ball_y >= (player2_y - PADDLE_LENGTH)));
    end
end

endmodule