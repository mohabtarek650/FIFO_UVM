////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(arb_if.DUT inter);

localparam max_fifo_addr = $clog2(inter.FIFO_DEPTH);

logic [inter.FIFO_WIDTH-1:0] mem [inter.FIFO_DEPTH-1:0];
logic [max_fifo_addr-1:0] wr_ptr, rd_ptr;
logic [max_fifo_addr:0] count;

always @(posedge inter.clk or negedge inter.rst_n) begin
	if (!inter.rst_n) begin
		wr_ptr <= 0;
		inter.overflow <= 0; //modefied
		inter.wr_ack <= 0;   //modefied
	end
	else if ( inter.wr_en && count < inter.FIFO_DEPTH) begin
		mem[wr_ptr] <=  inter.data_in;
		 inter.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		inter.overflow <= 0; //modefied
	end
	else begin 
		inter.wr_ack <= 0; 
		if (inter.wr_en && inter.full) 
		inter.overflow <= 1; 
		else
		inter.overflow <= 0; 
	end
end

always @(posedge inter.clk or negedge inter.rst_n) begin
	if (!inter.rst_n) begin
		rd_ptr <= 0;
		inter.underflow <= 0; 
	end
	else if (inter.rd_en && count != 0) begin
		inter.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		inter.underflow <= 0;           //modefied
	end else begin                     //modefied
	if (inter.rd_en && inter.empty)   //modefied
		inter.underflow <= 1;        //modefied
		else                         //modefied
		inter.underflow <= 0;       //modefied
	end
end

always @(posedge inter.clk or negedge inter.rst_n) begin
	if (!inter.rst_n) begin
		count <= 0;
	end
	else begin 
	  if(inter.rd_en && inter.empty&& inter.wr_en)             //modefied
			count <= count + 1;
		else if (inter.rd_en && inter.full && inter.wr_en)   //modefied
			count <= count - 1;
        else if( ({inter.wr_en, inter.rd_en} == 2'b10) && !inter.full) 
			count <= count + 1;
		else if ( ({inter.wr_en,inter.rd_en} == 2'b01) && !inter.empty)
			count <= count - 1;
                
	end
end

assign  inter.full = (count == inter.FIFO_DEPTH)? 1 : 0;
assign  inter.empty = (count == 0)? 1 : 0;
assign  inter.almostfull = (count ==inter.FIFO_DEPTH-1)? 1 : 0; 
assign  inter.almostempty = (count == 1)? 1 : 0;

endmodule