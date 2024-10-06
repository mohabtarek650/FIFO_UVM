
package fifo_test_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import fifo_env_pkg::*;  
  import fifo_config_pkg::*; 
  import fifo_write_sequence_pkg::*; 
  import fifo_main_sequence_pkg::*; 
  import fifo_read_sequence_pkg::*; 
  class fifo_test extends uvm_test;
    `uvm_component_utils(fifo_test)

    fifo_env env;
    fifo_config fifo_cfg;
	virtual arb_if fifo_vif;
	fifo_write_sequence write_seq;
	fifo_read_sequence  read_seq;
	fifo_main_sequence main_seq;

    function new(string name = "fifo_test", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      env = fifo_env::type_id::create("env", this);
      fifo_cfg = fifo_config::type_id::create("fifo_cfg", this);
      read_seq = fifo_read_sequence::type_id::create("read_seq", this);
      write_seq = fifo_write_sequence::type_id::create("write_seq", this);
       main_seq = fifo_main_sequence::type_id::create("main_seq", this);
      if (!uvm_config_db#(virtual arb_if)::get(this, "", "FIFO_IF", fifo_cfg.fifo_vif))
        `uvm_fatal("build_phase", "Unable to get the virtual interface from uvm_config_db");
      uvm_config_db#(fifo_config)::set(this, "*", "CFG", fifo_cfg);
    endfunction

    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      phase.raise_objection(this);
	  `uvm_info("run_phase","WRITE ASSERTION.",UVM_LOW)
       write_seq.start(env.agt.sqr);
	  `uvm_info("run_phase","WRITE DEASSERTION.",UVM_LOW)
	  
	  `uvm_info("run_phase","READ ASSERTION.",UVM_LOW)
       read_seq.start(env.agt.sqr);
	  `uvm_info("run_phase","READ DEASSERTION.",UVM_LOW)
	  
	  `uvm_info("run_phase","STIMULUS START.",UVM_LOW)
      main_seq.start(env.agt.sqr);
      `uvm_info("run_phase","STIMULUS END.",UVM_LOW)

      phase.drop_objection(this);
    endtask

  endclass
endpackage


