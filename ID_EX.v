module ID_EX( clk, rst, en_reg,
             RegDst,     ALUOp,     ALUSrc,
             RegDst_out, ALUOp_out, ALUSrc_out,
             Branch,     MemRead,     MemWrite,
             Branch_out, MemRead_out, MemWrite_out,
             RegWrite,     MemtoReg,
             RegWrite_out, MemtoReg_out,
             rd1,     rd2,     rt,     rd,     extend_immed,     funct,
             rd1_out, rd2_out, rt_out, rd_out, extend_immed_out, funct_out );

    input clk, rst, en_reg, RegDst, ALUSrc;
    input Branch, MemRead, MemWrite, RegWrite, MemtoReg;
    input[1:0] ALUOp;
    input[4:0] rt, rd;
    input[5:0] funct;
    input[31:0] rd1, rd2, extend_immed;
    
    output RegDst_out, ALUSrc_out;
    output Branch_out, MemRead_out, MemWrite_out, RegWrite_out, MemtoReg_out;
    output[1:0] ALUOp_out;
    output[4:0] rt_out, rd_out;
    output[5:0] funct_out;
    output[31:0] rd1_out, rd2_out, extend_immed_out;
    
    reg RegDst_out, ALUSrc_out;
    reg Branch_out, MemRead_out, MemWrite_out, RegWrite_out, MemtoReg_out;
    reg[1:0] ALUOp_out;
    reg[4:0] rt_out, rd_out;
    reg[5:0] funct_out;

    reg32 RD1( .clk(clk), .rst(rst), .en_reg(en_reg), .d_in(rd1), .d_out(rd1_out) );
    reg32 RD2( .clk(clk), .rst(rst), .en_reg(en_reg), .d_in(rd2), .d_out(rd2_out) );
    reg32 Extend_immed( .clk(clk), .rst(rst), .en_reg(en_reg), .d_in(extend_immed), .d_out(extend_immed_out) );

    always @( posedge clk ) begin
      if ( rst ) 
      begin
        RegDst_out        <= 1'b0;
        ALUSrc_out        <= 1'b0;
        ALUOp_out         <= 2'b0;
        Branch_out        <= 1'b0;
        MemRead_out       <= 1'b0;
        MemWrite_out      <= 1'b0;
        RegWrite_out      <= 1'b0;
        MemtoReg_out      <= 1'b0;
        funct_out         <= 6'b0;
      end
      else if ( en_reg )
      begin
        RegDst_out        <= RegDst;
        ALUSrc_out        <= ALUSrc;
        ALUOp_out         <= ALUOp;
        rt_out            <= rt;
        rd_out            <= rd;
        Branch_out        <= Branch;
        MemRead_out       <= MemRead;
        MemWrite_out      <= MemWrite;
        RegWrite_out      <= RegWrite;
        MemtoReg_out      <= MemtoReg;
        funct_out         <= funct;
      end
    end
    
endmodule