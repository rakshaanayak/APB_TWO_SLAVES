class apb_passive_agent extends uvm_agent;

  `uvm_component_utils(apb_passive_agent)

  apb_output_monitor op_mon_h;

  function new(string name =  "apb_passive_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    op_mon_h = apb_output_monitor::type_id::create("op_mon_h",this);
  endfunction

endclass

