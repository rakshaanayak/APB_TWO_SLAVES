//------------------------------------------------------------------------------
// Project      : APB
// File Name    : apb_sequence.sv
// Developer    : Raksha Nayak
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//------------------------------------------------------------------------------

class apb_sequence extends uvm_sequence #(apb_seq_item);

  `uvm_object_utils(apb_sequence)

  function new(string name = "apb_sequence");
    super.new(name);
  endfunction

  virtual task body();
    req = apb_seq_item::type_id::create("req");
    wait_for_grant();
    req.randomize();
    send_request(req);
    wait_for_item_done();
  endtask

endclass

class apb_write_sequence extends apb_sequence;
 
  `uvm_object_utils(apb_write_sequence)
 
  function new(string name = "apb_write_sequence");
   super.new(name);
  endfunction
 
 
  virtual task body();
    req = apb_seq_item::type_id::create("req");
    wait_for_grant();
    //req.randomize()with{read_write == 0;apb_write_paddr inside{[0:`AW-1]};};
    void'(req.randomize()with{read_write == 0;});
    
    
    send_request(req);
    wait_for_item_done();
  endtask
endclass
 

class apb_read_sequence extends apb_sequence;
 
  `uvm_object_utils(apb_read_sequence)
 
  function new(string name = "apb_read_sequence");
   super.new(name);
  endfunction
 
 
  virtual task body();
    req = apb_seq_item::type_id::create("req");
    wait_for_grant();
   // req.randomize()with{read_write == 1;apb_read_paddr inside{[0:`AW-1]};};
    void'(req.randomize()with{read_write == 1;});
    

    send_request(req);
    wait_for_item_done();
  endtask
endclass
 
/*

class apb_alternate_write_read_sequence extends apb_sequence;
 
  `uvm_object_utils(apb_alternate_write_read_sequence)
 
  function new(string name = "apb_alternate_write_read_sequence");
   super.new(name);
  endfunction
 
 
  virtual task body();
    apb_write_sequence wr_seq;
    apb_read_sequence  rd_seq;  
 repeat(2) begin
      `uvm_do(wr_seq)
   end
    repeat(2) begin
      `uvm_do(rd_seq)
    end
  endtask


endclass
*/
/*
class apb_alternate_write_read_sequence extends apb_sequence;

  `uvm_object_utils(apb_alternate_write_read_sequence)

  function new(string name = "apb_alternate_write_read_sequence");
    super.new(name);
  endfunction

  virtual task body();
   // apb_seq_item tr;

    // WRITE: 54 to address 0x0A2
    `uvm_info(get_type_name(), "Starting WRITE transaction", UVM_MEDIUM)
    req = apb_seq_item::type_id::create("req");
    req.apb_write_paddr    = 9'h0A2;
    req.apb_write_data    = 8'd54;
    req.read_write = 0;
    start_item(req);
    finish_item(req);

    // READ: from address 0x0A2
    `uvm_info(get_type_name(), "Starting READ transaction", UVM_MEDIUM)
    req = apb_seq_item::type_id::create("req");
    req.apb_read_paddr    = 9'h0A2;
    req.read_write = 1;
    start_item(req);
    finish_item(req);
  endtask

endclass
*/
class apb_alternate_write_read_sequence extends apb_sequence;

  `uvm_object_utils(apb_alternate_write_read_sequence)

  function new(string name = "apb_alternate_write_read_sequence");
    super.new(name);
  endfunction

  virtual task body();
    apb_seq_item wr_req, rd_req;

    // WRITE: 54 to address 0x0A2
    `uvm_info(get_type_name(), "Starting WRITE transaction", UVM_MEDIUM)
    wr_req = apb_seq_item::type_id::create("wr_req");
    wr_req.apb_write_paddr  = 9'h0A2;
    wr_req.apb_write_data   = 8'd54;
    wr_req.read_write       = 1'b0;
    wr_req.transfer         = 1'b1;
    start_item(wr_req);
    finish_item(wr_req);

    // READ: from address 0x0A2
    `uvm_info(get_type_name(), "Starting READ transaction", UVM_MEDIUM)
    rd_req = apb_seq_item::type_id::create("rd_req");
    rd_req.apb_read_paddr   = 9'h0A2;
    rd_req.read_write       = 1'b1;
    rd_req.transfer         = 1'b1;
    start_item(rd_req);
    finish_item(rd_req);
  endtask

endclass



class apb_repeated_write_access_sequence extends apb_sequence;
 
  `uvm_object_utils(apb_repeated_write_access_sequence)
 
  function new(string name = "apb_repeated_write_access_sequence");
   super.new(name);
  endfunction
 
 
  virtual task body();
 
    apb_write_sequence wr_seq;
    apb_read_sequence  rd_seq;
    repeat(5) begin
      `uvm_do(wr_seq)
    end
    repeat(5)begin
      `uvm_do(rd_seq)
end
  endtask


endclass
 
 
 
