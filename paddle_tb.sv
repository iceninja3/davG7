// Testbench for the modified paddle module with 2-bit button input
module paddle_tb;

// Parameters for the testbench
localparam YBIT_WIDTH = 8;          // Width for yPos, e.g., 8 for [8:0] (0-511)
localparam DY_VAL = 10;             // Step size for paddle movement (magnitude)
localparam TOP_BOUNDARY_VAL = 395;  // Example top boundary
localparam BOTTOM_BOUNDARY_VAL = 50; // Example bottom boundary
localparam CLK_PERIOD = 10;         // Clock period in ns

// Expected reset position from DUT (hardcoded in DUT as 240)
localparam INITIAL_YPOS_EXPECTED = 240; 

// Signals to connect to the DUT
logic clk;
logic rst_dut;                      // Renamed to avoid conflict
logic [1:0] btn_dut;                // 2-bit button input for DUT
logic xPos_dut;                     // 1-bit xPos input for DUT (unused in DUT's yPos logic)
logic [YBIT_WIDTH:0] yPos_dut;      // Output from DUT

// Instantiate the Device Under Test (DUT)
// IMPORTANT: Assumes DUT has syntax corrections:
// - `always_ff @(posedge clk)` (not `ck`)
// - `if(rst)` (not `reset`) inside the always_ff block
paddle #(
  .DY(DY_VAL), // DY is now the magnitude
  .TOP_BOUNDARY(TOP_BOUNDARY_VAL),
  .BOTTOM_BOUNDARY(BOTTOM_BOUNDARY_VAL),
  .YBIT_WIDTH(YBIT_WIDTH)
) dut_instance (
  .clk(clk),
  .rst(rst_dut), // Connects to DUT's 'rst' input
  .btn(btn_dut),
  .xPos(xPos_dut),
  .yPos(yPos_dut)
);

// Clock generation process
always #(CLK_PERIOD/2) clk = ~clk;

// Task to apply stimulus and wait for a clock edge
task apply_stimulus_and_tick(input logic [1:0] btn_val, input logic rst_val);
  btn_dut = btn_val;
  rst_dut = rst_val;
  $display("[%0t ns] Applied: rst_dut=%b, btn_dut=%2b. Waiting for next clk edge...", $time, rst_dut, btn_dut);
  #(CLK_PERIOD);
  $display("[%0t ns] After clk: rst_dut=%b, btn_dut=%2b, yPos_dut=%3d", $time, rst_dut, btn_dut, yPos_dut);
endtask

