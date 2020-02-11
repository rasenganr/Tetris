module convertXY(in_xy, out_x, out_y);
  input [18:0] in_xy;
  output [9:0] out_x;
  output [8:0] out_y;
  
  wire [9:0] col;
  
  assign col = 10'b1010000000;
  assign out_x = in_xy % col;
  assign out_y = in_xy / col;
endmodule
