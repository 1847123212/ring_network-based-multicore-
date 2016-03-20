/// date:2016/3/9
/// engineer: ZhaiShaoMin
module    m_rep_upload(//input
                        clk,
                        rst,
                        m_flits_rep,
                        v_m_flits_rep,
                        flits_max,
                        en_flits_max,
                        rep_fifo_rdy,
                        //output
                        m_flit_out,
                        v_m_flit_out,
                        m_rep_upload_state
                        );
//input
input                          clk;
input                          rst;
input         [175:0]          m_flits_rep;
input                          v_m_flits_rep;
input         [3:0]            flits_max;
input                          en_flits_max;
input                          rep_fifo_rdy;
                          //output
output        [15:0]            m_flit_out;
output                          v_m_flit_out;
output                          m_rep_upload_state;

//parameter 
parameter    m_rep_upload_idle=1'b0;
parameter    m_rep_upload_busy=1'b1;

//reg          m_req_nstate; 
reg          m_rep_state;
reg  [143:0]  m_rep_flits;
reg  [3:0]   sel_cnt;
reg          v_m_flit_out;
reg          fsm_rst;
reg          next;
reg          en_flits_in;
reg          inc_cnt;
reg  [3:0]   flits_max_reg;

assign m_rep_upload_state=m_rep_state;
always@(*)
begin
  //default value
 // dc_req_nstate=dc_req_state;
  v_m_flit_out=1'b0;
  inc_cnt=1'b0;
  fsm_rst=1'b0;
  en_flits_in=1'b0;
  next=1'b0;
  
  case(m_rep_state)
    m_rep_upload_idle:
       begin
         if(v_m_flits_rep)
           begin
             en_flits_in=1'b1;
             next=1'b1;
           end
       end
    m_rep_upload_busy:
       begin
         if(rep_fifo_rdy)
           begin
             if(sel_cnt==flits_max_reg)
               fsm_rst=1'b1;
             inc_cnt=1'b1;
             v_m_flit_out=1'b1;
           end
       end
    endcase
end

// fsm state
always@(posedge clk)
begin
  if(rst||fsm_rst)
    m_rep_state<=1'b0;
else if(next)
    m_rep_state<=1'b1;
end
// flits regs
always@(posedge clk)
begin
  if(rst||fsm_rst)
    m_rep_flits<=143'h0000;
  else if(en_flits_in)
    m_rep_flits<=m_flits_rep;
end
reg  [15:0]  m_flit_out;
always@(*)
begin
  case(sel_cnt)
    4'b0000:m_flit_out=m_rep_flits[143:128];
    4'b0001:m_flit_out=m_rep_flits[127:112];
    4'b0010:m_flit_out=m_rep_flits[111:96];
    4'b0011:m_flit_out=m_rep_flits[95:80];
    4'b0100:m_flit_out=m_rep_flits[79:64];
    4'b0101:m_flit_out=m_rep_flits[63:48];
    4'b0110:m_flit_out=m_rep_flits[47:32];
    4'b0111:m_flit_out=m_rep_flits[31:16];
    4'b1000:m_flit_out=m_rep_flits[15:0];
    default:m_flit_out=m_rep_flits[143:128];
  endcase
end

// flits_max
always@(posedge  clk)
begin
  if(rst||fsm_rst)
    flits_max_reg<=4'b0000;
  else if(en_flits_max)
    flits_max_reg<=flits_max;
end
    
///sel_counter
always@(posedge clk)
begin
  if(rst||fsm_rst)
    sel_cnt<=4'b0000;
  else if(inc_cnt)
    sel_cnt<=sel_cnt+1;
end

endmodule