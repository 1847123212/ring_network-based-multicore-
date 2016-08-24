/*************************************************************************************
date:2016/7/25
designer:ZhaiShaoMin
module name:tb_core_ras
module function:find out errors in the core_RAS
*************************************************************************************/

`timescale 1ns/1ps
`include"define.v"
module tb_core_pc();

//input
reg           clk;
reg           rst; 
reg  [31:0]   btb_target;
reg  [31:0]   ras_target;
reg           id_pc_src;
reg           stall;
reg           pc_go;
reg  [31:0]   good_target;
reg  [1:0]    btb_type;
reg           btb_v;


//output
wire  [31:0]    pc_out;
wire            v_pc_out;
wire  [31:0]    pc_plus4;


core_pc  duv(//input
               .clk(clk),
               .rst(rst),
               .btb_target(btb_target),
               .ras_target(ras_target),
               .pc_go(pc_go),//pipeline is not stall 
               .stall(stall),
               // from id module
               .good_target(good_target), // target from decode stage, correct target
               .id_pc_src(id_pc_src),  // if 1 ,meaning pc scoure is from decode ,0,otherwise
               // from BTB module
               .btb_v(btb_v),
               .btb_type(btb_type),
               //output
               .pc_out(pc_out),
               .v_pc_out(v_pc_out),
               .pc_plus4(pc_plus4)
               );

					
//initial inputs
  initial  begin
      clk=1'b0;
      rst=1'b1;
      btb_target=32'hffffffff;
		ras_target=32'h11111111;
		pc_go=1'b0;
		stall=1'b0;
		good_target=32'h88888888;
		id_pc_src=1'b0;
		btb_v=1'b0;
		btb_type=2'b11;
		
		end 
		
		// para used in btb
parameter  br_type=2'b00;
parameter  j_type=2'b01;
parameter  jal_type=2'b10;
parameter  jr_type=2'b11;

	always #5 clk=~clk;
    
	integer log_file;
  `define clk_step #10;
   
  
  `define record_log  1
  
	initial begin
  log_file = $fopen("core_pc_tf.txt"); 
  ////////////////////////begin test//////////////////////////
  
  `clk_step
  
  rst=1'b0;
  
  `clk_step
  
  /////case 1: if rst is set to 1, then pc should be set to 32'h00040000;
  rst=1'b1;
  
  `clk_step
  
  `ifdef record_log
  
  $display(  "(%t) we should get rst_pc. Got 0x%x. Expected 32'h00040000", $time, pc_out);
  $fdisplay(log_file, "(%t) we should get rst_pc. Got 0x%x. Expected 32'h00040000", $time, pc_out);
  
  
  `endif
  
  /////// case 2.1: if rst==0&&   pc_go  stall   pc_go&&!stall         what it means
  ///////                         0      0          0             inst cache not hits, pipeline is busy.
  
  rst=1'b0;
  pc_go=1'b0;
  stall=1'b0;
  
  `clk_step
  
  `ifdef record_log
  
  $display(  "(%t) pc_out should not be changed. Got 0x%x. Expected 32'h00040000", $time, pc_out);
  $fdisplay(log_file, "(%t) pc_out should not be changed. Got 0x%x. Expected 32'h00040000", $time, pc_out);
  
  
  `endif
  
  /////// case 2.2: if rst==0&&   pc_go  stall   pc_go&&!stall         what it means
  /////////                       0      1          0             inst cache not hits, pipeline is stall.
  
  rst=1'b0;
  pc_go=1'b0;
  stall=1'b1;
  
  `clk_step
  
  `ifdef record_log
  
  $display(  "(%t) pc_out should not be changed. Got 0x%x. Expected 32'h00040000", $time, pc_out);
  $fdisplay(log_file, "(%t) pc_out should not be changed. Got 0x%x. Expected 32'h00040000", $time, pc_out);
  
  
  `endif
  
  /////// case 2.3: if rst==0&&   pc_go  stall   pc_go&&!stall               what it means
  /////////                       1        1         0             inst cache hits,     pipeline is busy.
  
  rst=1'b0;
  pc_go=1'b1;
  stall=1'b1;
  
  `clk_step
  
  `ifdef record_log
  
  $display(  "(%t) pc_out should not be changed. Got 0x%x. Expected 32'h00040000", $time, pc_out);
  $fdisplay(log_file, "(%t) pc_out should not be changed. Got 0x%x. Expected 32'h00040000", $time, pc_out);
  
  
  `endif
  
  /////// case 2.4: if rst==0&&   pc_go  stall   pc_go&&!stall               what it means
  ///////                           1      0          1             inst cache hits,     pipeline is busy.
