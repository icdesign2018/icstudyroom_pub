//  ---------------------------------------------------------------------------
//                    Copyright Message
//  ---------------------------------------------------------------------------
//
//  Icstudyroom confidential and proprietary.
//  COPYRIGHT (c) 2019 by Icstduyroom. 
//
//  All rights are reserved. Reproduction in whole or in part is
//  prohibited without the written consent of the copyright owner.
//
//
//  ----------------------------------------------------------------------------
//                    Design Information
//  ----------------------------------------------------------------------------
//
//  File            : fifo.v
//
//  Author          : qidianbanche
//
//  Organisation    : Icstudyroom
//
//  Project         : fifo_sync
//
//  Description     : 
//
//  ----------------------------------------------------------------------------
 
module fifo(
	input                       clk,
  input                       rst_n,
	input                       wr_en,
  input                       rd_en,
	input      [`BUF_WIDTH-1:0] din,             
	output reg [`BUF_WIDTH-1:0] dout,       
	output                      buf_empty,
  output                      buf_full,   
	output reg [`BUF_WIDTH-1:0] fifo_cnt,  
	output                      alfull
  );	


	reg [`BUF_SIZE:0] rd_ptr;
  reg [`BUF_SIZE:0] wr_ptr;  //
	reg [7:0]         buf_mem[0:`BUF_SIZE-1];
	
	
	assign buf_empty = (fifo_cnt == 0);  //
	assign buf_full  = (fifo_cnt == `BUF_SIZE);
  assign alfull    = (fifo_cnt >= `ALFULL_CNT);
	
	always @(posedge clk or negedge rst_n)begin
		  if(!rst_n)
		  	  fifo_cnt <= `TD 0;
		  else if((!buf_full&&wr_en)&&(!buf_empty&&rd_en)) 
		  	  fifo_cnt <= `TD fifo_cnt;
		  else if(!buf_full && wr_en)          
		  	  fifo_cnt <= `TD fifo_cnt + 1;
		  else if(!buf_empty && rd_en)         
		  	  fifo_cnt <= `TD fifo_cnt-1;
		  else 
		  	  fifo_cnt <= `TD fifo_cnt;
	end
	
	always @(posedge clk or negedge rst_n) begin   
		  if(!rst_n)
			    dout <= `TD 0;
		  else if(rd_en && !buf_empty)
			   dout <= `TD buf_mem[rd_ptr];
	end
	
	always @(posedge clk) begin
	  	if(wr_en && !buf_full)
		    	buf_mem[wr_ptr] <= `TD din;
	end
	
	always @(posedge clk or negedge rst_n) begin
	  	if(!rst_n) begin
			    wr_ptr <= `TD 0;
			    rd_ptr <= `TD 0;
	   	end
		  else begin
			   if(!buf_full && wr_en)
             if(wr_ptr==`BUF_SIZE-1)
                 wr_ptr <= `TD 0;
             else 
			          	wr_ptr <= `TD wr_ptr + 1;
			   if(!buf_empty && rd_en)
             if(rd_ptr==`BUF_SIZE-1)
                 rd_ptr <= `TD 0;
             else 
			         	rd_ptr <= `TD rd_ptr + 1;
		 end
	end
	
endmodule
