module ID_EX( clk, rst, en_reg,
             RegDst, ALUOp, ALUSrc, RegDst_out, ALUOp_out, ALUSrc_out,
             rd1, rd2, wn, extend_immed, alu_ctl, multuOp, total_alu_sel,
             rd1_out, rd2_out, wn_out, extend_immed_out, alu_ctl_out, multuOp_out, total_alu_sel_out );

    input clk, rst, en_reg, multuOp, ALUSrc, RegDst;
    input[1:0] total_alu_sel, ALUOp;
    input[2:0] alu_ctl;
    input[4:0] wn;
    input[31:0] rd1, rd2, extend_immed;
    
    output multuOp_out, ALUSrc_out, RegDst_out;
    output[1:0] total_alu_sel_out, ALUOp_out;
    output[2:0] alu_ctl_out;
    output[4:0] wn_out;
    output[31:0] rd1_out, rd2_out, extend_immed_out;
    
    reg multuOp_out, ALUSrc_out, RegDst_out;
    reg[1:0] total_alu_sel_out, ALUOp;
    reg[2:0] alu_ctl_out;
    reg[4:0] wn_out;

    reg32 RD1( .clk(clk), .rst(rst), .en_reg(en_reg), .d_in(rd1), .d_out(rd1_out) );
    reg32 RD2( .clk(clk), .rst(rst), .en_reg(en_reg), .d_in(rd2), .d_out(rd2_out) );
    reg32 Extend_immed( .clk(clk), .rst(rst), .en_reg(en_reg), .d_in(extend_immed), .d_out(extend_immed_out) );

    always @( posedge clk ) begin
      if ( rst ) 
      begin
        RegDst_out <= 1'b0;
        ALUSrc_out <= 1'b0;
        ALUOp_out <= 2'b00;
        multuOp_out <= 1'b0;
        total_alu_sel_out <= 2'b00;
        alu_ctl_out <= 3'b000;
        wn_out <= 5'b00000;
      end
      else if ( en_reg )
      begin
        RegDst_out <= RegDst;
        ALUSrc_out <= ALUSrc;
        ALUOp_out <= ALUOp;
        multuOp_out <= multuOp;
        total_alu_sel_out <= total_alu_sel;
        alu_ctl_out <= alu_ctl;
        wn_out <= wn;
      end
    end
    
endmodule