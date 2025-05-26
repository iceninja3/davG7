`timescale 1ns/1ns
`define CLOCK_SPEED 50000000 // in Hz

module pong_tb
(
    output logic smth
);

localparam period = 1000000000 / `CLOCK_SPEED; // in ns
localparam halfPeriod = period / 2;
localparam doublePeriod = period * 2;
localparam longPeriod = period * 10000;

logic clk;
logic rst;
logic pause;
logic switchPlayer;
logic upButton;
logic downButton;
logic[3:0] redOut;
logic[3:0] greenOut;
logic[3:0] blueOut;
logic hSync;
logic vSync;

logic[9:0] ball_x;
logic[9:0] ball_y;
logic[9:0] player1_x;
logic[9:0] player1_y;
logic[9:0] player2_x;
logic[9:0] player2_y;
logic[1:0] touchingPaddle;
logic[1:0] win;
logic vgaClk;
logic[9:0] hc;
logic[9:0] vc;

top pongGame
(
    .clk(clk),
    .rst(rst),
    .pause(pause),
    .switchPlayer(switchPlayer),
    .upButton(upButton),
    .downButton(downButton),

    .redOut(redOut),
    .greenOut(greenOut),
    .blueOut(blueOut),
    .hSync(hSync),
    .vSync(vSync),

    .ball_x_out(ball_x),
    .ball_y_out(ball_y),
    .player1_x_out(player1_x),
    .player1_y_out(player1_y),
    .player2_x_out(player2_x),
    .player2_y_out(player2_y),
    .touchingPaddle_out(touchingPaddle),
    .win_out(win),
    .vgaClk_out(vgaClk),
    .hc_out(hc),
    .vc_out(vc)
);

always
begin
    clk = 0;
    #halfPeriod;
    clk = 1;
    #halfPeriod;
end

initial 
begin
    $monitor("clk: %b, rst: %b, p: %b, sP: %b, up: %b, down: %b, vgaClk: %b, R: %d, G: %d, B: %d, HS: %b, VS: %b, ballX: %d, ballY: %d, P1X: %d, P1Y: %d, P2X: %d, P2Y: %d, TP: %b, win: %b, hc: %d, vc: %d", 
            clk, rst, pause, switchPlayer, upButton, downButton, vgaClk, redOut, greenOut, blueOut, hSync, vSync, ball_x, ball_y, player1_x, player1_y, player2_x, player2_y, touchingPaddle, win, hc, vc);
    #period;
    rst = 1;
    pause = 0;
    switchPlayer = 0;
    upButton = 1;
    downButton = 1;
    #doublePeriod;
    #doublePeriod;
    #doublePeriod;
    rst = 0;
    #doublePeriod;
    #doublePeriod;
    pause = 1;
    #doublePeriod;
    pause = 0;
    upButton = 0;
    #doublePeriod;
    upButton = 1;
    downButton = 0;
    #doublePeriod;
    downButton = 1;
    switchPlayer = 1;
    upButton = 0;
    #doublePeriod;
    upButton = 1;
    downButton = 0;
    #doublePeriod;
    downButton = 1;
    #doublePeriod;
    #doublePeriod;
    #doublePeriod;
    #doublePeriod;
    #doublePeriod;
    #doublePeriod;

    #longPeriod;
    #longPeriod;
    #longPeriod;
    #longPeriod;
    #longPeriod;
    #longPeriod;
    #longPeriod;
    #longPeriod;

    $stop;
end
endmodule