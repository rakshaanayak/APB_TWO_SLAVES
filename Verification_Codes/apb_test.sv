//------------------------------------------------------------------------------
// Project      : APB
// File Name    : apb_test.sv
// Developer    : Raksha Nayak
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//------------------------------------------------------------------------------


class apb_test extends uvm_test;

  `uvm_component_utils(apb_test)

  apb_env env;

  function new(string name = "apb_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = apb_env::type_id::create("env",this);
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction

  function void report_phase(uvm_phase phase);
    uvm_report_server svr;
    super.report_phase(phase);
    svr=uvm_report_server::get_server();
    if(svr.get_severity_count(UVM_FATAL)+svr.get_severity_count(UVM_ERROR)>0) begin
                        `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
                        `uvm_info(get_type_name(), "----            TEST FAIL          ----", UVM_NONE)
                        `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
                end
                else begin
                        `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
                        `uvm_info(get_type_name(), "----           TEST PASS           ----", UVM_NONE)
                        `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
                end
                `uvm_info("ALU_TEST","Inside alu_test REPORT_PHASE",UVM_HIGH)
  endfunction
endclass


class ApbWriteToSlave1Test extends apb_test;
  `uvm_component_utils( ApbWriteToSlave1Test)

  apb_write_to_slave1_sequence write_to_slave1_seq;

  function new(string name = " ApbWriteToSlave1Test", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     //create sequences
    write_to_slave1_seq = apb_write_to_slave1_sequence::type_id::create("write_to_slave1_seq");
    `uvm_info(" ApbWriteToSlave1Test","Inside write_to_slave1 BULID_PHASE",UVM_HIGH);
  endfunction :build_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    phase.raise_objection(this);
    //#20;
    
    `uvm_info("SEQUENCE","\n----------------------------!!! WRITE TO SLAVE1 BEGINS !!!-------------------------------\n",UVM_LOW)
    repeat(5) begin
      write_to_slave1_seq.start(env.a_agent_h.sequencer_h);
    end
    #100;
    `uvm_info("SEQUENCE","\n----------------------------!!! WRITE TO SLAVE1 ENDS !!!----------------------------------\n",UVM_LOW)
    phase.drop_objection(this);
   

  endtask
endclass


class ApbWriteToSlave2Test extends apb_test;
  `uvm_component_utils( ApbWriteToSlave2Test)

  apb_write_to_slave2_sequence write_to_slave2_seq;

  function new(string name = " ApbWriteToSlave2Test", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     //create sequences
    write_to_slave2_seq = apb_write_to_slave2_sequence::type_id::create("write_to_slave2_seq");
    `uvm_info(" ApbWriteToSlave2Test","Inside write_to_slave2 BULID_PHASE",UVM_HIGH);
  endfunction :build_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    phase.raise_objection(this);
    //#20;
    
    `uvm_info("SEQUENCE","\n----------------------------!!! WRITE TO SLAVE2 BEGINS !!!-------------------------------\n",UVM_LOW)
    repeat(5) begin
      write_to_slave2_seq.start(env.a_agent_h.sequencer_h);
    end
    #100;
    `uvm_info("SEQUENCE","\n----------------------------!!! WRITE TO SLAVE2 ENDS !!!----------------------------------\n",UVM_LOW)
    phase.drop_objection(this);
   

  endtask
endclass

class ApbReadTest extends apb_test;
  `uvm_component_utils(ApbReadTest)

  apb_read_sequence read_seq;

  function new(string name = "ApbReadTest", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     //create sequences
    read_seq = apb_read_sequence::type_id::create("read_seq");
    `uvm_info("ApbReadTest","Inside wr_rd_test BULID_PHASE",UVM_HIGH);
  endfunction :build_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    //#20;

    `uvm_info("SEQUENCE","\n----------------------------!!! READ BEGINS !!!-------------------------------\n",UVM_LOW)
        //env.sb_h.ref_mem[9'h108] = 8'hA5;  // Preload expected data at address 108
    repeat(5) begin
      read_seq.start(env.a_agent_h.sequencer_h);
    end
     #100;
    `uvm_info("SEQUENCE","\n----------------------------!!! READ ENDS !!!----------------------------------\n",UVM_LOW)
    phase.drop_objection(this);
  endtask
