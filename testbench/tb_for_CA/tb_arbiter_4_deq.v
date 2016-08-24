/// date: 2016/8/10 
/// engineer: ZhaiShaoMin
/// module name: tb_arbiter_4_deq
/// module function: decide which fifo among pass fifos and OUT_local fifos can 
///                  really deq flit,ctrl and next_node infos;

`timescale 1ns/1ps

module tb_arbiter_4_deq();
  
  
 
  
  //input
reg       clk;
reg       rst;
reg       pass_req_empty;                 //local node: pass req fifo is empty     
reg       pass_rep_empty;                 //local node: pass rep fifo is empty
reg       OUT_local_req_empty;            //local node: OUT_local req fifo is empty
reg       OUT_local_rep_empty;            //local node: OUT_local rep fifo is empty
reg      [1:0]       pass_req_ctrl;       //local node: tell whether current flit is over.
reg      [1:0]       pass_rep_ctrl;       //local node: tell whether current flit is over.
reg      [1:0]       out_req_ctrl;        //local node: tell whether current flit is over.
reg      [1:0]       out_rep_ctrl;        //local node: tell whether current flit is over.
reg       en_local_req;                   //IN_local_req_fifo of next node says I can receive a flit 
reg       en_local_rep;                   //IN_local_rep_fifo of next node says I can receive a flit
reg       en_pass_req;                    //pass req fifo of next node says i can receive a flit now
reg       en_pass_rep;                    //pass rep fifo of next node says i can receive a flit now
reg [3:0] used_slots_pass_req;          //pass req fifo of next node says how many slots I have used ,avoiding deadlock
reg [3:0] used_slots_pass_rep;          //pass rep fifo of next node says how many slots I have used ,avoiding deadlock

reg       next_pass_req;                  //local node: flit in the head of pass req fifo says I am a flit to next node if it's 1;
reg       next_pass_rep;                  //local node: flit in the head of pass rep fifo says I am a flit to next node if it's 1;
reg       next_local_req;                 //local node: flit in the head of OUT_local req fifo says I am a flit to next node if it's 1;
reg       next_local_rep;                 //local node: flit in the head of OUT_local rep fifo says I am a flit to next node if it's 1;
reg [1:0] OUT_rep_length_code;


 //output 
 wire [3:0]   select;                      // one-hot encode select  4'b0001 : pass_rep
                                             //                        4'b0010 : local_rep
                                             //                        4'b0100 ? pass_req
                                             //                        4'b1000 ? local_req
                                             
  arbiter_4_deq    duv( 
                       //input
                       .clk(clk),
                       .rst(rst),
                       .pass_req_empty(pass_req_empty),
                       .pass_rep_empty(pass_rep_empty),
                       .OUT_local_req_empty(OUT_local_req_empty),
                       .OUT_local_rep_empty(OUT_local_rep_empty),
                       .pass_req_ctrl(pass_req_ctrl),
                       .pass_rep_ctrl(pass_rep_ctrl),
                       .out_req_ctrl(out_req_ctrl),
                       .out_rep_ctrl(out_rep_ctrl),
                       .OUT_rep_length_code(OUT_rep_length_code),
                       .en_local_req(en_local_req),
                       .en_local_rep(en_local_rep),
                       .en_pass_req(en_pass_req),
                       .en_pass_rep(en_pass_rep),
                       .used_slots_pass_req(used_slots_pass_req),
                       .used_slots_pass_rep(used_slots_pass_rep),
                       .next_pass_req(next_pass_req),
                       .next_pass_rep(next_pass_rep),
                       .next_local_req(next_local_req),
                       .next_local_rep(next_local_rep),
                       //output
                       .select(select)
                       );      
        integer log_file;
               
    initial begin
          clk = 1'b0;
          rst = 1'b1;
          pass_req_empty = 1'b0;
          pass_rep_empty = 1'b0;
          OUT_local_req_empty = 1'b0;
          OUT_local_rep_empty = 1'b0;
          pass_req_ctrl = 2'b00;
          pass_rep_ctrl = 2'b00;
          out_req_ctrl = 2'b00;
          out_rep_ctrl = 2'b00;
          OUT_rep_length_code = 2'b00;
          en_local_req = 1'b0;
          en_local_rep = 1'b0;
          en_pass_req = 1'b0;
          en_pass_rep = 1'b0;
          used_slots_pass_req = 4'b0000;
          used_slots_pass_rep = 4'b0000;
          next_pass_req = 1'b0;
          next_pass_rep = 1'b0;
          next_local_req = 1'b0;
          next_local_rep = 1'b0;
          log_file=$fopen("tb_arbiter_4_deq.txt");
     end                                    
      
      `define clk_step  #10;
      always  #5 clk=~clk;
      
      ////////////////////////////////////////////////////////////////////
      ////////////////////begin test//////////////////////////////////////
      initial begin
        
        #6;
        
        rst=1'b0;
        
        #4;
        //////////////////////////////////////////////////////////////////////////////////////
        // the case order is pass_rep 11, pass_req 10, out_rep 01, out_req 00 to next node////
        // ex: 11,10,01,00 means local fifos go to respective fifo of next node///////////////
        
        ////case 1: 11,10,01,00 ; 
        pass_req_empty = 1'b0;
        pass_rep_empty = 1'b0;
        OUT_local_req_empty = 1'b0;
        OUT_local_rep_empty = 1'b0;
        OUT_rep_length_code = 2'b00;
        
        en_local_req = 1'b1;
        en_local_rep = 1'b1;
        en_pass_req = 1'b1;
        en_pass_rep = 1'b1;
        
        next_pass_req = 1'b0;
        next_pass_rep = 1'b0;
        next_local_req = 1'b1;
        next_local_rep = 1'b1;
        
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        pass_req_ctrl = 2'b11;
        pass_rep_ctrl = 2'b11;
        out_req_ctrl = 2'b11;
        out_rep_ctrl = 2'b11;
        `clk_step
        pass_req_ctrl = 2'b00;
        pass_rep_ctrl = 2'b00;
        out_req_ctrl = 2'b00;
        out_rep_ctrl = 2'b00;
          
          
        ////case 2: -11,10,11,00 ; 
        pass_req_empty = 1'b0;
        pass_rep_empty = 1'b0;
        OUT_local_req_empty = 1'b0;
        OUT_local_rep_empty = 1'b0;
        OUT_rep_length_code = 2'b00;
        
        en_local_req = 1'b1;
        en_local_rep = 1'b1;
        en_pass_req = 1'b1;
        en_pass_rep = 1'b1;
        
        next_pass_req = 1'b0;
        next_pass_rep = 1'b0;
        next_local_req = 1'b1;
        next_local_rep = 1'b0;
        
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        pass_req_ctrl = 2'b11;
        pass_rep_ctrl = 2'b11;
        out_req_ctrl = 2'b11;
        out_rep_ctrl = 2'b11;
        `clk_step
        pass_req_ctrl = 2'b00;
        pass_rep_ctrl = 2'b00;
        out_req_ctrl = 2'b00;
        out_rep_ctrl = 2'b00;
        
        
        ////case 3: 01,10,11,00 ; 
        pass_req_empty = 1'b0;
        pass_rep_empty = 1'b0;
        OUT_local_req_empty = 1'b0;
        OUT_local_rep_empty = 1'b0;
        OUT_rep_length_code = 2'b00;
        
        en_local_req = 1'b1;
        en_local_rep = 1'b1;
        en_pass_req = 1'b1;
        en_pass_rep = 1'b1;
        
        next_pass_req = 1'b0;
        next_pass_rep = 1'b1;
        next_local_req = 1'b1;
        next_local_rep = 1'b0;
        
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        pass_req_ctrl = 2'b11;
        pass_rep_ctrl = 2'b11;
        out_req_ctrl = 2'b11;
        out_rep_ctrl = 2'b11;
        `clk_step
        pass_req_ctrl = 2'b00;
        pass_rep_ctrl = 2'b00;
        out_req_ctrl = 2'b00;
        out_rep_ctrl = 2'b00;
        
        
        ////case 4: 01,-10,11,10 ; 
        pass_req_empty = 1'b0;
        pass_rep_empty = 1'b0;
        OUT_local_req_empty = 1'b0;
        OUT_local_rep_empty = 1'b0;
        OUT_rep_length_code = 2'b00;
        
        en_local_req = 1'b1;
        en_local_rep = 1'b1;
        en_pass_req = 1'b1;
        en_pass_rep = 1'b1;
        
        next_pass_req = 1'b0;
        next_pass_rep = 1'b1;
        next_local_req = 1'b0;
        next_local_rep = 1'b0;
        
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        pass_req_ctrl = 2'b11;
        pass_rep_ctrl = 2'b11;
        out_req_ctrl = 2'b11;
        out_rep_ctrl = 2'b11;
        `clk_step
        pass_req_ctrl = 2'b00;
        pass_rep_ctrl = 2'b00;
        out_req_ctrl = 2'b00;
        out_rep_ctrl = 2'b00;
        
        
        ////case 5: 01,00,11,10 ; 
           /////////////////////////////////////////////////////////////////////////
           //////// also useful to test length code cases for OUT rep fifo /////////
           
           /// case 5.1 origin case
        pass_req_empty = 1'b0;
        pass_rep_empty = 1'b0;
        OUT_local_req_empty = 1'b0;
        OUT_local_rep_empty = 1'b0;
        OUT_rep_length_code = 2'b00;
        
        en_local_req = 1'b1;
        en_local_rep = 1'b1;
        en_pass_req = 1'b1;
        en_pass_rep = 1'b1;
        
        next_pass_req = 1'b1;
        next_pass_rep = 1'b1;
        next_local_req = 1'b0;
        next_local_rep = 1'b0;
        
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        pass_req_ctrl = 2'b11;
        pass_rep_ctrl = 2'b11;
        out_req_ctrl = 2'b11;
        out_rep_ctrl = 2'b11;
        `clk_step
        pass_req_ctrl = 2'b00;
        pass_rep_ctrl = 2'b00;
        out_req_ctrl = 2'b00;
        out_rep_ctrl = 2'b00;
        
        
         /// case 5.2 length_code is 11 and used_slots_pass_rep = 4'b0100;
         //   out_rep go is one 
        pass_req_empty = 1'b0;
        pass_rep_empty = 1'b0;
        OUT_local_req_empty = 1'b0;
        OUT_local_rep_empty = 1'b0;
        OUT_rep_length_code = 2'b11;
        used_slots_pass_rep = 4'b0100;
        
        en_local_req = 1'b1;
        en_local_rep = 1'b1;
        en_pass_req = 1'b1;
        en_pass_rep = 1'b1;
        
        next_pass_req = 1'b1;
        next_pass_rep = 1'b1;
        next_local_req = 1'b0;
        next_local_rep = 1'b0;
        
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        pass_req_ctrl = 2'b11;
        pass_rep_ctrl = 2'b11;
        out_req_ctrl = 2'b11;
        out_rep_ctrl = 2'b11;
        `clk_step
        pass_req_ctrl = 2'b00;
        pass_rep_ctrl = 2'b00;
        out_req_ctrl = 2'b00;
        out_rep_ctrl = 2'b00;
        
        /// case 5.3 length_code is 11 and used_slots_pass_rep = 4'b0101;
         //   out_rep go is zero 
        pass_req_empty = 1'b0;
        pass_rep_empty = 1'b0;
        OUT_local_req_empty = 1'b0;
        OUT_local_rep_empty = 1'b0;
        OUT_rep_length_code = 2'b11;
        used_slots_pass_rep = 4'b0101;
        
        en_local_req = 1'b1;
        en_local_rep = 1'b1;
        en_pass_req = 1'b1;
        en_pass_rep = 1'b1;
        
        next_pass_req = 1'b1;
        next_pass_rep = 1'b1;
        next_local_req = 1'b0;
        next_local_rep = 1'b0;
        
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        pass_req_ctrl = 2'b11;
        pass_rep_ctrl = 2'b11;
        out_req_ctrl = 2'b11;
        out_rep_ctrl = 2'b11;
        `clk_step
        pass_req_ctrl = 2'b00;
        pass_rep_ctrl = 2'b00;
        out_req_ctrl = 2'b00;
        out_rep_ctrl = 2'b00;
        
        
        /// case 5.4 length_code is 10 and used_slots_pass_rep = 4'b0110;
         //   out_rep go is one 
        pass_req_empty = 1'b0;
        pass_rep_empty = 1'b0;
        OUT_local_req_empty = 1'b0;
        OUT_local_rep_empty = 1'b0;
        OUT_rep_length_code = 2'b10;
        used_slots_pass_rep = 4'b0110;
        
        en_local_req = 1'b1;
        en_local_rep = 1'b1;
        en_pass_req = 1'b1;
        en_pass_rep = 1'b1;
        
        next_pass_req = 1'b1;
        next_pass_rep = 1'b1;
        next_local_req = 1'b0;
        next_local_rep = 1'b0;
        
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        pass_req_ctrl = 2'b11;
        pass_rep_ctrl = 2'b11;
        out_req_ctrl = 2'b11;
        out_rep_ctrl = 2'b11;
        `clk_step
        pass_req_ctrl = 2'b00;
        pass_rep_ctrl = 2'b00;
        out_req_ctrl = 2'b00;
        out_rep_ctrl = 2'b00;
        
        /// case 5.5 length_code is 10 and used_slots_pass_rep = 4'b0111;
         //   out_rep go is zero 
        pass_req_empty = 1'b0;
        pass_rep_empty = 1'b0;
        OUT_local_req_empty = 1'b0;
        OUT_local_rep_empty = 1'b0;
        OUT_rep_length_code = 2'b10;
        used_slots_pass_rep = 4'b0111;
        
        en_local_req = 1'b1;
        en_local_rep = 1'b1;
        en_pass_req = 1'b1;
        en_pass_rep = 1'b1;
        
        next_pass_req = 1'b1;
        next_pass_rep = 1'b1;
        next_local_req = 1'b0;
        next_local_rep = 1'b0;
        
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        pass_req_ctrl = 2'b11;
        pass_rep_ctrl = 2'b11;
        out_req_ctrl = 2'b11;
        out_rep_ctrl = 2'b11;
        `clk_step
        pass_req_ctrl = 2'b00;
        pass_rep_ctrl = 2'b00;
        out_req_ctrl = 2'b00;
        out_rep_ctrl = 2'b00;
        
        /// case 5.6 length_code is 01 and used_slots_pass_rep = 4'b1100;
         //   out_rep go is one 
        pass_req_empty = 1'b0;
        pass_rep_empty = 1'b0;
        OUT_local_req_empty = 1'b0;
        OUT_local_rep_empty = 1'b0;
        OUT_rep_length_code = 2'b01;
        used_slots_pass_rep = 4'b1100;
        
        en_local_req = 1'b1;
        en_local_rep = 1'b1;
        en_pass_req = 1'b1;
        en_pass_rep = 1'b1;
        
        next_pass_req = 1'b1;
        next_pass_rep = 1'b1;
        next_local_req = 1'b0;
        next_local_rep = 1'b0;
        
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        pass_req_ctrl = 2'b11;
        pass_rep_ctrl = 2'b11;
        out_req_ctrl = 2'b11;
        out_rep_ctrl = 2'b11;
        `clk_step
        pass_req_ctrl = 2'b00;
        pass_rep_ctrl = 2'b00;
        out_req_ctrl = 2'b00;
        out_rep_ctrl = 2'b00;
        
         /// case 5.7 length_code is 01 and used_slots_pass_rep = 4'b1101;
         //   out_rep go is zero 
        pass_req_empty = 1'b0;
        pass_rep_empty = 1'b0;
        OUT_local_req_empty = 1'b0;
        OUT_local_rep_empty = 1'b0;
        OUT_rep_length_code = 2'b01;
        used_slots_pass_rep = 4'b1101;
        
        en_local_req = 1'b1;
        en_local_rep = 1'b1;
        en_pass_req = 1'b1;
        en_pass_rep = 1'b1;
        
        next_pass_req = 1'b1;
        next_pass_rep = 1'b1;
        next_local_req = 1'b0;
        next_local_rep = 1'b0;
        
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        pass_req_ctrl = 2'b11;
        pass_rep_ctrl = 2'b11;
        out_req_ctrl = 2'b11;
        out_rep_ctrl = 2'b11;
        `clk_step
        pass_req_ctrl = 2'b00;
        pass_rep_ctrl = 2'b00;
        out_req_ctrl = 2'b00;
        out_rep_ctrl = 2'b00;
        
         /// case 5.8 length_code is 00 and used_slots_pass_rep = 4'b1110;
         //   out_rep go is one 
        pass_req_empty = 1'b0;
        pass_rep_empty = 1'b0;
        OUT_local_req_empty = 1'b0;
        OUT_local_rep_empty = 1'b0;
        OUT_rep_length_code = 2'b00;
        used_slots_pass_rep = 4'b1110;
        
        en_local_req = 1'b1;
        en_local_rep = 1'b1;
        en_pass_req = 1'b1;
        en_pass_rep = 1'b1;
        
        next_pass_req = 1'b1;
        next_pass_rep = 1'b1;
        next_local_req = 1'b0;
        next_local_rep = 1'b0;
        
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        pass_req_ctrl = 2'b11;
        pass_rep_ctrl = 2'b11;
        out_req_ctrl = 2'b11;
        out_rep_ctrl = 2'b11;
        `clk_step
        pass_req_ctrl = 2'b00;
        pass_rep_ctrl = 2'b00;
        out_req_ctrl = 2'b00;
        out_rep_ctrl = 2'b00;
        
         /// case 5.9 length_code is 00 and used_slots_pass_rep = 4'b1111;
         //   out_rep go is zero 
        pass_req_empty = 1'b0;
        pass_rep_empty = 1'b0;
        OUT_local_req_empty = 1'b0;
        OUT_local_rep_empty = 1'b0;
        OUT_rep_length_code = 2'b01;
        used_slots_pass_rep = 4'b1111;
        
        en_local_req = 1'b1;
        en_local_rep = 1'b1;
        en_pass_req = 1'b1;
        en_pass_rep = 1'b1;
        
        next_pass_req = 1'b1;
        next_pass_rep = 1'b1;
        next_local_req = 1'b0;
        next_local_rep = 1'b0;
        
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        pass_req_ctrl = 2'b11;
        pass_rep_ctrl = 2'b11;
        out_req_ctrl = 2'b11;
        out_rep_ctrl = 2'b11;
        `clk_step
        pass_req_ctrl = 2'b00;
        pass_rep_ctrl = 2'b00;
        out_req_ctrl = 2'b00;
        out_rep_ctrl = 2'b00;
        
        
        ////case 6: -11,00,11,10 ; 
        pass_req_empty = 1'b0;
        pass_rep_empty = 1'b0;
        OUT_local_req_empty = 1'b0;
        OUT_local_rep_empty = 1'b0;
        OUT_rep_length_code = 2'b00;
       
        used_slots_pass_rep = 4'b0000;
        en_local_req = 1'b1;
        en_local_rep = 1'b1;
        en_pass_req = 1'b1;
        en_pass_rep = 1'b1;
        
        next_pass_req = 1'b1;
        next_pass_rep = 1'b0;
        next_local_req = 1'b0;
        next_local_rep = 1'b0;
        
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        pass_req_ctrl = 2'b11;
        pass_rep_ctrl = 2'b11;
        out_req_ctrl = 2'b11;
        out_rep_ctrl = 2'b11;
        `clk_step
        pass_req_ctrl = 2'b00;
        pass_rep_ctrl = 2'b00;
        out_req_ctrl = 2'b00;
        out_rep_ctrl = 2'b00;
        
        
        ////case 7: 01,00\,11,00\ ; 
        pass_req_empty = 1'b0;
        pass_rep_empty = 1'b0;
        OUT_local_req_empty = 1'b0;
        OUT_local_rep_empty = 1'b0;
        OUT_rep_length_code = 2'b00;
        
        en_local_req = 1'b1;
        en_local_rep = 1'b1;
        en_pass_req = 1'b1;
        en_pass_rep = 1'b1;
        
        next_pass_req = 1'b1;
        next_pass_rep = 1'b1;
        next_local_req = 1'b1;
        next_local_rep = 1'b0;
        
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        pass_req_ctrl = 2'b11;
        pass_rep_ctrl = 2'b11;
        out_req_ctrl = 2'b11;
        out_rep_ctrl = 2'b11;
        `clk_step
        pass_req_ctrl = 2'b00;
        pass_rep_ctrl = 2'b00;
        out_req_ctrl = 2'b00;
        out_rep_ctrl = 2'b00;
        
        
        ////case 8: 01\,00\,01\,00\ ;
        pass_req_empty = 1'b0;
        pass_rep_empty = 1'b0;
        OUT_local_req_empty = 1'b0;
        OUT_local_rep_empty = 1'b0;
        OUT_rep_length_code = 2'b00;
        
        en_local_req = 1'b1;
        en_local_rep = 1'b1;
        en_pass_req = 1'b1;
        en_pass_rep = 1'b1;
        
        next_pass_req = 1'b1;
        next_pass_rep = 1'b1;
        next_local_req = 1'b1;
        next_local_rep = 1'b1;
        
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        pass_req_ctrl = 2'b11;
        pass_rep_ctrl = 2'b11;
        out_req_ctrl = 2'b11;
        out_rep_ctrl = 2'b11;
        `clk_step
        pass_req_ctrl = 2'b00;
        pass_rep_ctrl = 2'b00;
        out_req_ctrl = 2'b00;
        out_rep_ctrl = 2'b00;
        
        
        ////case 9: 11,00\,01,00\ ; 
        pass_req_empty = 1'b0;
        pass_rep_empty = 1'b0;
        OUT_local_req_empty = 1'b0;
        OUT_local_rep_empty = 1'b0;
        OUT_rep_length_code = 2'b00;
        
        en_local_req = 1'b1;
        en_local_rep = 1'b1;
        en_pass_req = 1'b1;
        en_pass_rep = 1'b1;
        
        next_pass_req = 1'b1;
        next_pass_rep = 1'b0;
        next_local_req = 1'b1;
        next_local_rep = 1'b1;
        
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        pass_req_ctrl = 2'b11;
        pass_rep_ctrl = 2'b11;
        out_req_ctrl = 2'b11;
        out_rep_ctrl = 2'b11;
        `clk_step
        pass_req_ctrl = 2'b00;
        pass_rep_ctrl = 2'b00;
        out_req_ctrl = 2'b00;
        out_rep_ctrl = 2'b00;
        
        
        ////case 10: 01\,-10,01\,10\ ; 
        pass_req_empty = 1'b0;
        pass_rep_empty = 1'b0;
        OUT_local_req_empty = 1'b0;
        OUT_local_rep_empty = 1'b0;
        OUT_rep_length_code = 2'b00;
        
        en_local_req = 1'b1;
        en_local_rep = 1'b1;
        en_pass_req = 1'b1;
        en_pass_rep = 1'b1;
        
        next_pass_req = 1'b0;
        next_pass_rep = 1'b1;
        next_local_req = 1'b0;
        next_local_rep = 1'b1;
        
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        `clk_step
        pass_req_ctrl = 2'b11;
        pass_rep_ctrl = 2'b11;
        out_req_ctrl = 2'b11;
        out_rep_ctrl = 2'b11;
        `clk_step
        pass_req_ctrl = 2'b00;
        pass_rep_ctrl = 2'b00;
        out_req_ctrl = 2'b00;
        out_rep_ctrl = 2'b00;
        
        ///////////////////////////////////////////////////////////////////////
        //////////test whether the arbiter_4_deq can avoid deadlock////////////
        used_slots_pass_req = 4'b0000;
        used_slots_pass_rep = 4'b0000;
        
        pass_req_empty = 1'b0;
        pass_rep_empty = 1'b0;
        OUT_local_req_empty = 1'b0;
        OUT_local_rep_empty = 1'b0;
        OUT_rep_length_code = 2'b00;
        
        en_local_req = 1'b1;
        en_local_rep = 1'b1;
        en_pass_req = 1'b1;
        en_pass_rep = 1'b1;
        
        next_pass_req = 1'b0;
        next_pass_rep = 1'b0;
        next_local_req = 1'b1;
        next_local_rep = 1'b1;
        
        `clk_step
        
        pass_rep_ctrl = 2'b11;
        
        `clk_step
        
        pass_rep_ctrl = 2'b00;
        
        `clk_step
        
        
        pass_req_ctrl = 2'b11;
        out_req_ctrl = 2'b11;
        out_rep_ctrl = 2'b11;
        
        `clk_step
        
        pass_req_ctrl = 2'b00;
        out_req_ctrl = 2'b00;
        out_rep_ctrl = 2'b00;
        
        `clk_step
        
        pass_rep_ctrl = 2'b11;
        out_rep_ctrl = 2'b11;
        
        `clk_step
        
        pass_rep_ctrl = 2'b00;
        out_rep_ctrl = 2'b00;
        pass_req_ctrl = 2'b11;
        out_req_ctrl = 2'b11;
        
        `clk_step
        
        pass_req_ctrl = 2'b00;
        out_req_ctrl = 2'b00;
        
        `clk_step
        
        `clk_step
        
        pass_req_ctrl = 2'b11;
        out_req_ctrl = 2'b11;
        
        `clk_step
        
        pass_req_ctrl = 2'b00;
        out_req_ctrl = 2'b00;
        
        `clk_step
        
        `clk_step
        
        pass_req_ctrl = 2'b11;
        out_req_ctrl = 2'b11;
        
        `clk_step
        
        pass_req_ctrl = 2'b00;
        out_req_ctrl = 2'b00;
        
        `clk_step
        
        
        
        pass_rep_ctrl = 2'b11;
        `clk_step
        
        
        pass_rep_ctrl = 2'b00;
        
        pass_req_ctrl = 2'b11;
        out_req_ctrl = 2'b11;
        
        `clk_step
        
        pass_req_ctrl = 2'b00;
        out_req_ctrl = 2'b00;
        
        out_rep_ctrl = 2'b11;
        `clk_step
        out_rep_ctrl = 2'b00;
        `clk_step
        
        pass_req_ctrl = 2'b11;
        out_req_ctrl = 2'b11;
        
        `clk_step
        
        pass_req_ctrl = 2'b00;
        out_req_ctrl = 2'b00;
        
        `clk_step
        
        `clk_step
        
        pass_req_ctrl = 2'b11;
        out_req_ctrl = 2'b11;
        
        `clk_step
        
        pass_req_ctrl = 2'b00;
        out_req_ctrl = 2'b00;
        
        `clk_step
        
        `clk_step
        
        pass_req_ctrl = 2'b11;
        out_req_ctrl = 2'b11;
        
        `clk_step
        
        pass_req_ctrl = 2'b00;
        out_req_ctrl = 2'b00;
        
        pass_rep_ctrl=2'b11;
        out_rep_ctrl = 2'b11;
        
        `clk_step
        pass_rep_ctrl=2'b00;
        out_rep_ctrl = 2'b00;
        
        `clk_step
        
        pass_req_ctrl = 2'b11;
        out_req_ctrl = 2'b11;
        
        `clk_step
        
        pass_req_ctrl = 2'b00;
        out_req_ctrl = 2'b00;
        
        `clk_step
        
        `clk_step
        
        pass_req_ctrl = 2'b11;
        out_req_ctrl = 2'b11;
        
        `clk_step
        
        pass_req_ctrl = 2'b00;
        out_req_ctrl = 2'b00;
        
        `clk_step
        
        `clk_step
        
        pass_req_ctrl = 2'b11;
        out_req_ctrl = 2'b11;
        
        pass_rep_ctrl = 2'b11;
        `clk_step
        
        pass_req_ctrl = 2'b00;
        out_req_ctrl = 2'b00;
        
        pass_rep_ctrl = 2'b00;
        
        `clk_step
        
        `clk_step
        out_rep_ctrl= 2'b11;
        
        `clk_step
        out_rep_ctrl = 2'b00;
        `clk_step
        
        $stop;
      end
  endmodule