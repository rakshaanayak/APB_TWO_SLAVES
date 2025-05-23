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


class ApbWriteTest extends apb_test;
  `uvm_component_utils( ApbWriteTest)

  apb_write_sequence write_seq;

  function new(string name = " ApbWriteTest", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     //create sequences
    write_seq = apb_write_sequence::type_id::create("write_seq");
    `uvm_info(" ApbWriteTest","Inside wr_rd_test BULID_PHASE",UVM_HIGH);
  endfunction :build_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    phase.raise_objection(this);
    //#20;
    
    `uvm_info("SEQUENCE","\n----------------------------!!! WRITE BEGINS !!!-------------------------------\n",UVM_LOW)
    repeat(5) begin
      write_seq.start(env.a_agent_h.sequencer_h);
    end
    #100;
    `uvm_info("SEQUENCE","\n----------------------------!!! WRITE ENDS !!!----------------------------------\n",UVM_LOW)
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



class ApbAlternateWriteReadTest extends apb_test;
  `uvm_component_utils(ApbAlternateWriteReadTest)

  apb_alternate_write_read_sequence alternatewriteread_seq;

  function new(string name = "ApbAlternateWriteReadTest", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     //create sequences
    alternatewriteread_seq = apb_alternate_write_read_sequence::type_id::create("read_seq");
    `uvm_info("ApbAlternateWriteReadTest","Inside wr_rd_test BULID_PHASE",UVM_HIGH);
  endfunction :build_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    //#20;

    `uvm_info("SEQUENCE","\n----------------------------!!! ALTERNATE WRITE READ BEGINS !!!-------------------------------\n",UVM_LOW)
    repeat(5) begin
      alternatewriteread_seq.start(env.a_agent_h.sequencer_h);
    end
     #100;
    `uvm_info("SEQUENCE","\n----------------------------!!! ALTERNATE WRITE READ ENDS !!!----------------------------------\n",UVM_LOW)
    phase.drop_objection(this);
  endtask
endclass:ApbAlternateWriteReadTest



class ApbRepeatedWriteAccessTest extends apb_test;
  `uvm_component_utils(ApbRepeatedWriteAccessTest)

  apb_repeated_write_access_sequence repeat_write_seq;

  function new(string name = "RepeatedWriteAccessTest", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     //create sequences
    repeat_write_seq = apb_repeated_write_access_sequence::type_id::create(" repeat_write_seq ");
    `uvm_info("RepeatedWriteAccessTest","Inside wr_rd_test BULID_PHASE",UVM_HIGH);
  endfunction :build_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    //#20;
    
    `uvm_info("SEQUENCE","\n----------------------------!!! REPEATED WRITE BEGINS !!!-------------------------------\n",UVM_LOW)
    //repeat(1) begin
     repeat_write_seq.start(env.a_agent_h.sequencer_h);
    //end
    #100;
    `uvm_info("SEQUENCE","\n----------------------------!!! REPEATED WRITE ENDS !!!----------------------------------\n",UVM_LOW)
    phase.drop_objection(this);
    
  endtask
endclass

///////////////////REGRESSION TEST/////////////////////////////

class ApbRegressionTest extends apb_test;

  `uvm_component_utils(ApbRegressionTest)

   apb_write_sequence seq_write;
  // apb_read_sequence  seq_read;
   apb_alternate_write_read_sequence seq_alternate_write_read;
  // apb_repeated_write_access_sequence seq_repeated_write_access;


   function new(string name ="ApbRegressionTest",uvm_component parent);
     super.new(name,parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    seq_write=apb_write_sequence::type_id::create("seq_write");
    //seq_read=apb_read_sequence::type_id::create("seq_read");
    seq_alternate_write_read=apb_alternate_write_read_sequence::type_id::create("seq_alternate_write_read");
   // seq_repeated_write_access=apb_repeated_write_access_sequence::type_id::create("seq_repeated_write_access");

    endfunction:build_phase


    virtual function void end_of_elaboration ();
      print ();
    endfunction: end_of_elaboration

    task run_phase (uvm_phase phase);
    
      phase.raise_objection (this);
      repeat(1)
      begin
        seq_write.start(env.a_agent_h.sequencer_h);
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
        seq_alternate_write_read.start(env.a_agent_h.sequencer_h);
      end
      phase.drop_objection(this);
    
    
/*
 phase.raise_objection (this);
      repeat(1)
      begin
        seq_repeated_write_access.start(env.a_agent_h.sequencer_h);
      end
      phase.drop_objection(this);

*/
     `uvm_info(get_type_name(),"----------------------",UVM_LOW)
      `uvm_info(get_type_name(),$sformatf("-------------------------!!REGRESSION TEST COMPLETE !!-------------------"),UVM_LOW)
      `uvm_info(get_type_name(),"----------------------",UVM_LOW)
  endtask: run_phase
  
endclass

