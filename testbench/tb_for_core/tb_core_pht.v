// date:2016/3/20
// engineer:ZhaiShaoMin
// module name: PHT :Pattern History Table,actually should be direction predictor.
// moduel implementation:
//                   this is a local predictor
// in read stage(if stage) first we index BHR, then use conbination of BHR and pc to index PHT
//                         then we get the direction infos to judge which path to go .
// in write stage(id stage) we use BHR_rd of id stage to generate index of PHT, 
//                          then use delayed PHT to judge whether we need to update the PHT.
//
// test plan is shown below! I think it will be ok for 3 bits BHR if it works well for 2 bits BHR.
//
/***from MIT 6-823-fall-2005\contents\assignments
loop: LW R4, 0(R3)
      ADDI R3, R3, 4
      SUBI R1, R1, 1
  b1: BEQZ R4, b2ADDI R2, R2, 1
  b2: BNEZ R1, loop
  
PC R3/R4 b1 bits b2 bits Predicted Actual
b1 4/1     10      10        N       N
b2 4/1     10      10        N       T
b1 8/0     10      11        N       T
b2 8/0     11      11        N       T
b1 12/1    11      00        N       N
b2 12/1    10      00        T       T
b1 16/0    10      00        N       T
b2 16/0    11      00        T       T
b1 20/1    11      00        N       N
b2 20/1    10      00        T       T
b1 24/0    10      00        N       T
b2 24/0    11      00        T       T
b1 28/1    11      00        N       N
b2 28/1    10      00        T       T
b1 32/0    10      00        N       T
b2 32/0    11      00        T       N
  
Assume the initial value of R1 is n (n>0).
Assume the initial value of R2 is 0 (R2 holds the result of the program).
Assume the initial value of R3 is p (a pointer to the beginning of an array of 32-bit integers).


******/
// the only thing I need to do is to figure out the chart above , according to this module 

`timescale 1ns/1ps

`include "define.v"

module   tb_core_pht();

//input
reg               clk;
reg               rst;
reg               update_BP;
reg               pred_right;
reg               taken;
reg     [9:0]     if_pc;  //part of pc
reg     [9:0]     id_pc;  // part of pc
//reg     [3:0]     BHR_in;          
reg     [1:0]     delayed_PHT;
//output
wire              pred_out; 
//wire    [3:0]     BHR_rd;
wire    [1:0]     PHT_out;

core_pht     duv(//input
                   .clk(clk),
                   .rst(rst),
                   .if_pc(if_pc),  // pc[10:5]
                   .id_pc(id_pc),  // pc[10:5]
                   .update_BP(update_BP),
                   .pred_right(pred_right),
                   .taken(taken),
                //   .BHR_in(BHR_in),
                   //delayed PHT_out from previous stage , useful to avoid reading PHT when update PHT
                   .delayed_PHT(delayed_PHT),
                   //output
                   .pred_out(pred_out),
                //   .BHR_rd(BHR_rd),
                   .PHT_out(PHT_out)
                   );
						 
	initial begin
	   clk=1'b0;
		rst=1'b1;
		if_pc=16'd1430;
		id_pc=16'd1450;
		update_BP=1'b0;
    pred_right=1'b0;
    delayed_PHT=2'b00;
		taken=1'b0;
		
		end
		
		always  #5 clk=~clk;
		`define clk_step  #10;
		
	//////////////////////////////////////////////////////////////////////
	//////////////////////////////begin test//////////////////////////////
	
	initial begin
// R3/R4	

	`clk_step
	rst=1'b0;
// 4/1
	if_pc = 16'd1430;
	//$display("b1 bits should be 2'b00, actually pht array: %b or pred_out: %b ", PHT[if_pc], PHT_out);
	
	`clk_step
// 4/1
   //update 
   id_pc = 16'd1430;
	update_BP=1'b1;
	taken = 1'b0;
	delayed_PHT=2'b00;
	//predict
	if_pc = 16'd1450;
	
	`clk_step
// 8/0
	//update 
	id_pc = 16'd1450;
	update_BP=1'b1;
	taken = 1'b1;
	delayed_PHT=2'b00;
   //predict 
	if_pc = 16'd1430;
	
	`clk_step
// 8/0
	//update 
	id_pc = 16'd1430;
	update_BP=1'b1;
	taken = 1'b1;
	delayed_PHT=2'b00;
	//predict 
	if_pc = 16'd1450;
	
	`clk_step
// 12/1
	//update 
	id_pc = 16'd1450;
	update_BP=1'b1;
	taken = 1'b1;
	delayed_PHT=2'b01;
	//predict 
	if_pc = 16'd1430;
	
	`clk_step
// 12/1
	//update 
	id_pc = 16'd1430;
	update_BP=1'b1;
	taken = 1'b0;
	delayed_PHT=2'b01;
	//predict 
	if_pc = 16'd1450;
	
	`clk_step
// 16/0
	//update 
	id_pc = 16'd1450;
	update_BP=1'b1;
	taken = 1'b1;
	delayed_PHT=2'b10;
	//predict 
	if_pc = 16'd1430;
	
	`clk_step
// 16/0
	//update 
	id_pc = 16'd1430;
	update_BP=1'b1;
	taken = 1'b1;
	delayed_PHT=2'b00;
	//predict 
	if_pc = 16'd1450;
	
	`clk_step
// 20/1
	//update 
	id_pc = 16'd1450;
	update_BP=1'b1;
	taken = 1'b1;
	delayed_PHT=2'b10;
	//predict 
	if_pc = 16'd1430;
	
	`clk_step
// 20/1
	//update 
	id_pc = 16'd1430;
	update_BP=1'b1;
	taken = 1'b0;
	delayed_PHT=2'b01;
	//predict 
	if_pc = 16'd1450;
	
	`clk_step
// 24/0
	//update 
	id_pc = 16'd1450;
	update_BP=1'b1;
	taken = 1'b1;
	delayed_PHT=2'b10;
	//predict 
	if_pc = 16'd1430;
	
	`clk_step
// 24/0
	//update 
	id_pc = 16'd1430;
	update_BP=1'b1;
	taken = 1'b1;
	delayed_PHT=2'b00;
	//predict 
	if_pc = 16'd1450;
	
	`clk_step
// 28/1
	//update 
	id_pc = 16'd1450;
	update_BP=1'b1;
	taken = 1'b1;
	delayed_PHT=2'b10;
	//predict 
	if_pc = 16'd1430;
	
	`clk_step
// 28/1
	//update 
	id_pc = 16'd1430;
	update_BP=1'b1;
	taken = 1'b0;
	delayed_PHT=2'b01;
	//predict 
	if_pc = 16'd1450;
	
	`clk_step
// 32/0
	//update 
	id_pc = 16'd1450;
	update_BP=1'b1;
	taken = 1'b1;
	delayed_PHT=2'b10;
	//predict 
	if_pc = 16'd1430;
	
	`clk_step
// 32/0
	//update 
	id_pc = 16'd1430;
	update_BP=1'b1;
	taken = 1'b1;
	delayed_PHT=2'b00;
	//predict 
	if_pc = 16'd1450;
	  
	  $stop;
	 end
	endmodule