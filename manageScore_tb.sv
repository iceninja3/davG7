// Testbench for the updated manageScore module
module manageScore_tb;

// Parameters for the testbench
// These should match or be compatible with the DUT's parameters
localparam BALL_X_W_TB         = 10;
localparam X_MIN_TB            = 50;  // Example value, ensure X_MIN < X_MAX
localparam X_MAX_TB            = 600; // Example value
localparam CLK_PERIOD          = 10;  // Clock period in ns
localparam MAX_SCORE_EXPECTED  = 99;

// Signals to connect to the DUT
logic clk_tb;
logic reset_tb;
logic [BALL_X_W_TB-1:0] ball_x_coords_tb;
logic [1:0] increaseScore_dut;
logic [6:0] score1_dut;
logic [6:0] score2_dut;

// Instantiate the Device Under Test (DUT)
manageScore #(
  .BALL_X_W(BALL_X_W_TB),
  .X_MIN(X_MIN_TB),
  .X_MAX(X_MAX_TB)
) dut_instance (
  .clk(clk_tb),
  .reset(reset_tb),
  .ball_x_coords(ball_x_coords_tb),
  .increaseScore(increaseScore_dut),
  .score1(score1_dut),
  .score2(score2_dut)
);

// Clock generation process
always #(CLK_PERIOD/2) clk_tb = ~clk_tb;

// Task to apply stimulus and wait for a clock edge
task apply_stimulus_and_tick(input [BALL_X_W_TB-1:0] x_coord_val, input rst_val);
  ball_x_coords_tb = x_coord_val;
  reset_tb = rst_val;
  $display("[%0t ns] Applied: reset_tb=%b, ball_x_coords_tb=%3d. Waiting for next clk edge...", $time, reset_tb, ball_x_coords_tb);
  #(CLK_PERIOD);
  $display("[%0t ns] After clk: reset_tb=%b, ball_x_coords_tb=%3d | increaseScore=%2b, score1=%d, score2=%d",
           $time, reset_tb, ball_x_coords_tb, increaseScore_dut, score1_dut, score2_dut);
endtask

// Task to check scores and increaseScore output
task check_outputs( input [1:0] exp_increase, input [6:0] exp_s1, input [6:0] exp_s2, input string context);
  if (increaseScore_dut !== exp_increase) begin
    $error("[%0t ns] %s: increaseScore FAILED. Got %2b, Expected %2b", $time, context, increaseScore_dut, exp_increase);
  end else if (score1_dut !== exp_s1) begin
    $error("[%0t ns] %s: score1 FAILED. Got %d, Expected %d", $time, context, score1_dut, exp_s1);
  end else if (score2_dut !== exp_s2) begin
    $error("[%0t ns] %s: score2 FAILED. Got %d, Expected %d", $time, context, score2_dut, exp_s2);
  end else begin
    $info("[%0t ns] %s: Outputs PASSED. increaseScore=%2b, score1=%d, score2=%d", $time, context, increaseScore_dut, score1_dut, score2_dut);
  end
endtask


