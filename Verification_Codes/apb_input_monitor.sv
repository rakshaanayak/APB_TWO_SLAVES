//------------------------------------------------------------------------------
// Project      : APB
// File Name    : apb_input_monitor.sv
// Developer    : Raksha Nayak
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//------------------------------------------------------------------------------

//`define MON_ip_if vif.MON.mon_cb

class apb_input_monitor extends uvm_monitor;

  `uvm_component_utils(apb_input_monitor)

  virtual apb_inf vif;

  apb_seq_item ip_mon_seq;

  uvm_analysis_port #(apb_seq_item) ip_mon_port;

  function new(string name = "apb_input_monitor", uvm_component parent);
    super.new(name, parent);
    ip_mon_port = new("ip_mon_port",this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!(uvm_config_db #(virtual apb_inf)::get(this,"","vif",vif)))
      `uvm_fatal("Input monitor","unable to get interface handle");
  
  endfunction

  virtual task run_phase(uvm_phase phase);
     repeat(2) @(vif.mon_cb);
      ip_mon_seq = apb_seq_item ::type_id::create("ip_mon_seq");
  
    forever begin
      @(vif.mon_cb); 
      ip_mon_seq.transfer = vif.mon_cb.transfer;
      ip_mon_seq.read_write = vif.mon_cb.read_write;
      
       if((vif.mon_cb.transfer && (vif.presetn))) begin
      
          if(! vif.mon_cb.read_write ) begin
       
          ip_mon_seq.apb_write_paddr =vif.mon_cb.apb_write_paddr;
          ip_mon_seq.apb_write_data = vif.mon_cb.apb_write_data;
        

         end
        else begin
   
           ip_mon_seq.apb_read_paddr =  vif.mon_cb.apb_read_paddr;
        
        end
      ip_mon_port.write(ip_mon_seq);
        `uvm_info(get_type_name(),$sformatf("apb_write_paddr = %h, apb_write_data = %h, apb_read_paddr = %h",ip_mon_seq.apb_write_paddr, ip_mon_seq.apb_write_data,ip_mon_seq.apb_read_paddr),UVM_LOW);
    
      ip_mon_seq.print();
    
      end
    end
  endtask
endclass


