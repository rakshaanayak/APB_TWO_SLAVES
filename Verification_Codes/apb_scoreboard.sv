//------------------------------------------------------------------------------
// Project      : APB
// File Name    : apb_scoreboard.sv
// Developer    : Raksha Nayak
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//------------------------------------------------------------------------------

class apb_scoreboard extends uvm_scoreboard;

  //Register component with factory
  `uvm_component_utils(apb_scoreboard)

  //Virtual interface handle and internal register model
  virtual apb_inf vif;


  //Analysis ports for input and output monitors
  uvm_analysis_imp_ip #(apb_seq_item, apb_scoreboard) aport_ip;
  uvm_analysis_imp_op #(apb_seq_item, apb_scoreboard) aport_op;

  //TLM FIFOs to store expected and actual transactions
  uvm_tlm_fifo #(apb_seq_item) exp_op_fifo;
  uvm_tlm_fifo #(apb_seq_item) act_op_fifo;

  //External function declarations for comparison and display
  extern function void compare(apb_seq_item exp_tr, apb_seq_item act_tr);
  extern function void display(apb_seq_item exp_tr, apb_seq_item act_tr);

  //Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  //Build phase: create ports, FIFOs, get interface handle
  function void build_phase(uvm_phase phase);
    aport_ip     = new("aport_ip", this);
    aport_op     = new("aport_op", this);
    exp_op_fifo  = new("exp_op_fifo", this);
    act_op_fifo  = new("act_op_fifo", this);

  //Input port write method: store expected transaction
  function void write_ip(apb_seq_item tr);
   // put transaction in expected FIFO
  endfunction

  //Output port write method: store actual transaction
  function void write_op(apb_seq_item tr);
    //put transaction in actual FIFO
  endfunction

  //Run phase: compare expected and actual outputs (not implemented here)
  task run_phase(uvm_phase phase);
    // Compare logic can be implemented here
  endtask

endclass
