//date:2016/8/02
//engineer:ZhaiShaoMin
//module name :regflie
//version: test bench 
module   tb_core_rf();
                         
//input
reg          clk;
reg          rst;
reg   [4:0]  raddr1;
reg   [4:0]  raddr2;
reg          rf_write;
reg   [4:0]  waddr;
reg   [31:0] data;
//output
wire  [31:0] rd_data1;
wire  [31:0] rd_data2;


core_id_regfile    duv(//input
                         .clk(clk),
                         .rst(rst),
                         .raddr1(raddr1),
                         .raddr2(raddr2),
                         .rf_write(rf_write),
                         .waddr(waddr),
                         .data(data),
                         //output
                         .rd_data1(rd_data1),
                         .rd_data2(rd_data2)
                         );
								 
		always #5 clk=~clk;
		
		integer log_file;
		integer  i;
		
		
		
		`define clk_step  #10;
		
		initial begin
		
		clk=1'b0;
		rst=1'b1;
		raddr1=5'h00;
		raddr2=5'h00;
		rf_write=1'b0;
		waddr=5'h01;
		data=32'h11112222;
		log_file=$fopen("core_rf_log.txt");
		end
		
		////////////////////////////////////////////////////////////////////////////
		/////////////BEGIN TEST/////////////////////////////////////////////////////
		initial begin
		
		////////case 1: write the regfile then we should see what I want to see////////
		///////here just write th rf/////////////
		`clk_step
		rst=1'b0;
		
		for(i=0;i<32;i=i+1)
		begin
		  rf_write=1'b1;
		  waddr=i;
		  data=i+1; 
		  
		 $display(  "(%t) writing %d. to %d ", $time, data, waddr);
     $fdisplay(log_file, "(%t) writing %d. to %d ", $time, data, waddr);
 
		 
		`clk_step
		end
		
		////////case 2: read out the content in regfile /////////////////
		`clk_step
		rf_write=1'b0;
		 
		for(i=0;i<32;i=i+1)
		   begin
			 raddr1=i;
		   raddr2=i;
			 
			 $display(  "(%t) get %d. from %d and get %d from %d", $time, rd_data1, raddr1 ,rd_data2, raddr2);
       $fdisplay(log_file, "(%t) get %d. from %d and get %d from %d", $time, rd_data1, raddr1 ,rd_data2, raddr2);
			 
			 `clk_step
			 
			end
			
		////////case 3: when read a reg same as being written one, it should get it direct from write data////////////
		
		////read port 1
	   for(i=0;i<32;i=i+1)
	      begin
		     raddr1=i;
			   rf_write=1'b1;
		     waddr=i;
		     data=i+32; 
			  
			  $display(  "(%t) get %d. from %d and write %d to %d", $time, rd_data1, raddr1 ,data, waddr);
        $fdisplay(log_file, "(%t) get %d. from %d and write %d to %d", $time, rd_data1, raddr1 ,data, waddr);
			  
			`clk_step
			
	      end
		////read port 2
	   for(i=0;i<32;i=i+1)
	      begin
		     raddr2=i;
			  rf_write=1'b1;
		     waddr=i;
		     data=i+64; 
			  
			  $display(  "(%t) get %d. from %d and write %d to %d", $time, rd_data1, raddr1 ,data, waddr);
           $fdisplay(log_file, "(%t) get %d. from %d and write %d to %d", $time, rd_data1, raddr1 ,data, waddr);
			  
			`clk_step
			
	      end	
	      $stop;
		end
	endmodule	
		