`timescale 1ns/1ns

module collisionDetection_tb;

    // Parameters from collisionDetection module
    localparam BIT_WIDTH     = 10;
    localparam BALL_RADIUS   = 5;
    localparam PADDLE_RADIUS = 20;
    localparam FLOOR_Y       = 479; // Assuming a screen height of 480, floor is at max Y

    // Inputs
    logic [(BIT_WIDTH-1):0] paddleX;
    logic [(BIT_WIDTH-1):0] paddleY;
    logic [(BIT_WIDTH-1):0] ballX;
    logic [(BIT_WIDTH-1):0] ballY;

    // Outputs
    logic ballTouchingPaddle;
    logic ballTouchingFloor;

    // Instantiate the module under test (MUT)
    collisionDetection #(
        .BIT_WIDTH(BIT_WIDTH),
        .BALL_RADIUS(BALL_RADIUS),
        .PADDLE_RADIUS(PADDLE_RADIUS),
        .FLOOR_Y(FLOOR_Y)
    ) cd_inst (
        .paddleX(paddleX),
        .paddleY(paddleY),
        .ballX(ballX),
        .ballY(ballY),
        .ballTouchingPaddle(ballTouchingPaddle),
        .ballTouchingFloor(ballTouchingFloor)
    );

    initial begin
        $monitor("Time: %0t | paddleX: %d, paddleY: %d, ballX: %d, ballY: %d | ballTouchingPaddle: %b, ballTouchingFloor: %b",
                 $time, paddleX, paddleY, ballX, ballY, ballTouchingPaddle, ballTouchingFloor);

        // Test case 1: Ball not touching paddle, not touching floor
        paddleX = 50;
        paddleY = 240;
        ballX   = 100;
        ballY   = 200;
        #10;

        // Test case 2: Ball touching paddle (center) 
        // ((ballX == paddleX) && (ballY <= (paddleY + PADDLE_RADIUS)) && (ballY >= (paddleY - PADDLE_RADIUS)))
        paddleX = 50;
        paddleY = 240;
        ballX   = 50;  // ballX == paddleX
        ballY   = 240; // paddleY - PADDLE_RADIUS <= ballY <= paddleY + PADDLE_RADIUS (220 <= 240 <= 260)
        #10;

        // Test case 3: Ball touching paddle (upper edge) 
        ballX   = 50;
        ballY   = paddleY + PADDLE_RADIUS; // 240 + 20 = 260
        #10;

        // Test case 4: Ball touching paddle (lower edge) 
        ballX   = 50;
        ballY   = paddleY - PADDLE_RADIUS; // 240 - 20 = 220
        #10;

        // Test case 5: Ball ALMOST touching paddle (X mismatch)
        ballX   = 51; // X different
        ballY   = 240;
        #10;

        // Test case 6: Ball ALMOST touching paddle (Y too high)
        ballX   = 50;
        ballY   = paddleY + PADDLE_RADIUS + 1; // 261
        #10;

        // Test case 7: Ball ALMOST touching paddle (Y too low)
        ballX   = 50;
        ballY   = paddleY - PADDLE_RADIUS - 1; // 219
        #10;

        // Test case 8: Ball touching floor 
        // ((ballY - BALL_RADIUS) == FLOOR_Y)
        ballX   = 200;
        ballY   = FLOOR_Y + BALL_RADIUS; // 479 + 5 = 484
        #10;

        // Test case 9: Ball just above floor (not touching)
        ballY   = FLOOR_Y + BALL_RADIUS - 1; // 483
        #10;
        
        // Test case 10: Ball below floor (should also register as not touching based on exact equality)
        ballY   = FLOOR_Y + BALL_RADIUS + 1; // 485
        #10;

        $stop;
    end

endmodule