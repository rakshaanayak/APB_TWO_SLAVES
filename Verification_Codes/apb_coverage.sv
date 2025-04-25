//------------------------------------------------------------------------------
// Project      : APB
// File Name    : apb_coverage.sv
// Developer    : Raksha Nayak
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//-----------------------------------------------------------------------------

class apb_coverage extends uvm_subscriber #(apb_seq_item);

  //Register with factory
  `uvm_component_utils(apb_cov)

  //Declare two analysis implementation ports for input and output monitor connections
  uvm_analysis_imp_mon_ip #(apb_seq_item, apb_cov) mon_ip_imp;
  uvm_analysis_imp_mon_op #(apb_seq_item, apb_cov) mon_op_imp;

  //Sequence item instances for input/output samples
  apb_seq_item seq_item_ip;
  apb_seq_item seq_item_op;

  //Input coverage group
  covergroup fun_cov_ip;
  // Coverpoint for transfer signal 
    TRANSFER_CP:coverpoint seq_item_ip.transfer {
      bins no_transfer = {0};
      bins valid_transfer = {1};
    }
  // Coverpoint for read_write signal 
    READ_WRITE_CP:coverpoint seq_item_ip.read_write {
      bins read_op = {0};
      bins write_op = {1};
    }
  // Coverpoint for write address 
    APB_WRITE_PADDR_CP:coverpoint seq_item_ip.apb_write_paddr {
      bins addr_bins = {[`AW'h000:  `AW'h1FF]};
    }
  // Coverpoint for read address  
    APB_READ_PADDR_CP:coverpoint seq_item_ip.apb_read_paddr {
      bins addr_bins = {[`AW'h000:`AW'h1FF]};
    }
  // Coverpoint for write data  
    APB_WRITE_DATA_CP: coverpoint seq_item_ip.apb_write_data {
      bins data_bins = {[`AW'h000:`AW'h1FF]};
    }
      
  endgroup

  READ_WRITE_X_APB_WRITE_PADDR: cross READ_WRITE_CP,APB_WRITE_PADDR_CP;
  //Output coverage group
  covergroup fun_cov_op;
    APB_READ_DATA_OUT_CP: coverpoint seq_item_op.apb_read_data_out {
      bins data_bins = {[`AW'h000:`AW'h1FF]};
  endgroup

  //Coverage percentage variables
  real ip_cov_value, op_cov_value;

  //Constructor: create ports and coverage groups
  function new(string name, uvm_component parent);
    super.new(name, parent);
     fun_cov_ip=new();
     fun_cov_op=new();
     mon_ip_imp=new("mon_ip_imp",this);
     mon_op_imp=new("mon_op_imp",this);
  endfunction

  //Callback for input monitor transactions
  function void write_mon_ip(apb_seq_item item);
    seq_item_ip=item;
    fun_cov_ip.sample();
  endfunction

  //Callback for output monitor transactions
  function void write_mon_op(apb_seq_item item);
    seq_item_op=item;
    fun_cov_op.sample();
  endfunction

  //UVM base write method (unused here)
  function void write(apb_seq_item t);
  endfunction

  //Extract phase: calculate and report coverage
  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
     ip_cov_value=fun_cov_ip.get_coverage();
     op_cov_value=fun_cov_op.get_coverage();
     
  endfunction
   
   //report phase
  function void report_phase(uvm_phase phase);
     super.report_phase(phase);
       `uvm_info("COVERAGE", $sformatf("\n----------------------------\nCoverage Details:\nInput coverage is %f \nOutput coverage is %f\n--------------------------------\n", ip_cov_value, op_cov_value), UVM_LOW);
    endfunction: report_phase
 
endclass: apb_coverage
 