endclass:ApbReadTest



class ApbAlternateWriteReadForSlave1Test extends apb_test;
  `uvm_component_utils(ApbAlternateWriteReadForSlave1Test)

  apb_alternate_write_read_for_slave1_sequence alternate_write_read_for_slave1_seq;

  function new(string name = "ApbAlternateWriteReadForSlave1Test", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     //create sequences
    alternate_write_read_for_slave1_seq = apb_alternate_write_read_for_slave1_sequence::type_id::create("alternate_write_read_for_slave1_seq");
    `uvm_info("ApbAlternateWriteReadForSlave1Test","Inside wr_rd_test BULID_PHASE",UVM_HIGH);
  endfunction :build_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    //#20;

    `uvm_info("SEQUENCE","\n----------------------------!!! ALTERNATE WRITE READ FOR SLAVE1 BEGINS !!!-------------------------------\n",UVM_LOW)
    repeat(5) begin
      alternate_write_read_for_slave1_seq.start(env.a_agent_h.sequencer_h);
    end
     #100;
    `uvm_info("SEQUENCE","\n----------------------------!!! ALTERNATE WRITE READ FOR SLAVE1  ENDS !!!----------------------------------\n",UVM_LOW)
    phase.drop_objection(this);
  endtask
endclass:ApbAlternateWriteReadForSlave1Test

class ApbAlternateWriteReadForSlave2Test extends apb_test;
  `uvm_component_utils(ApbAlternateWriteReadForSlave2Test)

  apb_alternate_write_read_for_slave2_sequence alternate_write_read_for_slave2_seq;

  function new(string name = "ApbAlternateWriteReadForSlave2Test", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     //create sequences
    alternate_write_read_for_slave2_seq = apb_alternate_write_read_for_slave2_sequence::type_id::create("alternate_write_read_for_slave2_seq");
    `uvm_info("ApbAlternateWriteReadForSlave2Test","Inside wr_rd_test BULID_PHASE",UVM_HIGH);
  endfunction :build_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    //#20;

    `uvm_info("SEQUENCE","\n----------------------------!!! ALTERNATE WRITE READ FOR SLAVE2 BEGINS !!!-------------------------------\n",UVM_LOW)
    repeat(5) begin
      alternate_write_read_for_slave2_seq.start(env.a_agent_h.sequencer_h);
    end
     #100;
    `uvm_info("SEQUENCE","\n----------------------------!!! ALTERNATE WRITE READ FOR SLAVE2  ENDS !!!----------------------------------\n",UVM_LOW)
    phase.drop_objection(this);
  endtask
endclass:ApbAlternateWriteReadForSlave2Test



class ApbRepeatedWriteAccessToSlave1Test extends apb_test;
  `uvm_component_utils(ApbRepeatedWriteAccessToSlave1Test)

  apb_repeated_write_access_to_slave1_sequence repeated_write_access_to_slave1_seq;

  function new(string name = "RepeatedWriteAccessToSlave1Test", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     //create sequences
    repeated_write_access_to_slave1_seq = apb_repeated_write_access_to_slave1_sequence::type_id::create(" repeated_write_access_to_slave1_seq ");
    `uvm_info("RepeatedWriteAccessToSlave1Test","Inside repeated_write_access_to_slave1_test BULID_PHASE",UVM_HIGH);
  endfunction :build_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    //#20;
    
    `uvm_info("SEQUENCE","\n----------------------------!!! REPEATED WRITE TO SLAVE1 BEGINS !!!-------------------------------\n",UVM_LOW)
    repeat(5) begin
     repeated_write_access_to_slave1_seq.start(env.a_agent_h.sequencer_h);
    end
    #100;
    `uvm_info("SEQUENCE","\n----------------------------!!! REPEATED WRITE TO SLAVE1 ENDS !!!----------------------------------\n",UVM_LOW)
    phase.drop_objection(this);
    
  endtask
endclass




