module pongClockDivider
(
    input logic clk,
    input logic rst,

    output logic outClk
);

logic[1:0] counter;

initial
begin
    counter = 2'b0;
end

always @(posedge clk)
begin
    counter <= counter + 1;
end

assign outClk = counter[1];
endmodule