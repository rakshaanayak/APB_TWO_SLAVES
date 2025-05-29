//------------------------------------------------------------------------------
// Project      : APB
// File Name    : apb_seq_item.sv
// Developer    : Raksha Nayak
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//------------------------------------------------------------------------------

 import uvm_pkg::*;

`include "define.svh"
`include "uvm_macros.svh"
 
class apb_seq_item extends uvm_sequence_item;


  rand logic            transfer;
  rand logic            read_write;
  rand logic  [`AW-1:0] apb_write_paddr   ;
  rand logic  [`DW-1:0] apb_write_data  ;
  rand logic  [`AW-1:0] apb_read_paddr  ;
  logic       [`DW-1:0] apb_read_data_out;
   

  `uvm_object_utils_begin(apb_seq_item)
     `uvm_field_int (transfer,UVM_ALL_ON)
     `uvm_field_int (read_write,UVM_ALL_ON)
     `uvm_field_int (apb_write_paddr,UVM_ALL_ON)
     `uvm_field_int (apb_write_data,UVM_ALL_ON)
     `uvm_field_int (apb_read_paddr,UVM_ALL_ON)
     `uvm_field_int (apb_read_data_out,UVM_ALL_ON)
   `uvm_object_utils_end
  

  //constructor
  function new(string name="apb_seq_item");
    super.new(name);
  endfunction
  

   //constraint transfer_c{soft transfer==1;}

   constraint slave_select_c{apb_write_paddr[8] dist {0:=1,1:=1};}

   /*constraint write_address_range_c{apb_write_paddr inside {[0:(2**`AW)-1]};}

   constraint read_address_range_c{apb_read_paddr inside {[0:(2**`AW)-1]};}

   constraint write_data_range_c{apb_write_data inside {[0:(2**`DW)-1]};}
*/

endclass


