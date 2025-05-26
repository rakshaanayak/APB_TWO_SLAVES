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

class apb_write_to_slave1_sequence extends apb_sequence;
 
  `uvm_object_utils(apb_write_to_slave1_sequence)
 
  function new(string name = "apb_write_to_slave1_sequence");
   super.new(name);
  endfunction
 
 
  virtual task body();
    req = apb_seq_item::type_id::create("req");
    wait_for_grant();
    //req.randomize()with{read_write == 0;apb_write_paddr inside{[0:`AW-1]};};
    void'(req.randomize()with{transfer==1;read_write == 0;apb_write_paddr[8]==0;});
    
    
    send_request(req);
    wait_for_item_done();
  endtask
endclass
 

class apb_write_to_slave2_sequence extends apb_sequence;
 
  `uvm_object_utils(apb_write_to_slave2_sequence)
 
  function new(string name = "apb_write_to_slave2_sequence");
   super.new(name);
  endfunction
 
 
  virtual task body();
    req = apb_seq_item::type_id::create("req");
    wait_for_grant();
    //req.randomize()with{read_write == 0;apb_write_paddr inside{[0:`AW-1]};};
    void'(req.randomize()with{transfer==1;read_write == 0;apb_write_paddr[8]==1;});
    
    
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
    void'(req.randomize()with{transfer==1;read_write == 1;});
    

    send_request(req);
    wait_for_item_done();
  endtask
endclass
 
class apb_alternate_write_read_for_slave1_sequence extends apb_sequence;

  `uvm_object_utils(apb_alternate_write_read_for_slave1_sequence)

  function new(string name = "apb_alternate_write_read_for_slave1_sequence");
    super.new(name);
  endfunction

bit [8:0]addr;
 
virtual task body();
req = apb_seq_item::type_id::create("req");

//    repeat(2)begin
     `uvm_do_with(req, {req.transfer == 1; req.read_write == 0;req.apb_write_paddr[8] == 0;})
 //    `uvm_send(req);
      addr = req.apb_write_paddr;
     `uvm_do_with(req, {req.transfer == 1; req.read_write == 1; req.apb_read_paddr == addr;})
   //  `uvm_send(req);
  //  end
  endtask

endclass

class apb_alternate_write_read_for_slave2_sequence extends apb_sequence;

  `uvm_object_utils(apb_alternate_write_read_for_slave2_sequence)

  function new(string name = "apb_alternate_write_read_for_slave2_sequence");
    super.new(name);
  endfunction

bit [8:0]addr;
 
virtual task body();
req = apb_seq_item::type_id::create("req");

//    repeat(2)begin
     `uvm_do_with(req, {req.transfer == 1; req.read_write == 0;req.apb_write_paddr[8] == 1;})
 //    `uvm_send(req);
      addr = req.apb_write_paddr;
     `uvm_do_with(req, {req.transfer == 1; req.read_write == 1; req.apb_read_paddr == addr;})
   //  `uvm_send(req);
  //  end
  endtask

endclass


class apb_repeated_write_access_sequence extends apb_sequence;

  `uvm_object_utils(apb_repeated_write_access_sequence)
  //`uvm_declare_p_sequencer(apb_sequencer)

  function new(string name = "apb_repeated_write_access_sequence");
    super.new(name);
  endfunction

  bit [8:0] addr;

  virtual task body();
    req = apb_seq_item::type_id::create("req");

    // First write (random data) to Slave 1
    `uvm_do_with(req, {
      transfer == 1;
      read_write == 0;
      apb_write_paddr[8] == 0;
    })
    addr = req.apb_write_paddr;

    // Second write (another random data) to same address
    `uvm_do_with(req, {
      transfer == 1;
      read_write == 0;
      apb_write_paddr == addr;
    })
    #100;
//     repeat (2) @(posedge pclk);

    //  repeat(2) @(posedge p_sequencer.vif.pclk);
    // Read from same address
    `uvm_do_with(req, {
      transfer == 1;
      read_write == 1;
      apb_read_paddr == addr;
    })
  endtask

endclass


 
class apb_transfer_disable_sequence extends apb_sequence;

  `uvm_object_utils(apb_transfer_disable_sequence)

  function new(string name = "apb_transfer_disable_sequence");
   super.new(name);
  endfunction


  virtual task body();
    req = apb_seq_item::type_id::create("req");
    wait_for_grant();
   
    void'(req.randomize()with{req.transfer== 0;});


    send_request(req);
    wait_for_item_done();
  endtask
endclass

class apb_boundary_address_check_sequence extends apb_sequence;

  `uvm_object_utils(apb_boundary_address_check_sequence)

  function new(string name = "apb_boundary_address_check_sequence");
   super.new(name);
  endfunction


  virtual task body();
    req = apb_seq_item::type_id::create("req");
    wait_for_grant();

   // void'(req.randomize()with{apb_write_paddr inside {[0:(2**`AW)-1]};apb_read_paddr inside {[0:(2**`AW)-1]};});
     void'(req.randomize() with {
    apb_write_paddr inside {[0:255]};
    apb_read_paddr  inside {[0:255]};
  });

    send_request(req);
    wait_for_item_done();
  endtask
endclass



class apb_slave_toggle_sequence extends apb_sequence;

  `uvm_object_utils(apb_slave_toggle_sequence)

  function new(string name = "apb_slave_toggle_sequence");
    super.new(name);
  endfunction

  bit [8:0] addr;

  virtual task body();
    req = apb_seq_item::type_id::create("req");

    // Cycle 1: Slave 1, write
   addr = {1'b0, 8'b0000_0100};
    `uvm_do_with(req, {
      req.transfer == 1;
      req.read_write == 0;
      req.apb_write_paddr == addr;
   //   apb_write_paddr[8] == 0;
    })

    // Cycle 2: Slave 2, write
    addr = {1'b1, 8'b0000_0100};
    `uvm_do_with(req, {
      req.transfer == 1;
      req.read_write == 0;
      req.apb_write_paddr == addr;
   //   apb_write_paddr[8] == 1;
    })

    // Cycle 3: Slave 1, write
    addr = {1'b0, 8'b0000_0100};
    `uvm_do_with(req, {
      req.transfer == 1;
      req.read_write == 0;
      req.apb_write_paddr == addr;
   //   apb_write_paddr[8] == 0;
    })

    // Cycle 4: Slave 2, read
    addr = {1'b1, 8'b0000_0100};
    `uvm_do_with(req, {
     req.transfer == 1;
      req.read_write == 1;
      req.apb_read_paddr == addr;
 //     apb_write_paddr[8] == 1;
    })
  endtask

endclass



