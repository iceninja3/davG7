module joystickController(
    output logic i2c_scl,
    inout logic i2c_sda,
    input logic clk,
    output logic [7:0] joystick_y
);

    

    assign i2c_sda = {'hF0, 'h55, 'hFB, 'h00};
    assign i2c_scl = clk;


endmodule