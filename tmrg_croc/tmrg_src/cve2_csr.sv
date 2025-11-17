// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

/**
 * Control / status register primitive
 */

module cve2_csr #(
  parameter int unsigned    Width      = 32,
  parameter bit             ShadowCopy = 1'b0,
  parameter bit [Width-1:0] ResetValue = '0
 ) (
  input  logic             clk_i,
  input  logic             rst_ni,

  input  logic [Width-1:0] wr_data_i,
  input  logic             wr_en_i,
  output logic [Width-1:0] rd_data_o,

  output logic             rd_error_o
);
// tmrg default triplicate
// tmrg tmr_error true

  logic [Width-1:0] rdata_q, rdata_qVoted;
  assign rdata_qVoted = rdata_q;

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      rdata_q <= ResetValue;
    end else if (wr_en_i) begin
      rdata_q <= wr_data_i;
    end
  end

  assign rd_data_o = rdata_qVoted;

  logic [Width-1:0] shadow_q, shadow_qVoted;
  assign shadow_qVoted = shadow_q;

  if (ShadowCopy) begin : gen_shadow

    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        shadow_q <= ~ResetValue;
      end else if (wr_en_i) begin
        shadow_q <= ~wr_data_i;
      end
    end

    assign rd_error_o = rdata_qVoted != ~shadow_qVoted;

  end else begin : gen_no_shadow
    assign rd_error_o = 1'b0;
    assign shadow_q = '0;
  end

  // `ASSERT_KNOWN(IbexCSREnValid, wr_en_i)

endmodule
