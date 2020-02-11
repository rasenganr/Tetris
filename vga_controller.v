module vga_controller(iRST_n,
                      iVGA_CLK,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data,
							 move);

	
input iRST_n;
input iVGA_CLK;
input [3:0] move;
output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [7:0] b_data;
output [7:0] g_data;  
output [7:0] r_data;                        
///////// ////                     
reg [18:0] ADDR;
reg [23:0] bgr_data;
wire VGA_CLK_n;
wire [7:0] index;
wire [23:0] bgr_data_raw;
wire [23:0] bgr_data_square;
wire cBLANK_n,cHS,cVS,rst;
wire [9:0] x_current;
wire [8:0] y_current;
////
assign rst = ~iRST_n;
assign bgr_data_square = 24'b111111111111111111111111;
video_sync_generator LTM_ins (.vga_clk(iVGA_CLK),
                              .reset(rst),
                              .blank_n(cBLANK_n),
                              .HS(cHS),
                              .VS(cVS));
/////////////////
////Addresss generator
always@(posedge iVGA_CLK,negedge iRST_n)
begin
  if (!iRST_n)
     ADDR<=19'd0;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR<=19'd0;
  else if (cBLANK_n==1'b1)
     ADDR<=ADDR+1;
end
//////////////////////////
//////INDEX addr.
assign VGA_CLK_n = ~iVGA_CLK;
img_data	img_data_inst (
	.address ( ADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index )
	);
	
/////////////////////////
//////Add switch-input logic here
convertXY convertXY_inst (
   .in_xy(ADDR),
	.out_x(x_current),
	.out_y(y_current)
	);
///////////////
//////Check if the point is in the square
mySquare mySquare_inst (
   .ADDR(ADDR),
	.clk(iVGA_CLK),
   .x(x_current),
	.y(y_current),
	.move(move),
	.isInSquare(isInSquare)
	);
//////Color table output
img_index	img_index_inst (
	.address ( index ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw )
	);	
///////////////
//////latch valid data at falling edge;
always@(posedge VGA_CLK_n) begin
  if (isInSquare == 0) bgr_data <= bgr_data_raw;
  if (isInSquare == 1) bgr_data <= bgr_data_square;
end
assign b_data = bgr_data[23:16];
assign g_data = bgr_data[15:8];
assign r_data = bgr_data[7:0]; 
///////////////////
//////Delay the iHD, iVD,iDEN for one clock cycle;
always@(negedge iVGA_CLK)
begin
  oHS<=cHS;
  oVS<=cVS;
  oBLANK_n<=cBLANK_n;
end
//////////////////
//////
endmodule
 	















