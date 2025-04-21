class apb_active_agent extends uvm_agent;

  `uvm_component_utils(apb_active_agent)

  apb_driver driver_h;
  apb_sequencer sequencer_h;
  apb_input_monitor ip_mon_h;

  function new(string name = "apb_active_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(get_is_active() == UVM_ACTIVE) begin
      driver_h = apb_driver::type_id::create("driver_h",this);
      sequencer_h = apb_sequencer::type_id::create("sequencer_h",this);
    end
    ip_mon_h = apb_input_monitor::type_id::create("ip_mon_h",this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(get_is_active == UVM_ACTIVE) begin
      driver_h.seq_item_port.connect(sequencer_h.seq_item_export);
    end
  endfunction

endclass


