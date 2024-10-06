
package fifo_driver_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_seq_item_pkg::*;
import fifo_config_pkg::*;

class fifo_driver extends uvm_driver #(fifo_seq_item);
   `uvm_component_utils(fifo_driver)

   virtual arb_if fifo_vif;
   fifo_seq_item stim_seq_item;

   function new(string name = "fifo_driver", uvm_component parent = null);
      super.new(name, parent);
   endfunction

   task run_phase(uvm_phase phase);
      super.run_phase(phase);
      forever begin
         stim_seq_item = fifo_seq_item::type_id::create("stim_seq_item");
         seq_item_port.get_next_item(stim_seq_item);
         fifo_vif.rst_n = stim_seq_item.rst_n;
         fifo_vif.wr_en = stim_seq_item.wr_en;
         fifo_vif.rd_en = stim_seq_item.rd_en;
         fifo_vif.data_out = stim_seq_item.data_out;
         fifo_vif.overflow = stim_seq_item.overflow;
         fifo_vif.wr_ack = stim_seq_item.wr_ack;
         fifo_vif.full = stim_seq_item.full;
         fifo_vif.empty = stim_seq_item.empty;
         fifo_vif.almostfull = stim_seq_item.almostfull;
         fifo_vif.almostempty = stim_seq_item.almostempty;
         fifo_vif.underflow = stim_seq_item.underflow;

         @(negedge fifo_vif.clk);
         seq_item_port.item_done();
         `uvm_info("Driver", stim_seq_item.convert2string_stimulus(), UVM_HIGH);
      end
   endtask
endclass
endpackage
