//------------------------------------------------------------------------------
// Project      : APB
// File Name    : apb_scoreboard.sv
// Developer    : Raksha Nayak
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//------------------------------------------------------------------------------

`uvm_analysis_imp_decl(_ip)
`uvm_analysis_imp_decl(_op)

class apb_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(apb_scoreboard)
  
  virtual apb_inf vif;
  logic [`DW-1:0] apb_reg[5];
  
  localparam ADDR_LSB = $clog2(`DW/8);

  uvm_analysis_imp_ip #(apb_seq_item, apb_scoreboard) aport_ip;
  uvm_analysis_imp_op #(apb_seq_item, apb_scoreboard) aport_op;
  
  uvm_tlm_fifo #(apb_seq_item) exp_op_fifo;
  uvm_tlm_fifo #(apb_seq_item) act_op_fifo;

  extern function void compare(apb_seq_item exp_tr, apb_seq_item act_tr);	
  extern function void display(apb_seq_item exp_tr, apb_seq_item act_tr);	
  
  function new(string name = "apb_scoreboard", uvm_component parent);
    super.new(name,parent);
  endfunction

	
    
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    aport_ip = new("aport_ip", this);
    aport_op = new("aport_op", this);
    exp_op_fifo = new("exp_op_fifo", this);
    act_op_fifo = new("act_op_fifo",this);
	if(!(uvm_config_db #(virtual apb_inf)::get(this, "*", "vif", vif)))
    `uvm_fatal("apb_driver","unable to get interface");
     
  endfunction
  

  function void write_ip(apb_seq_item tr);
    //logic
    void'(exp_op_fifo.try_put(tr));
  endfunction

  function void write_op(apb_seq_item tr);
    //logic
     void'(act_op_fifo.try_put(tr));
  endfunction

  task run_phase(uvm_phase phase);
    //body
  endtask
 endfunction

endclass
