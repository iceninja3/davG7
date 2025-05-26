module paddle #(parameter BIT_WIDTH, MAX_X, MAX_Y, PADDLE_SPEED, PADDLE_LENGTH, PADDLE_WIDTH, EDGE_OFFSET)
(
    input logic rst,
    input logic clk,
    input logic pause,
    input logic side,
    input logic[1:0] dy,

    output logic[(BIT_WIDTH-1):0] paddle_x,
    output logic[(BIT_WIDTH-1):0] paddle_y
);

logic[(BIT_WIDTH-1):0] prevX;
logic[(BIT_WIDTH-1):0] prevY;

always @(posedge clk)
begin
    if (rst)
    begin
        if (side == 0)
        begin
            paddle_x <= MAX_X - PADDLE_WIDTH - 1;
            paddle_y <= MAX_Y / 2;
        end
        else
        begin
            paddle_x <= PADDLE_WIDTH + 1;
            paddle_y <= MAX_Y / 2;
        end
    end
    else if (dy[0]) // moving up
    begin
        if ((prevY + PADDLE_LENGTH + PADDLE_SPEED) > MAX_Y)
        begin
            paddle_y <= prevY;
        end
        else
        begin
            paddle_y <= prevY + PADDLE_SPEED;
        end
        paddle_x <= prevX;
    end
    else if (dy[1]) // moving down
    begin
        if ((prevY - PADDLE_LENGTH - PADDLE_SPEED) < EDGE_OFFSET)
        begin
            paddle_y <= prevY;
        end
        else
        begin
            paddle_y <= prevY - PADDLE_SPEED;
        end
        paddle_x <= prevX;
    end
    else
    begin
        paddle_x <= prevX;
        paddle_y <= prevY;
    end

    prevX <= paddle_x;
    prevY <= paddle_y;
end

endmodule