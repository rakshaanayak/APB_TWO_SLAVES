//------------------------------------------------------------------------------
// Project      : APB
// File Name    : apb_interface.sv
// Developer    : Team-3
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//------------------------------------------------------------------------------

`include "define.svh"
//`include "apb_package.sv"

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

  modport DRV(clocking drv_cb,input pclk,presetn);
  modport MON(clocking mon_cb,input pclk,presetn);



//assertions
/*property checkWrite;
  @(posedge pclk) disable iff (!presetn)
  transfer |-> !read_write ;
endproperty

 assert property (checkWrite)
    $info("Valid Write ");
  else $error("Invalid Write!");
 */

/*property checkRead;
  @(posedge pclk) disable iff (!presetn)
  transfer |-> read_write ;
endproperty

 assert property (checkRead)
    $info("Valid Read");
  else $error("Invalid Read!");
*/

property checkWriteAddressValidity;
  @(posedge pclk) disable iff (!presetn)
  (transfer && !read_write && !$isunknown(apb_write_paddr)) |-> (apb_write_paddr inside {[0 : (1 << `AW) - 1]});
endproperty

  assert property (checkWriteAddressValidity)
    $info("Valid Write Address");
  else $error("Invalid Write Address detected!");
 

property checkReadAddressValidity;
  @(posedge pclk) disable iff (!presetn)
  (transfer && read_write) |-> !$isunknown(apb_read_paddr);
endproperty

  assert property (checkReadAddressValidity)
    $info("Valid Read Address");
  else $error("Invalid Read Address detected!");


property checkWriteDataValidity;
  @(posedge pclk) disable iff (!presetn)
  (transfer && !read_write) |-> !$isunknown(apb_write_data);
endproperty

  assert property (checkWriteDataValidity)
    $info("Valid Write Data");
  else $error("Invalid Write Data detected!");
 

property checkReadDataValidity;
  @(posedge pclk) disable iff (!presetn)
  (transfer && read_write) |-> !$isunknown(apb_read_data_out);
endproperty

  assert property (checkReadDataValidity)
    $info("Valid Read Data");
  else $error("Invalid Read Data detected!");



endinterface
