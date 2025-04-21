`define MON_op_if vif.MON.mon_cb


class apb_output_monitor extends uvm_monitor;

  `uvm_component_utils(apb_output_monitor)


  virtual apb_inf vif;


  apb_seq_item op_mon_seq;


  uvm_analysis_port #(apb_seq_item) op_mon_port;

  function new(string name = "apb_output_monitor", uvm_component parent);
    super.new(name, parent);
    op_mon_port = new("op_mon_port",this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!(uvm_config_db #(virtual apb_inf)::get(this,"","vif",vif)))
      `uvm_fatal("Output monitor","unable to get interface handle");
    op_mon_seq = apb_seq_item ::type_id::create("ip_mon_seq");
  endfunction

  virtual task run_phase(uvm_phase phase);
   //body
  endtask
endclass


