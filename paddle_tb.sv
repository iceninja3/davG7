`timescale 1ns/1ns
`define CLOCK_SPEED 50000000 // in Hz
`define BIT_WIDTH 10

module paddle_tb
(
	output logic smth
);

    // Parameters from paddle module
    localparam DY              = 1; // Movement step
    localparam TOP_BOUNDARY    = 0;
    localparam BOTTOM_BOUNDARY = 479; // Assuming screen height of 480
    localparam YBIT_WIDTH      = `BIT_WIDTH;  // To represent up to 479, 9 bits (2^9 = 512) is not enough, needs 10 bits.
                                     // The module output is [YBIT_WIDTH:0], so if YBIT_WIDTH = 9, it's 10 bits.
                                     // If YBIT_WIDTH is meant to be the number of bits, then it should be 10.
                                     // Let's assume YBIT_WIDTH = 9 means indices 9 down to 0 (10 bits total).
                                     // Max value for 10 bits is 1023. Max value for (YBIT_WIDTH):0 is 2^(YBIT_WIDTH+1)-1.

    // Testbench clock
    localparam halfPeriod = ((1000000000 / `CLOCK_SPEED) / 2); // in ns 
    localparam period = 2 * halfPeriod;                         // in ns 

    // Inputs
    logic clk;
    logic rst;
    logic [1:0] btn;
    logic [YBIT_WIDTH:0] xPos_dummy; // xPos is an input to paddle module but not used for yPos logic 

    // Outputs
    logic [YBIT_WIDTH:0] yPos;

    // Instantiate the module under test (MUT)
    paddle #(
        .DY(DY),
        .TOP_BOUNDARY(TOP_BOUNDARY),
        .BOTTOM_BOUNDARY(BOTTOM_BOUNDARY),
        .YBIT_WIDTH(YBIT_WIDTH)
    ) paddle_inst (
        .clk(clk),
        .rst(rst),
        .btn(btn),
        .xPos(xPos_dummy), // Connect the dummy xPos
        .yPos(yPos)
    );

    // Clock generation
    always begin
        clk = 0;
        #halfPeriod;
        clk = 1;
        #halfPeriod;
    end

    initial begin
        $monitor("rst: %b, btn: %2b, yPos: %b", rst, btn, yPos);

        // Test case 1: Reset paddle
        rst = 1;
        btn = 2'b00;
        xPos_dummy = 100; // Initialize dummy input
        #period;
        // yPos should be 240 
        if (yPos !== 240) $display("Error: Reset failed, yPos is %d, expected 240", yPos);

        rst = 0;
        #period;

        // Test case 2: Move paddle up (btn == 2'b01)
        // According to module: if (btn == 1) yPos <= yPos + btn*DY;
        // This means yPos will increase by 1*DY.
        btn = 2'b01; // PADDLE_MOVE_UP (intended logic, assuming btn=1 is up)
        #period; // yPos should be 240 + 1 = 241
        if (yPos !== 241) $display("Error: Move up (btn=1) failed, yPos is %d, expected 241", yPos);
        #period; // yPos should be 241 + 1 = 242
        if (yPos !== 242) $display("Error: Move up (btn=1) failed, yPos is %d, expected 242", yPos);

        // Test case 3: Move paddle down (btn == 2'b10)
        // According to module: else if (btn == 2) yPos <= yPos - btn*DY; 
        // This means yPos will decrease by 2*DY. If DY=1, it decreases by 2.
        btn = 2'b10; // PADDLE_MOVE_DOWN
        #period; // yPos should be 242 - 2*1 = 240
        if (yPos !== 240) $display("Error: Move down (btn=2) failed, yPos is %d, expected 240", yPos);
        #period; // yPos should be 240 - 2*1 = 238
        if (yPos !== 238) $display("Error: Move down (btn=2) failed, yPos is %d, expected 238", yPos);

        // Test case 4: No button press (btn == 2'b00)
        btn = 2'b00;
        #period; // yPos should be 238 (no change)
        if (yPos !== 238) $display("Error: No button press failed, yPos is %d, expected 238", yPos);

        // Test case 5: Button combination 2'b11 (undefined in current logic, should default to no change)
        btn = 2'b11;
        #period; // yPos should be 238 (no change)
        if (yPos !== 238) $display("Error: btn=3 failed, yPos is %d, expected 238", yPos);


        // Test case 6: Reaching TOP_BOUNDARY
        // Set yPos close to TOP_BOUNDARY
        // Manually set yPos for testing - this requires internal access or a different test approach.
        // For a black-box testbench, we need to drive it there.
        // Current yPos = 238. TOP_BOUNDARY = 0.
        // To reach 0 using btn = 2 (moves by -2*DY = -2 per clock): (238 - 0) / 2 = 119 clocks.
        // This is too long. Let's reset and move from a closer position if possible,
        // or test with a yPos initialized closer via a non-synthesizable force if this were a more complex TB.
        // For now, let's assume we can test it by moving.
        // Let's set yPos to a value close to top boundary manually for test illustration.
        // This is not directly possible without forcing or specific test modes in the DUT.
        // We will simulate moving it to the boundary.
        // Reset to 240.
        rst = 1;
        #period;
        rst = 0;
        #period; // yPos = 240

        // Move paddle to TOP_BOUNDARY
        // Target: yPos = TOP_BOUNDARY (0)
        // Using btn = 2'b10 (move by -2*DY = -2)
        // We need to set yPos to TOP_BOUNDARY + 1 or TOP_BOUNDARY + 2 to test the boundary logic properly.
        // Let's set yPos to 1. We can't directly set yPos in this testbench style.
        // We will move it repeatedly. This will take many cycles.
        // Instead, let's assume paddle module is modified for easier testing or use a smaller range.
        // For now, we'll test with current yPos.
        // To test TOP_BOUNDARY, yPos must be TOP_BOUNDARY.
        // If yPos is currently DY (e.g., 1), and btn == 2'b10 (move down by 2*DY), it will try to go to 1 - 2 = -1.
        // If yPos is TOP_BOUNDARY (0) and btn == 2'b10, it should stay at TOP_BOUNDARY. 
        // Let's assume yPos is somehow set to TOP_BOUNDARY (0) for this test point.
        // This requires an understanding that we'd need many cycles to get there.
        // The test here will assume we are at the boundary.
        // $display("Manually setting yPos for boundary test (conceptual for TB)");
        // paddle_inst.yPos <= TOP_BOUNDARY; // This is a force, not standard synthesisable TB style.
        // For a pure black-box TB, we'd have to step until it reaches the boundary.
        
        // Simulate moving to TOP_BOUNDARY + 1 then try to move down.
        // Let current yPos be 238. Goal is TOP_BOUNDARY = 0.
        // Using btn = 2 (yPos -= 2*DY):
        // yPos = 238.
        btn = 2'b10; // down
        for (int i = 0; i < 118; i++) begin // 238 -> 238 - 2*118 = 238 - 236 = 2
            #period;
        end
        // Now yPos should be 2.
        if (yPos !== 2) $display("Error: Setup for top boundary test, yPos is %d, expected 2", yPos);
        #period; // yPos should be 0 (2 - 2*1)
        if (yPos !== TOP_BOUNDARY) $display("Error: Reaching top boundary failed, yPos is %d, expected %d", yPos, TOP_BOUNDARY);

        // Try to move further down (should stay at TOP_BOUNDARY)
        #period; // yPos should remain 0 
        if (yPos !== TOP_BOUNDARY) $display("Error: Top boundary lock failed, yPos is %d, expected %d", yPos, TOP_BOUNDARY);

        // Try to move up from TOP_BOUNDARY
        btn = 2'b01; // up (yPos += DY)
        #period; // yPos should be 0 + 1 = 1
        if (yPos !== TOP_BOUNDARY + DY) $display("Error: Move up from top boundary failed, yPos is %d, expected %d", yPos, TOP_BOUNDARY + DY);


        // Test case 7: Reaching BOTTOM_BOUNDARY
        // Reset to 240
        rst = 1;
        #period;
        rst = 0;
        #period; // yPos = 240

        // Move paddle to BOTTOM_BOUNDARY - 1
        // Target: yPos = BOTTOM_BOUNDARY (479)
        // Using btn = 2'b01 (move by +DY = +1)
        // We need to reach 478. (478 - 240) = 238 steps.
        btn = 2'b01; // up
        for (int i = 0; i < (BOTTOM_BOUNDARY - 1 - 240); i++) begin // Move to 478
            #period;
        end
        // Now yPos should be BOTTOM_BOUNDARY - 1 = 478
        if (yPos !== BOTTOM_BOUNDARY - DY) $display("Error: Setup for bottom boundary, yPos is %d, expected %d", yPos, BOTTOM_BOUNDARY - DY);
        
        #period; // yPos should be 478 + 1 = 479 (BOTTOM_BOUNDARY)
        if (yPos !== BOTTOM_BOUNDARY) $display("Error: Reaching bottom boundary failed, yPos is %d, expected %d", yPos, BOTTOM_BOUNDARY);

        // Try to move further up (should stay at BOTTOM_BOUNDARY)
        #period; // yPos should remain 479 
        if (yPos !== BOTTOM_BOUNDARY) $display("Error: Bottom boundary lock failed, yPos is %d, expected %d", yPos, BOTTOM_BOUNDARY);
        
        // Try to move down from BOTTOM_BOUNDARY
        btn = 2'b10; // down (yPos -= 2*DY)
        #period; // yPos should be 479 - 2 = 477
        if (yPos !== BOTTOM_BOUNDARY - 2*DY) $display("Error: Move down from bottom boundary failed, yPos is %d, expected %d", yPos, BOTTOM_BOUNDARY - 2*DY);

        $stop;
    end

endmodule