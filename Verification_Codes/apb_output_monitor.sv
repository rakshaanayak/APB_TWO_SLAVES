//------------------------------------------------------------------------------
// Project      : APB
// File Name    : apb_output_monitor.sv
// Developer    : Raksha Nayak
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//------------------------------------------------------------------------------

//`define MON_op_if vif.MON.mon_cb
//------------------------------------------------------------------------------
// Project      : APB
// File Name    : apb_output_monitor.sv
// Developer    : Raksha Nayak
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//------------------------------------------------------------------------------

//`define MON_op_if vif.MON.mon_cb


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

  endfunction

   task run_phase(uvm_phase phase);
   repeat(2) @(vif.mon_cb);
   forever begin
     @( vif.mon_cb);

      op_mon_seq = apb_seq_item ::type_id::create("op_mon_seq");

        @(posedge vif.pclk);
        if(!vif.presetn) begin
        op_mon_seq.apb_read_paddr = vif.mon_cb.apb_read_paddr;
        op_mon_seq.apb_read_data_out= vif.mon_cb.apb_read_data_out;

         op_mon_port.write(op_mon_seq);
        `uvm_info("out_monitor","out_monitor",UVM_LOW);
      end

      else begin
               op_mon_seq.transfer = vif.mon_cb.transfer;
               op_mon_seq.read_write = vif.mon_cb.read_write;
             //   @(posedge vif.pclk);  // wait for one clock cycle


                if(vif.mon_cb.transfer && !vif.mon_cb.read_write) begin

                     op_mon_seq.apb_write_paddr = vif.mon_cb.apb_write_paddr;
                    op_mon_seq.apb_write_data = vif.mon_cb.apb_write_data;


                    op_mon_port.write(op_mon_seq);
               `uvm_info(get_type_name(),$sformatf("apb_write_paddr = %h, apb_write_data = %h",op_mon_seq.apb_write_paddr, op_mon_seq.apb_write_data),UVM_LOW);

                  end

                else if(vif.mon_cb.transfer && vif.mon_cb.read_write) begin

                   //@(posedge vif.pclk);  // wait for one clock cycle

                    op_mon_seq.apb_read_paddr = vif.mon_cb.apb_read_paddr;
                    op_mon_seq.apb_read_data_out = vif.mon_cb.apb_read_data_out;


                     op_mon_port.write(op_mon_seq);
             `uvm_info(get_type_name(),$sformatf("apb_read_paddr = %h, apb_read_data_out = %h",op_mon_seq.apb_read_paddr, op_mon_seq.apb_read_data_out),UVM_LOW);

      end
               
                 //op_mon_port.write(op_mon_seq);
 
                 op_mon_seq.print();
        end
end
  endtask
endclass


