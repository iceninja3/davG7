module top
(
    input logic clk,
    input logic rst,
    input logic pause,
    input logic switchPlayer,
    input logic upButton,
    input logic downButton,

    output logic[3:0] redOut,
    output logic[3:0] greenOut,
    output logic[3:0] blueOut,
    output logic hSync,
    output logic vSync,
    
    // for testing purposes only
    output logic[9:0] ball_x_out,
    output logic[9:0] ball_y_out,
    output logic[9:0] player1_x_out,
    output logic[9:0] player1_y_out,
    output logic[9:0] player2_x_out,
    output logic[9:0] player2_y_out,
    output logic[1:0] touchingPaddle_out,
    output logic[1:0] win_out,
    output logic vgaClk_out,
    output logic[9:0] hc_out,
    output logic[9:0] vc_out
);

localparam BIT_WIDTH = 10;
localparam MAX_X = 31;
localparam MAX_Y = 23;
localparam BALL_SPEED_X = 1;
localparam BALL_SPEED_Y = 0;
localparam PADDLE_SPEED = 1;
localparam BALL_RADIUS = 1;
localparam PADDLE_WIDTH = 1;
localparam PADDLE_LENGTH = 3;
localparam EDGE_OFFSET = 3;

logic sysRst;
logic up1;
logic up2;
logic down1;
logic down2;
logic[1:0] touchingPaddle;
logic[(BIT_WIDTH-1):0] ball_x;
logic[(BIT_WIDTH-1):0] ball_y;
logic[(BIT_WIDTH-1):0] player1_x;
logic[(BIT_WIDTH-1):0] player1_y;
logic[(BIT_WIDTH-1):0] player2_x;
logic[(BIT_WIDTH-1):0] player2_y;
logic[1:0] win;
logic vgaClk;

assign sysRst = rst;
always_comb
begin
    if (switchPlayer)
    begin
        up1 = ~upButton;
        down1 = ~downButton;
		  up2 = 0;
		  down2 = 0;
    end
    else
    begin
        up2 = ~upButton;
        down2 = ~downButton;
		  up1 = 0;
		  down1 = 0;
    end
end

ball
    #(
        .BIT_WIDTH(BIT_WIDTH), 
        .MAX_X(MAX_X), 
        .MAX_Y(MAX_Y), 
        .BALL_SPEED_X(BALL_SPEED_X), 
        .BALL_SPEED_Y(BALL_SPEED_Y), 
        .BALL_RADIUS(BALL_RADIUS), 
        .EDGE_OFFSET(EDGE_OFFSET)
    )
	 ballInstance 
(
    .rst(rst),
    .clk(clk),
    .pause(pause),
    .touchingPaddle(touchingPaddle),

    .ball_x(ball_x),
    .ball_y(ball_y),
    .win(win)
);

paddle
    #(
        .BIT_WIDTH(BIT_WIDTH),
        .MAX_X(MAX_X),
        .MAX_Y(MAX_Y),
        .PADDLE_SPEED(PADDLE_SPEED),
        .PADDLE_LENGTH(PADDLE_LENGTH),
        .PADDLE_WIDTH(PADDLE_WIDTH),
        .EDGE_OFFSET(EDGE_OFFSET)
    )
	 player1
(
    .rst(rst),
    .clk(clk),
    .pause(pause),
    .side(0),
    .dy({down1, up1}),

    .paddle_x(player1_x),
    .paddle_y(player1_y)
);

paddle
    #(
        .BIT_WIDTH(BIT_WIDTH),
        .MAX_X(MAX_X),
        .MAX_Y(MAX_Y),
        .PADDLE_SPEED(PADDLE_SPEED),
        .PADDLE_LENGTH(PADDLE_LENGTH),
        .PADDLE_WIDTH(PADDLE_WIDTH),
        .EDGE_OFFSET(EDGE_OFFSET)
    )
	 player2
(
    .rst(rst),
    .clk(clk),
    .pause(pause),
    .side(1),
    .dy({down2, up2}),

    .paddle_x(player2_x),
    .paddle_y(player2_y)
);

collisionDetection
    #(
        .BIT_WIDTH(BIT_WIDTH),
        .BALL_RADIUS(BALL_RADIUS),
        .PADDLE_WIDTH(PADDLE_WIDTH),
        .PADDLE_LENGTH(PADDLE_LENGTH)
    )
	 collisionDetector
(
    .rst(rst),
    .ball_x(ball_x),
    .ball_y(ball_y),
    .player1_x(player1_x),
    .player1_y(player1_y),
    .player2_x(player2_x),
    .player2_y(player2_y),

    .touchingPaddle(touchingPaddle)
);

graphicsDriver
    #(
        .BIT_WIDTH(BIT_WIDTH),
        .BALL_RADIUS(BALL_RADIUS),
        .PADDLE_WIDTH(PADDLE_WIDTH),
        .PADDLE_LENGTH(PADDLE_LENGTH)
    )
	 screenDisplayer
(
    .clk(clk),
    .sysRst(sysRst),
    .ball_x(ball_x),
    .ball_y(ball_y),
    .player1_x(player1_x),
    .player1_y(player1_y),
    .player2_x(player2_x),
    .player2_y(player2_y),

    //.red(redOut),
    //.green(greenOut),
    //.blue(blueOut),
    .hSync(hSync),
    .vSync(vSync),

    // for testing
    .vgaClk_out(vgaClk),
    .hc_out(hc_out),
    .vc_out(vc_out)
);

// for testing
assign ball_x_out = ball_x;
assign ball_y_out = ball_y;
assign player1_x_out = player1_x;
assign player1_y_out = player1_y;
assign player2_x_out = player2_x;
assign player2_y_out = player2_y;
assign touchingPaddle_out = touchingPaddle;
assign win_out = win;
assign vgaClk_out = vgaClk;

assign redOut = 4'b1110;
assign greenOut = 4'b1110;
assign blueOut = 4'b1100;


endmodule