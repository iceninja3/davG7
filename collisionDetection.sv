module collisionDetection #(parameter BIT_WIDTH, BALL_RADIUS, Y_AXIS)
    (
        input logic[BIT_WIDTH:0] paddleX,
        input logic[BIT_WIDTH:0] paddleY,
        input logic[BIT_WIDTH:0] ballX,
        input logic[BIT_WIDTH:0] ballY,

        output logic touchingPaddle,
        output logic touchingFloor
    );

    assign touchingPaddle = ((ballX == paddleX) && (ballY == paddleY));

endmodule