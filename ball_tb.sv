`define X_COORDS_WIDTH 10
`define Y_COORDS_WIDTH 10
`define CLOCK_SPEED 50000000 // in Hz
`timescale 1ns/1ns
module ball_tb
    (
        output logic smth
    );
    localparam halfPeriod = ((1000000000 / `CLOCK_SPEED) / 2); // in ns
    localparam period = 2 * halfPeriod; // in ns

    logic clk, rst, touchingPaddle, touchingWall;
    logic[`X_COORDS_WIDTH-1:0] oldX, newX;
    logic[`Y_COORDS_WIDTH-1:0] oldY, newY;
    ball #(`X_COORDS_WIDTH, `Y_COORDS_WIDTH) ballInstance (clk, rst, touchingPaddle, touchingWall, oldX, oldY, newX, newY);

    always
    begin
        clk = 0;
        #halfPeriod;
        clk = 1;
        #halfPeriod;
    end

    localparam massiveDelay = 10 * period;

    initial 
    begin
        $monitor("rst: %b, touchingPaddle: %b, touchingWall: %b, oldX: %b, oldY: %b, newX: %b, newY: %b", rst, touchingPaddle, touchingWall, oldX, oldY, newX, newY);
        
        rst = 1;
        touchingPaddle = 0;
        touchingWall = 0;
        oldX = 0;
        oldY = 0;
        #period
        rst = 0;
        oldX = 0;
        oldY = 0;
        #period
        oldX = newX;
        oldY = newY;
        #period
        oldX = newX;
        oldY = newY;
        #period
        touchingPaddle = 1;
        #period
        touchingPaddle = 0;
        oldX = newX;
        oldY = newY;
        #period
        touchingWall = 1;
        oldX = newX;
        oldY = newY;
        #period
        touchingWall = 0;
        oldX = newX;
        oldY = newY;
        #period
        $stop;
    end
endmodule
