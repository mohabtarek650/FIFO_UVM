import uvm_pkg::*; 
`include "uvm_macros.svh"
import fifo_test_pkg::*; 

module FIFO_top ();

bit clk ;
initial begin
       clk = 0;
        forever begin 
            #5 clk = ~clk;
        end
    end

    arb_if inter(clk);
    bind FIFO SVA fifo_inst(inter);
    FIFO dut(inter);   

initial begin 
uvm_config_db#(virtual arb_if)::set(null,"uvm_test_top","FIFO_IF",inter);
run_test("fifo_test");
end
	
endmodule


