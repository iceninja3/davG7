module double_buffer
    (
        input logic clk,
        input logic rst,
        input logic[9:0] hc,
        input logic[9:0] vc, 
        input logic[9:0] writeAddress,
        input logic[11:0] colorIn,

        output logic[11:0] colorOut
    );

    localparam HPIXELS = 640;
    localparam VPIXELS = 480;
    localparam BLOCKING_FACTOR = 20;
    localparam hMaxPixel = (HPIXELS / BLOCKING_FACTOR) - 1;
    localparam vMaxPixel = (VPIXELS / BLOCKING_FACTOR) - 1;

    reg[11:0] RAM [1:0][hMaxPixel:0][vMaxPixel:0];
    reg readRam;

    always @(posedge clk)
    begin
        if (rst) begin readRam <= 0; end
        else if ((hc == 0) & (vc == 0)) begin readRam <= (~readRam); end
        else begin readRam <= readRam; end
		  
		  RAM[~readRam][hc / BLOCKING_FACTOR][vc / BLOCKING_FACTOR] <= colorIn;
		  colorOut <= RAM[readRam][hc / BLOCKING_FACTOR][vc / BLOCKING_FACTOR];
    end

	 /*
    always_comb
    begin
        RAM[(~readRam)][hc / BLOCKING_FACTOR][vc / BLOCKING_FACTOR] = colorIn;
        colorOut = RAM [readRam][hc / BLOCKING_FACTOR][vc / BLOCKING_FACTOR];
    end*/
	 

endmodule