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
//  File            : fifo_tb.v
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
`define BUF_WIDTH   4 
`define BUF_SIZE    9 
`define ALFULL_CNT  5  
`define TD          #1

module tb_fifo;

parameter WR         = 0,
          WAIT_EMPTY = 1;
reg                            clk;
reg                            rst_n;
reg [`BUF_WIDTH-1:0]           din;
wire                           wr_en;
reg                            rd_en;
wire [`BUF_WIDTH-1:0]          dout;
wire                           buf_empty;
wire                           buf_full;
wire                           alfull;

reg                            wr_en_d1;
reg                            wr_en_d2;
reg                            wr_en_d3;
reg                            wr_en_d4;
reg                            wr_en_d5;
reg                            wr_en_d6;
reg                            wr_en_d7;
reg                            wr_en_d8;
reg                            writen_flag;

reg [`BUF_WIDTH-1:0]           din_d1;
reg [`BUF_WIDTH-1:0]           din_d2;
reg [`BUF_WIDTH-1:0]           din_d3;
reg [`BUF_WIDTH-1:0]           din_d4;
reg [`BUF_WIDTH-1:0]           din_d5;
reg [`BUF_WIDTH-1:0]           din_d6;
reg [`BUF_WIDTH-1:0]           din_d7;
reg [`BUF_WIDTH-1:0]           din_d8;

reg                             wr_cs;
reg                             wr_ns;

always #5 clk = ~clk;
initial begin
    #1;
    clk   = 0;
    rst_n = 0;
    #10;
    rst_n = 1;

#2000;
    $finish;
end

initial begin
    $fsdbDumpfile("fifo.fsdb");
    $fsdbDumpvars(0,tb_fifo);
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        wr_cs <= `TD WR;     
    end
    else begin
        wr_cs <= `TD wr_ns;
    end
end
always @(*)  begin
    case(wr_cs)
        WR:begin
            if(alfull) begin
                wr_ns = WAIT_EMPTY;
            end
            else begin  
                wr_ns = WR;
            end
        end
        WAIT_EMPTY:begin
            if(!wr_en_d8 & !alfull) begin
                wr_ns = WR;
            end
            else begin  
                wr_ns = WAIT_EMPTY;
            end             
        end
    endcase 
end

assign wr_en = (wr_ns==WR);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        wr_en_d1 <= `TD 1'b0;     
        wr_en_d2 <= `TD 1'b0;     
        wr_en_d3 <= `TD 1'b0;     
        wr_en_d4 <= `TD 1'b0;     
        wr_en_d5 <= `TD 1'b0;     
        wr_en_d6 <= `TD 1'b0;     
        wr_en_d7 <= `TD 1'b0;     
        wr_en_d8 <= `TD 1'b0;     
    end
    else begin
        wr_en_d1 <= `TD wr_en;
        wr_en_d2 <= `TD wr_en_d1;
        wr_en_d3 <= `TD wr_en_d2;
        wr_en_d4 <= `TD wr_en_d3;
        wr_en_d5 <= `TD wr_en_d4;
        wr_en_d6 <= `TD wr_en_d5;
        wr_en_d7 <= `TD wr_en_d6;
        wr_en_d8 <= `TD wr_en_d7;
    end
end

always @(posedge clk or negedge rst_n) begin
   if(!rst_n) begin
       writen_flag <= `TD 1'b0;
   end
   else if(wr_en_d8) begin
       writen_flag <= `TD 1'b1;
   end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        rd_en <= `TD 1'b0;     
    end
    else if(!writen_flag) begin
        if(wr_en_d8) begin
            rd_en <= `TD 1'b1;
        end
        else begin
            rd_en <= `TD 1'b0;
        end
    end
    else begin
        rd_en <= `TD ~rd_en;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        din <= `TD $random;     
    end
    else if(wr_en)begin
        din <= `TD din + 1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        din_d1 <= `TD 'b0;     
        din_d2 <= `TD 'b0;     
        din_d3 <= `TD 'b0;     
        din_d4 <= `TD 'b0;     
        din_d5 <= `TD 'b0;     
        din_d6 <= `TD 'b0;     
        din_d7 <= `TD 'b0;     
        din_d8 <= `TD 'b0;     
    end
    else begin
        din_d1 <= `TD din;
        din_d2 <= `TD din_d1;
        din_d3 <= `TD din_d2;
        din_d4 <= `TD din_d3;
        din_d5 <= `TD din_d4;
        din_d6 <= `TD din_d5;
        din_d7 <= `TD din_d6;
        din_d8 <= `TD din_d7;
    end
end


fifo U_fifo(
     .clk (clk),
     .rst_n (rst_n),
     .din (din_d8),
     .wr_en (wr_en_d8),
 
     .rd_en (rd_en),
     .dout (dout),
     .buf_empty (buf_empty),
     .buf_full (buf_full),
     .alfull (alfull)
);  
endmodule
