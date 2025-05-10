`define BIT_WIDTH 8
`define BALL_RADIUS 4
`define PADDLE_RADIUS 8
`define MID_X 40
`define FLOOR_Y 80
`define BALL_X_COORDS_WIDTH 10
`define BALL_x_COORDS_MIN 10
`define BALL_X_COORDS_MAX 10

module top
    (
        input clk,
        input rst,
        input [1:0] player1,
        input [1:0] player2,

        output ball_x,
        output ball_y
    );

    reg ball_x = 0;
    reg ball_y = 0;
    reg player1_x = 50;
    reg player2_x = 590;

    reg wall_collision = 0;
    reg paddle_collision = 0;

    paddle #(.DY(5), .TOP_BOUNDARY(480), .BOTTOM_BOUNDARY(0), .YBIT_WIDTH(10)) paddle1 (clk, rst, player1, player1_x);
    paddle #(.DY(5), .TOP_BOUNDARY(480), .BOTTOM_BOUNDARY(0), .YBIT_WIDTH(10)) paddle2(clk, rst, player2, player2_x);
    ball ball1(clk, rst, paddle_collision, wall_collision, ball_x, ball_y);
    collisionDetection collisionDetector (BIT_WIDTH, BALL_RADIUS, PADDLE_RADIUS, MID_X, FLOOR_Y);
    manageScore scoreManager (BALL_X_COORDS_WIDTH, BALL_x_COORDS_MIN, BALL_X_COORDS_MAX);

    // always @(posedge clk) 
    // begin
    //     ball_

        
    // end

    

endmodule
