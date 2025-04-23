//------------------------------------------------------------------------------
// Project      : APB
// File Name    : apb_sequencer.sv
// Developer    : Raksha Nayak
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//-----------------------------------------------------------------------------
`include "apb_package.sv"

class apb_sequencer extends uvm_sequencer #(apb_seq_item);
  
   //factory registration
  `uvm_component_utils(apb_sequencer)
   
  //constructor
  function new(string name = "apb_sequencer", uvm_component parent);
    super.new(name,parent);
  endfunction

endclass