// Main test sequence
initial begin
  // Initialize signals
  clk_tb = 0;
  reset_tb = 1; // Start with reset asserted
  ball_x_coords_tb = X_MIN_TB + 10; // Initial neutral value

  $display("------------------------------------------------------------------------------------");
  $display("[%0t ns] Testbench Started.", $time);
  $display("Parameters: BALL_X_W=%0d, X_MIN=%0d, X_MAX=%0d, MAX_SCORE=%0d",
           BALL_X_W_TB, X_MIN_TB, X_MAX_TB, MAX_SCORE_EXPECTED);
  $display("------------------------------------------------------------------------------------");
  
  // 1. Reset Sequence
  $display("[%0t ns] === Test Case 1: Reset Sequence ===", $time);
  apply_stimulus_and_tick(X_MIN_TB + 10, 1); // ball in neutral during reset
  check_outputs(2'b00, 0, 0, "Reset Active");
  
  apply_stimulus_and_tick(X_MIN_TB - 1, 1); // P1 score condition during reset
  check_outputs(2'b00, 0, 0, "Reset Active (P1 score condition)");

  apply_stimulus_and_tick(X_MAX_TB + 1, 1); // P2 score condition during reset
  check_outputs(2'b00, 0, 0, "Reset Active (P2 score condition)");
  
  $display("[%0t ns] De-asserting reset.", $time);
  apply_stimulus_and_tick(X_MIN_TB + 10, 0); // De-assert reset, ball in neutral
  check_outputs(2'b00, 0, 0, "Post-Reset, Neutral Ball");
  
  // 2. Test No Score (Ball in Neutral Zone)
  $display("[%0t ns] === Test Case 2: Ball in Neutral Zone (No Score) ===", $time);
  apply_stimulus_and_tick(X_MIN_TB, 0); // Exactly at X_MIN
  check_outputs(2'b00, 0, 0, "Ball at X_MIN");
  apply_stimulus_and_tick(X_MAX_TB, 0); // Exactly at X_MAX
  check_outputs(2'b00, 0, 0, "Ball at X_MAX");
  apply_stimulus_and_tick((X_MIN_TB + X_MAX_TB) / 2, 0); // Middle of neutral zone
  check_outputs(2'b00, 0, 0, "Ball in Middle");

  // 3. Test Player 1 Scores
  $display("[%0t ns] === Test Case 3: Player 1 Scores ===", $time);
  apply_stimulus_and_tick(X_MIN_TB - 1, 0); // P1 scores
  check_outputs(2'b01, 1, 0, "P1 Score 1");
  apply_stimulus_and_tick(X_MIN_TB - 10, 0); // P1 scores again
  check_outputs(2'b01, 2, 0, "P1 Score 2");
  apply_stimulus_and_tick(0, 0); // P1 scores (far left)
  check_outputs(2'b01, 3, 0, "P1 Score 3 (Far Left)");
  // Back to neutral
  apply_stimulus_and_tick(X_MIN_TB + 5, 0);
  check_outputs(2'b00, 3, 0, "P1 Back to Neutral");


  // 4. Test Player 2 Scores
  $display("[%0t ns] === Test Case 4: Player 2 Scores ===", $time);
  apply_stimulus_and_tick(X_MAX_TB + 1, 0); // P2 scores
  check_outputs(2'b10, 3, 1, "P2 Score 1");
  apply_stimulus_and_tick(X_MAX_TB + 10, 0); // P2 scores again
  check_outputs(2'b10, 3, 2, "P2 Score 2");
  apply_stimulus_and_tick(BALL_X_W_TB'( (1<<BALL_X_W_TB) -1 ), 0); // P2 scores (far right)
  check_outputs(2'b10, 3, 3, "P2 Score 3 (Far Right)");
  // Back to neutral
  apply_stimulus_and_tick(X_MAX_TB - 5, 0);
  check_outputs(2'b00, 3, 3, "P2 Back to Neutral");

  // 5. Test Score Capping at MAX_SCORE_EXPECTED (99) for Player 1
  $display("[%0t ns] === Test Case 5: Player 1 Score Capping at %0d ===", $time, MAX_SCORE_EXPECTED);
  // Reset scores first
  apply_stimulus_and_tick(X_MIN_TB + 10, 1); // Assert reset
  check_outputs(2'b00, 0, 0, "Reset for P1 Cap Test");
  apply_stimulus_and_tick(X_MIN_TB + 10, 0); // De-assert reset
  check_outputs(2'b00, 0, 0, "Post-Reset for P1 Cap Test");

  for (int i = 1; i <= MAX_SCORE_EXPECTED + 2; i++) begin
    apply_stimulus_and_tick(X_MIN_TB - 1, 0); // P1 scores
    if (i < MAX_SCORE_EXPECTED) begin
      check_outputs(2'b01, i, 0, $sformatf("P1 Score %0d (towards cap)", i));
    end else if (i == MAX_SCORE_EXPECTED) begin
      check_outputs(2'b01, MAX_SCORE_EXPECTED, 0, $sformatf("P1 Score %0d (hit cap)", MAX_SCORE_EXPECTED));
    end else begin // i > MAX_SCORE_EXPECTED
      check_outputs(2'b01, MAX_SCORE_EXPECTED, 0, $sformatf("P1 Score Attempt %0d (at cap)", i));
    end
  end
  apply_stimulus_and_tick(X_MIN_TB + 10, 0); // Neutral
  check_outputs(2'b00, MAX_SCORE_EXPECTED, 0, "P1 Cap Test - Neutral");


  // 6. Test Score Capping at MAX_SCORE_EXPECTED (99) for Player 2
  $display("[%0t ns] === Test Case 6: Player 2 Score Capping at %0d ===", $time, MAX_SCORE_EXPECTED);
  // Reset scores first
  apply_stimulus_and_tick(X_MIN_TB + 10, 1); // Assert reset
  check_outputs(2'b00, 0, 0, "Reset for P2 Cap Test");
  apply_stimulus_and_tick(X_MIN_TB + 10, 0); // De-assert reset
  check_outputs(2'b00, 0, 0, "Post-Reset for P2 Cap Test");

  for (int i = 1; i <= MAX_SCORE_EXPECTED + 2; i++) begin
    apply_stimulus_and_tick(X_MAX_TB + 1, 0); // P2 scores
    if (i < MAX_SCORE_EXPECTED) begin
      check_outputs(2'b10, 0, i, $sformatf("P2 Score %0d (towards cap)", i));
    end else if (i == MAX_SCORE_EXPECTED) begin
      check_outputs(2'b10, 0, MAX_SCORE_EXPECTED, $sformatf("P2 Score %0d (hit cap)", MAX_SCORE_EXPECTED));
    end else begin // i > MAX_SCORE_EXPECTED
      check_outputs(2'b10, 0, MAX_SCORE_EXPECTED, $sformatf("P2 Score Attempt %0d (at cap)", i));
    end
  end
  apply_stimulus_and_tick(X_MIN_TB + 10, 0); // Neutral
  check_outputs(2'b00, 0, MAX_SCORE_EXPECTED, "P2 Cap Test - Neutral");

  // 7. Alternating Scores
  $display("[%0t ns] === Test Case 7: Alternating Scores ===", $time);
  apply_stimulus_and_tick(X_MIN_TB + 10, 1); // Reset
  apply_stimulus_and_tick(X_MIN_TB + 10, 0); // Release Reset
  check_outputs(2'b00, 0, 0, "Alternating - Initial");

  apply_stimulus_and_tick(X_MIN_TB - 1, 0); // P1 scores
  check_outputs(2'b01, 1, 0, "Alternating - P1 scores (1,0)");
  apply_stimulus_and_tick(X_MAX_TB + 1, 0); // P2 scores
  check_outputs(2'b10, 1, 1, "Alternating - P2 scores (1,1)");
  apply_stimulus_and_tick(X_MIN_TB - 1, 0); // P1 scores
  check_outputs(2'b01, 2, 1, "Alternating - P1 scores (2,1)");
  apply_stimulus_and_tick(X_MAX_TB + 1, 0); // P2 scores
  check_outputs(2'b10, 2, 2, "Alternating - P2 scores (2,2)");
  apply_stimulus_and_tick(X_MIN_TB + 10, 0); // Neutral
  check_outputs(2'b00, 2, 2, "Alternating - Neutral (2,2)");


  $display("------------------------------------------------------------------------------------");
  $display("[%0t ns] Test sequence finished.", $time);
  $finish;
end

endmodule
