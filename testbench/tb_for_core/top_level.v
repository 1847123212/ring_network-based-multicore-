///2016/8/6
///ShaoMin Zhai
///module function: used to debug core 

`include "define.v"

module  top_level(
                  clk,
                  rst
                  );
input clk;
input rst;

wire  [31:0] pc;
wire  [31:0] mem_data;
wire  [31:0] mem_addr;
wire  [3:0]  mem_head;
wire         v_mem;
wire         v_pc;

wire  [31:0] data;
wire         v_data;
wire  [31:0] inst;
wire         v_inst;
core  core_du(//input
                .clk(clk),
                .rst(rst),
                .v_inst(v_inst),
                .inst(inst),
                .v_data(v_data),
                .data(data),
                //output
                .pc(pc),
                .v_pc(v_pc),
                .v_mem(v_mem),
                .mem_head(mem_head),
                .mem_addr(mem_addr),
                .mem_data(mem_data)
                );
                
instmem    instmem_du(
                   .clk(clk),
                   .rst(rst),
                   .pc(pc),
                   .read(v_pc),
                   .inst(inst),
                   .v_inst(v_inst)
                 );      
                 
datamem    datamem_du(
                  .clk(clk),
                  .rst(rst),
                  .addr(mem_addr),
                  .data_in(mem_data),
                  .r_w(mem_head[3]),
                  .v_cmd(v_mem),
                  .data_out(data),
                  .v_data_out(v_data)
                 );          
endmodule