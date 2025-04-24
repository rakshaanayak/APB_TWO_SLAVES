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
    phase.phase_done.set_drain_time(this);

  endtask
endclass

class apb_read_sequence extends apb_test;
  `uvm_component_utils(apb_read_sequence)
 
 apb_read_sequence read_seq;
 
  function new (string name = "apb_read_sequence", uvm_component parent);
    super.new (name, parent);
  endfunction: new
 
  virtual function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    read_seq = apb_read_sequence::type_id::create("read_seq");
  endfunction: build_phase
 
 
  task run_phase (uvm_phase phase);
    
    phase.raise_objection (this);
    repeat(5)begin
    read_seq(env.a_agent_h.sequencer_h);
    end
    phase.drop_objection (this);
  endtask: run_phase
 
endclass:apb_read_sequence
