TMRG ?= tmrg

FILES += tmrg_src/addr_decode.sv
FILES += tmrg_src/addr_decode_dync.sv

FILES += tmrg_src/timer_unit.sv
FILES += tmrg_src/timer_unit_counter.sv
FILES += tmrg_src/timer_unit_counter_presc.sv

FILES += tmrg_src/tc_sram_impl.sv
# FILES += tmrg_src/tc_sram.sv

FILES += tmrg_src/soc_ctrl_reg_top.sv
FILES += tmrg_src/prim_subreg.sv
FILES += tmrg_src/prim_subreg_arb.sv

FILES += tmrg_src/periph_to_reg.sv

FILES += tmrg_src/obi_xbar.sv
FILES += tmrg_src/obi_demux.sv
FILES += tmrg_src/obi_mux.sv
FILES += tmrg_src/obi_err_sbr.sv
FILES += tmrg_src/delta_counter.sv
FILES += tmrg_src/fifo_v3.sv
FILES += tmrg_src/rr_arb_tree.sv
FILES += tmrg_src/lzc.sv
FILES += tmrg_src/spill_register.sv
FILES += tmrg_src/spill_register_flushable.sv

FILES += tmrg_src/obi_uart.sv
FILES += tmrg_src/obi_uart_baudgen.sv
FILES += tmrg_src/counter.sv
FILES += tmrg_src/obi_uart_interrupts.sv
FILES += tmrg_src/obi_uart_modem.sv
FILES += tmrg_src/obi_uart_register.sv
FILES += tmrg_src/obi_uart_rx.sv
FILES += tmrg_src/obi_uart_tx.sv

FILES += tmrg_src/obi_sram_shim.sv

FILES += tmrg_src/gpio.sv
FILES += tmrg_src/gpio_reg_top.sv
FILES += tmrg_src/sync.sv

FILES += tmrg_src/dmi_jtag.sv
# FILES += tmrg_src/dmi_cdc.sv
# FILES += tmrg_src/cdc_2phase_clearable.sv
# FILES += tmrg_src/cdc_2phase_dst_clearable.sv
# FILES += tmrg_src/cdc_2phase_src_clearable.sv
# FILES += tmrg_src/cdc_reset_ctrlr.sv
# FILES += tmrg_src/cdc_reset_ctrlr_half.sv
# FILES += tmrg_src/cdc_4phase_dst.sv
# FILES += tmrg_src/cdc_4phase_src.sv
# FILES += tmrg_src/dmi_jtag_tap.sv
# FILES += tmrg_src/tc_clk_inverter.sv
# FILES += tmrg_src/tc_clk_mux2.sv

FILES += tmrg_src/dm_obi_top.sv
# FILES += tmrg_src/dm_top.sv
# FILES += tmrg_src/dm_csrs.sv
# FILES += tmrg_src/dm_mem.sv
# FILES += tmrg_src/debug_rom.sv
# FILES += tmrg_src/debug_rom_one_scratch.sv
# FILES += tmrg_src/dm_sba.sv

FILES += tmrg_src/core_wrap.sv
FILES += tmrg_src/cve2_core.sv
FILES += tmrg_src/cve2_cs_registers.sv
FILES += tmrg_src/cve2_counter.sv
FILES += tmrg_src/cve2_csr.sv
FILES += tmrg_src/cve2_ex_block.sv
FILES += tmrg_src/cve2_alu.sv
FILES += tmrg_src/cve2_multdiv_fast.sv
FILES += tmrg_src/cve2_multdiv_slow.sv
FILES += tmrg_src/cve2_id_stage.sv
FILES += tmrg_src/cve2_controller.sv
FILES += tmrg_src/cve2_decoder.sv
FILES += tmrg_src/cve2_if_stage.sv
FILES += tmrg_src/cve2_compressed_decoder.sv
FILES += tmrg_src/cve2_prefetch_buffer.sv
FILES += tmrg_src/cve2_fetch_fifo.sv
FILES += tmrg_src/cve2_load_store_unit.sv
FILES += tmrg_src/cve2_pmp.sv
FILES += tmrg_src/cve2_register_file_ff.sv
FILES += tmrg_src/cve2_wb.sv

FILES += tmrg_src/rstgen.sv	

FILES += tmrg_src/croc_domain.sv
FILES += tmrg_src/user_domain.sv
FILES += tmrg_src/croc_soc.sv

# comment:
# 	python scripts/comment_src_types.py $(FILES)

# expand:
# 	python scripts/expand_sv_ports.py $(FILES)

tmrg:
	mkdir -p tmrg_files
	${TMRG} $(FILES) --top-module=croc_soc --tmr-dir=tmrg_files || true

patch:
	patch tmrg_files/addr_decodeTMR.sv patches/addr_decodeTMR.patch
	patch tmrg_files/addr_decode_dyncTMR.sv patches/addr_decode_dyncTMR.patch
	patch tmrg_files/croc_domainTMR.sv patches/croc_domainTMR.patch
	patch tmrg_files/cve2_controllerTMR.sv patches/cve2_controllerTMR.patch
	patch tmrg_files/cve2_cs_registersTMR.sv patches/cve2_cs_registersTMR.patch
	patch tmrg_files/cve2_ex_blockTMR.sv patches/cve2_ex_blockTMR.patch
	patch tmrg_files/cve2_id_stageTMR.sv patches/cve2_id_stageTMR.patch
	patch tmrg_files/cve2_load_store_unitTMR.sv patches/cve2_load_store_unitTMR.patch
	patch tmrg_files/cve2_multdiv_fastTMR.sv patches/cve2_multdiv_fastTMR.patch
	patch tmrg_files/cve2_multdiv_slowTMR.sv patches/cve2_multdiv_slowTMR.patch
	patch tmrg_files/fifo_v3TMR.sv patches/fifo_v3TMR.patch
	patch tmrg_files/gpio_reg_topTMR.sv patches/gpio_reg_topTMR.patch
	patch tmrg_files/gpioTMR.sv patches/gpioTMR.patch
	patch tmrg_files/obi_demuxTMR.sv patches/obi_demuxTMR.patch
	patch tmrg_files/obi_err_sbrTMR.sv patches/obi_err_sbrTMR.patch
	patch tmrg_files/obi_muxTMR.sv patches/obi_muxTMR.patch
	patch tmrg_files/obi_sram_shimTMR.sv patches/obi_sram_shimTMR.patch
	patch tmrg_files/obi_uart_registerTMR.sv patches/obi_uart_registerTMR.patch
	patch tmrg_files/obi_uartTMR.sv patches/obi_uartTMR.patch
	patch tmrg_files/obi_xbarTMR.sv patches/obi_xbarTMR.patch
	patch tmrg_files/periph_to_regTMR.sv patches/periph_to_regTMR.patch
	patch tmrg_files/rr_arb_treeTMR.sv patches/rr_arb_treeTMR.patch
	patch tmrg_files/soc_ctrl_reg_topTMR.sv patches/soc_ctrl_reg_topTMR.patch
	patch tmrg_files/spill_register_flushableTMR.sv patches/spill_register_flushableTMR.patch
	patch tmrg_files/spill_registerTMR.sv patches/spill_registerTMR.patch
	patch tmrg_files/tc_sram_implTMR.sv patches/tc_sram_implTMR.patch
	patch tmrg_files/timer_unitTMR.sv patches/timer_unitTMR.patch
	patch tmrg_files/user_domainTMR.sv patches/user_domainTMR.patch