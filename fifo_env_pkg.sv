

package fifo_env_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

import fifo_agent_pkg::*;
import fifo_scoreboard_pkg::*;
import fifo_coverage_pkg::*;
import fifo_sequencer_pkg::*; 
  
class fifo_env extends uvm_env;
   `uvm_component_utils(fifo_env)
   
   fifo_agent agt;
   fifo_scoreboard sb;
   fifo_coverage cov;
   fifo_sequencer seqr;
   function new(string name = "fifo_env", uvm_component parent = null);
      super.new(name, parent);
   endfunction
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      agt = fifo_agent::type_id::create("agt", this);
      sb = fifo_scoreboard::type_id::create("sb", this);
      cov = fifo_coverage::type_id::create("cov", this);
	  seqr = fifo_sequencer::type_id::create("seqr", this);
   endfunction // build_phase
   
   function void connect_phase(uvm_phase phase);
      agt.agt_ap.connect(sb.sb_export);
      agt.agt_ap.connect(cov.cov_export);
   endfunction
endclass
endpackage