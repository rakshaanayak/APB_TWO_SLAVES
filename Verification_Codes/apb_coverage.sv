//------------------------------------------------------------------------------
// Project      : APB
// File Name    : apb_coverage.sv
// Developer    : Raksha Nayak
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//-----------------------------------------------------------------------------
`uvm_analysis_imp_decl(_ip_mon)
`uvm_analysis_imp_decl(_op_mon)


class apb_coverage extends uvm_subscriber #(apb_seq_item);

  //Register with factory
  `uvm_component_utils(apb_coverage)

  //Declare two analysis implementation ports for input and output monitor connections
  uvm_analysis_imp_ip_mon #(apb_seq_item, apb_coverage) ip_mon_imp;
  uvm_analysis_imp_op_mon #(apb_seq_item, apb_coverage) op_mon_imp;

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
      bins read_op = {1'b0};
      bins write_op = {1'b1};
    }
  // Coverpoint for write address 
    APB_WRITE_PADDR_CP:coverpoint seq_item_ip.apb_write_paddr {
      bins write_addr_bins = {[`AW'h000:`AW'h1FF]};

    //  bins write_addr_bin0 = {[`AW'h00:`AW'h3F]};
    //  bins write_addr_bin1 = {[`AW'h40:`AW'h7F]};
    //  bins write_addr_bin2 = {[`AW'h80:`AW'hBF]};
    //  bins write_addr_bin3 = {[`AW'hC0:`AW'hFF]};


    }  

    //Coverpoints for write slave select
    APB_WRITE_SLAVE_SELECT_CP:coverpoint seq_item_ip.apb_write_paddr[8] {
      bins write_slave_0={1'b0};
      bins write_slave_1={1'b1};
    }

  // Coverpoint for write data  
    APB_WRITE_DATA_CP: coverpoint seq_item_ip.apb_write_data {
      bins data_bins = {[`AW'h00:`AW'hFF]};
    }
      
  //endgroup


   //cross coverage
  READ_WRITE_X_TRANSFER: cross READ_WRITE_CP, TRANSFER_CP;
  READ_WRITE_X_APB_WRITE_PADDR: cross READ_WRITE_CP,APB_WRITE_PADDR_CP;
  APB_WRITE_SLAVE_SELECT_X_APB_WRITE_PADDR: cross APB_WRITE_SLAVE_SELECT_CP, APB_WRITE_PADDR_CP;
  APB_WRITE_DATA_X_APB_WRITE_PADDR:cross APB_WRITE_DATA_CP,APB_WRITE_PADDR_CP;
endgroup

  //Output coverage group
  covergroup fun_cov_op;
    APB_READ_DATA_OUT_CP: coverpoint seq_item_op.apb_read_data_out {
      bins data_bins = {[`AW'h00:`AW'hFF]};

    }
    //Coverage for read slave select
    APB_READ_SLAVE_SELECT_CP:coverpoint seq_item_op.apb_read_paddr[8] {
      bins read_slave_0={1'b0};
      bins read_slave_1={1'b1};
    }
  
     // Coverpoint for read address  
    APB_READ_PADDR_CP:coverpoint seq_item_op.apb_read_paddr {
      bins read_addr_bins = {[`AW'h000:`AW'h1FF]};
   //   bins read_addr_bin0 = {[`AW'h00:`AW'h3F]};
    //  bins read_addr_bin1 = {[`AW'h40:`AW'h7F]};
    //  bins read_addr_bin2 = {[`AW'h80:`AW'hBF]};
    //  bins read_addr_bin3 = {[`AW'hC0:`AW'hFF]};

    }  


  //endgroup
   

   //cross coverage

   APB_READ_DATA_OUT_X_APB_READ_PADDR:cross APB_READ_DATA_OUT_CP,APB_READ_PADDR_CP;
   APB_READ_DATA_OUT_X_APB_SLAVE_SELECT: cross APB_READ_DATA_OUT_CP, APB_READ_SLAVE_SELECT_CP;
endgroup


  //Coverage percentage variables
  real ip_cov_value, op_cov_value;

  //Constructor: create ports and coverage groups
  function new(string name, uvm_component parent);
    super.new(name, parent);
     fun_cov_ip=new();
     fun_cov_op=new();
     ip_mon_imp=new("ip_mon_imp",this);
     op_mon_imp=new("op_mon_imp",this);
  endfunction

  //Callback for input monitor transactions
  function void write_ip_mon(apb_seq_item item);
    seq_item_ip=item;
    fun_cov_ip.sample();
  endfunction

  //Callback for output monitor transactions
  function void write_op_mon(apb_seq_item item);
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
 //   endfunction: report_phase

     // Print detailed bin hits
//  fun_cov_ip.print();
 // fun_cov_op.print();
  endfunction: report_phase


endclass: apb_coverage
 


