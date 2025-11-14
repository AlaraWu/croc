// Copyright 2024 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// Authors: Chen Wu <chenwu@iis.ee.ethz.ch>

module periph_to_fm import croc_pkg::*; (
    input sbr_obi_req_t periph_req_iA,
    input sbr_obi_req_t periph_req_iB,
    input sbr_obi_req_t periph_req_iC,
    output sbr_obi_req_t fm_req_o,

    input sbr_obi_rsp_t fm_rsp_i,
    output sbr_obi_rsp_t periph_rsp_oA,
    output sbr_obi_rsp_t periph_rsp_oB,
    output sbr_obi_rsp_t periph_rsp_oC
);

assign fm_req_o = (periph_req_iA & periph_req_iB) | (periph_req_iB & periph_req_iC) | (periph_req_iA & periph_req_iC);
assign periph_rsp_oA = fm_rsp_i;
assign periph_rsp_oB = fm_rsp_i;
assign periph_rsp_oC = fm_rsp_i;

endmodule