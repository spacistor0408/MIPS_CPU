module MEM_WB( clk, rst, en_reg,
              RegWrite,     MemtoReg,
              RegWrite_out, MemtoReg_out,
              wn,     rd,     total_alu,
              wn_out, rd_out, total_alu_out );

    input clk, rst, en_reg;
    input RegWrite, MemtoReg;
    input[4:0] wn;
    input[31:0] rd, total_alu;

    output RegWrite_out, MemtoReg_out;
    output[4:0] wn_out;
    output[31:0] rd_out, total_alu_out;

    reg RegWrite_out, MemtoReg_out;
    reg[4:0] wn_out;

    reg32 RD( .clk(clk), .rst(rst), .en_reg(en_reg), .d_in(rd), .d_out(rd_out) );
    reg32 TotalALU( .clk(clk), .rst(rst), .en_reg(en_reg), .d_in(total_alu), .d_out(total_alu_out) );

    always @( posedge clk ) begin
      if ( rst ) 
      begin
        wn_out       <= 4'b0;
        RegWrite_out <= 1'b0;
        MemtoReg_out <= 1'b0;
      end
      else if ( en_reg )
      begin
        wn_out       <= wn;
        RegWrite_out <= RegWrite;
        MemtoReg_out <= MemtoReg;
      end
    end
    
endmodule