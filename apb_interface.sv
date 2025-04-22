interface apb_inf
(
  input logic pclk,
  input logic presetn
);


  logic           transfer;
  logic           read_write  ;
  logic [`AW-1:0] apb_write_paddr  ;
  logic [`DW-1:0] apb_write_data;
  logic [`AW-1:0] apb_read_paddr  ;
  logic [`DW-1:0] apb_read_data_out;


  clocking drv_cb @(posedge pclk or negedge presetn);
    default input #0 output #0;
    output transfer,read_write,apb_write_paddr,apb_read_paddr,apb_write_data;
    input presetn;
  endclocking

  clocking mon_cb @(posedge pclk or negedge presetn);
    default input #0 output #0;
    input apb_read_data_out;
  endclocking

  modport DRV(clocking drv_cb);
  modport MON(clocking mon_cb);

endinterface


