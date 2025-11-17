// Copyright 2024 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// Authors:
// - Philippe Sauter <phsauter@iis.ee.ethz.ch>

module croc_soc import croc_pkg::*; #(
  parameter int unsigned GpioCount = 16
) (
  input  logic clk_i,
  input  logic rst_ni,
  input  logic ref_clk_i,
  input  logic testmode_i,
  input  logic fetch_en_i,
  output logic status_o,

  input  logic jtag_tck_i,
  input  logic jtag_tdi_i,
  output logic jtag_tdo_o,
  input  logic jtag_tms_i,
  input  logic jtag_trst_ni,

  input  logic uart_rx_i,
  output logic uart_tx_o,

  input  logic [GpioCount-1:0] gpio_i,       // Input from GPIO pins
  output logic [GpioCount-1:0] gpio_o,       // Output to GPIO pins
  output logic [GpioCount-1:0] gpio_out_en_o // Output enable signal; 0 -> input, 1 -> output
);
// tmrg default triplicate
// tmrg do_not_triplicate clk_i
// tmrg do_not_triplicate rst_ni
// tmrg do_not_triplicate ref_clk_i
// tmrg do_not_triplicate testmode_i
// tmrg do_not_triplicate fetch_en_i
// tmrg do_not_triplicate status_o
// tmrg do_not_triplicate jtag_tck_i
// tmrg do_not_triplicate jtag_tdi_i
// tmrg do_not_triplicate jtag_tdo_o
// tmrg do_not_triplicate jtag_tms_i
// tmrg do_not_triplicate jtag_trst_ni
// tmrg do_not_triplicate uart_rx_i
// tmrg do_not_triplicate uart_tx_o
// tmrg do_not_triplicate gpio_i
// tmrg do_not_triplicate gpio_o
// tmrg do_not_triplicate gpio_out_en_o
// tmrg tmr_error true

  logic synced_rst_n, synced_fetch_en;

  rstgen i_rstgen (
    .clk_i( clk_i ),
    .rst_ni( rst_ni ),
    .test_mode_i ( testmode_i ),
    .rst_no      ( synced_rst_n ),
    .init_no ( )
  );

  sync #(
      .STAGES     (    2 ),
      .ResetValue ( 1'b0 )
    ) i_ext_intr_sync (
      .clk_i( clk_i ),
      .rst_ni   ( synced_rst_n    ),
      .serial_i ( fetch_en_i      ),
      .serial_o ( synced_fetch_en )
    );

// Connection between Croc_domain and User_domain: User Sbr, Croc Mgr
sbr_obi_req_t user_sbr_obi_req;
sbr_obi_rsp_t user_sbr_obi_rsp;

// Connection between Croc_domain and User_domain: Croc Sbr, User Mgr
mgr_obi_req_t user_mgr_obi_req;
mgr_obi_rsp_t user_mgr_obi_rsp;

logic [NumExternalIrqs-1:0] interrupts;
logic [GpioCount-1:0] gpio_in_sync;

croc_domain #(
  .GpioCount( GpioCount ) 
) i_croc (
  .clk_i( clk_i ),
  .rst_ni ( synced_rst_n ),
  .ref_clk_i( ref_clk_i ),
  .testmode_i( testmode_i ),
  .fetch_en_i ( synced_fetch_en ),

  .jtag_tck_i( jtag_tck_i ),
  .jtag_tdi_i( jtag_tdi_i ),
  .jtag_tdo_o( jtag_tdo_o ),
  .jtag_tms_i( jtag_tms_i ),
  .jtag_trst_ni( jtag_trst_ni ),
  .uart_rx_i( uart_rx_i ),
  .uart_tx_o( uart_tx_o ),

  .gpio_i( gpio_i ),             
  .gpio_o( gpio_o ),            
  .gpio_out_en_o( gpio_out_en_o ),

  .gpio_in_sync_o ( gpio_in_sync ),

  .user_sbr_obi_req_o  ( user_sbr_obi_req ),
  .user_sbr_obi_rsp_i  ( user_sbr_obi_rsp ),

  .user_mgr_obi_req_i  ( user_mgr_obi_req ),
  .user_mgr_obi_rsp_o  ( user_mgr_obi_rsp ),

  .interrupts_i ( interrupts  ),
  .core_busy_o  ( status_o    )
);

user_domain #(
  .GpioCount( GpioCount ) 
) i_user (
  .clk_i( clk_i ),
  .rst_ni ( synced_rst_n ),
  .ref_clk_i( ref_clk_i ),
  .testmode_i( testmode_i ),

  .user_sbr_obi_req_i ( user_sbr_obi_req ),
  .user_sbr_obi_rsp_o ( user_sbr_obi_rsp ),

  .user_mgr_obi_req_o ( user_mgr_obi_req ),
  .user_mgr_obi_rsp_i ( user_mgr_obi_rsp ),

  .gpio_in_sync_i ( gpio_in_sync ),
  .interrupts_o   ( interrupts   )
);

endmodule
