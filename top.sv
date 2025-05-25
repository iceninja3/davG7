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
        input logic clk,
        input logic rst,
        input logic [1:0] player1,
        input logic [1:0] player2,

        output logic [`BIT_WIDTH:0] ball_x,
        output logic [`BIT_WIDTH:0] ball_y
    );

    //reg [BIT_WIDTH:0] ball_x = 0;
    //reg [BIT_WIDTH:0] ball_y = 0;
    localparam p1x_initial= 50;
	 logic [`BIT_WIDTH:0] p1x;
    localparam p2x_initial = 590;
	 logic [`BIT_WIDTH:0] p2x;
    reg [`BIT_WIDTH:0] p1y_initial = 50;
	 logic [`BIT_WIDTH:0] p1y;
	 logic [`BIT_WIDTH:0] p1y_buffer;
    reg [`BIT_WIDTH:0] p2y_initial = 50;
	 logic [`BIT_WIDTH:0] p2y;
	 logic [`BIT_WIDTH:0] p2y_buffer;


    reg wall_collision;
    reg p1_paddle_collision;
    reg p2_paddle_collision;
    reg ball_touching_floor;


    paddle #(.DY(5), .TOP_BOUNDARY(480), .BOTTOM_BOUNDARY(0), .YBIT_WIDTH(`BIT_WIDTH)) paddle1(clk, rst, player1, p1x, p1y_buffer);
    paddle #(.DY(5), .TOP_BOUNDARY(480), .BOTTOM_BOUNDARY(0), .YBIT_WIDTH(`BIT_WIDTH)) paddle2(clk, rst, player2, p2x, p2y_buffer);
    ball ball1(clk, rst, p1_paddle_collision, wall_collision, ball_x, ball_y);
    collisionDetection #(`BIT_WIDTH, `BALL_RADIUS, `PADDLE_RADIUS, `FLOOR_Y) collisionDetector1(p1x, p1y, ball_x, ball_y, p1_paddle_collision, ball_touching_floor);
    collisionDetection #(`BIT_WIDTH, `BALL_RADIUS, `PADDLE_RADIUS, `FLOOR_Y) collisionDetector2(p2x, p2y, ball_x, ball_y, p2_paddle_collision, ball_touching_floor);
    manageScore scoreManager (`BALL_X_COORDS_WIDTH, `BALL_X_COORDS_MIN, `BALL_X_COORDS_MAX);

   always_comb
	begin
		if (rst)
		begin
			p1y = p1y_initial;
			p2y = p2y_initial;
		end
		else
		begin
			p1y = p1y_buffer;
			p2y = p2y_buffer;
		end
		p1x = p1x_initial;
		p2x = p2x_initial;
	end
    

endmodule