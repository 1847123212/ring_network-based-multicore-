// date:2016/8/10 
// engineer:ZhaiShaoMin
// module name:tb_arbiter_4_enq
// module func: find out the bugs and prove that this part canworks well;
// module function:decide which fifo should receive coming flit according to the head flit of msg
//                 since arbiter dequeue has done most of the selction work , this part seems much easier!

`timescale 1ns/1ps

module tb_arbiter_4_enq();
  
  
//INPUT
reg            [15:0]  flit;              
reg            [1:0]   ctrl;
reg                    en_dest_fifo; // enable selection between 4 fifos
reg            [1:0]   dest_fifo;// used to decide write flit to pass fifos or In_local fifos
                                      // 00:write to pass req fifo;      01:write to pass rep fifo;
                                      // 10:write to IN_local req fifo;  11:write to IN_local rep fifo;

//output

//output           [1:0]   enq_select;  // 00:enq for pass fifo req;
                                      // 01:enq for pass fifo rep;  10:enq for local fifo req;
                                      // 11:enq for local fifo rep.
wire           [15:0]  flit2pass_req;   // seled flit output to pass req 
wire           [1:0]   ctrl2pass_req;   // seled ctrl output to pass req
wire           [15:0]  flit2pass_rep;   // seled flit output to pass req 
wire           [1:0]   ctrl2pass_rep;   // seled ctrl output to pass req
wire           [15:0]  flit2local_in_req;   // seled flit output to pass req 
wire           [1:0]   ctrl2local_in_req;   // seled ctrl output to pass req
wire           [15:0]  flit2local_in_rep;   // seled flit output to pass req 
wire           [1:0]   ctrl2local_in_rep;   // seled ctrl output to pass req

wire                   en_pass_req;  //  enable for pass req fifo to write data to tail
wire                   en_pass_rep;  //  enable for pass rep fifo to write data to tail 
wire                   en_local_in_req; // enable for local in req fifo to write data to tail
wire                   en_local_in_rep; // enable for local in rep fifo to write data to tail


arbiter_4_enq     duv( // input 
                       .flit(flit),
                       .ctrl(ctrl),
                       .en_dest_fifo(en_dest_fifo),
                       .dest_fifo(dest_fifo),
                       // output
                       .flit2pass_req(flit2pass_req),   // seled flit output to pass req 
                       .ctrl2pass_req(ctrl2pass_req),   // seled ctrl output to pass req
                       .flit2pass_rep(flit2pass_rep),   // seled flit output to pass rep
                       .ctrl2pass_rep(ctrl2pass_rep),   // seled ctrl output to pass rep
                       .flit2local_in_req(flit2local_in_req),   // seled flit output to local in req   
                       .ctrl2local_in_req(ctrl2local_in_req),   // seled ctrl output to local in req
                       .flit2local_in_rep(flit2local_in_rep),   // seled flit output to local in rep 
                       .ctrl2local_in_rep(ctrl2local_in_rep),   // seled ctrl output to local in rep
                       .en_pass_req(en_pass_req),
                       .en_pass_rep(en_pass_rep),
                       .en_local_in_req(en_local_in_req),
                       .en_local_in_rep(en_local_in_rep)
                      );
                      
        initial begin
          flit = 16'h0000;
          ctrl = 2'b00;
          en_dest_fifo =  1'b0;
          dest_fifo = 2'b00;
        end
        
        `define clk_step #10;
        
        ///////////////////////////////////////////begin test/////////////////////////////////////////
        initial begin
          
          `clk_step
          
          flit = 16'h0001;
          ctrl = 2'b01;
          en_dest_fifo =  1'b0;
          dest_fifo = 2'b00;
          
          `clk_step
                      
          flit = 16'h0001;
          ctrl = 2'b01;
          en_dest_fifo =  1'b1;
          dest_fifo = 2'b00;            
          
          `clk_step
                      
          flit = 16'h0002;
          ctrl = 2'b01;
          en_dest_fifo =  1'b1;
          dest_fifo = 2'b01;   
          
          `clk_step
                      
          flit = 16'h0003;
          ctrl = 2'b01;
          en_dest_fifo =  1'b1;
          dest_fifo = 2'b10;    
          
          `clk_step
                      
          flit = 16'h0004;
          ctrl = 2'b01;
          en_dest_fifo =  1'b1;
          dest_fifo = 2'b11;    
          
          `clk_step
                      
          flit = 16'h1234;
          ctrl = 2'b01;
          en_dest_fifo =  1'b1;
          dest_fifo = 2'b10;     
          
          `clk_step
                      
          flit = 16'h4321;
          ctrl = 2'b01;
          en_dest_fifo =  1'b1;
          dest_fifo = 2'b01;   
          
          `clk_step
          
          $stop;
        end
    endmodule
      