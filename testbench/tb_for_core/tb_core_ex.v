//date:2016/8/03
//engineer:ZhaiShaoMin
//module name :excution stage of core
//module function :tset the function of core_ex

`timescale 1ns/1ps

`include "define.v"

module  tb_core_ex();

//reg
reg   [31:0]                alusrc_a;
reg   [31:0]                alusrc_b;
reg   [3:0]                 aluop;
reg                         regdst;
reg   [1:0]                 alusrc;
reg   [4:0]                 id_ex_rs;
reg   [4:0]                 id_ex_rt;
reg   [4:0]                 id_ex_rd;
reg                         mem_regwrite;
reg                         wb_regwrite;
reg   [4:0]                 mem_regrd;
reg   [4:0]                 wb_regrd;
reg   [31:0]                mem_reg_data;
reg   [31:0]                wb_reg_data;
reg   [31:0]                id_ex_sign_extend;
//wire
wire   [31:0]               alu_result;
wire   [31:0]               data_to_mem;
wire   [4:0]                ex_dest_rd;
wire                        zero;


core_ex      duv(//input
                  .alusrc_a(alusrc_a),
                  .alusrc_b(alusrc_b),
                  .aluop(aluop),
                  .regdst(regdst),
                  .alusrc(alusrc),
                  .id_ex_rs(id_ex_rs),
                  .id_ex_rt(id_ex_rt),
                  .id_ex_rd(id_ex_rd),
                  .mem_regwrite(mem_regwrite),
                  .wb_regwrite(wb_regwrite),
                  .mem_regrd(mem_regrd),
                  .wb_regrd(wb_regrd),
                  .mem_reg_data(mem_reg_data),
						      .wb_reg_data(wb_reg_data),
                  .id_ex_sign_extend(id_ex_sign_extend),
                  //output
                  .alu_result(alu_result),
                  .data_to_mem(data_to_mem),
                  .ex_dest_rd(ex_dest_rd),
                  .zero(zero)
                  );
    //always #5  clk=~clk;
	 
	 `define  clk_step  #7; 
	  integer log_file ;
	 
	 
	 
	 
	 initial begin
	
       alusrc_a=32'h00000001;
       alusrc_b=32'h00000002;
       aluop=4'b0000;
       regdst=1'b0;
       alusrc=2'b00;
       id_ex_rs=1;
       id_ex_rt=2;
       id_ex_rd=3;
       mem_regwrite=1'b0;
       wb_regwrite=1'b0;
       mem_regrd=4;
       wb_regrd=5;
       mem_reg_data=32'h00000003;
		   wb_reg_data=32'h00000004;
       id_ex_sign_extend=32'h00000005;
		   
		  
		   log_file= $fopen("tb_core_ex_logfile");
		 end
		 
		 
		 ////////////////////////////////////////////////////////////////////////////////////
		 //////////////////////////////////////begin test////////////////////////////////////
	initial begin
	        ////////////////we need to delay the time to display result compared to input////////////////////////////
	     #3;///////////////////////ensure that alu_result is ready for the ops to be displayed////////////////////////
	     /////////////////////////////////////////////////////////////////////////////////////////////////////////////
       `clk_step
		// rst=1'b0;
		 #3;
		 `clk_step
		 
		 //////case 1:just test forwarding unit///////////////////
		 
		 //src_1 forward data from mem 
		 //src_2 forward data from regread
		 
		 //case 1: mem_reg and wb_reg=rs and mem_regwrite and wb_regwrite=1 ;while we need to get latest value from mem, but simlation show taht
		 // forward from wb. 2+4=6
		 /////////////////////////////////////wrong,from wb instead of mem
		   id_ex_rs=1;
       id_ex_rt=2;
       id_ex_rd=3;
       mem_regwrite=1'b1;
       wb_regwrite=1'b1;
       mem_regrd=1;
       wb_regrd=1;
       mem_reg_data=32'h00000003;
		   wb_reg_data=32'h00000004;
		   id_ex_sign_extend[5:0]=	`add_funct;
		   aluop=4'b0010;
		   alusrc=2'b00;
		   #3;
		 $display("///add_funct, alu_result should be 32'h00000005,actually is %h",alu_result);
		 $fdisplay(log_file,"///add_funct, alu_result should be 32'h00000005,actually is %h",alu_result);
		 
		 `clk_step
		 //case 2: mem_reg =rs and mem_regwrite =1 ;while we need to get latest value from mem;
		 id_ex_rs=1;
       id_ex_rt=2;
       id_ex_rd=3;
       mem_regwrite=1'b1;
       wb_regwrite=1'b0;
       mem_regrd=1;
       wb_regrd=1;
       mem_reg_data=32'h00000003;
		   wb_reg_data=32'h00000004;
		   id_ex_sign_extend[5:0]=	`add_funct;
		   aluop=4'b0010;
		   alusrc=2'b00;
		   #3;
		 $display("///add_funct, alu_result should be 32'h00000005,actually is %h",alu_result);
		 $fdisplay(log_file,"///add_funct, alu_result should be 32'h00000005,actually is %h",alu_result);
		 
		 `clk_step 
		 
		 //src_1 forward data from wb 
		 //src_2 forward data from regread
		 //////////////////////////////////wrong, should from wb but seems from reg
		 //case 1:  wb_reg=rs and  wb_regwrite=1 ;while we need to get latest value from wb mem_rd != rs;
		   id_ex_rs=1;
       id_ex_rt=2;
       id_ex_rd=3;
       mem_regwrite=1'b1;
       wb_regwrite=1'b1;
       mem_regrd=4;
       wb_regrd=1;
       mem_reg_data=32'h00000003;
		   wb_reg_data=32'h00000004;
		   id_ex_sign_extend[5:0]=	`add_funct;
		   aluop=4'b0010;
		   alusrc=2'b00;
		   #3;
		 $display("///add_funct, alu_result should be 32'h00000006,actually is %h",alu_result);
		 $fdisplay(log_file,"///add_funct, alu_result should be 32'h00000006,actually is %h",alu_result);
		`clk_step	
		 
		 //src_1 forward data from regread  because not matching
		 //src_2 forward data from regread  because not matching
		   id_ex_rs=1;
       id_ex_rt=2;
       id_ex_rd=3;
       mem_regwrite=1'b1;
       wb_regwrite=1'b1;
       mem_regrd=4;
       wb_regrd=5;
       mem_reg_data=32'h00000003;
		   wb_reg_data=32'h00000004;
		   id_ex_sign_extend[5:0]=	`add_funct;
		   aluop=4'b0010;
		   alusrc=2'b00;
		   #3;
		 $display("///add_funct, alu_result should be 32'h00000003,actually is %h",alu_result);
		 $fdisplay(log_file,"///add_funct, alu_result should be 32'h00000003,actually is %h",alu_result);
		
		 
		 `clk_step
		 
		 //src_1 forward data from regread 
		 //src_2 forward data from regread 
		   id_ex_rs=1;
       id_ex_rt=2;
       id_ex_rd=3;
       mem_regwrite=1'b1;
       wb_regwrite=1'b0;
       mem_regrd=4;
       wb_regrd=1;
       mem_reg_data=32'h00000003;
		   wb_reg_data=32'h00000004;
		   id_ex_sign_extend[5:0]=	`add_funct;
		   aluop=4'b0010;
		   alusrc=2'b00;
		   #3;
		 $display("///add_funct, alu_result should be 32'h00000003,actually is %h",alu_result);
		 $fdisplay(log_file,"///add_funct, alu_result should be 32'h00000003,actually is %h",alu_result);
		 
		 `clk_step
		 
		 //src_1 forward data from regread 
		 //src_2 forward data from regread 
		   id_ex_rs=1;
       id_ex_rt=2;
       id_ex_rd=3;
       mem_regwrite=1'b0;
       wb_regwrite=1'b1;
       mem_regrd=4;
       wb_regrd=3;
       mem_reg_data=32'h00000003;
		   wb_reg_data=32'h00000004;
		   id_ex_sign_extend[5:0]=	`add_funct;
		   aluop=4'b0010;
		   alusrc=2'b00;
		   #3;
		 $display("///add_funct, alu_result should be 32'h00000003,actually is %h",alu_result);
		 $fdisplay(log_file,"///add_funct, alu_result should be 32'h00000003,actually is %h",alu_result);
		 
		 `clk_step
		 
		 //src_1 forward data from regread 
		 //src_2 forward data from mem
		 /////////////////////////////////wrong ,seems forward from wb instead of mem////////////////
		   id_ex_rs=1;
       id_ex_rt=2;
       id_ex_rd=3;
       mem_regwrite=1'b1;
       wb_regwrite=1'b1;
       mem_regrd=2;
       wb_regrd=2;
       mem_reg_data=32'h00000003;
		   wb_reg_data=32'h00000004;
		   id_ex_sign_extend[5:0]=	`add_funct;
		   aluop=4'b0010;
		   alusrc=2'b00;
		   #3;
		 $display("///add_funct, alu_result should be 32'h00000004,actually is %h",alu_result);
		 $fdisplay(log_file,"///add_funct, alu_result should be 32'h00000004,actually is %h",alu_result);
		 
		 `clk_step
		 
		   id_ex_rs=1;
       id_ex_rt=2;
       id_ex_rd=3;
       mem_regwrite=1'b1;
       wb_regwrite=1'b0;
       mem_regrd=2;
       wb_regrd=2;
       mem_reg_data=32'h00000003;
		   wb_reg_data=32'h00000004;
		   id_ex_sign_extend[5:0]=	`add_funct;
		   aluop=4'b0010;
		   alusrc=2'b00;
		   #3;
		 $display("///add_funct, alu_result should be 32'h00000004,actually is %h",alu_result);
		 $fdisplay(log_file,"///add_funct, alu_result should be 32'h00000004,actually is %h",alu_result);
		 
		 `clk_step
		 
		 //src_1 forward data from regread 
		 //src_2 forward data from wb
		 ///////////////////////////////wrong, should from wb but seems from reg
		   id_ex_rs=1;
       id_ex_rt=2;
       id_ex_rd=3;
       mem_regwrite=1'b1;
       wb_regwrite=1'b1;
       mem_regrd=23;
       wb_regrd=2;
       mem_reg_data=32'h00000003;
		   wb_reg_data=32'h00000004;
		   id_ex_sign_extend[5:0]=	`add_funct;
		   aluop=4'b0010;
		   alusrc=2'b00;
		   #3;
		 $display("///add_funct, alu_result should be 32'h00000005,actually is %h",alu_result);
		 $fdisplay(log_file,"///add_funct, alu_result should be 32'h00000005,actually is %h",alu_result);
		 
		 `clk_step
		 
		 //src_1 forward data from mem
		 //src_2 forward data from wb
		   id_ex_rs=4;
       id_ex_rt=6;
       id_ex_rd=3;
       mem_regwrite=1'b1;
       wb_regwrite=1'b1;
       mem_regrd=4;
       wb_regrd=6;
       mem_reg_data=32'h00000003;
		   wb_reg_data=32'h00000004;
		   id_ex_sign_extend[5:0]=	`add_funct;
		   aluop=4'b0010;
		   alusrc=2'b00;
		   #3;
		 $display("///add_funct, alu_result should be 32'h00000007,actually is %h",alu_result);
		 $fdisplay(log_file,"///add_funct, alu_result should be 32'h00000007,actually is %h",alu_result);
		 
		 `clk_step
		 
		 //src_1 forward data from wb
		 //src_2 forward data from wb
		 ///////////////////////////////wrong, should from wb but seems from reg
		   id_ex_rs=6;
       id_ex_rt=6;
       id_ex_rd=3;
       mem_regwrite=1'b1;
       wb_regwrite=1'b1;
       mem_regrd=4;
       wb_regrd=6;
       mem_reg_data=32'h00000003;
		   wb_reg_data=32'h00000004;
		   id_ex_sign_extend[5:0]=	`add_funct;
		   aluop=4'b0010;
		   alusrc=2'b00;
		   #3;
		 $display("///add_funct, alu_result should be 32'h00000008,actually is %h",alu_result);
		 $fdisplay(log_file,"///add_funct, alu_result should be 32'h00000008,actually is %h",alu_result);
		 
		 `clk_step
		 
		 //src_1 forward data from mem
		 //src_2 forward data from mem
		   id_ex_rs=4;
       id_ex_rt=4;
       id_ex_rd=3;
       mem_regwrite=1'b1;
       wb_regwrite=1'b1;
       mem_regrd=4;
       wb_regrd=6;
       mem_reg_data=32'h00000003;
		   wb_reg_data=32'h00000004;
		   id_ex_sign_extend[5:0]=	`add_funct;
		   aluop=4'b0010;
		   alusrc=2'b00;
		   #3;
		 $display("///add_funct, alu_result should be 32'h00000006,actually is %h",alu_result);
		 $fdisplay(log_file,"///add_funct, alu_result should be 32'h00000006,actually is %h",alu_result);
		 
		 `clk_step
		 
		 
		 //////case 2: all kinds of aluops////////////////////////
		 //RESET 
		   alusrc_a=32'h00000001;
       alusrc_b=32'h00000002;
       aluop=4'b0000;
       regdst=1'b0;
       alusrc=2'b00;
       id_ex_rs=1;
       id_ex_rt=2;
       id_ex_rd=3;
       mem_regwrite=1'b0;
       wb_regwrite=1'b0;
       mem_regrd=4;
       wb_regrd=5;
       mem_reg_data=32'h00000003;
		   wb_reg_data=32'h00000004;
       id_ex_sign_extend=32'h00000005;
       
		 `clk_step
		 
		 //lw,sw,ll,sc,addiu,addi
		 aluop=4'b0000;
		 alusrc=2'b01;
		 #3;
		 $display("//lw,sw,ll,sc,addiu,addi; alu_result should be 32'h00000006,actually is %h",alu_result);
		 $fdisplay(log_file,"//lw,sw,ll,sc,addiu,addi;alu_result should be 32'h00000006,actually is %h",alu_result);
		 `clk_step
		 
		 //beq, bne, blez, bgtz ,bltz, bgez  
		 //beq
		 aluop=4'b0001;
		 alusrc=2'b00;
		 #3;
		 $display("//beq zero should be 0,actually is %h",alu_result);
		 $fdisplay(log_file,"//beq zero should be 0,actually is %h",alu_result);
		 `clk_step
		 
		 //bne
		 aluop=4'b0011;
		 alusrc=2'b00;
		 #3;
		 $display("//bne zero should be 0,actually is %h",alu_result);
		 $fdisplay(log_file,"//bne zero should be 0,actually is %h",alu_result);
		 `clk_step
		 
		 //blez
		 aluop=4'b0100;
		 alusrc=2'b00;
		 #3;
		 $display("//blez here we don't care about alu_result should be ,actually is %h",alu_result);
		 $fdisplay(log_file,"//blez here we don't care about alu_result should be ,actually is %h",alu_result);
		 $display("alu_result should be ,actually is %h",alu_result);
		 $fdisplay(log_file,"alu_result should be ,actually is %h",alu_result);
		 `clk_step
		 
		 //bgtz
		 aluop=4'b0101;
		 alusrc=2'b00;
		 #3;
		 $display("//bgtz here we don't care about alu_result should be ,actually is %h",alu_result);
		 $fdisplay(log_file,"//bgtz here we don't care about alu_result should be ,actually is %h",alu_result);
		 `clk_step
		 
		 //bltz
		 aluop=4'b0110;
		 alusrc=2'b00;
		 #3;
		 $display("//bltz here we don't care about alu_result should be ,actually is %h",alu_result);
		 $fdisplay(log_file,"//bltz here we don't care about alu_result should be ,actually is %h",alu_result);
		 `clk_step
		 
		 //bgez
		 aluop=4'b0111;
		 alusrc=2'b00;
		 #3;
		 $display("//bgez here we don't care about alu_result should be ,actually is %h",alu_result);
		 $fdisplay(log_file,"//bgez here we don't care about alu_result should be ,actually is %h",alu_result);
		 `clk_step
		 
		 // R_type according to fun field
		 aluop=4'b0010;
		 alusrc=2'b00;
		
		   ///add_funct,`addu_funct
		id_ex_sign_extend[5:0]=	`add_funct;
		#3;
		$display("///add_funct, alu_result should be 32'h00000003,actually is %h",alu_result);
		 $fdisplay(log_file,"///add_funct, alu_result should be 32'h00000003,actually is %h",alu_result);
		`clk_step
		
		id_ex_sign_extend[5:0]=	`addu_funct;
		#3;
		$display("`addu_funct alu_result should be 32'h00000003,actually is %h",alu_result);
		 $fdisplay(log_file,"`addu_funct alu_result should be 32'h00000003 ,actually is %h",alu_result);
		`clk_step
			
			///sub_funct,`subu_funct
		id_ex_sign_extend[5:0]=	`sub_funct;
		#3;
		$display("`sub_funct; alu_result should be 32'hffffffff,actually is %h",alu_result);
		 $fdisplay(log_file,"`sub_funct; alu_result should be 32'hffffffff,actually is %h",alu_result);
		`clk_step
		
		id_ex_sign_extend[5:0]=	`subu_funct;
		#3;
		$display("`subu_funct; alu_result should be 32'hffffffff,actually is %h",alu_result);
		 $fdisplay(log_file,"`subu_funct; alu_result should be 32'hffffffff,actually is %h",alu_result);
		`clk_step	
			
			///and_funct
		id_ex_sign_extend[5:0]=	`and_funct;
		#3;
		$display("`and_funct; alu_result should be 32'h00000000,actually is %h",alu_result);
		 $fdisplay(log_file,"`and_funct; alu_result should be 32'h00000000,actually is %h",alu_result);
		`clk_step	
		
			///or_funct
		id_ex_sign_extend[5:0]=	`or_funct;
		#3;
		$display("`or_funct; alu_result should be 32'h00000003,actually is %h",alu_result);
		 $fdisplay(log_file,"`or_funct; alu_result should be 32'h00000003,actually is %h",alu_result);
		`clk_step
		
			///slt_funct
		id_ex_sign_extend[5:0]=	`slt_funct;
		#3;
		$display("`slt_funct; alu_result should be 32'h00000001,actually is %h",alu_result);
		 $fdisplay(log_file,"`slt_funct; alu_result should be 32'h00000001,actually is %h",alu_result);
		`clk_step	
			
		id_ex_sign_extend[5:0]=	`sltu_funct;
		#3;
		$display("`sltu_funct; alu_result should be 32'h00000001,actually is %h",alu_result);
		 $fdisplay(log_file,"`sltu_funct; alu_result should be 32'h00000001,actually is %h",alu_result);
		`clk_step
		
			///sll_funct
		id_ex_sign_extend[5:0]=	`sll_funct;
		id_ex_sign_extend[10:6]=5'b00011;
		#3;
		$display("`sll_funct; alu_result should be 32'h00000010,actually is %h",alu_result);
		 $fdisplay(log_file,"`sll_funct; alu_result should be 32'h00000010,actually is %h",alu_result);
		`clk_step	
			
			///srl_funct
		id_ex_sign_extend[5:0]=	`srl_funct;
		id_ex_sign_extend[10:6]=5'b00011;
		alusrc_b=32'h000000f0;
		#3;
		$display("`srl_funct; alu_result should be 32'h0000001e;,actually is %h",alu_result);
		 $fdisplay(log_file,"`srl_funct; alu_result should be 32'h0000001e;,actually is %h",alu_result);
		`clk_step	
			
			///sra_funct
		id_ex_sign_extend[5:0]=	`sra_funct; 
		id_ex_sign_extend[10:6]=5'b00011;
		alusrc_b=32'h800000f0;
		#3;
		$display("`sra_funct; alu_result should be 32'h1000001e,actually is %h",alu_result);
		 $fdisplay(log_file,"`sra_funct; alu_result should be 32'h1000001e,actually is %h",alu_result);
		`clk_step	
			
			///sllv_funct
		id_ex_sign_extend[5:0]=	`sllv_funct;
		alusrc_a=32'h00000003;
		alusrc_b=32'h00000ff0;
		#3;
		$display("	`sllv_funct; alu_result should be 32'h00007f80,actually is %h",alu_result);
		 $fdisplay(log_file,"	`sllv_funct; alu_result should be 32'h00007f80,actually is %h",alu_result);
		`clk_step	
			
			///srlv_funct
		id_ex_sign_extend[5:0]=	`srlv_funct;
		#3;
		$display("	`srlv_funct; alu_result should be 32'h000001fe,actually is %h",alu_result);
		 $fdisplay(log_file,"	`srlv_funct; alu_result should be 32'h000001fe,actually is %h",alu_result);
		`clk_step	
			
			///srav_funct
		id_ex_sign_extend[5:0]=	`srav_funct;
		alusrc_a=32'h00000004;
		alusrc_b=32'h80000ff0;
		#3;
		$display("`srav_funct; alu_result should be 32'h080000ff;,actually is %h",alu_result);
		 $fdisplay(log_file,"`srav_funct; alu_result should be 32'h080000ff;,actually is %h",alu_result);
		`clk_step	
			
			///xor_funct
			alusrc_a=32'h00000001;
      alusrc_b=32'h00000002;
		id_ex_sign_extend[5:0]=	`xor_funct;
		#3;
		$display("`xor_funct; alu_result should be 32'h00000003,actually is %h",alu_result);
		 $fdisplay(log_file,"`xor_funct; alu_result should be 32'h00000003,actually is %h",alu_result);
		`clk_step	
			
			///nor_funct
		id_ex_sign_extend[5:0]=	`nor_funct;
		#3;
		$display("`nor_funct; alu_result should be 32'hfffffffc,actually is %h",alu_result);
		 $fdisplay(log_file,"`nor_funct; alu_result should be 32'hfffffffc,actually is %h",alu_result);
		`clk_step	
			
		 //slt_op
		id_ex_sign_extend=32'h00000005; 
		
		aluop=4'b1010;
		alusrc=2'b01;
		#3;
		$display(" //slt_op alu_result should be 32'h00000001,actually is %h",alu_result);
		 $fdisplay(log_file," //slt_op alu_result should be 32'h00000001,actually is %h",alu_result);
		`clk_step
		
		 //andi
		aluop=4'b1011;
		alusrc=2'b10;
		#3;
		$display("//andi alu_result should be 32'h00000001,actually is %h",alu_result);
		 $fdisplay(log_file,"//andi alu_result should be 32'h00000001,actually is %h",alu_result);
		`clk_step 
		 
		 //ori
		aluop=4'b1100;
		alusrc=2'b10;
		#3;
		$display("//ori alu_result should be 32'h00000005,actually is %h",alu_result);
		 $fdisplay(log_file,"//ori alu_result should be 32'h00000005,actually is %h",alu_result);
		`clk_step 
		 
		 //xori
		aluop=4'b1101;
		alusrc=2'b10;
		#3;
		$display("//xori alu_result should be 32'h00000004,actually is %h",alu_result);
		 $fdisplay(log_file,"//xori alu_result should be 32'h00000004,actually is %h",alu_result);
		`clk_step 
		 
		 //lui
		aluop=4'b1110;
		alusrc=2'b01;
		#3;
		$display("//lui alu_result should be 32'h00050000; actually is %h",alu_result);
		 $fdisplay(log_file,"//lui alu_result should be 32'h00050000; actually is %h",alu_result);
		`clk_step
		
		$stop;
		end
		endmodule
		
		 