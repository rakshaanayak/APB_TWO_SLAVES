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
    //repeat(1) begin
      write_seq.start(env.a_agent_h.sequencer_h);
    //end
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
    read_seq = ApbReadTest::type_id::create("read_seq");
    `uvm_info("ApbReadTest","Inside wr_rd_test BULID_PHASE",UVM_HIGH);
  endfunction :build_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    //#20;

    `uvm_info("SEQUENCE","\n----------------------------!!! READ BEGINS !!!-------------------------------\n",UVM_LOW)
    //repeat(1) begin
      read_seq.start(env.a_agent_h.sequencer_h);
    //end
    `uvm_info("SEQUENCE","\n----------------------------!!! READ ENDS !!!----------------------------------\n",UVM_LOW)
    phase.drop_objection(this);
  endtask
endclass:ApbReadTest



class ApbAlternateWriteReadTest extends apb_test;
  `uvm_component_utils(ApbAlternateWriteReadTest)

  apb_alternatewriteread_sequence alternatewriteread_seq;

  function new(string name = "ApbAlternateWriteReadTest", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     //create sequences
    alternatewriteread_seq = ApbAlternateWriteReadTest::type_id::create("read_seq");
    `uvm_info("ApbAlternateWriteReadTest","Inside wr_rd_test BULID_PHASE",UVM_HIGH);
  endfunction :build_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    //#20;

    `uvm_info("SEQUENCE","\n----------------------------!!! ALTERNATE WRITE READ BEGINS !!!-------------------------------\n",UVM_LOW)
    //repeat(1) begin
      alternatewriteread_seq.start(env.a_agent_h.sequencer_h);
    //end
    `uvm_info("SEQUENCE","\n----------------------------!!! ALTERNATE WRITE READ ENDS !!!----------------------------------\n",UVM_LOW)
    phase.drop_objection(this);
  endtask
endclass:ApbAlternateWriteReadTest



class RepeatedWriteAccessTest extends apb_test;
  `uvm_component_utils(RepeatedWriteAccessTest)

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
    `uvm_info("SEQUENCE","\n----------------------------!!! REPEATED WRITE ENDS !!!----------------------------------\n",UVM_LOW)
    phase.drop_objection(this);
    
  endtask
endclass
