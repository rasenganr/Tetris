module mySquare(ADDR, clk, x, y, move, isInSquare);
  input [9:0] x;
  input [8:0] y;
  input [3:0] move;
  input [18:0] ADDR;
  input clk;
  output reg isInSquare;
  
  reg [9:0] x_square;
  reg [8:0] y_square;
  reg clk_move;
  
  integer i;
  
  initial begin
    x_square <= 10'b0101000000;
	 y_square <= 9'b011110000;
	 i = 0;
	 clk_move <= 0;
  end
  
  always @(posedge clk) begin
    if (i < 100000) i = i + 1;
	 else begin
	   i = 0;
		clk_move = ~clk_move;
	 end
  end
  
  always @(posedge clk_move) begin
    if (move[0] == 0 && x_square > 10'b0000011001)
		x_square <= x_square - 1;
	 if (move[1] == 0 && x_square < 10'b1010000000 - 10'b0000011001)
		x_square <= x_square + 1;
	 if (move[2] == 0 && y_square > 9'b000011001)
		y_square <= y_square - 1;
	 if (move[3] == 0 && y_square < 9'b111100000 - 9'b000011001)
		y_square <= y_square + 1;
  end
  
  always @(ADDR) begin
    if ((x > x_square - 10'b0000011001) && (x < x_square + 10'b0000011001) && (y > y_square - 9'b000011001) && (y < y_square + 9'b000011001))
	   isInSquare <= 1'b1;
	 else
	   isInSquare <= 1'b0;
  end
endmodule
