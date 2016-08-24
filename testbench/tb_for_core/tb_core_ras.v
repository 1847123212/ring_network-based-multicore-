/*************************************************************************************
date:2016/4/4
designer:ZhaiShaoMin
module name:tb_core_ras
module function:find out errors in the core_RAS
*************************************************************************************/

`timescale 1ns/1ps

module tb_core_ras();
  
  
//input  
reg              clk;
reg              rst;
reg              en_call_in;// a ret inst isn coming!
reg              en_ret_in; // a call inst is coming!
reg     [29:0]   ret_addr_in;
reg              recover_push;
reg     [29:0]   recover_push_addr;
reg              recover_pop;


//output  
wire     [31:0]      ret_addr_out;



core_ras     uut(//input 
                   .clk(clk),
                   .rst(rst),
                   //inst fetch stage prediction 
                   .en_call_in(en_call_in), //in my previous version ,it equals en_ret_addr_in 
                   .en_ret_in(en_ret_in),//in my previous version ,it equals en_ret_addr_out
                   .ret_addr_in(ret_addr_in),// which is gened by call inst
                   // decode stage recover something wrong,which caused by misprediction in btb, in RAS.
                   .recover_push(recover_push),//previous inst was preded as a JR inst incorrectly.
                   .recover_push_addr(recover_push_addr),//push back the top return addr to RAs
                   .recover_pop(recover_pop),// previous inst was preded as a jal inst incorrectly.
                   
                   ////output
                   //inst fetch stage poping top addr
                   .ret_addr_out(ret_addr_out)
                   );
    integer log_file;               
    
  //initial inputs
  initial  begin
      clk=1'b0;
      rst=1'b1;
      
      en_call_in=1'b0;
      en_ret_in=1'b0;
      ret_addr_in=30'h00000000;
      
      recover_push=1'b0;
      recover_push_addr=30'h00000000;
      recover_pop=1'b0;
      log_file=$fopen("tb_core_ras_logfile.txt");
    end
    
    always #5 clk=~clk;
    
    `define clk_step #10;
    
    initial begin
      
      //////////////////////////////////////////////////////////////
      ////////////////BEGIN RAS TEST!///////////////////////////////
      //////////////////////////////////////////////////////////////
      
         ///////////////////////////////////////////////////////////////////////
         ///////////1st case: normal case which pred right& no mispred//////////
         ///////////////////////////////////////////////////////////////////////
            `clk_step
            
            rst=1'b0;
            
            `clk_step
           
           ///////////////////////////////////////////////////////////
           ////////furst we should push 8 addrs into ras one by one  
            ///push 1st addr into ras
            en_call_in=1'b1;
            ret_addr_in=30'h12340000;
            $display("%t, push 1st addr: %h into ras",$time,ret_addr_in);
            $fdisplay(log_file,"%t, push 1st addr: %h into ras",$time,ret_addr_in);
            
            `clk_step
            ///push 2nd addr into ras
            en_call_in=1'b1;
            ret_addr_in=30'h12340001;
            $display("%time, push 2nd addr: %h into ras",$time,ret_addr_in);
            $fdisplay(log_file,"%time, push 2nd addr: %h into ras",$time,ret_addr_in);
            
            `clk_step
            ///push 3rd addr into ras
            en_call_in=1'b1;
            ret_addr_in=30'h12340002;
            $display("%time, push 3nd addr: %h into ras",$time,ret_addr_in);
            $fdisplay(log_file,"%time, push 3nd addr: %h into ras",$time,ret_addr_in);
            
            `clk_step
            ///push 4th addr into ras
            en_call_in=1'b1;
            ret_addr_in=30'h12340003;
            $display("%time, push 4nd addr: %h into ras",$time,ret_addr_in);
            $fdisplay(log_file,"%time, push 4nd addr: %h into ras",$time,ret_addr_in);
            
            `clk_step
            ///push 5th addr into ras
            en_call_in=1'b1;
            ret_addr_in=30'h12340004;
            $display("%time, push 5nd addr: %h into ras",$time,ret_addr_in);
            $fdisplay(log_file,"%time, push 5nd addr: %h into ras",$time,ret_addr_in);
            
            `clk_step
            ///push 6th addr into ras
            en_call_in=1'b1;
            ret_addr_in=30'h12340005;
            $display("%time, push 6nd addr: %h into ras",$time,ret_addr_in);
            $fdisplay(log_file,"%time, push 6nd addr: %h into ras",$time,ret_addr_in);
            
            `clk_step
            ///push 7th addr into ras
            en_call_in=1'b1;
            ret_addr_in=30'h12340006;
            $display("%time, push 7nd addr: %h into ras",$time,ret_addr_in);
            $fdisplay(log_file,"%time, push 7nd addr: %h into ras",$time,ret_addr_in);
            
            `clk_step
            ///push 8th addr into ras
            en_call_in=1'b1;
            ret_addr_in=30'h12340007;
            $display("%time, push 8nd addr: %h into ras",$time,ret_addr_in);
            $fdisplay(log_file,"%time, push 8nd addr: %h into ras",$time,ret_addr_in);
            
            //////////////////////////////////////////////////////
            ///////then we can pop the pushed addrs one by one ///
            `clk_step
            en_call_in=1'b0;
            
            
            ///pop 8th addr 30'h12340007;
            en_ret_in=1'b1;
            `clk_step 
            $display("%time, pop 8st addr: %h pop 8th addr 30'h12340007;",$time,ret_addr_out);
            $fdisplay(log_file,"%time, pop 8st addr: %h pop 8th addr 30'h12340007;",$time,ret_addr_out);
            
            ///pop 7th addr 30'h12340006;
            `clk_step
            $display("%time, pop 7st addr: %h pop 7th addr 30'h12340006;",$time,ret_addr_out);
            $fdisplay(log_file,"%time, pop 7st addr: %h pop 7th addr 30'h12340006;",$time,ret_addr_out);
            
            ///pop 6th addr 30'h12340005;
            `clk_step
            $display("%time, pop 6st addr: %h pop 6th addr 30'h12340005;",$time,ret_addr_out);
            $fdisplay(log_file,"%time, pop 6st addr: %h pop 6th addr 30'h12340005;",$time,ret_addr_out);
            
            ///pop 5th addr 30'h12340004;
            `clk_step
            $display("%time, pop 5st addr: %h pop 5th addr 30'h12340004;",$time,ret_addr_out);
            $fdisplay(log_file,"%time, pop 5st addr: %h pop 5th addr 30'h12340004;",$time,ret_addr_out);
            
            ///pop 4th addr 30'h12340003;
            `clk_step
            $display("%time, pop 4st addr: %h pop 4th addr 30'h12340003;",$time,ret_addr_out);
            $fdisplay(log_file,"%time, pop 4st addr: %h pop 4th addr 30'h12340003;",$time,ret_addr_out);
            
            ///pop 3th addr 30'h12340002;
            `clk_step
            $display("%time, pop 3st addr: %h pop 3th addr 30'h12340002;",$time,ret_addr_out);
            $fdisplay(log_file,"%time, pop 3st addr: %h pop 3th addr 30'h12340002;",$time,ret_addr_out);
            
            ///pop 2th addr 30'h12340001;
            `clk_step
            $display("%time, pop 2st addr: %h pop 2th addr 30'h12340001;",$time,ret_addr_out);
            $fdisplay(log_file,"%time, pop 2st addr: %h pop 2th addr 30'h12340001;",$time,ret_addr_out);
            
            ///pop 1st addr 30'h12340000;
            `clk_step
             $display("%time, pop 1st addr: %h pop 1st addr 30'h12340000;",$time,ret_addr_out);
             $fdisplay(log_file,"%time, pop 1st addr: %h pop 1st addr 30'h12340000;",$time,ret_addr_out);
            
            `clk_step
            en_ret_in=1'b0;
            `clk_step
            `clk_step
            
          ////////////////////////////////////////////////////////////////
          ///////////2nd case: pred non-ret inst as a ret inst////////////
          ////////////////////////////////////////////////////////////////
          
          //////note : en_call_in pop addr of ras ,while en_ret_in push ret_addr_in into ras!
            `clk_step
             ///first push a addr 12340078
             en_call_in=1'b1;
             ret_addr_in=30'h12340078;
             $display("%time, push  addr: %h into ras",$time,ret_addr_in);
             $fdisplay(log_file,"%time, push  addr: %h into ras",$time,ret_addr_in);
            
             `clk_step
             ///second push a addr 12340077
             ret_addr_in=30'h12340077;
             $display("%time, push  addr: %h into ras",$time,ret_addr_in);
             $fdisplay(log_file,"%time, push  addr: %h into ras",$time,ret_addr_in);
             
             `clk_step
             en_call_in=1'b0;
             en_ret_in=1'b1;///this is a non-ret inst!
             $display("%time, pop  addr: %h ",$time,ret_addr_out);
             $fdisplay(log_file,"%time, pop  addr: %h ",$time,ret_addr_out);
            
             `clk_step
             en_ret_in=1'b0;
             //////////////////////////////////////////////////////////////////
             /////1st case : there is not another operations concurrently /////
             //////////////////////////////////////////////////////////////////
             ///here is a recover to push poped addr which is incorrectly poped
             recover_push=1'b1;
             recover_push_addr=30'h12340077;
             $display("%time, recover_push_addr=30'h12340077;",$time);
             $fdisplay(log_file,"%time,recover_push_addr=30'h12340077;",$time);
             
             `clk_step
             recover_push=1'b0;
             
             `clk_step
             `clk_step
             ///this cycle a addr is pushed correctly into ras 
             en_call_in=1'b1;
             ret_addr_in=30'h12340076;
             $display("%time, push  addr: %h into ras",$time,ret_addr_in);
             $fdisplay(log_file,"%time, push  addr: %h into ras",$time,ret_addr_in);
             
             `clk_step
             ////note :there are three addrs in the ras! 12340078 and 12340077 12340076
             en_call_in=1'b0;
             `clk_step
             ///here is a fake ret
             en_ret_in=1'b1;
             $display("%time, pop  addr: %h ",$time,ret_addr_out);
             $fdisplay(log_file,"%time, pop  addr: %h ",$time,ret_addr_out);
             
             `clk_step
             en_ret_in=1'b0;
             ///////////////////////////////////////////////////////////////////////
             //////2nd case: there is concurrent ret when a recover_push comes/////
             ///////////////////////////////////////////////////////////////////////
             ///the fake inst is found not a ret in decode stage ,so it is recovered from decode
             recover_push=1'b1;
             recover_push_addr=30'h12340076;
             ///at the same time ,the real ret is calling the addr in the head of ras, then the ret_addr_out should be 30'h12340076;
             en_ret_in=1'b1;
             $display("%time, pop  addr: %h ret_addr_out should be 30'h12340076;",$time,ret_addr_out);
             $fdisplay(log_file,"%time, pop  addr: %h ret_addr_out should be 30'h12340076;",$time,ret_addr_out);
             
             `clk_step
             recover_push=1'b0;
             en_ret_in=1'b0;
             
             `clk_step
             `clk_step
             /// a fake ret pop the addr in the head of ras 30'h12340077
             en_ret_in=1'b1;
             $display("%time, pop  addr: %h ret_addr_out should be 30'h12340077;",$time,ret_addr_out);
             $fdisplay(log_file,"%time, pop  addr: %h ret_addr_out should be 30'h12340077;",$time,ret_addr_out);
             
             `clk_step
             ////////////////////////////////////////////////////////////////////////
             ///////3rd case:there is concurrent push when a recover comes!//////////
             ////////////////////////////////////////////////////////////////////////
             en_ret_in=1'b0;
             recover_push=1'b1;
             recover_push_addr=30'h12340077;
             en_call_in=1'b1;
             ret_addr_in=30'h12340075;
             
             //after this cycle, the stack should be 30'h12340075; 30'h12340077; 12340078 from top to root.
             `clk_step
             en_call_in=1'b0;
             recover_push=1'b0;
             
             `clk_step
             en_ret_in=1'b1;  // ret_addr_out is 30'h12340075;
             $display("%time, pop  addr: %h ret_addr_out is 30'h12340075;",$time,ret_addr_out);
             $fdisplay(log_file,"%time, pop  addr: %h ret_addr_out is 30'h12340075;",$time,ret_addr_out);
             
             `clk_step
             en_ret_in=1'b0;
             
             `clk_step
             en_ret_in=1'b1;  // ret_addr_out is 30'h12340077;
             $display("%time, pop  addr: %h ret_addr_out is 30'h12340077;",$time,ret_addr_out);
             $fdisplay(log_file,"%time, pop  addr: %h ret_addr_out is 30'h12340077;",$time,ret_addr_out);
             
             `clk_step
             en_ret_in=1'b0;
             
             `clk_step
             en_ret_in=1'b1;  // ret_addr_out is 30'h12340078;
             $display("%time, pop  addr: %h ret_addr_out is 30'h12340078;",$time,ret_addr_out);
             $fdisplay(log_file,"%time, pop  addr: %h ret_addr_out is 30'h12340078;",$time,ret_addr_out);
             
          ////////////////////////////////////////////////////////////////
          ///////////3rd case: pred non-call as a call////////////////////
          ////////////////////////////////////////////////////////////////   
          
             `clk_step
             ///first push a addr 20160405
             en_ret_in=1'b0;
             en_call_in=1'b1;
             ret_addr_in=30'h20160405;
             $display("%time, push  addr: %h into ras",$time,ret_addr_in);
             $fdisplay(log_file,"%time, push  addr: %h into ras",$time,ret_addr_in);
             
             `clk_step
             ///push a addr 20160404
             ret_addr_in=30'h20160404;
             $display("%time, push  addr: %h into ras",$time,ret_addr_in);
             $fdisplay(log_file,"%time, push  addr: %h into ras",$time,ret_addr_in);
             
             `clk_step
             en_call_in=1'b1;///this is a non-call inst!
             ret_addr_in=30'h20000406;
             $display("%time, push  addr: %h into ras ;this is a non-call inst!",$time,ret_addr_in);
             $fdisplay(log_file,"%time, push  addr: %h into ras ;this is a non-call inst!",$time,ret_addr_in);
             
             `clk_step
             en_call_in=1'b0;
             /////////////////////////////////////////////////////////////
             /////////1st case :there is no another operations ///////////
             /////////////////////////////////////////////////////////////
             
             /// I want to pop the wrong pred target pushed on the head of ras in the previous cycle
             /// just revise the tail pointer!
             recover_pop=1'b1;
             
             ////now 20160405 and 20160404 are in the ras
             
             `clk_step
             recover_pop=1'b0;
             en_call_in=1'b1;
             ret_addr_in=30'h20160403;// 3 4 5 from top to root
             
             `clk_step
             
             `clk_step
             en_call_in=1'b1;
             ret_addr_in=30'h20000404;/// a wrong ret addr, then 4 3 4 5 from top to root
             
             `clk_step
             en_call_in=1'b0;
             
             `clk_step
             /////////////////////////////////////////////////////////////
             ////////2nd case:there is a ret when a recover_pop///////////
             /////////////////////////////////////////////////////////////
             recover_pop=1'b1;
             en_ret_in=1'b1; // the ret_addr_out should be 30'h20160403;
             
             `clk_step
             recover_pop=1'b0;
             en_ret_in=1'b0;
             
             `clk_step
             `clk_step
             en_call_in=1'b1;
             ret_addr_in=30'h20000403; // the stack should be 30'h20000403; 20160404 20160405 from top to root
             
             `clk_step
             en_call_in=1'b0;
             
             `clk_step
             //////////////////////////////////////////////////////////////
             ////////3rd case: there is call when a recover_pop////////////
             //////////////////////////////////////////////////////////////
             recover_pop=1'b1;
             en_call_in=1'b1;
             ret_addr_in=30'h20160403; //the stack should be 20160403; 20160404 20160405 from top to root
             
             `clk_step
             recover_pop=1'b0;
             en_call_in=1'b0;
             
             `clk_step
             ///now there are 3 addrs in the ras :30'h20160403 30'h20160404 30'h20160405
             /// and we now pop them one by one to check the behavior of ras
             en_ret_in=1'b1;//ret_addr_out should be 20160403;
             
             `clk_step
             en_ret_in=1'b0;
             
             `clk_step
             en_ret_in=1'b1;//ret_addr_out should be 20160404;
             
             `clk_step
             en_ret_in=1'b0;
             
             `clk_step
             en_ret_in=1'b1;//ret_addr_out should be 20160405;
             
             `clk_step
             en_ret_in=1'b0;
             
             
             
             `clk_step
             
             $stop;
           end
         endmodule
         
             
