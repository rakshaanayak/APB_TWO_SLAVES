//------------------------------------------------------------------------------
// Project      : APB
// File Name    : apb_output_monitor.sv
// Developer    : Raksha Nayak
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//------------------------------------------------------------------------------

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

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!(uvm_config_db #(virtual apb_inf)::get(this,"","vif",vif)))
      `uvm_fatal("Output monitor","unable to get interface handle");
    op_mon_seq = apb_seq_item ::type_id::create("op_mon_seq");
  endfunction

  virtual task run_phase(uvm_phase phase);
   forever begin
      @(posedge vif.pclk);
      if(!vif.presetn) begin
        //repeat(1) @(posedge vif.pclk);
       // op_mon_seq.apb_read_paddr = `MON_op_if.apb_read_paddr;
       //op_mon_seq.apb_read_data_out= `MON_op_if.apb_read_data_out;
        
        op_mon_seq.apb_read_paddr = vif.apb_read_paddr;
        op_mon_seq.apb_read_data_out= vif.apb_read_data_out;
        

   

         op_mon_port.write(op_mon_seq);
        `uvm_info("out_monitor","out_monitor",UVM_LOW);
      end
      
      else begin
		if(vif.transfer && !vif.read_write) begin
                    //op_mon_seq.apb_read_paddr = `MON_op_if.apb_read_paddr;
                    //op_mon_seq.apb_read_data_out = `MON_op_if.apb_read_data_out;
                   
                     op_mon_seq.apb_read_paddr = vif.apb_read_paddr;
                    op_mon_seq.apb_read_data_out = vif.apb_read_data_out;
                    

                     op_mon_port.write(op_mon_seq);
             `uvm_info(get_type_name(),$sformatf("apb_read_paddr = %h, apb_read_data_out = %h",op_mon_seq.apb_read_paddr, op_mon_seq.apb_read_data_out),UVM_LOW);
       
      end
      
          //`uvm_info("out_monitor","out_monitor",UVM_LOW);
//	       op_mon_seq.print();
        end
end
  endtask
endclass


