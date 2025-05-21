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
 
class apb_alternate_write_read_sequence extends apb_sequence;

  `uvm_object_utils(apb_alternate_write_read_sequence)

  function new(string name = "apb_alternate_write_read_sequence");
    super.new(name);
  endfunction

bit [8:0]addr;
 
virtual task body();
req = apb_seq_item::type_id::create("req");

//    repeat(2)begin
     `uvm_do_with(req, {req.transfer == 1; req.read_write == 0;req.apb_write_paddr[8] == 1;})
     `uvm_send(req);
      addr = req.apb_write_paddr;
     `uvm_do_with(req, {req.transfer == 1; req.read_write == 1; req.apb_read_paddr == addr;})
     `uvm_send(req);
  //  end
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
 
 
 
