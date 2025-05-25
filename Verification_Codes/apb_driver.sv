//------------------------------------------------------------------------------
// Project      : APB
// File Name    : apb_driver.sv
// Developer    : Raksha Nayak
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//------------------------------------------------------------------------------
//`define DRV_if vif.DRV.drv_cb

class apb_driver extends uvm_driver #(apb_seq_item);

  `uvm_component_utils(apb_driver)

  function new(string name = "apb_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual apb_inf vif;

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!(uvm_config_db #(virtual apb_inf)::get(this, "*", "vif", vif)))
      `uvm_fatal("apb_driver","unable to get interface");
  endfunction


  task run_phase(uvm_phase phase);
    super.run_phase(phase);
//   repeat(3)@(vif.drv_cb); 
   forever begin
     req = apb_seq_item::type_id::create("req");

      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
   
    end
  endtask

  virtual task drive();
    repeat(2)@(vif.drv_cb);
      @(vif.drv_cb) begin
    
    //  driving logic 
    if(!vif.presetn) begin
    vif.drv_cb.transfer        <= 0;
    vif.drv_cb.read_write      <= 0;
    vif.drv_cb.apb_read_paddr  <= 0;
    vif.drv_cb.apb_write_paddr <= 0;
    vif.drv_cb.apb_write_data  <= 0;

    end
      
   else begin
    vif.drv_cb.transfer       <= req.transfer;
    vif.drv_cb.read_write     <= req.read_write;
   
    if(vif.drv_cb.transfer ) begin
    if(vif.drv_cb.read_write) begin
    vif.drv_cb.apb_read_paddr <= req.apb_read_paddr;
    end
    else begin 
    vif.drv_cb.apb_write_paddr<= req.apb_write_paddr;
    vif.drv_cb.apb_write_data <= req.apb_write_data;
   end 
   end
   end
        `uvm_info(get_type_name(),$sformatf("Driver driving logic: transfer = %b, read_write = %b, apb_write_paddr = %h, apb_read_paddr = %h, apb_write_data=%h",req.transfer, req.read_write,req.apb_write_paddr,req.apb_read_paddr,req.apb_write_data ),UVM_LOW);
req.print();
    end
  endtask    

endclass

