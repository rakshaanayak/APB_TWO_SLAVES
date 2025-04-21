class apb_seq_item extends uvm_sequence_item;

  rand bit            transfer;
  rand bit            read_write;
  rand bit  [`AW-1:0] apb_write_paddr   ;
  rand bit  [`DW-1:0] apb_write_data  ;
  bit       [`AW-1:0] apb_read_paddr  ;
  bit       [`DW-1:0] apb_read_data_out;

  `uvm_object_utils_begin(apb_seq_item)
     `uvm_field_int (transfer,UVM_ALL_ON)
     `uvm_field_int (read_write,UVM_ALL_ON)
     `uvm_field_int (apb_write_paddr,UVM_ALL_ON)
     `uvm_field_int (apb_write_data,UVM_ALL_ON)
     `uvm_field_int (apb_read_paddr,UVM_ALL_ON)
     `uvm_field_int (apb_read_data_out,UVM_ALL_ON)
   `uvm_object_utils_end

  function new(string name="apb_seq_item");
    super.new(name);
  endfunction

endclass