class ApbRepeatedWriteAccessToSlave2Test extends apb_test;
  `uvm_component_utils(ApbRepeatedWriteAccessToSlave2Test)

  apb_repeated_write_access_to_slave2_sequence repeated_write_access_to_slave2_seq;

  function new(string name = "RepeatedWriteAccessToSlave2Test", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     //create sequences
    repeated_write_access_to_slave2_seq = apb_repeated_write_access_to_slave2_sequence::type_id::create(" repeated_write_access_to_slave2_seq ");
    `uvm_info("RepeatedWriteAccessToSlave2Test","Inside repeated_write_access_to_slave2_test BULID_PHASE",UVM_HIGH);
  endfunction :build_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    //#20;
    
    `uvm_info("SEQUENCE","\n----------------------------!!! REPEATED WRITE TO SLAVE2 BEGINS !!!-------------------------------\n",UVM_LOW)
    repeat(5) begin
     repeated_write_access_to_slave2_seq.start(env.a_agent_h.sequencer_h);
    end
    #100;
    `uvm_info("SEQUENCE","\n----------------------------!!! REPEATED WRITE TO SLAVE2 ENDS !!!----------------------------------\n",UVM_LOW)
    phase.drop_objection(this);
    
  endtask
endclass




class ApbTransferDisableTest extends apb_test;
  `uvm_component_utils(ApbTransferDisableTest)

  apb_transfer_disable_sequence transfer_disable_seq;

  function new(string name = "ApbTransferDisableTest", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     //create sequences
    transfer_disable_seq = apb_transfer_disable_sequence::type_id::create("transfer_disable_seq");
    `uvm_info("ApbTransferDisableTest","Inside wr_rd_test BULID_PHASE",UVM_HIGH);
  endfunction :build_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    

    `uvm_info("SEQUENCE","\n----------------------------!!! DISABLING OF TRANSFER BEGINS !!!-------------------------------\n",UVM_LOW)
      
    repeat(5) begin
      transfer_disable_seq.start(env.a_agent_h.sequencer_h);
    end
     #100;
    `uvm_info("SEQUENCE","\n----------------------------!!! DISABLING OF TRANSFER  ENDS !!!----------------------------------\n",UVM_LOW)
    phase.drop_objection(this);
  endtask
endclass:ApbTransferDisableTest


class ApbWriteReadDifferentAddressTest extends apb_test;
  `uvm_component_utils(ApbWriteReadDifferentAddressTest )

 apb_write_read_different_address_sequence write_read_different_address_seq;

  function new(string name = "ApbWriteReadDifferentAddressTest ", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     //create sequences
    write_read_different_address_seq = apb_write_read_different_address_sequence::type_id::create(" write_read_different_address_seq ");
    `uvm_info("ApbWriteReadDifferentAddressTest","Inside  write_read_different_address_test BULID_PHASE",UVM_HIGH);
  endfunction :build_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    //#20;

    `uvm_info("SEQUENCE","\n----------------------------!!!  WRITE READ DIFFERENT ADDRESS BEGINS !!!-------------------------------\n",UVM_LOW)
    repeat(5) begin
     write_read_different_address_seq.start(env.a_agent_h.sequencer_h);
    end
    #100;
    `uvm_info("SEQUENCE","\n----------------------------!!! WRITE READ DIFFERENT ADDRESS ENDS !!!----------------------------------\n",UVM_LOW)
    phase.drop_objection(this);

  endtask
endclass


class ApbBoundaryAddressCheckTest extends apb_test;
  `uvm_component_utils( ApbBoundaryAddressCheckTest)

  apb_boundary_address_check_sequence boundary_address_check_seq;

  function new(string name = " ApbBoundaryAddressCheckTest", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     //create sequences
   boundary_address_check_seq = apb_boundary_address_check_sequence::type_id::create("boundary_address_check_seq");
    `uvm_info(" ApbBoundaryAddressCheckTest","Inside boundary_address_check_test BULID_PHASE",UVM_HIGH);
  endfunction :build_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);


    `uvm_info("SEQUENCE","\n----------------------------!!! BOUNDARY ADDRESS CHECK BEGINS !!!-------------------------------\n",UVM_LOW)

    repeat(5) begin
      boundary_address_check_seq.start(env.a_agent_h.sequencer_h);
    end
     #100;
    `uvm_info("SEQUENCE","\n----------------------------!!! BOUNDARY ADDRESS CHECK  ENDS !!!----------------------------------\n",UVM_LOW)
    phase.drop_objection(this);
  endtask
