module pongVga
  (
    // incoming clock signal - 25 MHz
    input vgaclk,
    // incoming reset signal - driven by shift register in top level
    input rst,

    // 8-bit color allocates 3 bits for red, 3 for green, 2 for blue
    input [2:0] input_red,
    input [2:0] input_green,
    input [1:0] input_blue,

    // output horizontal and vertical counters for communication with graphics module
    output logic [9:0] hc_out,
    output logic [9:0] vc_out,

    // VGA outputs
    output logic hsync,
    output logic vsync,
    // expects 12 bits for color
    output logic [3:0] red,
    output logic [3:0] green,
    output logic [3:0] blue
  );

  /*  TODO(1): VGA protocol constants
         Fill out the constants below with the correct values. 
         You can find these described in the VGA specification for a 640x480 display.
  */
  localparam HPIXELS  = 640;    // number of visible pixels per horizontal line
  localparam HFP      = 16;    // length (in pixels) of horizontal front porch
  localparam HSPULSE  = 96;    // length (in pixels) of hsync pulse
  localparam HBP      = 48;    // length (in pixels) of horizontal back porch

  localparam VPIXELS  = 480;    // number of visible horizontal lines per frame
  localparam VFP      = 10;    // length (in pixels) of vertical front porch
  localparam VSPULSE  = 2;    // length (in pixels) of vsync pulse
  localparam VBP      = 33;    // length (in pixels) of vertical back porch

  /* no need to mess with this -- this is a basic sanity check that will
   * cause the compiler to yell at you if the values above don't add up
   */
  initial
  begin
    if (HPIXELS + HFP + HSPULSE + HBP != 800 || VPIXELS + VFP + VSPULSE + VBP != 525)
    begin
      $error("Expected horizontal pixels to add up to 800 and vertical pixels to add up to 525");
    end
  end

  /* these registers are for storing the horizontal & vertical counters
      we're outputting the counter values from this module so that 
             other modules can stay in sync with the VGA
      (it's a surprise tool that will help us later!)
   */
  logic [9:0] hc;
  logic [9:0] vc;

  /*initial
  begin
    hc = 10'b0;
    vc = 10'b0;
  end*/

  assign hc_out = hc;
  assign vc_out = vc;

  // in the sequential block, we update hc and vc based on their current values
  always_ff @(posedge vgaclk)
  begin
    /* TODO(2): update the counters, paying careful attention to
              a) the reset condition, and
              b) the conditions that cause hc and vc to go back to 0
    */
	if (rst)
	begin
		hc <= 0;
		vc <= 0;
	end
	else if ((hc >= (HPIXELS + HFP + HSPULSE + HBP - 1)) & (vc >= (VPIXELS + VFP + VSPULSE + VBP - 1)))
	begin
		hc <= 0;
		vc <= 0;
	end
	else if (hc >= (HPIXELS + HFP + HSPULSE + HBP - 1))
	begin
		hc <= 0;
		vc <= vc + 1;
	end
	else
	begin
		hc <= hc + 1;
		vc <= vc;
	end
  end

  /* TODO(3): when should hsync and vsync go low?
  */
  assign hsync = ~(((hc - HPIXELS) >= HFP) && ((hc - (HPIXELS + HFP)) < HSPULSE));
  assign vsync = ~(((vc - VPIXELS) >= VFP) && ((vc - (VPIXELS + VFP)) < VSPULSE));

  // in the combinational block, we set red, green, blue outputs
  always_comb
  begin
    /*  TODO(4): check if we're within the active video range;
            if we are, drive the RGB outputs with the input color values
            if not, we're in the blanking interval, so set them all to 0
        NOTE: our inputs are fewer bits than the outputs, so left-shift accordingly!
    */
    if (((hc < (HPIXELS))) && (vc < (VPIXELS)))
    begin
        red = {input_red, 1'b0};
        green = {input_green, 1'b0};
        blue = {input_blue, 2'b00};
    end
    else
    begin
        red = 0;
        green = 0;
        blue = 0;
    end
  end

endmodule
