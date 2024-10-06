
package fifo_scoreboard_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_seq_item_pkg::*;
import fifo_config_pkg::*;

class fifo_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(fifo_scoreboard)
  
  uvm_analysis_export #(fifo_seq_item) sb_export;
  uvm_tlm_analysis_fifo #(fifo_seq_item) sb_fifo;
  fifo_seq_item seq_item_sb;
  bit [15:0] data_out_ref;
  bit [3:0] count_ref;
  bit full_ref, empty_ref, almostfull_ref, almostempty_ref, wr_ack_ref, overflow_ref, underflow_ref;
  int error_count = 0;
  int correct_count = 0;

  function new(string name = "fifo_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_export = new("sb_export", this);
    sb_fifo   = new("sb_fifo", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    sb_export.connect(sb_fifo.analysis_export);
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      sb_fifo.get(seq_item_sb);
      ref_model(seq_item_sb);
      if (seq_item_sb.wr_ack != wr_ack_ref &&
          seq_item_sb.full != full_ref &&
          seq_item_sb.empty != empty_ref &&
          seq_item_sb.almostfull != almostfull_ref &&
          seq_item_sb.almostempty != almostempty_ref &&
          seq_item_sb.overflow != overflow_ref &&
          seq_item_sb.underflow != underflow_ref) begin
        `uvm_info("run_phase", $sformatf("Comparison failed : %s", seq_item_sb.convert2string()), UVM_HIGH);
		`uvm_info("run_phase", $sformatf("Error: Mismatch REFF = ,data_out=%d,full=%d,empty=%d,overflow=%d,underflow=%d,almostfull=%d,almostempty=%d",data_out_ref,full_ref,empty_ref,overflow_ref,underflow_ref,almostfull_ref,almostempty_ref), UVM_HIGH);;
        error_count++;
      end else begin
        `uvm_info("run_phase", $sformatf("Correct out : %s", seq_item_sb.convert2string()), UVM_HIGH);
        correct_count++;
      end
    end
  endtask

  task ref_model(fifo_seq_item seq_item_chk);
  
     if( ({seq_item_chk.wr_en, seq_item_chk.rd_en} == 2'b10) && !seq_item_chk.full) begin
	    count_ref = count_ref + 1;
        wr_ack_ref = 1;
     end else if ( ({seq_item_chk.wr_en, seq_item_chk.rd_en} == 2'b01) && !seq_item_chk.empty) begin
	     count_ref = count_ref - 1;
    end
      wr_ack_ref =(seq_item_chk.wr_en && !seq_item_chk.full);
      full_ref = (count_ref == seq_item_chk.FIFO_DEPTH);
      empty_ref = (count_ref == 0);
      almostfull_ref = (count_ref == seq_item_chk.FIFO_DEPTH - 1);
      almostempty_ref = (count_ref == 1);
      overflow_ref = ( seq_item_chk.full && seq_item_chk.wr_en );
      underflow_ref = (seq_item_chk.empty && seq_item_chk.rd_en );
  endtask

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("report_phase", $sformatf("Total successful transactions: %0d, Total failed transactions: %0d", correct_count, error_count), UVM_MEDIUM);
  endfunction
endclass
endpackage
