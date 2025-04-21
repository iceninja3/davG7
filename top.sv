`define BIT_WIDTH 8
`define BALL_RADIUS 4
`define PADDLE_RADIUS 8
`define MID_X 40
`define FLOOR_Y 80

module top
    (
        input clk,
        input rst,
        input player1,
        input player2
    );

    reg ball_x = 0;
    reg ball_y = 0;
    reg player1_x = 50;
    reg player2_x = 590;

    reg wall_collision = 0;
    reg paddle_collision = 0;

    paddle paddle1(clk, rst, player1, player1_x);
    paddle paddle2(clk, rst, player2, player2_x);
    ball ball1(clk, rst, paddle_collision, wall_collision, ball_x, ball_y);
    collisionDetection collisionDetector (BIT_WIDTH, BALL_RADIUS, PADDLE_RADIUS, MID_X, FLOOR_Y);

    always @(posedge clk) begin
        

        
    end

    

endmodule
