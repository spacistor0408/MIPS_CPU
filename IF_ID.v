module IF_ID( clk, rst, en_reg, instr, pc_incr, instr_out, pc_incr_out );
    
    input clk, rst, en_reg;
    input[31:0] instr, pc_incr;
    input[31:0] instr_out, pc_incr_out;
    
    reg32 Instr( .clk(clk), .rst(rst), .en_reg(en_reg), .d_in(instr), .d_out(instr_out) );
    reg32 PC_Incr( .clk(clk), .rst(rst), .en_reg(en_reg), .d_in(pc_incr), .d_out(pc_incr_out) );

endmodule