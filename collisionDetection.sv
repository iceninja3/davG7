module collisionDetection #(parameter BIT_WIDTH, BALL_RADIUS, PADDLE_RADIUS MID_X, FLOOR_Y)
    (
        input logic[(BIT_WIDTH-1):0] paddleX,
        input logic[(BIT_WIDTH-1):0] paddleY,
        input logic[(BIT_WIDTH-1):0] ballX,
        input logic[(BIT_WIDTH-1):0] ballY,

        output logic touchingPaddle,
        output logic touchingFloor
    );

    assign touchingPaddle = ((ballX == paddleX) && (ballY <= (paddleY + PADDLE_RADIUS)) && (ballY >= (paddleY - PADDLE_RADIUS)));
    assign touchingFloor = ((ballY - BALL_RADIUS) == FLOOR_Y);

endmodule
