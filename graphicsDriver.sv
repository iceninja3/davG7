module graphicsDriver #(BIT_WIDTH, BALL_RADIUS, PADDLE_WIDTH, PADDLE_LENGTH)
(
    input logic clk,
    input logic sysRst,
    input logic[(BIT_WIDTH-1):0] ball_x,
    input logic[(BIT_WIDTH-1):0] ball_y,
    input logic[(BIT_WIDTH-1):0] player1_x,
    input logic[(BIT_WIDTH-1):0] player1_y,
    input logic[(BIT_WIDTH-1):0] player2_x,
    input logic[(BIT_WIDTH-1):0] player2_y,

    output logic[3:0] red,
    output logic[3:0] green,
    output logic[3:0] blue,
    output logic hSync,
    output logic vSync
);

localparam HPIXELS = 32;
localparam BLOCKING_FACTOR = 20;
localparam BLK = 8'h00;
localparam WHT = 8'hff;
localparam RED = 8'he0;
localparam BLU = 8'h03;

logic vgaClk;
logic locked;
logic[7:0] color_8bit;
logic[11:0] color_12bit;
logic[11:0] colorOut;
logic[9:0] hc;
logic[9:0] vc;
logic[9:0] address;
logic atBall;
logic atBallX;
logic atBallY;
logic atPaddle1;
logic atPaddle1X;
logic atPaddle1Y;
logic atPaddle2;
logic atPaddle2X;
logic atPaddle2Y;


vgaclk pll
(
    .areset(sysRst),
    .inclk0(clk),
    .c0(vgaClk),
    .locked(locked)
);

vga vgaInstance
(
    .vgaclk(vgaClk), 
    .rst(sysRst), 
    .input_red(color_8bit[7:5]), 
    .input_green(color_8bit[4:2]), 
    .input_blue(color_8bit[1:0]), 

    .hc_out(hc), 
    .vc_out(vc), 
    .hsync(hSync), 
    .vsync(vSync), 
    .red(color_12bit[11:8]), 
    .green(color_12bit[7:4]), 
    .blue(color_12bit[3:0])
);
  
double_buffer doubleBuffer
(
    .clk(vgaClk),
    .rst(sysRst),
    .hc(hc),
    .vc(vc),
    .writeAddress(address),
    .colorIn(color_12bit),

    .colorOut(colorOut)
);
    
assign address = (vc / BLOCKING_FACTOR) * HPIXELS + (hc / BLOCKING_FACTOR);

assign atBallX = ((hc / BLOCKING_FACTOR) >= (ball_x - BALL_RADIUS)) && ((hc / BLOCKING_FACTOR) <= (ball_x + BALL_RADIUS));
assign atBallY = ((vc / BLOCKING_FACTOR) >= (ball_y - BALL_RADIUS)) && ((vc / BLOCKING_FACTOR) <= (ball_y + BALL_RADIUS));
assign atBall = atBallX && atBallY;

assign atPaddle1X = ((hc / BLOCKING_FACTOR) >= (player1_x - 0)) && ((hc / BLOCKING_FACTOR) <= (player1_x + PADDLE_WIDTH));
assign atPaddle1Y = ((vc / BLOCKING_FACTOR) <= (player1_y - PADDLE_LENGTH)) && ((vc / BLOCKING_FACTOR) >= (player1_y + PADDLE_LENGTH));
assign atPaddle1 = atPaddle1X && atPaddle1Y;

assign atPaddle2X = ((hc / BLOCKING_FACTOR) >= (player2_x - 0)) && ((hc / BLOCKING_FACTOR) <= (player2_x + PADDLE_WIDTH));
assign atPaddle2Y = ((vc / BLOCKING_FACTOR) <= (player2_y - PADDLE_LENGTH)) && ((vc / BLOCKING_FACTOR) >= (player2_y + PADDLE_LENGTH));
assign atPaddle2 = atPaddle2X && atPaddle2Y;

always_comb
begin
    if (atBall || atPaddle1 || atPaddle2)
    begin
        color_8bit = WHT;
    end
    else
    begin
        color_8bit = BLK;
    end
end

assign red = colorOut[11:8];
assign green = colorOut[7:4];
assign blue = colorOut[3:0];

endmodule