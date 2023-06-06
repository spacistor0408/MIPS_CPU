module EX_MEM( clk, rst, en_reg,
              Branch,     MemRead,     MemWrite,
              Branch_out, MemRead_out, MemWrite_out,
              RegWrite    , MemtoReg, 
              RegWrite_out, MemtoReg_out, 
              zero,     wn,     total_alu,     rd2,
              zero_out, wn_out, total_alu_out, rd2_out );
    
    input clk, rst, en_reg, zero;
    input MemRead, MemWrite, Branch, RegWrite, MemtoReg;
    input[4:0] wn;
    input[31:0] rd2, total_alu;

    output MemRead_out, MemWrite_out, Branch_out, RegWrite_out, MemtoReg_out;
    output zero_out;
    output[4:0] wn_out;
    output[31:0] rd2_out, total_alu_out;

    reg MemRead_out, MemWrite_out, Branch_out, RegWrite_out, MemtoReg_out;
    reg zero_out;
    reg[4:0] wn_out;

    reg32 RD2( .clk(clk), .rst(rst), .en_reg(en_reg), .d_in(rd2), .d_out(rd2_out) );
    reg32 TotalALU( .clk(clk), .rst(rst), .en_reg(en_reg), .d_in(total_alu), .d_out(total_alu_out) );

    always @( posedge clk ) begin
      if ( rst ) 
      begin
        wn_out <= 5'b0;
        MemRead_out <= 1'b0;
        MemWrite_out <= 1'b0;
        Branch_out <= 1'b0;
        RegWrite_out <= 1'b0;
        MemtoReg_out <= 1'b0;
      end
      else if ( en_reg )
      begin
        wn_out <= wn;
        MemRead_out <= MemRead;
        MemWrite_out <= MemWrite;
        Branch_out <= Branch;
        RegWrite_out <= RegWrite;
        MemtoReg_out <= MemtoReg;
      end
    end

endmodule