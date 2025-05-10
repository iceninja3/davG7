`define BIT_WIDTH 10
`define BALL_RADIUS 4
`define PADDLE_RADIUS 8
`define MID_X 40
`define FLOOR_Y 80
`define BALL_X_COORDS_WIDTH 10
`define BALL_X_COORDS_MIN 10
`define BALL_X_COORDS_MAX 10

`define MIN_X 0
`define MAX_X 639
`define MIN_Y 0
`define MAX_Y 479
// Screen resolution is 640x480

module top
    (
        input clk,
        input rst,
        input [1:0] player1,
        input [1:0] player2,

        output [BIT_WIDTH:0] ball_x,
        output [BIT_WIDTH:0] ball_y
    );

    reg [BIT_WIDTH:0] ball_x = 0;
    reg [BIT_WIDTH:0] ball_y = 0;
    reg [BIT_WIDTH:0] player1_x = 50;
    reg [BIT_WIDTH:0] player2_x = 590;
    reg [BIT_WIDTH:0] player1_y = 50;
    reg [BIT_WIDTH:0] player2_y = 50;


    reg wall_collision = 0;
    reg p1_paddle_collision = 0;
    reg p2_paddle_collision = 0;
    reg ball_touching_floor = 0;


    paddle #(.DY(5), .TOP_BOUNDARY(480), .BOTTOM_BOUNDARY(0), .YBIT_WIDTH(BIT_WIDTH)) paddle1(clk, rst, player1, player1_x, player1_y);
    paddle #(.DY(5), .TOP_BOUNDARY(480), .BOTTOM_BOUNDARY(0), .YBIT_WIDTH(BIT_WIDTH)) paddle2(clk, rst, player2, player2_x, player2_y);
    ball ball1(clk, rst, paddle_collision, wall_collision, ball_x, ball_y);
    collisionDetection #(BIT_WIDTH, BALL_RADIUS, PADDLE_RADIUS, MID_X, FLOOR_Y) collisionDetector(player1_x, player1_y, ball_x, ball_y, p1_paddle_collision, ball_touching_floor);
    collisionDetection #(BIT_WIDTH, BALL_RADIUS, PADDLE_RADIUS, MID_X, FLOOR_Y) collisionDetector(player2_x, player2_y, ball_x, ball_y, p2_paddle_collision, ball_touching_floor);
    manageScore scoreManager (BALL_X_COORDS_WIDTH, BALL_X_COORDS_MIN, BALL_X_COORDS_MAX);

    // always @(posedge clk) 
    // begin
    //     ball_

        
    // end

    

endmodule
