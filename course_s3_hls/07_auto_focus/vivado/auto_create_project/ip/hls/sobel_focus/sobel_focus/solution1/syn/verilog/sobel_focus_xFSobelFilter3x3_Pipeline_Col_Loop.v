// ==============================================================
// Generated by Vitis HLS v2023.1
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// ==============================================================

`timescale 1 ns / 1 ps 

module sobel_focus_xFSobelFilter3x3_Pipeline_Col_Loop (
        ap_clk,
        ap_rst,
        ap_start,
        ap_done,
        ap_idle,
        ap_ready,
        grayImg_data_dout,
        grayImg_data_num_data_valid,
        grayImg_data_fifo_cap,
        grayImg_data_empty_n,
        grayImg_data_read,
        sobelImg_x_data_din,
        sobelImg_x_data_num_data_valid,
        sobelImg_x_data_fifo_cap,
        sobelImg_x_data_full_n,
        sobelImg_x_data_write,
        sobelImg_y_data_din,
        sobelImg_y_data_num_data_valid,
        sobelImg_y_data_fifo_cap,
        sobelImg_y_data_full_n,
        sobelImg_y_data_write,
        buf_r_address0,
        buf_r_ce0,
        buf_r_q0,
        buf_r_address1,
        buf_r_ce1,
        buf_r_we1,
        buf_r_d1,
        buf_1_address0,
        buf_1_ce0,
        buf_1_q0,
        buf_1_address1,
        buf_1_ce1,
        buf_1_we1,
        buf_1_d1,
        buf_2_address0,
        buf_2_ce0,
        buf_2_q0,
        buf_2_address1,
        buf_2_ce1,
        buf_2_we1,
        buf_2_d1,
        tp_1,
        mid_1,
        bottom_1,
        trunc_ln,
        cmp_i_i603_i,
        src_buf3_1_out,
        src_buf3_1_out_ap_vld,
        src_buf2_out,
        src_buf2_out_ap_vld,
        src_buf3_out,
        src_buf3_out_ap_vld,
        src_buf1_1_out,
        src_buf1_1_out_ap_vld,
        src_buf1_out,
        src_buf1_out_ap_vld
);

parameter    ap_ST_fsm_pp0_stage0 = 1'd1;

input   ap_clk;
input   ap_rst;
input   ap_start;
output   ap_done;
output   ap_idle;
output   ap_ready;
input  [7:0] grayImg_data_dout;
input  [1:0] grayImg_data_num_data_valid;
input  [1:0] grayImg_data_fifo_cap;
input   grayImg_data_empty_n;
output   grayImg_data_read;
output  [7:0] sobelImg_x_data_din;
input  [1:0] sobelImg_x_data_num_data_valid;
input  [1:0] sobelImg_x_data_fifo_cap;
input   sobelImg_x_data_full_n;
output   sobelImg_x_data_write;
output  [7:0] sobelImg_y_data_din;
input  [1:0] sobelImg_y_data_num_data_valid;
input  [1:0] sobelImg_y_data_fifo_cap;
input   sobelImg_y_data_full_n;
output   sobelImg_y_data_write;
output  [10:0] buf_r_address0;
output   buf_r_ce0;
input  [7:0] buf_r_q0;
output  [10:0] buf_r_address1;
output   buf_r_ce1;
output   buf_r_we1;
output  [7:0] buf_r_d1;
output  [10:0] buf_1_address0;
output   buf_1_ce0;
input  [7:0] buf_1_q0;
output  [10:0] buf_1_address1;
output   buf_1_ce1;
output   buf_1_we1;
output  [7:0] buf_1_d1;
output  [10:0] buf_2_address0;
output   buf_2_ce0;
input  [7:0] buf_2_q0;
output  [10:0] buf_2_address1;
output   buf_2_ce1;
output   buf_2_we1;
output  [7:0] buf_2_d1;
input  [1:0] tp_1;
input  [1:0] mid_1;
input  [1:0] bottom_1;
input  [1:0] trunc_ln;
input  [0:0] cmp_i_i603_i;
output  [7:0] src_buf3_1_out;
output   src_buf3_1_out_ap_vld;
output  [7:0] src_buf2_out;
output   src_buf2_out_ap_vld;
output  [7:0] src_buf3_out;
output   src_buf3_out_ap_vld;
output  [7:0] src_buf1_1_out;
output   src_buf1_1_out_ap_vld;
output  [7:0] src_buf1_out;
output   src_buf1_out_ap_vld;

reg ap_idle;
reg grayImg_data_read;
reg sobelImg_x_data_write;
reg sobelImg_y_data_write;
reg buf_r_ce0;
reg[10:0] buf_r_address1;
reg buf_r_ce1;
reg buf_r_we1;
reg[7:0] buf_r_d1;
reg buf_1_ce0;
reg[10:0] buf_1_address1;
reg buf_1_ce1;
reg buf_1_we1;
reg[7:0] buf_1_d1;
reg buf_2_ce0;
reg[10:0] buf_2_address1;
reg buf_2_ce1;
reg buf_2_we1;
reg[7:0] buf_2_d1;
reg src_buf3_1_out_ap_vld;
reg src_buf2_out_ap_vld;
reg src_buf3_out_ap_vld;
reg src_buf1_1_out_ap_vld;
reg src_buf1_out_ap_vld;

(* fsm_encoding = "none" *) reg   [0:0] ap_CS_fsm;
wire    ap_CS_fsm_pp0_stage0;
wire    ap_enable_reg_pp0_iter0;
reg    ap_enable_reg_pp0_iter1;
reg    ap_enable_reg_pp0_iter2;
reg    ap_enable_reg_pp0_iter3;
reg    ap_enable_reg_pp0_iter4;
reg    ap_enable_reg_pp0_iter5;
reg    ap_idle_pp0;
wire    ap_block_state1_pp0_stage0_iter0;
reg   [0:0] icmp_ln225_reg_577;
wire   [0:0] cmp_i_i603_i_read_reg_548;
reg    ap_predicate_op58_read_state2;
reg    ap_block_state2_pp0_stage0_iter1;
wire    ap_block_state3_pp0_stage0_iter2;
wire    ap_block_state4_pp0_stage0_iter3;
wire    ap_block_state5_pp0_stage0_iter4;
reg   [0:0] icmp_ln250_reg_588;
reg   [0:0] icmp_ln250_reg_588_pp0_iter4_reg;
reg    ap_block_state6_pp0_stage0_iter5;
reg    ap_block_pp0_stage0_subdone;
wire   [0:0] icmp_ln225_fu_358_p2;
reg    ap_condition_exit_pp0_iter0_stage0;
wire    ap_loop_exit_ready;
reg    ap_ready_int;
reg    grayImg_data_blk_n;
wire    ap_block_pp0_stage0;
reg    sobelImg_x_data_blk_n;
reg    sobelImg_y_data_blk_n;
reg    ap_block_pp0_stage0_11001;
wire   [1:0] trunc_ln_read_reg_552;
wire   [1:0] bottom_1_read_reg_556;
reg   [10:0] col_1_reg_571;
reg   [0:0] icmp_ln225_reg_577_pp0_iter1_reg;
reg   [0:0] icmp_ln225_reg_577_pp0_iter2_reg;
reg   [0:0] icmp_ln225_reg_577_pp0_iter3_reg;
wire   [63:0] zext_ln225_fu_375_p1;
reg   [63:0] zext_ln225_reg_581;
wire   [0:0] icmp_ln250_fu_384_p2;
reg   [0:0] icmp_ln250_reg_588_pp0_iter2_reg;
reg   [0:0] icmp_ln250_reg_588_pp0_iter3_reg;
wire   [7:0] src_buf1_2_fu_389_p5;
reg   [7:0] src_buf1_2_reg_607;
wire   [7:0] src_buf2_2_fu_400_p5;
reg   [7:0] src_buf2_2_reg_613;
wire   [7:0] src_buf3_2_fu_411_p5;
reg   [7:0] src_buf3_2_reg_619;
reg    ap_condition_exit_pp0_iter4_stage0;
wire   [7:0] grp_xFSobel3x3_1_1_0_0_s_fu_308_ap_return_0;
wire   [7:0] grp_xFSobel3x3_1_1_0_0_s_fu_308_ap_return_1;
reg    grp_xFSobel3x3_1_1_0_0_s_fu_308_ap_ce;
wire    ap_block_state1_pp0_stage0_iter0_ignore_call12;
reg    ap_block_state2_pp0_stage0_iter1_ignore_call12;
wire    ap_block_state3_pp0_stage0_iter2_ignore_call12;
wire    ap_block_state4_pp0_stage0_iter3_ignore_call12;
wire    ap_block_state5_pp0_stage0_iter4_ignore_call12;
reg    ap_block_state6_pp0_stage0_iter5_ignore_call12;
reg    ap_block_pp0_stage0_11001_ignoreCallOp88;
wire   [10:0] buf_addr_gep_fu_257_p3;
wire   [10:0] buf_1_addr_gep_fu_264_p3;
wire   [10:0] buf_2_addr_gep_fu_271_p3;
reg   [10:0] col_fu_90;
wire   [10:0] add_ln225_fu_364_p2;
wire    ap_loop_init;
reg   [10:0] ap_sig_allocacmp_col_1;
reg   [7:0] src_buf1_fu_94;
reg   [7:0] src_buf2_fu_98;
reg   [7:0] src_buf3_1_fu_102;
reg   [7:0] src_buf2_1_fu_106;
reg   [7:0] src_buf1_1_fu_110;
reg   [7:0] src_buf3_fu_114;
reg    ap_block_pp0_stage0_01001;
reg    ap_done_reg;
wire    ap_continue_int;
reg    ap_done_int;
reg    ap_loop_exit_ready_pp0_iter1_reg;
reg    ap_loop_exit_ready_pp0_iter2_reg;
reg    ap_loop_exit_ready_pp0_iter3_reg;
reg    ap_loop_exit_ready_pp0_iter4_reg;
reg   [0:0] ap_NS_fsm;
wire    ap_enable_pp0;
wire    ap_start_int;
reg    ap_condition_465;
reg    ap_condition_471;
reg    ap_condition_475;
wire    ap_ce_reg;

// power-on initialization
initial begin
#0 ap_CS_fsm = 1'd1;
#0 ap_enable_reg_pp0_iter1 = 1'b0;
#0 ap_enable_reg_pp0_iter2 = 1'b0;
#0 ap_enable_reg_pp0_iter3 = 1'b0;
#0 ap_enable_reg_pp0_iter4 = 1'b0;
#0 ap_enable_reg_pp0_iter5 = 1'b0;
#0 ap_done_reg = 1'b0;
end

sobel_focus_xFSobel3x3_1_1_0_0_s grp_xFSobel3x3_1_1_0_0_s_fu_308(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst),
    .src_buf1_0_val(src_buf1_fu_94),
    .src_buf1_1_val(src_buf1_1_fu_110),
    .src_buf1_2_val(src_buf1_2_reg_607),
    .src_buf2_0_val(src_buf2_fu_98),
    .src_buf2_2_val(src_buf2_2_reg_613),
    .src_buf3_0_val(src_buf3_1_fu_102),
    .src_buf3_1_val(src_buf3_fu_114),
    .src_buf3_2_val(src_buf3_2_reg_619),
    .ap_return_0(grp_xFSobel3x3_1_1_0_0_s_fu_308_ap_return_0),
    .ap_return_1(grp_xFSobel3x3_1_1_0_0_s_fu_308_ap_return_1),
    .ap_ce(grp_xFSobel3x3_1_1_0_0_s_fu_308_ap_ce)
);

sobel_focus_mux_3_2_8_1_1 #(
    .ID( 1 ),
    .NUM_STAGE( 1 ),
    .din0_WIDTH( 8 ),
    .din1_WIDTH( 8 ),
    .din2_WIDTH( 8 ),
    .din3_WIDTH( 2 ),
    .dout_WIDTH( 8 ))
mux_3_2_8_1_1_U83(
    .din0(buf_r_q0),
    .din1(buf_1_q0),
    .din2(buf_2_q0),
    .din3(tp_1),
    .dout(src_buf1_2_fu_389_p5)
);

sobel_focus_mux_3_2_8_1_1 #(
    .ID( 1 ),
    .NUM_STAGE( 1 ),
    .din0_WIDTH( 8 ),
    .din1_WIDTH( 8 ),
    .din2_WIDTH( 8 ),
    .din3_WIDTH( 2 ),
    .dout_WIDTH( 8 ))
mux_3_2_8_1_1_U84(
    .din0(buf_r_q0),
    .din1(buf_1_q0),
    .din2(buf_2_q0),
    .din3(mid_1),
    .dout(src_buf2_2_fu_400_p5)
);

sobel_focus_mux_3_2_8_1_1 #(
    .ID( 1 ),
    .NUM_STAGE( 1 ),
    .din0_WIDTH( 8 ),
    .din1_WIDTH( 8 ),
    .din2_WIDTH( 8 ),
    .din3_WIDTH( 2 ),
    .dout_WIDTH( 8 ))
mux_3_2_8_1_1_U85(
    .din0(buf_r_q0),
    .din1(buf_1_q0),
    .din2(buf_2_q0),
    .din3(bottom_1),
    .dout(src_buf3_2_fu_411_p5)
);

sobel_focus_flow_control_loop_pipe_sequential_init flow_control_loop_pipe_sequential_init_U(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst),
    .ap_start(ap_start),
    .ap_ready(ap_ready),
    .ap_done(ap_done),
    .ap_start_int(ap_start_int),
    .ap_loop_init(ap_loop_init),
    .ap_ready_int(ap_ready_int),
    .ap_loop_exit_ready(ap_condition_exit_pp0_iter0_stage0),
    .ap_loop_exit_done(ap_done_int),
    .ap_continue_int(ap_continue_int),
    .ap_done_int(ap_done_int)
);

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_CS_fsm <= ap_ST_fsm_pp0_stage0;
    end else begin
        ap_CS_fsm <= ap_NS_fsm;
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_done_reg <= 1'b0;
    end else begin
        if ((ap_continue_int == 1'b1)) begin
            ap_done_reg <= 1'b0;
        end else if (((1'b0 == ap_block_pp0_stage0_subdone) & (ap_loop_exit_ready_pp0_iter4_reg == 1'b1))) begin
            ap_done_reg <= 1'b1;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_enable_reg_pp0_iter1 <= 1'b0;
    end else begin
        if (((1'b0 == ap_block_pp0_stage0_subdone) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
            ap_enable_reg_pp0_iter1 <= ap_start_int;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_enable_reg_pp0_iter2 <= 1'b0;
    end else begin
        if ((1'b0 == ap_block_pp0_stage0_subdone)) begin
            ap_enable_reg_pp0_iter2 <= ap_enable_reg_pp0_iter1;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_enable_reg_pp0_iter3 <= 1'b0;
    end else begin
        if ((1'b0 == ap_block_pp0_stage0_subdone)) begin
            ap_enable_reg_pp0_iter3 <= ap_enable_reg_pp0_iter2;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_enable_reg_pp0_iter4 <= 1'b0;
    end else begin
        if ((1'b0 == ap_block_pp0_stage0_subdone)) begin
            ap_enable_reg_pp0_iter4 <= ap_enable_reg_pp0_iter3;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_enable_reg_pp0_iter5 <= 1'b0;
    end else begin
        if ((1'b1 == ap_condition_exit_pp0_iter4_stage0)) begin
            ap_enable_reg_pp0_iter5 <= 1'b0;
        end else if ((1'b0 == ap_block_pp0_stage0_subdone)) begin
            ap_enable_reg_pp0_iter5 <= ap_enable_reg_pp0_iter4;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        if (((icmp_ln225_fu_358_p2 == 1'd0) & (ap_enable_reg_pp0_iter0 == 1'b1))) begin
            col_fu_90 <= add_ln225_fu_364_p2;
        end else if ((ap_loop_init == 1'b1)) begin
            col_fu_90 <= 11'd0;
        end
    end
end

always @ (posedge ap_clk) begin
    if ((1'b0 == ap_block_pp0_stage0_11001)) begin
        if (((ap_loop_init == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
            src_buf1_1_fu_110 <= 8'd0;
        end else if (((ap_enable_reg_pp0_iter4 == 1'b1) & (icmp_ln225_reg_577_pp0_iter3_reg == 1'd0))) begin
            src_buf1_1_fu_110 <= src_buf1_2_reg_607;
        end
    end
end

always @ (posedge ap_clk) begin
    if ((1'b0 == ap_block_pp0_stage0_11001)) begin
        if (((ap_loop_init == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
            src_buf1_fu_94 <= 8'd0;
        end else if (((ap_enable_reg_pp0_iter4 == 1'b1) & (icmp_ln225_reg_577_pp0_iter3_reg == 1'd0))) begin
            src_buf1_fu_94 <= src_buf1_1_fu_110;
        end
    end
end

always @ (posedge ap_clk) begin
    if ((1'b0 == ap_block_pp0_stage0_11001)) begin
        if (((ap_loop_init == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
            src_buf2_1_fu_106 <= 8'd0;
        end else if (((ap_enable_reg_pp0_iter4 == 1'b1) & (icmp_ln225_reg_577_pp0_iter3_reg == 1'd0))) begin
            src_buf2_1_fu_106 <= src_buf2_2_reg_613;
        end
    end
end

always @ (posedge ap_clk) begin
    if ((1'b0 == ap_block_pp0_stage0_11001)) begin
        if (((ap_loop_init == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
            src_buf2_fu_98 <= 8'd0;
        end else if (((ap_enable_reg_pp0_iter4 == 1'b1) & (icmp_ln225_reg_577_pp0_iter3_reg == 1'd0))) begin
            src_buf2_fu_98 <= src_buf2_1_fu_106;
        end
    end
end

always @ (posedge ap_clk) begin
    if ((1'b0 == ap_block_pp0_stage0_11001)) begin
        if (((ap_loop_init == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
            src_buf3_1_fu_102 <= 8'd0;
        end else if (((ap_enable_reg_pp0_iter4 == 1'b1) & (icmp_ln225_reg_577_pp0_iter3_reg == 1'd0))) begin
            src_buf3_1_fu_102 <= src_buf3_fu_114;
        end
    end
end

always @ (posedge ap_clk) begin
    if ((1'b0 == ap_block_pp0_stage0_11001)) begin
        if (((ap_loop_init == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
            src_buf3_fu_114 <= 8'd0;
        end else if (((ap_enable_reg_pp0_iter4 == 1'b1) & (icmp_ln225_reg_577_pp0_iter3_reg == 1'd0))) begin
            src_buf3_fu_114 <= src_buf3_2_reg_619;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_loop_exit_ready_pp0_iter1_reg <= ap_loop_exit_ready;
        ap_loop_exit_ready_pp0_iter2_reg <= ap_loop_exit_ready_pp0_iter1_reg;
        col_1_reg_571 <= ap_sig_allocacmp_col_1;
        icmp_ln225_reg_577 <= icmp_ln225_fu_358_p2;
        icmp_ln225_reg_577_pp0_iter1_reg <= icmp_ln225_reg_577;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b0 == ap_block_pp0_stage0_11001)) begin
        ap_loop_exit_ready_pp0_iter3_reg <= ap_loop_exit_ready_pp0_iter2_reg;
        ap_loop_exit_ready_pp0_iter4_reg <= ap_loop_exit_ready_pp0_iter3_reg;
        icmp_ln225_reg_577_pp0_iter2_reg <= icmp_ln225_reg_577_pp0_iter1_reg;
        icmp_ln225_reg_577_pp0_iter3_reg <= icmp_ln225_reg_577_pp0_iter2_reg;
        icmp_ln250_reg_588_pp0_iter2_reg <= icmp_ln250_reg_588;
        icmp_ln250_reg_588_pp0_iter3_reg <= icmp_ln250_reg_588_pp0_iter2_reg;
        icmp_ln250_reg_588_pp0_iter4_reg <= icmp_ln250_reg_588_pp0_iter3_reg;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (icmp_ln225_reg_577 == 1'd0) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        icmp_ln250_reg_588 <= icmp_ln250_fu_384_p2;
        zext_ln225_reg_581[10 : 0] <= zext_ln225_fu_375_p1[10 : 0];
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (icmp_ln225_reg_577_pp0_iter2_reg == 1'd0))) begin
        src_buf1_2_reg_607 <= src_buf1_2_fu_389_p5;
        src_buf2_2_reg_613 <= src_buf2_2_fu_400_p5;
        src_buf3_2_reg_619 <= src_buf3_2_fu_411_p5;
    end
end

always @ (*) begin
    if (((icmp_ln225_fu_358_p2 == 1'd1) & (1'b0 == ap_block_pp0_stage0_subdone) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_condition_exit_pp0_iter0_stage0 = 1'b1;
    end else begin
        ap_condition_exit_pp0_iter0_stage0 = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0_subdone) & (ap_enable_reg_pp0_iter4 == 1'b1) & (icmp_ln225_reg_577_pp0_iter3_reg == 1'd1))) begin
        ap_condition_exit_pp0_iter4_stage0 = 1'b1;
    end else begin
        ap_condition_exit_pp0_iter4_stage0 = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0_subdone) & (ap_loop_exit_ready_pp0_iter4_reg == 1'b1))) begin
        ap_done_int = 1'b1;
    end else begin
        ap_done_int = ap_done_reg;
    end
end

always @ (*) begin
    if (((ap_start_int == 1'b0) & (ap_idle_pp0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_idle = 1'b1;
    end else begin
        ap_idle = 1'b0;
    end
end

always @ (*) begin
    if (((ap_enable_reg_pp0_iter5 == 1'b0) & (ap_enable_reg_pp0_iter4 == 1'b0) & (ap_enable_reg_pp0_iter3 == 1'b0) & (ap_enable_reg_pp0_iter2 == 1'b0) & (ap_enable_reg_pp0_iter1 == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b0))) begin
        ap_idle_pp0 = 1'b1;
    end else begin
        ap_idle_pp0 = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0_subdone) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_ready_int = 1'b1;
    end else begin
        ap_ready_int = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0) & (ap_loop_init == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_sig_allocacmp_col_1 = 11'd0;
    end else begin
        ap_sig_allocacmp_col_1 = col_fu_90;
    end
end

always @ (*) begin
    if ((1'b1 == ap_condition_465)) begin
        if (((cmp_i_i603_i == 1'd1) & (trunc_ln_read_reg_552 == 2'd1))) begin
            buf_1_address1 = buf_1_addr_gep_fu_264_p3;
        end else if (((cmp_i_i603_i_read_reg_548 == 1'd0) & (bottom_1_read_reg_556 == 2'd1))) begin
            buf_1_address1 = zext_ln225_fu_375_p1;
        end else begin
            buf_1_address1 = 'bx;
        end
    end else begin
        buf_1_address1 = 'bx;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (ap_enable_reg_pp0_iter2 == 1'b1))) begin
        buf_1_ce0 = 1'b1;
    end else begin
        buf_1_ce0 = 1'b0;
    end
end

always @ (*) begin
    if ((((1'b0 == ap_block_pp0_stage0_11001) & (cmp_i_i603_i == 1'd1) & (icmp_ln225_reg_577 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0) & (trunc_ln_read_reg_552 == 2'd1)) | ((1'b0 == ap_block_pp0_stage0_11001) & (cmp_i_i603_i_read_reg_548 == 1'd0) & (icmp_ln225_reg_577 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0) & (bottom_1_read_reg_556 == 2'd1)))) begin
        buf_1_ce1 = 1'b1;
    end else begin
        buf_1_ce1 = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_condition_465)) begin
        if (((cmp_i_i603_i == 1'd1) & (trunc_ln_read_reg_552 == 2'd1))) begin
            buf_1_d1 = grayImg_data_dout;
        end else if (((cmp_i_i603_i_read_reg_548 == 1'd0) & (bottom_1_read_reg_556 == 2'd1))) begin
            buf_1_d1 = 8'd0;
        end else begin
            buf_1_d1 = 'bx;
        end
    end else begin
        buf_1_d1 = 'bx;
    end
end

always @ (*) begin
    if ((((1'b0 == ap_block_pp0_stage0_11001) & (cmp_i_i603_i == 1'd1) & (icmp_ln225_reg_577 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0) & (trunc_ln_read_reg_552 == 2'd1)) | ((1'b0 == ap_block_pp0_stage0_11001) & (cmp_i_i603_i_read_reg_548 == 1'd0) & (icmp_ln225_reg_577 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0) & (bottom_1_read_reg_556 == 2'd1)))) begin
        buf_1_we1 = 1'b1;
    end else begin
        buf_1_we1 = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_condition_465)) begin
        if ((1'b1 == ap_condition_475)) begin
            buf_2_address1 = buf_2_addr_gep_fu_271_p3;
        end else if ((1'b1 == ap_condition_471)) begin
            buf_2_address1 = zext_ln225_fu_375_p1;
        end else begin
            buf_2_address1 = 'bx;
        end
    end else begin
        buf_2_address1 = 'bx;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (ap_enable_reg_pp0_iter2 == 1'b1))) begin
        buf_2_ce0 = 1'b1;
    end else begin
        buf_2_ce0 = 1'b0;
    end
end

always @ (*) begin
    if (((~(trunc_ln_read_reg_552 == 2'd0) & ~(trunc_ln_read_reg_552 == 2'd1) & (1'b0 == ap_block_pp0_stage0_11001) & (cmp_i_i603_i == 1'd1) & (icmp_ln225_reg_577 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0)) | (~(bottom_1_read_reg_556 == 2'd0) & ~(bottom_1_read_reg_556 == 2'd1) & (1'b0 == ap_block_pp0_stage0_11001) & (cmp_i_i603_i_read_reg_548 == 1'd0) & (icmp_ln225_reg_577 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0)))) begin
        buf_2_ce1 = 1'b1;
    end else begin
        buf_2_ce1 = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_condition_465)) begin
        if ((1'b1 == ap_condition_475)) begin
            buf_2_d1 = grayImg_data_dout;
        end else if ((1'b1 == ap_condition_471)) begin
            buf_2_d1 = 8'd0;
        end else begin
            buf_2_d1 = 'bx;
        end
    end else begin
        buf_2_d1 = 'bx;
    end
end

always @ (*) begin
    if (((~(trunc_ln_read_reg_552 == 2'd0) & ~(trunc_ln_read_reg_552 == 2'd1) & (1'b0 == ap_block_pp0_stage0_11001) & (cmp_i_i603_i == 1'd1) & (icmp_ln225_reg_577 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0)) | (~(bottom_1_read_reg_556 == 2'd0) & ~(bottom_1_read_reg_556 == 2'd1) & (1'b0 == ap_block_pp0_stage0_11001) & (cmp_i_i603_i_read_reg_548 == 1'd0) & (icmp_ln225_reg_577 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0)))) begin
        buf_2_we1 = 1'b1;
    end else begin
        buf_2_we1 = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_condition_465)) begin
        if (((cmp_i_i603_i == 1'd1) & (trunc_ln_read_reg_552 == 2'd0))) begin
            buf_r_address1 = buf_addr_gep_fu_257_p3;
        end else if (((cmp_i_i603_i_read_reg_548 == 1'd0) & (bottom_1_read_reg_556 == 2'd0))) begin
            buf_r_address1 = zext_ln225_fu_375_p1;
        end else begin
            buf_r_address1 = 'bx;
        end
    end else begin
        buf_r_address1 = 'bx;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (ap_enable_reg_pp0_iter2 == 1'b1))) begin
        buf_r_ce0 = 1'b1;
    end else begin
        buf_r_ce0 = 1'b0;
    end
end

always @ (*) begin
    if ((((1'b0 == ap_block_pp0_stage0_11001) & (cmp_i_i603_i == 1'd1) & (icmp_ln225_reg_577 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0) & (trunc_ln_read_reg_552 == 2'd0)) | ((1'b0 == ap_block_pp0_stage0_11001) & (cmp_i_i603_i_read_reg_548 == 1'd0) & (icmp_ln225_reg_577 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0) & (bottom_1_read_reg_556 == 2'd0)))) begin
        buf_r_ce1 = 1'b1;
    end else begin
        buf_r_ce1 = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_condition_465)) begin
        if (((cmp_i_i603_i == 1'd1) & (trunc_ln_read_reg_552 == 2'd0))) begin
            buf_r_d1 = grayImg_data_dout;
        end else if (((cmp_i_i603_i_read_reg_548 == 1'd0) & (bottom_1_read_reg_556 == 2'd0))) begin
            buf_r_d1 = 8'd0;
        end else begin
            buf_r_d1 = 'bx;
        end
    end else begin
        buf_r_d1 = 'bx;
    end
end

always @ (*) begin
    if ((((1'b0 == ap_block_pp0_stage0_11001) & (cmp_i_i603_i == 1'd1) & (icmp_ln225_reg_577 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0) & (trunc_ln_read_reg_552 == 2'd0)) | ((1'b0 == ap_block_pp0_stage0_11001) & (cmp_i_i603_i_read_reg_548 == 1'd0) & (icmp_ln225_reg_577 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0) & (bottom_1_read_reg_556 == 2'd0)))) begin
        buf_r_we1 = 1'b1;
    end else begin
        buf_r_we1 = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0) & (ap_predicate_op58_read_state2 == 1'b1) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        grayImg_data_blk_n = grayImg_data_empty_n;
    end else begin
        grayImg_data_blk_n = 1'b1;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (ap_predicate_op58_read_state2 == 1'b1) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        grayImg_data_read = 1'b1;
    end else begin
        grayImg_data_read = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0_11001_ignoreCallOp88) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        grp_xFSobel3x3_1_1_0_0_s_fu_308_ap_ce = 1'b1;
    end else begin
        grp_xFSobel3x3_1_1_0_0_s_fu_308_ap_ce = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0) & (icmp_ln250_reg_588_pp0_iter4_reg == 1'd0) & (ap_enable_reg_pp0_iter5 == 1'b1))) begin
        sobelImg_x_data_blk_n = sobelImg_x_data_full_n;
    end else begin
        sobelImg_x_data_blk_n = 1'b1;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (icmp_ln250_reg_588_pp0_iter4_reg == 1'd0) & (ap_enable_reg_pp0_iter5 == 1'b1))) begin
        sobelImg_x_data_write = 1'b1;
    end else begin
        sobelImg_x_data_write = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0) & (icmp_ln250_reg_588_pp0_iter4_reg == 1'd0) & (ap_enable_reg_pp0_iter5 == 1'b1))) begin
        sobelImg_y_data_blk_n = sobelImg_y_data_full_n;
    end else begin
        sobelImg_y_data_blk_n = 1'b1;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (icmp_ln250_reg_588_pp0_iter4_reg == 1'd0) & (ap_enable_reg_pp0_iter5 == 1'b1))) begin
        sobelImg_y_data_write = 1'b1;
    end else begin
        sobelImg_y_data_write = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (icmp_ln225_reg_577_pp0_iter3_reg == 1'd1))) begin
        src_buf1_1_out_ap_vld = 1'b1;
    end else begin
        src_buf1_1_out_ap_vld = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (icmp_ln225_reg_577_pp0_iter3_reg == 1'd1))) begin
        src_buf1_out_ap_vld = 1'b1;
    end else begin
        src_buf1_out_ap_vld = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (icmp_ln225_reg_577_pp0_iter3_reg == 1'd1))) begin
        src_buf2_out_ap_vld = 1'b1;
    end else begin
        src_buf2_out_ap_vld = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (icmp_ln225_reg_577_pp0_iter3_reg == 1'd1))) begin
        src_buf3_1_out_ap_vld = 1'b1;
    end else begin
        src_buf3_1_out_ap_vld = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (icmp_ln225_reg_577_pp0_iter3_reg == 1'd1))) begin
        src_buf3_out_ap_vld = 1'b1;
    end else begin
        src_buf3_out_ap_vld = 1'b0;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_pp0_stage0 : begin
            ap_NS_fsm = ap_ST_fsm_pp0_stage0;
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign add_ln225_fu_364_p2 = (ap_sig_allocacmp_col_1 + 11'd1);

assign ap_CS_fsm_pp0_stage0 = ap_CS_fsm[32'd0];

assign ap_block_pp0_stage0 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_pp0_stage0_01001 = (((ap_enable_reg_pp0_iter5 == 1'b1) & (((sobelImg_y_data_full_n == 1'b0) & (icmp_ln250_reg_588_pp0_iter4_reg == 1'd0)) | ((icmp_ln250_reg_588_pp0_iter4_reg == 1'd0) & (sobelImg_x_data_full_n == 1'b0)))) | ((ap_predicate_op58_read_state2 == 1'b1) & (grayImg_data_empty_n == 1'b0) & (ap_enable_reg_pp0_iter1 == 1'b1)));
end

always @ (*) begin
    ap_block_pp0_stage0_11001 = (((ap_enable_reg_pp0_iter5 == 1'b1) & (((sobelImg_y_data_full_n == 1'b0) & (icmp_ln250_reg_588_pp0_iter4_reg == 1'd0)) | ((icmp_ln250_reg_588_pp0_iter4_reg == 1'd0) & (sobelImg_x_data_full_n == 1'b0)))) | ((ap_predicate_op58_read_state2 == 1'b1) & (grayImg_data_empty_n == 1'b0) & (ap_enable_reg_pp0_iter1 == 1'b1)));
end

always @ (*) begin
    ap_block_pp0_stage0_11001_ignoreCallOp88 = (((ap_enable_reg_pp0_iter5 == 1'b1) & (((sobelImg_y_data_full_n == 1'b0) & (icmp_ln250_reg_588_pp0_iter4_reg == 1'd0)) | ((icmp_ln250_reg_588_pp0_iter4_reg == 1'd0) & (sobelImg_x_data_full_n == 1'b0)))) | ((ap_predicate_op58_read_state2 == 1'b1) & (grayImg_data_empty_n == 1'b0) & (ap_enable_reg_pp0_iter1 == 1'b1)));
end

always @ (*) begin
    ap_block_pp0_stage0_subdone = (((ap_enable_reg_pp0_iter5 == 1'b1) & (((sobelImg_y_data_full_n == 1'b0) & (icmp_ln250_reg_588_pp0_iter4_reg == 1'd0)) | ((icmp_ln250_reg_588_pp0_iter4_reg == 1'd0) & (sobelImg_x_data_full_n == 1'b0)))) | ((ap_predicate_op58_read_state2 == 1'b1) & (grayImg_data_empty_n == 1'b0) & (ap_enable_reg_pp0_iter1 == 1'b1)));
end

assign ap_block_state1_pp0_stage0_iter0 = ~(1'b1 == 1'b1);

assign ap_block_state1_pp0_stage0_iter0_ignore_call12 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_state2_pp0_stage0_iter1 = ((ap_predicate_op58_read_state2 == 1'b1) & (grayImg_data_empty_n == 1'b0));
end

always @ (*) begin
    ap_block_state2_pp0_stage0_iter1_ignore_call12 = ((ap_predicate_op58_read_state2 == 1'b1) & (grayImg_data_empty_n == 1'b0));
end

assign ap_block_state3_pp0_stage0_iter2 = ~(1'b1 == 1'b1);

assign ap_block_state3_pp0_stage0_iter2_ignore_call12 = ~(1'b1 == 1'b1);

assign ap_block_state4_pp0_stage0_iter3 = ~(1'b1 == 1'b1);

assign ap_block_state4_pp0_stage0_iter3_ignore_call12 = ~(1'b1 == 1'b1);

assign ap_block_state5_pp0_stage0_iter4 = ~(1'b1 == 1'b1);

assign ap_block_state5_pp0_stage0_iter4_ignore_call12 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_state6_pp0_stage0_iter5 = (((sobelImg_y_data_full_n == 1'b0) & (icmp_ln250_reg_588_pp0_iter4_reg == 1'd0)) | ((icmp_ln250_reg_588_pp0_iter4_reg == 1'd0) & (sobelImg_x_data_full_n == 1'b0)));
end

always @ (*) begin
    ap_block_state6_pp0_stage0_iter5_ignore_call12 = (((sobelImg_y_data_full_n == 1'b0) & (icmp_ln250_reg_588_pp0_iter4_reg == 1'd0)) | ((icmp_ln250_reg_588_pp0_iter4_reg == 1'd0) & (sobelImg_x_data_full_n == 1'b0)));
end

always @ (*) begin
    ap_condition_465 = ((1'b0 == ap_block_pp0_stage0) & (icmp_ln225_reg_577 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0));
end

always @ (*) begin
    ap_condition_471 = (~(bottom_1_read_reg_556 == 2'd0) & ~(bottom_1_read_reg_556 == 2'd1) & (cmp_i_i603_i_read_reg_548 == 1'd0));
end

always @ (*) begin
    ap_condition_475 = (~(trunc_ln_read_reg_552 == 2'd0) & ~(trunc_ln_read_reg_552 == 2'd1) & (cmp_i_i603_i == 1'd1));
end

assign ap_enable_pp0 = (ap_idle_pp0 ^ 1'b1);

assign ap_enable_reg_pp0_iter0 = ap_start_int;

assign ap_loop_exit_ready = ap_condition_exit_pp0_iter0_stage0;

always @ (*) begin
    ap_predicate_op58_read_state2 = ((cmp_i_i603_i == 1'd1) & (icmp_ln225_reg_577 == 1'd0));
end

assign bottom_1_read_reg_556 = bottom_1;

assign buf_1_addr_gep_fu_264_p3 = zext_ln225_fu_375_p1;

assign buf_1_address0 = zext_ln225_reg_581;

assign buf_2_addr_gep_fu_271_p3 = zext_ln225_fu_375_p1;

assign buf_2_address0 = zext_ln225_reg_581;

assign buf_addr_gep_fu_257_p3 = zext_ln225_fu_375_p1;

assign buf_r_address0 = zext_ln225_reg_581;

assign cmp_i_i603_i_read_reg_548 = cmp_i_i603_i;

assign icmp_ln225_fu_358_p2 = ((ap_sig_allocacmp_col_1 == 11'd1920) ? 1'b1 : 1'b0);

assign icmp_ln250_fu_384_p2 = ((col_1_reg_571 == 11'd0) ? 1'b1 : 1'b0);

assign sobelImg_x_data_din = grp_xFSobel3x3_1_1_0_0_s_fu_308_ap_return_0;

assign sobelImg_y_data_din = grp_xFSobel3x3_1_1_0_0_s_fu_308_ap_return_1;

assign src_buf1_1_out = src_buf1_1_fu_110;

assign src_buf1_out = src_buf1_fu_94;

assign src_buf2_out = src_buf2_fu_98;

assign src_buf3_1_out = src_buf3_1_fu_102;

assign src_buf3_out = src_buf3_fu_114;

assign trunc_ln_read_reg_552 = trunc_ln;

assign zext_ln225_fu_375_p1 = col_1_reg_571;

always @ (posedge ap_clk) begin
    zext_ln225_reg_581[63:11] <= 53'b00000000000000000000000000000000000000000000000000000;
end

endmodule //sobel_focus_xFSobelFilter3x3_Pipeline_Col_Loop
