//------------------------------------------------------------------------------
// Project      : APB
// File Name    : apb_top.sv
// Developer    : Raksha Nayak
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//------------------------------------------------------------------------------


`include "apb_package.sv"
`include "define.svh"
`include "uvm_macros.svh"
import uvm_pkg::*;
module apb_top;

  logic pclk;
  logic presetn;
   apb_inf  apb_if (
    .pclk(pclk),
    .presetn(presetn)
);

 /* apb_slave #(
    .AW(`AW),
    .DW(`DW)
  ) dut (
    .pclk(apb_if.pclk),
    .presetn(apb_if.presetn),
    .transfer(apb_if.transfer),
    .read_write(apb_if.read_write),
    .apb_write_paddr(apb_if.apb_write_paddr),
    .apb_write_data(apb_if.apb_write_data),
    .apb_read_paddr(apb_if.apb_read_paddr),
    .apb_read_data_out(apb_if.apb_read_data_out)
  );
   */

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
    run_test("ApbWriteTest");
  end
endmodule


