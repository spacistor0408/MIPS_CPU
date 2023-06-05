module EX_MEM( clk, rst, en_reg,
             MemRead, MemWrite, Branch, MemRead_out, MemWrite_out, Branch_out,
             zero, wn, total_alu_out, rfile_rd2,
             zero_out, wn_out, total_alu_out_out, rfile_rd2_out );
    
    input clk, rst, en_reg, zero;
    input MemRead, MemWrite, Branch;
    input[4:0] wn;

    output MemRead_out, MemWrite_out, Branch_out;
    output zero_out;
    output[4:0] wn_out;

    always @( posedge clk ) begin
      if ( rst ) 
      begin
        wn <= 5'b00000;
      end
      else if ( en_reg )
      begin
        wn_out <= wn;
      end
    end

endmodule