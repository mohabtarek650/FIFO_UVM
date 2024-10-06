module SVA(arb_if.DUT inter);

property p ;
@(posedge inter.clk ) (inter.empty &&inter.rd_en) |=> inter.underflow;
endproperty
assert property (p);
cover property (p);

property p1 ;
@(posedge inter.clk ) (inter.full &&inter.wr_en) |=> !inter.wr_ack;
endproperty

assert property (p1);
cover property (p1);


property p3 ;
@(posedge inter.clk ) (inter.full &&inter.wr_en) |-> inter.overflow;
endproperty
assert property (p3);
cover property (p3);


endmodule