package fifo_write_sequence_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_seq_item_pkg::*;

class fifo_write_sequence extends uvm_sequence #(fifo_seq_item);
  `uvm_object_utils(fifo_write_sequence) 

  fifo_seq_item seq_item;

  function new(string name = "fifo_write_sequence");
    super.new(name);
  endfunction

  task body();
    repeat(100) begin
      seq_item = fifo_seq_item::type_id::create("seq_item");
      start_item(seq_item);
      seq_item.rst_n = 1;
      seq_item.wr_en = 1;
      seq_item.rd_en = 0;
      seq_item.data_in = 'b10001;
      finish_item(seq_item);
    end
  endtask

endclass
endpackage

