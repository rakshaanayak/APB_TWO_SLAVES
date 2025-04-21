`include "alu_package.sv"
module tb_apb_slave;

  logic pclk;
  logic presetn;
   apb_inf  apb_if (
    .pclk(pclk),
    .presetn(presetn)
);

  apb_slave #(
    .AW(`AW),
    .DW(`DW)
  ) dut (
    .pclk(apb_if.pclk),
    .presetn(apb_if.presetn),
    .i_paddr(apb_if.i_paddr),
    .i_pwrite(apb_if.i_pwrite),
    .i_psel(apb_if.i_psel),
    .i_penable(apb_if.i_penable),
    .i_pwdata(apb_if.i_pwdata),
    .i_pstrb(apb_if.i_pstrb),
    .o_prdata(apb_if.o_prdata),
    .o_pslverr(apb_if.o_pslverr),
    .o_pready(apb_if.o_pready),
    .o_hw_ctl(apb_if.o_hw_ctl),
    .i_hw_sts(apb_if.i_hw_sts)
  );

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
    pclk = 0;
    forever #5 pclk = ~pclk;
  end

  initial begin
    presetn = 0;
    #10;
    presetn = 1;
  end

  initial begin

    uvm_config_db #(virtual apb_inf)::set(null,"*","vif",apb_if);
  end
  initial begin
    run_test();
  end
endmodule


