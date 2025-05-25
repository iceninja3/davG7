module ball #(parameter BIT_WIDTH, MAX_X, MAX_Y, BALL_SPEED_X, BALL_SPEED_Y, BALL_RADIUS, EDGE_OFFSET)
(
    input logic rst,
    input logic clk,
    input logic pause,
    input logic[1:0] touchingPaddle,

    output logic[(BIT_WIDTH-1):0] ball_x,
    output logic[(BIT_WIDTH-1):0] ball_y,
    output logic[1:0] win
);

logic[(BIT_WIDTH-1):0] prevBall_x;
logic[(BIT_WIDTH-1):0] prevBall_y;
logic xDirection;
logic prevXDirection;
logic yDirection;
logic prevYDirection;

always @(posedge clk)
begin
    if (rst)
    begin
        ball_x = MAX_X / 2;
        ball_y = MAX_Y / 2;
    end
    else if (pause)
    begin
        ball_x = prevBall_x;
        ball_y = prevBall_y;
    end
    else if (win[0] || win[1])
    begin
        ball_x = prevBall_x;
        ball_y = prevBall_y;
    end
    else if (xDirection && yDirection) // right and up
    begin
        ball_x = prevBall_x + BALL_SPEED_X;
        ball_y = prevBall_y + BALL_SPEED_Y;
    end
    else if (xDirection) // right and down
    begin
        ball_x = prevBall_x + BALL_SPEED_X;
        ball_y = prevBall_y - BALL_SPEED_Y;
    end
    else if (yDirection) // left and up
    begin
        ball_x = prevBall_x - BALL_SPEED_X;
        ball_y = prevBall_y + BALL_SPEED_Y;
    end
    else // left and down
    begin
        ball_x = prevBall_x - BALL_SPEED_X;
        ball_y = prevBall_y - BALL_SPEED_Y;
    end

    prevBall_x = ball_x;
    prevBall_y = ball_y;
    prevXDirection = xDirection;
    prevYDirection = yDirection;
end

always_comb
begin
    if (rst)
    begin
        xDirection = 1; // starts off going to the right
    end
    else if (touchingPaddle[0] || touchingPaddle[1])
    begin
        xDirection = ~prevXDirection;
    end
    else
    begin
        xDirection = prevXDirection;
    end


    if (rst)
    begin
        yDirection = 1; // starts off going up
    end
    else if (((prevBall_y + BALL_RADIUS) >= (MAX_Y - EDGE_OFFSET)) || ((prevBall_y - BALL_RADIUS) <= EDGE_OFFSET))
    begin
        yDirection = ~prevYDirection;
    end
    else
    begin
        yDirection = prevYDirection;
    end

    if (rst)
    begin
        win[0] = 0;
        win[1] = 0;
    end
    else
    begin
        win[0] = (prevBall_x + BALL_RADIUS) >= (MAX_X - EDGE_OFFSET);
        win[1] = (prevBall_x - BALL_RADIUS) <= EDGE_OFFSET;
    end
end

endmodule