endclass:ApbBoundaryAddressCheckTest


class ApbWriteReadForAlternateSlavesTest extends apb_test;
  `uvm_component_utils(ApbWriteReadForAlternateSlavesTest )

 apb_write_read_for_alternate_slaves_sequence write_read_for_alternate_slaves_seq;

  function new(string name = "ApbWriteReadForAlternateSlavesTest ", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     //create sequences
   write_read_for_alternate_slaves_seq = apb_write_read_for_alternate_slaves_sequence::type_id::create(" write_read_for_alternate_slaves_seq ");
    `uvm_info("ApbWriteReadForAlternateSlavesTest","Inside  write_read_for_alternate_slaves_test BULID_PHASE",UVM_HIGH);
  endfunction :build_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    //#20;

    `uvm_info("SEQUENCE","\n----------------------------!!!  WRITE READ FOR ALTERNATE SLAVES BEGINS !!!-------------------------------\n",UVM_LOW)
    repeat(5) begin
     write_read_for_alternate_slaves_seq.start(env.a_agent_h.sequencer_h);
    end
    #100;
    `uvm_info("SEQUENCE","\n----------------------------!!! WRITE READ FOR ALTERNATE SLAVES  ENDS !!!----------------------------------\n",UVM_LOW)
    phase.drop_objection(this);

  endtask
endclass



class ApbSlaveToggleTest extends apb_test;
  `uvm_component_utils(ApbSlaveToggleTest)

  apb_slave_toggle_sequence apb_slave_toggle_seq;

  function new(string name = "ApbSlaveToggleTest", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     //create sequences
   apb_slave_toggle_seq =   apb_slave_toggle_sequence::type_id::create("apb_slave_toggle_seq");
    `uvm_info("ApbSlaveToggleTest","Inside slave_toggle_test BULID_PHASE",UVM_HIGH);
  endfunction :build_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    //#20;

    `uvm_info("SEQUENCE","\n----------------------------!!! SLAVE TOGGLE BEGINS !!!-------------------------------\n",UVM_LOW)
    repeat(5) begin
      apb_slave_toggle_seq.start(env.a_agent_h.sequencer_h);
    end
     #100;
    `uvm_info("SEQUENCE","\n----------------------------!!! SLAVE TOGGLE  ENDS !!!----------------------------------\n",UVM_LOW)
    phase.drop_objection(this);
  endtask
endclass:ApbSlaveToggleTest



///////////////////REGRESSION TEST/////////////////////////////

