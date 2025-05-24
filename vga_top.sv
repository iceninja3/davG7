module vga_top
    (
        input logic clk,
        input logic rstButton,

        output logic[3:0] redOut,
        output logic[3:0] greenOut,
        output logic[3:0] blueOut,
        output logic hSync,
        output logic vSync
    );

    logic vgaClk;
    logic rst;
    logic[3:0] rstValidate;
    logic[9:0] hcOut;
    logic[9:0] vcOut;
    logic[9:0] address;
    logic[7:0] color_8bit;
    logic[11:0] color_12bit;
    logic[11:0] colorOut;
	logic locked;

    always @(posedge clk)
    begin
        rstValidate <= {rstValidate[2:0], (~rstButton)};
    end

    always_comb
    begin
        if (rstValidate == 4'b1111) begin rst = 1; end
        else begin rst = 0; end
    end

    vgaclk pll
	 (
			.areset(rst),
			.inclk0(clk),
			.c0(vgaClk),
			.locked(locked)
	 );

    vga vgaInstance
    (
        .vgaclk(vgaClk), 
        .rst(rst), 
        .input_red(color_8bit[7:5]), 
        .input_green(color_8bit[4:2]), 
        .input_blue(color_8bit[1:0]), 

        .hc_out(hcOut), 
        .vc_out(vcOut), 
        .hsync(hSync), 
        .vsync(vSync), 
        .red(color_12bit[11:8]), 
        .green(color_12bit[7:4]), 
        .blue(color_12bit[3:0])
    );

    graphics_driver graphicsDriver
    (
        .hc(hcOut),
        .vc(vcOut),

        .addressOut(address),
        .color(color_8bit)
    );

	 
    double_buffer doubleBuffer
    (
        .clk(vgaClk),
        .rst(rst),
        .hc(hcOut),
        .vc(vcOut),
        .writeAddress(address),
        .colorIn(color_12bit),

        .colorOut(colorOut)
    );
		
		
    assign redOut = colorOut[11:8];
    assign greenOut = colorOut[7:4];
    assign blueOut = colorOut[3:0];


endmodule