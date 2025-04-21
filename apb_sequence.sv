class apb_seq extends uvm_sequence #(apb_seq_item);

  `uvm_object_utils(apb_seq)

  function new(string name = "apb_seq");
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

