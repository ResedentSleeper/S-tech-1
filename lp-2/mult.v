`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2021 02:09:58 PM
// Design Name: 
// Module Name: mult
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mlt(
  input clk_i,
  input rst_i,
  input [15:0] a_bi,
  input [7:0] b_bi,
  input start_i,
  output busy_o,
  output reg [23:0] y_bo 
);
  localparam IDLE = 1'b0, WORK = 1'b1;
  reg [2:0] ctr;
  wire [2:0] end_step;
  wire [7:0] part_sum;
  wire [15:0] shifted_part_sum;
  reg [7:0] a,b;
  reg [15:0] part_res;
  reg state;
  
  assign part_sum = a&{16{b[ctr]}};
  assign shifted_part_sum=part_sum<<ctr;
  assign end_step=(ctr==3’h7);
  assign busy_o=state;
  
  always @(posedge clk_i)
	if (rst_i) begin
		ctr <= 0 ;
		part_res <= 0 ;
		y_bo <= 0 ;
		state <= IDLE;
	end else begin
		case (state)
			IDLE:
				if (start_i) begin
					state <= WORK;
					a <= a_bi;
					b <= b_bi;
					ctr <= 0;
					part_res <= 0;
				end
			WORK:
				begin
					if (end_step) begin
						state <= IDLE;
						y_bo <= part_res+shifted_part_sum;
					end
					part_res <= part_res+shifted_part_sum;
					ctr <= ctr+1;
				end
		endcase
	end
endmodule
