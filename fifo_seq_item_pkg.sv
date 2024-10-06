package fifo_seq_item_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

class fifo_seq_item extends uvm_sequence_item;
`uvm_object_utils(fifo_seq_item)

parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
rand bit [FIFO_WIDTH-1:0] data_in;
rand bit rst_n, wr_en, rd_en;
bit [FIFO_WIDTH-1:0] data_out;
bit wr_ack, overflow;
bit full, empty, almostfull, almostempty, underflow;
bit clk;

function new(string name ="fifo_seq_item");
super.new(name);
endfunction


function string convert2string(); 
return $sformatf("%s rst_n = 0b%0b,data_in = 0b%0b, wr_en = 0b%0b, rd_en = 0b%0b, data_out = 0b%0b, wr_ack = 0b%0b , overflow = 0b%0b, full = 0b%0b, empty = 0b%0b, almostfull = 0b%0b, almostempty = 0b%0b, underflow = 0b%0b",super.convert2string, rst_n,data_in, wr_en, rd_en, data_out, wr_ack,overflow,full,empty,almostfull,almostempty,underflow);
endfunction


function string convert2string_stimulus(); 
return $sformatf("rst_n = 0b%0b,data_in = 0b%0b, wr_en = 0b%0b, rd_en = 0b%0b, data_out = 0b%0b, wr_ack = 0b%0b , overflow = 0b%0b, full = 0b%0b, empty = 0b%0b, almostfull = 0b%0b, almostempty = 0b%0b, underflow = 0b%0b", rst_n,data_in, wr_en, rd_en, data_out, wr_ack,overflow,full,empty,almostfull,almostempty,underflow);
endfunction

////////////////////////////////

constraint trans {
rst_n dist {0:=10 , 1:=90};
wr_en dist {0:=30, 1:=70};
rd_en dist {0:=70 , 1:=30};
}
endclass

endpackage