`timescale 1ns/1ns
`define CLOCK_SPEED 50000000 // in Hz

module manageScore_tb;

    // Parameters from manageScore module
    localparam BALL_X_W   = 10;
    localparam X_MIN      = 0;   // Score for P2 if ball_x_coords < X_MIN (e.g. -1)
                                 // Based on module: if (ball_x_coords < X_MIN) score1++ [cite: 6]
                                 // This means P1 scores if ball is to the "left" of X_MIN.
    localparam X_MAX      = 639; // Score for P1 if ball_x_coords > X_MAX (e.g. 640)
                                 // Based on module: else if (ball_x_coords > X_MAX) score2++ [cite: 8]
                                 // This means P2 scores if ball is to the "right" of X_MAX.

    // Testbench clock
    localparam halfPeriod = ((1000000000 / `CLOCK_SPEED) / 2); // in ns [cite: 22]
    localparam period = 2 * halfPeriod;                         // in ns [cite: 23]

    // Inputs
    logic                       clk;
    logic                       reset;
    logic [BALL_X_W-1:0]        ball_x_coords;

    // Outputs
    logic [1:0]                 increaseScore;
    logic [6:0]                 score1;
    logic [6:0]                 score2;

    // Instantiate the module under test (MUT)
    manageScore #(
        .BALL_X_W(BALL_X_W),
        .X_MIN(X_MIN),
        .X_MAX(X_MAX)
    ) score_inst (
        .clk(clk),
        .reset(reset),
        .ball_x_coords(ball_x_coords),
        .increaseScore(increaseScore),
        .score1(score1),
        .score2(score2)
    );

    // Clock generation
    always begin
        clk = 0;
        #halfPeriod;
        clk = 1;
        #halfPeriod;
    end

    initial begin
        $monitor("Time: %0t | rst: %b, ball_x: %d | score1: %d, score2: %d, increaseScore: %2b",
                 $time, reset, ball_x_coords, score1, score2, increaseScore);

        // Test case 1: Reset scores
        reset = 1;
        ball_x_coords = X_MAX / 2; // Inactive position
        #period;
        // score1, score2 should be 0[cite: 4, 5], increaseScore should be 00 (default) [cite: 3]
        if (score1 !== 0 || score2 !== 0 || increaseScore !== 2'b00)
            $display("Error: Reset failed. S1:%d, S2:%d, IncS:%b", score1, score2, increaseScore);
        
        reset = 0;
        #period; // Default outputs check
        if (increaseScore !== 2'b00)
             $display("Error: Default increaseScore not 00. IncS:%b", increaseScore);


        // Test case 2: Player 1 scores (ball_x_coords < X_MIN)
        // X_MIN is 0. So ball_x_coords needs to be effectively negative.
        // Since ball_x_coords is unsigned, this condition `ball_x_coords < X_MIN`
        // will only be true if X_MIN is > 0 and ball_x_coords is less than it.
        // If X_MIN = 0, then `ball_x_coords < 0` is never true for unsigned.
        // Let's assume X_MIN is intended to be the leftmost boundary, and anything less means P1 scored.
        // To test this, we'd need X_MIN to be something like 1, and ball_x_coords = 0.
        // Given `parameter int X_MIN = 0`, `ball_x_coords < X_MIN` is problematic.
        // Let's assume the intent is "ball goes off left screen".
        // If BALL_X_W is 10, max value is 1023.
        // If X_MIN is 0, `ball_x_coords < 0` is never true.
        // The Verilog code `if (ball_x_coords < X_MIN)` when X_MIN is 0 will effectively be `if (ball_x_coords < 0)`
        // For an unsigned `ball_x_coords`, this is false unless `ball_x_coords` wraps around from a subtraction.
        // The problem description for `manageScore` states:
        // `if (ball_x_coords < X_MIN) begin ... increaseScore <= 2'b01;` (P1 scores) [cite: 6, 7]
        // `else if (ball_x_coords > X_MAX) begin ... increaseScore <= 2'b10;` (P2 scores) [cite: 8]
        // Let's assume X_MIN = 10, X_MAX = 630 for more robust testing of these conditions.
        // However, the module uses X_MIN=0, X_MAX=639 by default. [cite: 1]
        // With X_MIN = 0, player 1 (score1) will *not* score via `ball_x_coords < X_MIN`.
        // This seems like a potential bug in the DUT's parameterization or logic for P1 scoring.
        // For the purpose of this testbench, I will test according to the code given.
        // So, player 1 (score1) will not increment with the current parameters via the < X_MIN condition.
        
        // Test according to code: `ball_x_coords < X_MIN` (X_MIN = 0)
        $display("Info: Testing P1 score condition with X_MIN = 0. `ball_x_coords < 0` will be false for unsigned.");
        ball_x_coords = -1; // This will wrap around to a large positive for unsigned. E.g., 10'h3FF (1023)
        #period;
        // Expected: score1 does not change, increaseScore = 00.
        if (score1 !== 0 || increaseScore !== 2'b00)
            $display("Error: P1 score (ball_x < 0) failed. S1:%d, IncS:%b", score1, increaseScore);
        
        // If we set X_MIN to a value like 10 for testing this specific branch:
        // And then set ball_x_coords = 5 (which is < 10)
        // score_inst.X_MIN = 10; // This is not how you change params in TB for instantiated module
        // You would need to instantiate with different parameters or use `defparam` if hierarchical.
        // The testbench will proceed with parameters as defined (X_MIN = 0).


        // Test case 3: Player 2 scores (ball_x_coords > X_MAX)
        ball_x_coords = X_MAX + 1; // e.g., 639 + 1 = 640
        #period;
        // score2 should be 1, increaseScore should be 10 [cite: 8]
        if (score2 !== 1 || increaseScore !== 2'b10)
            $display("Error: P2 score (ball_x > X_MAX) failed. S2:%d, IncS:%b", score2, increaseScore);
        #period; // Let score update fully, check default increaseScore
        if (increaseScore !== 2'b00) // increaseScore is set for one cycle [cite: 3]
             $display("Error: P2 score, increaseScore should revert to 00. IncS:%b", increaseScore);


        // Test case 4: Ball in play (no score change)
        ball_x_coords = X_MAX / 2; // e.g., 319 (between 0 and 639)
        #period;
        // scores should remain s1=0, s2=1, increaseScore = 00
        if (score1 !== 0 || score2 !== 1 || increaseScore !== 2'b00)
            $display("Error: Ball in play failed. S1:%d, S2:%d, IncS:%b", score1, score2, increaseScore);


        // Test case 5: Max score for Player 2
        // Set score2 to 98
        // This requires forcing or running the simulation for 97 more P2 scores.
        // For simplicity in this example, we'll assume score2 is 98.
        // We'll score one more time.
        // score_inst.score2 = 98; // Not standard for black-box. Let's simulate it.
        $display("Info: Simulating score2 incrementing to 98...");
        for (int i = 0; i < 97; i = i + 1) begin // score2 is currently 1, need 97 more.
            ball_x_coords = X_MAX + 1;
            #period; // score2 increments, increaseScore = 10
            ball_x_coords = X_MAX / 2; // move ball back in play to reset increaseScore signal for next cycle
            #period; // increaseScore = 00
        end
        // Now score2 should be 1 (initial) + 97 = 98.
        if (score2 !== 98)
            $display("Error: Failed to increment score2 to 98. S2:%d", score2);

        ball_x_coords = X_MAX + 1; // P2 scores
        #period;
        // score2 should be 99, increaseScore = 10
        if (score2 !== 99 || increaseScore !== 2'b10)
            $display("Error: P2 score to 99 failed. S2:%d, IncS:%b", score2, increaseScore);
        #period;

        // Try to score again for P2 (should not exceed 99)
        ball_x_coords = X_MAX + 1; // P2 scores
        #period;
        // score2 should remain 99, increaseScore = 10 (as per logic, score doesn't change but flag is set)
        if (score2 !== 99 || increaseScore !== 2'b10)
            $display("Error: P2 score max limit failed. S2:%d, IncS:%b", score2, increaseScore);
        #period;


        // Test case 6: Player 1 scoring up to 99 (if X_MIN were > 0)
        // As established, with X_MIN = 0, P1 (score1) doesn't score with `< X_MIN`.
        // If the design intended X_MIN to be the coordinate of the left wall (e.g. X_MIN_WALL = 10)
        // and a separate X_MIN_SCORE_LIMIT = 0, then `ball_x_coords < X_MIN_SCORE_LIMIT` would be for scoring.
        // If the module `manageScore` is updated for P1 to score (e.g. `ball_x_coords == SOME_LEFT_EDGE_VALUE`),
        // then a similar test loop for P1 reaching 99 would be added here.
        // For now, score1 remains 0.

        $stop;
    end

endmodule