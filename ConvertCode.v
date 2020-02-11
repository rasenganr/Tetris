module ConvertCode (in, out);
  input [7:0] in;
  output reg [7:0] out;
  
  always@(*) begin
    case(in)
      8'h23 : out <= 8'h64;
	   8'h2d : out <= 8'h72;
	   8'h24 : out <= 8'h65;
	   8'h1d : out <= 8'h77;
		default: out <= in;
	 endcase
  end
endmodule
