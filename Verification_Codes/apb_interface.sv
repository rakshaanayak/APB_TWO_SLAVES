//------------------------------------------------------------------------------
// Project      : APB
// File Name    : apb_interface.sv
// Developer    : Team-3
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//------------------------------------------------------------------------------

`include "define.svh"
interface apb_inf
(
  input logic pclk,
  input logic presetn
);


  logic           transfer;
  logic           read_write  ;
  logic [`AW-1:0] apb_write_paddr  ;
  logic [`DW-1:0] apb_write_data;
  logic [`AW-1:0] apb_read_paddr  ;
  logic [`DW-1:0] apb_read_data_out;


  clocking drv_cb @(posedge pclk or negedge presetn);
    default input #0 output #0;
    output transfer,read_write,apb_write_paddr,apb_read_paddr,apb_write_data;
    input presetn;
  endclocking

  clocking mon_cb @(posedge pclk or negedge presetn);
    default input #0 output #0;
    input transfer,read_write,apb_write_paddr,apb_read_paddr,apb_write_data,apb_read_data_out;
  endclocking

  modport DRV(clocking drv_cb);
  modport MON(clocking mon_cb);

  
 property checkWrite;
  @(posedge pclk) disable iff (!presetn)
  (transfer && read_write) |-> !$isunknown(apb_write_data);
endproperty


property checkWriteAddressValidity;
  @(posedge pclk) disable iff (!presetn)
  (transfer && read_write && !$isunknown(apb_write_paddr)) |-> (apb_write_paddr inside {[0 : (1 << `AW) - 1]});
endproperty

property checkReadAddressValidity;
  @(posedge pclk) disable iff (!presetn)
  (transfer && !read_write) |-> !$isunknown(apb_read_paddr) && $stable(apb_read_paddr);
endproperty

property checkWriteDataValidity;
  @(posedge pclk) disable iff (!presetn)
  (transfer && read_write) |-> !$isunknown(apb_write_data);
endproperty


property checkReadDataValidity;
  @(posedge pclk) disable iff (!presetn)
  (transfer && !read_write) |-> !$isunknown(apb_read_data_out);
endproperty


endinterface












