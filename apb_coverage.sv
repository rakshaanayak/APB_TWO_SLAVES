class apb_coverage extends uvm_subscriber #(apb_seq_item);

  //Register with factory
  `uvm_component_utils(apb_cov)

  //Declare two analysis implementation ports for input and output monitor connections
  uvm_analysis_imp_mon_ip #(apb_seq_item, apb_cov) mon_ip_imp;
  uvm_analysis_imp_mon_op #(apb_seq_item, apb_cov) mon_op_imp;

  //Sequence item instances for input/output samples
  alu_seq_item seq_item_ip;
  alu_seq_item seq_item_op;

  //Input coverage group
  covergroup fun_cov_ip;
    coverpoint i_psel
    coverpoint i_penable
    coverpoint i_pwrite
    coverpoint i_paddr
    coverpoint i_pwdata
    coverpoint i_pstrb
    cross coverpoint: PWRITE x PENABLE
  endgroup

  //Output coverage group
  covergroup fun_cov_op;
    coverpoint o_pready
    coverpoint o_prdata
    coverpoint o_pslverr
    cross coverpoint: PSLVERR x PREADY
  endgroup

  //Coverage percentage variables
  real ip_cov_value, op_cov_value;

  //Constructor: create ports and coverage groups
  function new(string name, uvm_component parent);
    super.new(name, parent);
    create analysis ports
    create coverage groups
  endfunction

  //Callback for input monitor transactions
  function void write_mon_ip(apb_seq_item item);
    assign to local sample variable
    sample input coverage group
  endfunction

  //Callback for output monitor transactions
  function void write_mon_op(apb_seq_item item);
    assign to local sample variable
    sample output coverage group
  endfunction

  //UVM base write method (unused here)
  function void write(apb_seq_item t);
  endfunction

  //Extract phase: calculate and report coverage
  function void extract_phase(uvm_phase phase);
    get coverage values
    print info message with percentages
  endfunction

endclass
