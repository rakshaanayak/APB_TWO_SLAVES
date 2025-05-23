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
  
  int MATCH;
  int MISMATCH;

  uvm_analysis_imp_ip #(apb_seq_item, apb_scoreboard) aport_ip;
  uvm_analysis_imp_op #(apb_seq_item, apb_scoreboard) aport_op;

  uvm_tlm_fifo #(apb_seq_item) exp_op_fifo;
  uvm_tlm_fifo #(apb_seq_item) act_op_fifo;

  bit [`DW-1:0] ref_mem [bit [`AW-1:0]];

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    aport_ip     = new("aport_ip", this);
    aport_op     = new("aport_op", this);
    exp_op_fifo  = new("exp_op_fifo", this);
    act_op_fifo  = new("act_op_fifo", this);
    if (!uvm_config_db#(virtual apb_inf)::get(this, "*", "vif", vif))
      `uvm_fatal("SCOREBOARD", "Unable to get vif from config DB")
  endfunction

  function void write_ip(apb_seq_item tr);
    void'(exp_op_fifo.try_put(tr));
    $display("write_addr=%h,read_addr=%h,time=%t",tr.apb_write_paddr,tr.apb_read_paddr,$time);
   endfunction

  function void write_op(apb_seq_item tr);
    void'(act_op_fifo.try_put(tr));
    $display("write_addr=%h,read_addr=%h,time=%t",tr.apb_write_paddr,tr.apb_read_paddr,$time);

  endfunction

  task run_phase(uvm_phase phase);

    apb_seq_item exp_tr, act_tr;
     super.run_phase(phase);

    forever begin
    //  wait (exp_op_fifo.size() > 0 && act_op_fifo.size() > 0);
      exp_op_fifo.get(exp_tr);
      act_op_fifo.get(act_tr);
      ref_model_logic(exp_tr, act_tr);

      $display("Displaying before comparing");
      display(exp_tr,act_tr);

      $display("Display after comparing");
      compare(exp_tr, act_tr);
    end
  endtask

  task ref_model_logic(apb_seq_item exp_tr, apb_seq_item act_tr);
    if (vif.presetn == 0) begin
      exp_tr.apb_read_data_out = act_tr.apb_read_data_out;
    end
    else if (exp_tr.transfer && !exp_tr.read_write) begin // Write
      ref_mem[exp_tr.apb_write_paddr] = exp_tr.apb_write_data;
    end
    else if (exp_tr.transfer && exp_tr.read_write) begin
         exp_tr.apb_read_data_out = ref_mem[exp_tr.apb_read_paddr];
         //$display("I AM HERE");
      end
  endtask

  function void compare(apb_seq_item exp_tr, apb_seq_item act_tr);
    if (vif.presetn == 0) begin
      if (exp_tr.apb_read_data_out == act_tr.apb_read_data_out)begin
        `uvm_info(get_type_name(), "**packet_matched**\tReset condition", UVM_NONE);
         MATCH++;

         display_match(exp_tr,act_tr);
      end

      else begin
        `uvm_error(get_type_name(), "**packet_mismatched**\tReset condition");
         MISMATCH++;

         display_mismatch(exp_tr,act_tr);
       end
      display(exp_tr, act_tr);
      return;
    end

    if (exp_tr.transfer ) begin
       if (!exp_tr.read_write) begin
      if ((exp_tr.apb_write_paddr == act_tr.apb_write_paddr) &&
          (exp_tr.apb_write_data == act_tr.apb_write_data))begin
        `uvm_info(get_type_name(), "**packet_matched**\tWrite Transaction", UVM_NONE);
        MATCH++;

        display_match(exp_tr,act_tr);
      end
      else begin
        `uvm_error(get_type_name(), "**packet_mismatched**\tWrite Transaction");
        MISMATCH++;

        display_mismatch(exp_tr,act_tr);
     end
    end else begin
      if ((exp_tr.apb_read_paddr == act_tr.apb_read_paddr) &&
          (exp_tr.apb_read_data_out == act_tr.apb_read_data_out))begin
        `uvm_info(get_type_name(), "**packet_matched**\tRead Transaction", UVM_NONE);
        MATCH++;

       display_match(exp_tr,act_tr);
      end
      else begin
        `uvm_error(get_type_name(), "**packet_mismatched**\tRead Transaction");
        MISMATCH++;
        display_mismatch(exp_tr,act_tr);
    end
    end
end
    display(exp_tr, act_tr);
  endfunction

  function void display(apb_seq_item exp_tr, apb_seq_item act_tr);
    `uvm_info(get_type_name(), "Displaying Expected vs Actual Transaction", UVM_NONE);
    exp_tr.print();
    act_tr.print();
  endfunction


  function void display_match(apb_seq_item exp_tr, apb_seq_item act_tr);
    `uvm_info("Check_start", "---Start Check---", UVM_LOW);
    `uvm_info("expected", "---Expected---", UVM_LOW); exp_tr.print();
    `uvm_info("actual", "---Actual---", UVM_LOW); act_tr.print();
    `uvm_info("MATCH", $sformatf("Match count = %0d", MATCH), UVM_LOW);
    `uvm_info("Check_stop", "---Stop Check---", UVM_LOW);
  endfunction
 
  function void display_mismatch(apb_seq_item exp_tr, apb_seq_item act_tr);
    `uvm_info("Check_start", "---Start Check---", UVM_LOW);
    `uvm_info("expected", "---Expected---", UVM_LOW); exp_tr.print();
    `uvm_info("actual", "---Actual---", UVM_LOW); act_tr.print();
    `uvm_info("MISMATCH", $sformatf("Mismatch count = %0d", MISMATCH), UVM_LOW);
    `uvm_info("Check_stop", "---Stop Check---", UVM_LOW);
  endfunction


endclass


