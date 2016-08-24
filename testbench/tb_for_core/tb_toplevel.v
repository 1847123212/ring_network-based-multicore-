///2016/8/6
///ShaoMin Zhai
///module function : used to test core pipeline

`timescale 1ns/1ps

module tb_toplevel();
  
reg clk;
reg rst;

top_level    duv (
                  .clk(clk),
                  .rst(rst)
                  );
           
      always #5 clk=~clk;
      `define clk_step #8;
             
      initial begin
        rst=1'b1;
        clk=1'b0;
       // forever #5 clk=~clk;
      
        `clk_step
        rst=1'b0;
        #500;
        
        repeat(20)
        begin
         #2;
        `clk_step
        end
        $stop;
      end
      
    endmodule
        