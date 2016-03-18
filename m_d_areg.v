/// date:2016/3/9
/// engineer: ZhaiShaoMin
module   m_d_areg(//input
                   clk,
                   rst,
                   m_flits_d,
                   v_m_flits_d,
                   dc_done_access,
                   //output
                   m_d_areg_flits,
                   v_m_d_areg_flits,
                   m_d_areg_state
                   );
//input
input                   clk;
input                   rst;
input    [143:0]        m_flits_d;
input                   v_m_flits_d;
input                   dc_done_access;
                   //output
output   [143:0]         m_d_areg_flits;
output                   v_m_d_areg_flits;
output                   m_d_areg_state;


reg      m_d_cstate;
reg      [143:0]   flits_reg;

assign   m_d_areg_state=m_d_cstate;// when m_d_cstate is 1, it means this module is busy and
                                   // can't receive other flits. oterwise,able to receiving flits
always@(posedge clk)
begin
  if(rst||dc_done_access)
    flits_reg<=144'h0000;
else if(v_m_flits_d)
    flits_reg<=m_flits_d;
end

always@(posedge clk)
begin
  if(rst||dc_done_access)
    m_d_cstate<=1'b0;
  else if(v_m_flits_d)
    m_d_cstate<=1'b1;
end
endmodule