//  
//          case 2-1-0: if id_pc_src==1,then pc is set to good_target;

  
  rst=1'b0;
  pc_go=1'b1;
  stall=1'b0;
  id_pc_src=1'b1;
  good_target=32'h20168010;
  
  `clk_step
  
  `ifdef record_log
  
  $display(  "(%t) pc_out should  be changed . Got 0x%x. Expected 32'h20168010", $time, pc_out);
  $fdisplay(log_file, "(%t) pc_out should  be changed. Got 0x%x. Expected 32'h20168010", $time, pc_out);
  
  
  `endif
  
  
//          case 2-1-1: if btb_v==0&&id_pc_src==0, then pc is set to pc_plus4;


  rst=1'b0;
  pc_go=1'b1;
  stall=1'b0;
  id_pc_src=1'b0;
  good_target=32'h20168010;
  btb_v=1'b0;
  
  `clk_step
  
  `ifdef record_log
  
  $display(  "(%t) pc_out should  be changed . Got 0x%x. Expected 32'h20168014", $time, pc_out);
  $fdisplay(log_file, "(%t) pc_out should  be changed. Got 0x%x. Expected 32'h20168014", $time, pc_out);
  
  
  `endif
//          case 2-1-2: if btb_v==1&&id_pc_src==0&&btb_type==jr_type, then pc is set to RAS_target;


  rst=1'b0;
  pc_go=1'b1;
  stall=1'b0;
  id_pc_src=1'b0;
  good_target=32'h20168010;
  ras_target=32'h24241010;
  btb_v=1'b1;
  btb_type=`jr_type;
  
  `clk_step
  
  `ifdef record_log
  
  $display(  "(%t) pc_out should  be changed . Got 0x%x. Expected 32'h24241010", $time, pc_out);
  $fdisplay(log_file, "(%t) pc_out should  be changed. Got 0x%x. Expected 32'h24241010", $time, pc_out);
  
  
  `endif
//          case 2-1-3: if btb_v==1&&id_pc_src==0&&(btb_type==br_type||
//                                                    btb_type==j_type||
//                                                    btb_type==jal_type),then pc is set to btb_target.  
  
  
  //////btb_type==j_type
  rst=1'b0;
  pc_go=1'b1;
  stall=1'b0;
  id_pc_src=1'b0;
  good_target=32'h20168010;
  ras_target=32'h24241010;
  btb_target=32'h22228888;
  btb_v=1'b1;
  btb_type=`j_type;
  
  `clk_step
  
  `ifdef record_log
  
  $display(  "(%t) pc_out should  be changed . Got 0x%x. Expected 32'h22228888", $time, pc_out);
  $fdisplay(log_file, "(%t) pc_out should  be changed. Got 0x%x. Expected 32'h22228888", $time, pc_out);
  
  
  `endif
  
  /////btb_type==jal_type
  rst=1'b0;
  pc_go=1'b1;
  stall=1'b0;
  id_pc_src=1'b0;
  good_target=32'h20168010;
  ras_target=32'h24241010;
  btb_target=32'h22448888;
  btb_v=1'b1;
  btb_type=`jal_type;
  
  `clk_step
  
  `ifdef record_log
  
  $display(  "(%t) pc_out should  be changed . Got 0x%x. Expected 32'h22448888", $time, pc_out);
  $fdisplay(log_file, "(%t) pc_out should  be changed. Got 0x%x. Expected 32'h22448888", $time, pc_out);
  
  
  `endif
  
  /////btb_type==br_type
  rst=1'b0;
  pc_go=1'b1;
  stall=1'b0;
  id_pc_src=1'b0;
  good_target=32'h20168010;
  ras_target=32'h24241010;
  btb_target=32'h22446688;
  btb_v=1'b1;
  btb_type=`br_type;
  
  `clk_step
  
  `ifdef record_log
  
  $display(  "(%t) pc_out should  be changed . Got 0x%x. Expected 32'h22446688", $time, pc_out);
  $fdisplay(log_file, "(%t) pc_out should  be changed. Got 0x%x. Expected 32'h22446688", $time, pc_out);
  
  
  `endif
  $stop;
end
endmodule