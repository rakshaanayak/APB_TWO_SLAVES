//------------------------------------------------------------------------------
// Project      : APB
// File Name    : apb_env.sv
// Developer    : Raksha Nayak
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//------------------------------------------------------------------------------


//import uvm_pkg::*;
//`include "uvm_macros.svh"

class apb_env extends uvm_env;

  `uvm_component_utils(apb_env)

  function new(string name = "apb_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  apb_active_agent  a_agent_h;
  apb_passive_agent p_agent_h;
  apb_scoreboard    sb_h;

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    a_agent_h = apb_active_agent::type_id::create("a_agent_h", this);
    p_agent_h = apb_passive_agent::type_id::create("p_agent_h", this);
    sb_h      = apb_scoreboard::type_id::create("sb_h", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    a_agent_h.ip_mon_h.ip_mon_port.connect(sb_h.aport_ip);
    p_agent_h.op_mon_h.op_mon_port.connect(sb_h.aport_op);
  endfunction

endclass


