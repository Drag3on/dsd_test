vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xpm
vlib modelsim_lib/msim/xil_defaultlib

vmap xpm modelsim_lib/msim/xpm
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xpm  -incr -mfcu  -sv \
"C:/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"C:/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"C:/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm  -93  \
"C:/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -incr -mfcu  \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_addr_decode.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_read.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_reg.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_reg_bank.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_top.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_write.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/axi/mig_7series_v4_2_axi_mc.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/axi/mig_7series_v4_2_axi_mc_ar_channel.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/axi/mig_7series_v4_2_axi_mc_aw_channel.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/axi/mig_7series_v4_2_axi_mc_b_channel.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/axi/mig_7series_v4_2_axi_mc_cmd_arbiter.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/axi/mig_7series_v4_2_axi_mc_cmd_fsm.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/axi/mig_7series_v4_2_axi_mc_cmd_translator.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/axi/mig_7series_v4_2_axi_mc_fifo.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/axi/mig_7series_v4_2_axi_mc_incr_cmd.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/axi/mig_7series_v4_2_axi_mc_r_channel.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/axi/mig_7series_v4_2_axi_mc_simple_fifo.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/axi/mig_7series_v4_2_axi_mc_wrap_cmd.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/axi/mig_7series_v4_2_axi_mc_wr_cmd_fsm.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/axi/mig_7series_v4_2_axi_mc_w_channel.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/axi/mig_7series_v4_2_ddr_axic_register_slice.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/axi/mig_7series_v4_2_ddr_axi_register_slice.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/axi/mig_7series_v4_2_ddr_axi_upsizer.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/axi/mig_7series_v4_2_ddr_a_upsizer.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/axi/mig_7series_v4_2_ddr_carry_and.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/axi/mig_7series_v4_2_ddr_carry_latch_and.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/axi/mig_7series_v4_2_ddr_carry_latch_or.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/axi/mig_7series_v4_2_ddr_carry_or.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/axi/mig_7series_v4_2_ddr_command_fifo.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/axi/mig_7series_v4_2_ddr_comparator.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/axi/mig_7series_v4_2_ddr_comparator_sel.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/axi/mig_7series_v4_2_ddr_comparator_sel_static.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/axi/mig_7series_v4_2_ddr_r_upsizer.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/axi/mig_7series_v4_2_ddr_w_upsizer.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/clocking/mig_7series_v4_2_clk_ibuf.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/clocking/mig_7series_v4_2_infrastructure.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/clocking/mig_7series_v4_2_iodelay_ctrl.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/clocking/mig_7series_v4_2_tempmon.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/controller/mig_7series_v4_2_arb_mux.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/controller/mig_7series_v4_2_arb_row_col.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/controller/mig_7series_v4_2_arb_select.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/controller/mig_7series_v4_2_bank_cntrl.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/controller/mig_7series_v4_2_bank_common.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/controller/mig_7series_v4_2_bank_compare.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/controller/mig_7series_v4_2_bank_mach.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/controller/mig_7series_v4_2_bank_queue.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/controller/mig_7series_v4_2_bank_state.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/controller/mig_7series_v4_2_col_mach.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/controller/mig_7series_v4_2_mc.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/controller/mig_7series_v4_2_rank_cntrl.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/controller/mig_7series_v4_2_rank_common.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/controller/mig_7series_v4_2_rank_mach.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/controller/mig_7series_v4_2_round_robin_arb.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/ecc/mig_7series_v4_2_ecc_buf.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/ecc/mig_7series_v4_2_ecc_dec_fix.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/ecc/mig_7series_v4_2_ecc_gen.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/ecc/mig_7series_v4_2_ecc_merge_enc.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/ecc/mig_7series_v4_2_fi_xor.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/ip_top/mig_7series_v4_2_memc_ui_top_axi.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/ip_top/mig_7series_v4_2_mem_intfc.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/phy/mig_7series_v4_2_ddr_byte_group_io.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/phy/mig_7series_v4_2_ddr_byte_lane.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/phy/mig_7series_v4_2_ddr_calib_top.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/phy/mig_7series_v4_2_ddr_if_post_fifo.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/phy/mig_7series_v4_2_ddr_mc_phy.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/phy/mig_7series_v4_2_ddr_mc_phy_wrapper.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/phy/mig_7series_v4_2_ddr_of_pre_fifo.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_4lanes.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ck_addr_cmd_delay.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_dqs_found_cal.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_dqs_found_cal_hr.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_init.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_cntlr.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_data.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_edge.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_lim.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_mux.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_po_cntlr.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_samp.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_oclkdelay_cal.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_prbs_rdlvl.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_rdlvl.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_tempmon.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_top.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_wrcal.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_wrlvl.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_wrlvl_off_delay.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/phy/mig_7series_v4_2_ddr_prbs_gen.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/phy/mig_7series_v4_2_poc_cc.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/phy/mig_7series_v4_2_poc_edge_store.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/phy/mig_7series_v4_2_poc_meta.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/phy/mig_7series_v4_2_poc_pd.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/phy/mig_7series_v4_2_poc_tap_base.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/phy/mig_7series_v4_2_poc_top.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/ui/mig_7series_v4_2_ui_cmd.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/ui/mig_7series_v4_2_ui_rd_data.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/ui/mig_7series_v4_2_ui_top.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/ui/mig_7series_v4_2_ui_wr_data.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/mig_dram_mig_sim.v" \
"../../../../../../src/common_ip/mig_dram/mig_dram/user_design/rtl/mig_dram.v" \

vlog -work xil_defaultlib \
"glbl.v"