class ApbRegressionTest extends apb_test;

  `uvm_component_utils(ApbRegressionTest)

   apb_write_to_slave1_sequence seq_write_to_slave1;

     apb_write_to_slave2_sequence seq_write_to_slave2;
 
  // apb_read_sequence  seq_read;
   apb_alternate_write_read_for_slave1_sequence seq_alternate_write_read_for_slave1;
   apb_alternate_write_read_for_slave2_sequence seq_alternate_write_read_for_slave2;
     
   apb_repeated_write_access_to_slave1_sequence seq_repeated_write_access_to_slave1;
   apb_repeated_write_access_to_slave2_sequence seq_repeated_write_access_to_slave2;
  
   apb_transfer_disable_sequence seq_transfer_disable;
   apb_boundary_address_check_sequence seq_boundary_address_check;
  // apb_write_read_different_address_sequence seq_write_read_different_address;
  // apb_write_read_for_alternate_slaves_sequence seq_write_read_for_alternate_slaves;
   apb_slave_toggle_sequence seq_slave_toggle;

   function new(string name ="ApbRegressionTest",uvm_component parent);
     super.new(name,parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    seq_write_to_slave1=apb_write_to_slave1_sequence::type_id::create("seq_write_to_slave1");
  
    seq_write_to_slave2=apb_write_to_slave2_sequence::type_id::create("seq_write_to_slave2");
   
   //seq_read=apb_read_sequence::type_id::create("seq_read");
   seq_alternate_write_read_for_slave1=apb_alternate_write_read_for_slave1_sequence::type_id::create("seq_alternate_write_read_for_slave1");

   seq_alternate_write_read_for_slave2=apb_alternate_write_read_for_slave2_sequence::type_id::create("seq_alternate_write_read_for_slave2");
 
   seq_repeated_write_access_to_slave1=apb_repeated_write_access_to_slave1_sequence::type_id::create("seq_repeated_write_access_to_slave1");

   seq_repeated_write_access_to_slave2=apb_repeated_write_access_to_slave2_sequence::type_id::create("seq_repeated_write_access_to_slave2");


   seq_transfer_disable =apb_transfer_disable_sequence::type_id::create("seq_transfer_disable");
  
   seq_boundary_address_check =apb_boundary_address_check_sequence::type_id::create("seq_boundary_address_check");


   //seq_write_read_different_address =apb_write_read_different_address_sequence::type_id::create("seq_write_read_different_address");

   //seq_write_read_for_alternate_slaves =apb_write_read_for_alternate_slaves_sequence::type_id::create("seq_write_read_for_alternate_slaves");
  
   seq_slave_toggle= apb_slave_toggle_sequence::type_id::create("seq_slave_toggle");
    endfunction:build_phase


    virtual function void end_of_elaboration ();
      print ();
    endfunction: end_of_elaboration

    task run_phase (uvm_phase phase);
    
      phase.raise_objection (this);
      repeat(1)
      begin
        seq_write_to_slave1.start(env.a_agent_h.sequencer_h);
      end
      phase.drop_objection (this);
     
      
      phase.raise_objection (this);
      repeat(1)
      begin
        seq_write_to_slave2.start(env.a_agent_h.sequencer_h);
      end
      phase.drop_objection (this);



 /*  phase.raise_objection (this);
      repeat(1)
      begin
        seq_read.start(env.a_agent_h.sequencer_h);
      end
      phase.drop_objection (this);
*/
 phase.raise_objection (this);
      repeat(1)
      begin
        seq_alternate_write_read_for_slave1.start(env.a_agent_h.sequencer_h);
      end
      phase.drop_objection(this);
    
  phase.raise_objection (this);
      repeat(1)
      begin
        seq_alternate_write_read_for_slave2.start(env.a_agent_h.sequencer_h);
      end
      phase.drop_objection(this);
    

 phase.raise_objection (this);
      repeat(1)
      begin
        seq_repeated_write_access_to_slave1.start(env.a_agent_h.sequencer_h);
      end
      phase.drop_objection(this);

  phase.raise_objection (this);
      repeat(1)
      begin
        seq_repeated_write_access_to_slave2.start(env.a_agent_h.sequencer_h);
      end
      phase.drop_objection(this);



    phase.raise_objection (this);
      repeat(1)
      begin
        seq_transfer_disable.start(env.a_agent_h.sequencer_h);
      end
      phase.drop_objection(this);


    phase.raise_objection (this);
      repeat(1)
      begin
        seq_boundary_address_check.start(env.a_agent_h.sequencer_h);
      end
      phase.drop_objection(this);


/*
     
    phase.raise_objection (this);
      repeat(1)
      begin
        seq_write_read_different_address.start(env.a_agent_h.sequencer_h);
      end
      phase.drop_objection(this);

*/
/*
 
     phase.raise_objection (this);
      repeat(1)
      begin
        seq_write_read_for_alternate_slaves.start(env.a_agent_h.sequencer_h);
      end
      phase.drop_objection(this);
 
*/

    phase.raise_objection (this);
      repeat(1)
      begin
        seq_slave_toggle.start(env.a_agent_h.sequencer_h);
      end
      phase.drop_objection(this);
 

     `uvm_info(get_type_name(),"----------------------",UVM_LOW)
      `uvm_info(get_type_name(),$sformatf("-------------------------!!REGRESSION TEST COMPLETE !!-------------------"),UVM_LOW)
      `uvm_info(get_type_name(),"----------------------",UVM_LOW)
  endtask: run_phase
  
endclass

