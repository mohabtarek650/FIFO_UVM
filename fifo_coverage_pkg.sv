package fifo_coverage_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

import fifo_config_pkg::*;
import fifo_seq_item_pkg::*;

class fifo_coverage extends uvm_component;
  `uvm_component_utils(fifo_coverage)
  uvm_analysis_export #(fifo_seq_item) cov_export;
  uvm_tlm_analysis_fifo #(fifo_seq_item) cov_fifo;
  fifo_seq_item seq_item_cov;

  
    covergroup cov ;
        write_enable: coverpoint seq_item_cov.wr_en {
			bins write_enable_2 = {1};
        }
        read_enable: coverpoint seq_item_cov.rd_en {
                        bins test_read_enable_1 = {0};

        }
		test_full: coverpoint seq_item_cov.full {
                        bins test_full_1 = {0};

        }
		test_empty: coverpoint seq_item_cov.empty {
                        bins test_empty_1 = {0};
	
        }
		test_almostfull: coverpoint seq_item_cov.almostfull {
                        bins test_almostfull_1 = {0};
			
        }
		test_almostempty: coverpoint seq_item_cov.almostempty {
                        bins test_almostempty_1 = {0};
		
        }
		test_overflow_1: coverpoint seq_item_cov.overflow {
			bins test_overflow_1_1 = {0};
        }
		test_underflow_1: coverpoint seq_item_cov.underflow {
			bins test_underflow_1_1 = {0};
        }
		test_wr_ack_1: coverpoint seq_item_cov.wr_ack {
                        bins test_wr_ack_1_1 = {0};
        }
        a0: cross write_enable, test_full;
        a1: cross write_enable, test_almostfull ;
        a2: cross write_enable, test_wr_ack_1 ;
	a4: cross write_enable, test_overflow_1 ;
	b0: cross read_enable, test_empty;
	b1: cross read_enable, test_almostempty ;
	b2: cross read_enable, test_underflow_1 ;
    endgroup

  function new(string name = "fifo_coverage", uvm_component parent = null);
    super.new(name, parent);
    cov = new(); // Ensure cov is instantiated here
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cov_export = new("cov_export", this);
    cov_fifo   = new("cov_fifo", this);
  endfunction
	
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    cov_export.connect(cov_fifo.analysis_export);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      cov_fifo.get(seq_item_cov);
      cov.sample();
    end
  endtask

endclass
endpackage