// Main test sequence
initial begin
  // Initialize signals
  clk = 0;
  rst_dut = 1; // Start with reset asserted
  btn_dut = 2'b00; 
  xPos_dut = 0; // Arbitrary value for unused xPos input

  $display("------------------------------------------------------------------");
  $display("[%0t ns] Testbench Started.", $time);
  $display("Parameters: DY_VAL=%0d, TOP_BOUNDARY=%0d, BOTTOM_BOUNDARY=%0d, YBIT_WIDTH=%0d",
           DY_VAL, TOP_BOUNDARY_VAL, BOTTOM_BOUNDARY_VAL, YBIT_WIDTH);
  $display("DUT yPos is expected to reset to %0d.", INITIAL_YPOS_EXPECTED);
  $display("IMPORTANT DUT NOTE: Ensure 'if(reset)' in your DUT is changed to 'if(rst_dut)' or 'if(rst)' to match port name.");
  $display("IMPORTANT DUT NOTE: For btn=2'b10 (2), DUT logic is 'yPos <= yPos - btn*DY', which means 'yPos - 2*DY'. Movement will be 2*DY_VAL.");
  $display("------------------------------------------------------------------");
  
  // 1. Reset Sequence
  $display("[%0t ns] Asserting reset.", $time);
  apply_stimulus_and_tick(2'b00, 1); // btn=00 during reset
  apply_stimulus_and_tick(2'b00, 1); // Hold reset
  
  $display("[%0t ns] De-asserting reset.", $time);
  apply_stimulus_and_tick(2'b00, 0); // De-assert reset, btn=00

  if (yPos_dut !== INITIAL_YPOS_EXPECTED) begin
    $error("[%0t ns] RESET FAILED: yPos_dut is %d, expected %d.", $time, yPos_dut, INITIAL_YPOS_EXPECTED);
  end else begin
    $info("[%0t ns] RESET PASSED: yPos_dut is %d.", $time, yPos_dut);
  end
  
  // 2. Test No Button Press (btn = 2'b00)
  $display("[%0t ns] Testing no button press (btn_dut=2'b00). yPos_dut should remain %d.", $time, yPos_dut);
  logic [YBIT_WIDTH:0] yPos_before_nobtn = yPos_dut;
  apply_stimulus_and_tick(2'b00, 0);
  apply_stimulus_and_tick(2'b00, 0);
  if (yPos_dut !== yPos_before_nobtn) begin
    $error("[%0t ns] NO BUTTON PRESS (00) FAILED: yPos_dut changed to %d, expected %d.", $time, yPos_dut, yPos_before_nobtn);
  end else begin
    $info("[%0t ns] NO BUTTON PRESS (00) PASSED: yPos_dut remained %d.", $time, yPos_dut);
  end

  // 3. Test Button '1' (btn = 2'b01) - Move UP by DY_VAL
  $display("[%0t ns] Testing btn_dut=2'b01 (UP). Expect yPos + %0d.", $time, DY_VAL);
  yPos_before_nobtn = yPos_dut;
  apply_stimulus_and_tick(2'b01, 0); 
  if (yPos_dut !== yPos_before_nobtn + DY_VAL) begin
      $error("[%0t ns] BTN=01 (UP) FAILED: yPos_dut is %d, expected %d + %d = %d.", 
             $time, yPos_dut, yPos_before_nobtn, DY_VAL, yPos_before_nobtn + DY_VAL);
  end else begin
      $info("[%0t ns] BTN=01 (UP) PASSED: yPos_dut is %d.", $time, yPos_dut);
  end
  apply_stimulus_and_tick(2'b00, 0); // Release button

  // 4. Test Button '2' (btn = 2'b10) - Move DOWN by 2*DY_VAL (due to DUT's btn*DY logic)
  localparam MOVE_DOWN_STEP = 2 * DY_VAL;
  $display("[%0t ns] Testing btn_dut=2'b10 (DOWN). Expect yPos - %0d (2*DY_VAL due to DUT logic 'yPos - btn*DY').", $time, MOVE_DOWN_STEP);
  yPos_before_nobtn = yPos_dut;
  apply_stimulus_and_tick(2'b10, 0); 
  if (yPos_dut !== yPos_before_nobtn - MOVE_DOWN_STEP) begin
      $error("[%0t ns] BTN=10 (DOWN) FAILED: yPos_dut is %d, expected %d - %d = %d.", 
             $time, yPos_dut, yPos_before_nobtn, MOVE_DOWN_STEP, yPos_before_nobtn - MOVE_DOWN_STEP);
  end else begin
      $info("[%0t ns] BTN=10 (DOWN) PASSED: yPos_dut is %d.", $time, yPos_dut);
  end
  apply_stimulus_and_tick(2'b00, 0); // Release button

  // 5. Test Button '3' (btn = 2'b11) - No Move Expected
  $display("[%0t ns] Testing btn_dut=2'b11 (INVALID). Expect no move. yPos_dut should remain %d.", $time, yPos_dut);
  yPos_before_nobtn = yPos_dut;
  apply_stimulus_and_tick(2'b11, 0);
  if (yPos_dut !== yPos_before_nobtn) begin
    $error("[%0t ns] BTN=11 (INVALID) FAILED: yPos_dut changed to %d, expected %d.", $time, yPos_dut, yPos_before_nobtn);
  end else begin
    $info("[%0t ns] BTN=11 (INVALID) PASSED: yPos_dut remained %d.", $time, yPos_dut);
  end
  apply_stimulus_and_tick(2'b00, 0); // Release button

  // 6. Move UP to TOP_BOUNDARY
  $display("[%0t ns] Moving UP towards TOP_BOUNDARY (%d). Current yPos_dut: %d", $time, TOP_BOUNDARY_VAL, yPos_dut);
  // Reset to a known position closer to boundary to speed up test
  apply_stimulus_and_tick(2'b00, 1); // Assert reset
  apply_stimulus_and_tick(2'b00, 0); // De-assert reset (yPos_dut is INITIAL_YPOS_EXPECTED)
  
  // Manually set yPos_dut to a value close to TOP_BOUNDARY for testing boundary conditions
  // This is a testbench shortcut; in real hardware, it would move step-by-step.
  // We will simulate step-by-step from a closer point.
  yPos_dut = TOP_BOUNDARY_VAL - (2 * DY_VAL) - (DY_VAL/2) ; // e.g., 395 - 20 - 5 = 370
  $display("[%0t ns] Testbench manually set yPos_dut to %d for boundary test.", $time, yPos_dut);
  // Simulate the DUT having this value by not resetting and just proceeding
  // Note: The DUT's internal yPos will be what it is. This TB yPos_dut is just for expectation setting.
  // For a true test, we'd clock it up. Let's do that.
  // Reset again to ensure DUT internal state is known.
  apply_stimulus_and_tick(2'b00, 1); 
  apply_stimulus_and_tick(2'b00, 0); // yPos_dut is INITIAL_YPOS_EXPECTED (240)

  $display("[%0t ns] Moving UP from %d to TOP_BOUNDARY (%d) with btn=2'b01 (step %d)", $time, yPos_dut, TOP_BOUNDARY_VAL, DY_VAL);
  for (int i = 0; i < 30; i++) begin // Limit iterations
      if (yPos_dut >= TOP_BOUNDARY_VAL) break;
      yPos_before_nobtn = yPos_dut;
      apply_stimulus_and_tick(2'b01, 0); // Move UP
      if (yPos_dut == yPos_before_nobtn + DY_VAL) begin
          $info("[%0t ns] Moved UP to %d", $time, yPos_dut);
      } else if (yPos_dut == TOP_BOUNDARY_VAL && yPos_before_nobtn < TOP_BOUNDARY_VAL) {
           $info("[%0t ns] Moved UP and hit TOP_BOUNDARY %d exactly.", $time, yPos_dut);
      } else if (yPos_dut > TOP_BOUNDARY_VAL && yPos_before_nobtn < TOP_BOUNDARY_VAL) {
           $warning("[%0t ns] Moved UP and OVERSHOT TOP_BOUNDARY. yPos_dut=%d, Prev=%d, Boundary=%d", $time, yPos_dut, yPos_before_nobtn, TOP_BOUNDARY_VAL);
      } else if (yPos_dut == yPos_before_nobtn && yPos_dut == TOP_BOUNDARY_VAL) {
           $info("[%0t ns] At TOP_BOUNDARY (%d), did not move further up.", $time, yPos_dut);
           break;
      } else {
          $error("[%0t ns] Unexpected UP movement: yPos_dut=%d, Prev=%d", $time, yPos_dut, yPos_before_nobtn);
          break;
      }
  }
  apply_stimulus_and_tick(2'b00, 0); // Release button

  // 6.1 Test trying to move UP when AT TOP_BOUNDARY
  if (yPos_dut == TOP_BOUNDARY_VAL) {
      $display("[%0t ns] At TOP_BOUNDARY (%d). Trying to move UP (btn=2'b01). Expect no change.", $time, yPos_dut);
      yPos_before_nobtn = yPos_dut;
      apply_stimulus_and_tick(2'b01, 0);
      if (yPos_dut !== yPos_before_nobtn) {
          $error("[%0t ns] AT TOP_BOUNDARY, MOVE UP FAILED: yPos_dut changed to %d.", $time, yPos_dut);
      } else {
          $info("[%0t ns] AT TOP_BOUNDARY, MOVE UP PASSED: yPos_dut remained %d.", $time, yPos_dut);
      }
      apply_stimulus_and_tick(2'b00, 0);
  } else {
      $warning("[%0t ns] Did not reach TOP_BOUNDARY exactly to test upward boundary lock. yPos_dut is %d", $time, yPos_dut);
  }


  // 7. Move DOWN to BOTTOM_BOUNDARY
  $display("[%0t ns] Moving DOWN towards BOTTOM_BOUNDARY (%d). Current yPos_dut: %d", $time, BOTTOM_BOUNDARY_VAL, yPos_dut);
  // Reset to a known position closer to boundary to speed up test
  apply_stimulus_and_tick(2'b00, 1); // Assert reset
  apply_stimulus_and_tick(2'b00, 0); // De-assert reset (yPos_dut is INITIAL_YPOS_EXPECTED)

  $display("[%0t ns] Moving DOWN from %d to BOTTOM_BOUNDARY (%d) with btn=2'b10 (step -%d)", $time, yPos_dut, BOTTOM_BOUNDARY_VAL, MOVE_DOWN_STEP);
  for (int i = 0; i < 30; i++) begin // Limit iterations
      if (yPos_dut <= BOTTOM_BOUNDARY_VAL) break;
      yPos_before_nobtn = yPos_dut;
      apply_stimulus_and_tick(2'b10, 0); // Move DOWN
      if (yPos_dut == yPos_before_nobtn - MOVE_DOWN_STEP) begin
          $info("[%0t ns] Moved DOWN to %d", $time, yPos_dut);
      } else if (yPos_dut == BOTTOM_BOUNDARY_VAL && yPos_before_nobtn > BOTTOM_BOUNDARY_VAL) {
           $info("[%0t ns] Moved DOWN and hit BOTTOM_BOUNDARY %d exactly.", $time, yPos_dut);
      } else if (yPos_dut < BOTTOM_BOUNDARY_VAL && yPos_before_nobtn > BOTTOM_BOUNDARY_VAL) {
           $warning("[%0t ns] Moved DOWN and OVERSHOT BOTTOM_BOUNDARY. yPos_dut=%d, Prev=%d, Boundary=%d", $time, yPos_dut, yPos_before_nobtn, BOTTOM_BOUNDARY_VAL);
      } else if (yPos_dut == yPos_before_nobtn && yPos_dut == BOTTOM_BOUNDARY_VAL) {
           $info("[%0t ns] At BOTTOM_BOUNDARY (%d), did not move further down.", $time, yPos_dut);
           break;
      } else {
          $error("[%0t ns] Unexpected DOWN movement: yPos_dut=%d, Prev=%d", $time, yPos_dut, yPos_before_nobtn);
          break;
      }
  }
  apply_stimulus_and_tick(2'b00, 0); // Release button

  // 7.1 Test trying to move DOWN when AT BOTTOM_BOUNDARY
  if (yPos_dut == BOTTOM_BOUNDARY_VAL) {
      $display("[%0t ns] At BOTTOM_BOUNDARY (%d). Trying to move DOWN (btn=2'b10). Expect no change.", $time, yPos_dut);
      yPos_before_nobtn = yPos_dut;
      apply_stimulus_and_tick(2'b10, 0);
      if (yPos_dut !== yPos_before_nobtn) {
          $error("[%0t ns] AT BOTTOM_BOUNDARY, MOVE DOWN FAILED: yPos_dut changed to %d.", $time, yPos_dut);
      } else {
          $info("[%0t ns] AT BOTTOM_BOUNDARY, MOVE DOWN PASSED: yPos_dut remained %d.", $time, yPos_dut);
      }
      apply_stimulus_and_tick(2'b00, 0);
  } else {
      $warning("[%0t ns] Did not reach BOTTOM_BOUNDARY exactly to test downward boundary lock. yPos_dut is %d", $time, yPos_dut);
  }

  $display("------------------------------------------------------------------");
  $display("[%0t ns] Test sequence finished.", $time);
  $finish;
end

endmodule