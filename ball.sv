module ball #(parameter x_coords_width = 10,
              parameter y_coords_width = 10)
(
  input clk,
  input reset,
  input touching_paddle,
  input touching_wall,
  input [x_coords_width-1: 0] old_x,
  input [y_coords_width-1: 0] old_y,
  output logic [x_coords_width-1: 0] new_x,
  output logic [y_coords_width-1: 0] new_y
);

  reg x_speed_sign = 0; // Positive if 1, negative if zero
  reg y_speed_sign = 0; // Positive if 1, negative if zero

  always @(posedge clk) begin

    if(reset) begin
        x_speed_sign <= 0;
        y_speed_sign <= 0;
    end

    if (touching_paddle)
      x_speed_sign <= ~x_speed_sign;

    if (touching_wall)
      y_speed_sign <= ~y_speed_sign;

    if (x_speed_sign)
      new_x <= old_x + 1; // keep at one so it doesn't phase through paddle and walls during collision detection
    else
      new_x <= old_x - 1;

    if (y_speed_sign)
      new_y <= old_y + 1;
    else
      new_y <= old_y - 1;

  end
endmodule