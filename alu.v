/*
	Title:	ALU
	Input Port
		1. ctl: 由alu_ctrl解碼完的控制訊號
		2. dataA:   inputA,第一筆要處理的資料
		3. dataB:   inputB,第二筆要處理的資料
	Output Port
		1. dataOut: 最後處理完的結果
		2. zero:   branch指令所需要的輸出
*/

module ALU( ctl, dataA, dataB, dataOut, zero );
  input [2:0] ctl ;
  input [31:0] dataA ;
  input [31:0] dataB ;

  output [31:0] dataOut ;
  output zero ;

  wire [31:0] cout, sumAdd ;
  wire [31:0] result ; // store output
  wire inv, set ;

  wire zero ;


  assign set = sumAdd[31] ;
  assign zero = ( result == 32'b0 ) ? 1'b1 : 1'b0 ;

  ALU_Slice slice0( .a(dataA[0]), .b(dataB[0]), .cin(ctl[2]), .less(set), .ctl(ctl), .cout(cout[0]), .out(result[0]), .sumAdd(sumAdd[0] ) ) ;
  ALU_Slice slice1( .a(dataA[1]), .b(dataB[1]), .cin(cout[0]), .less(1'b0), .ctl(ctl), .cout(cout[1]), .out(result[1]), .sumAdd(sumAdd[1] ) ) ;
  ALU_Slice slice2( .a(dataA[2]), .b(dataB[2]), .cin(cout[1]), .less(1'b0), .ctl(ctl), .cout(cout[2]), .out(result[2]), .sumAdd(sumAdd[2] ) ) ;
  ALU_Slice slice3( .a(dataA[3]), .b(dataB[3]), .cin(cout[2]), .less(1'b0), .ctl(ctl), .cout(cout[3]), .out(result[3]), .sumAdd(sumAdd[3] ) ) ;
  ALU_Slice slice4( .a(dataA[4]), .b(dataB[4]), .cin(cout[3]), .less(1'b0), .ctl(ctl), .cout(cout[4]), .out(result[4]), .sumAdd(sumAdd[4] ) ) ;
  ALU_Slice slice5( .a(dataA[5]), .b(dataB[5]), .cin(cout[4]), .less(1'b0), .ctl(ctl), .cout(cout[5]), .out(result[5]), .sumAdd(sumAdd[5] ) ) ;
  ALU_Slice slice6( .a(dataA[6]), .b(dataB[6]), .cin(cout[5]), .less(1'b0), .ctl(ctl), .cout(cout[6]), .out(result[6]), .sumAdd(sumAdd[6] ) ) ;
  ALU_Slice slice7( .a(dataA[7]), .b(dataB[7]), .cin(cout[6]), .less(1'b0), .ctl(ctl), .cout(cout[7]), .out(result[7]), .sumAdd(sumAdd[7] ) ) ;
  ALU_Slice slice8( .a(dataA[8]), .b(dataB[8]), .cin(cout[7]), .less(1'b0), .ctl(ctl), .cout(cout[8]), .out(result[8]), .sumAdd(sumAdd[8] ) ) ;
  ALU_Slice slice9( .a(dataA[9]), .b(dataB[9]), .cin(cout[8]), .less(1'b0), .ctl(ctl), .cout(cout[9]), .out(result[9]), .sumAdd(sumAdd[9] ) ) ;
  ALU_Slice slice10( .a(dataA[10]), .b(dataB[10]), .cin(cout[9]), .less(1'b0), .ctl(ctl), .cout(cout[10]), .out(result[10]), .sumAdd(sumAdd[10] ) ) ;
  ALU_Slice slice11( .a(dataA[11]), .b(dataB[11]), .cin(cout[10]), .less(1'b0), .ctl(ctl), .cout(cout[11]), .out(result[11]), .sumAdd(sumAdd[11] ) ) ;
  ALU_Slice slice12( .a(dataA[12]), .b(dataB[12]), .cin(cout[11]), .less(1'b0), .ctl(ctl), .cout(cout[12]), .out(result[12]), .sumAdd(sumAdd[12] ) ) ;
  ALU_Slice slice13( .a(dataA[13]), .b(dataB[13]), .cin(cout[12]), .less(1'b0), .ctl(ctl), .cout(cout[13]), .out(result[13]), .sumAdd(sumAdd[13] ) ) ;
  ALU_Slice slice14( .a(dataA[14]), .b(dataB[14]), .cin(cout[13]), .less(1'b0), .ctl(ctl), .cout(cout[14]), .out(result[14]), .sumAdd(sumAdd[14] ) ) ;
  ALU_Slice slice15( .a(dataA[15]), .b(dataB[15]), .cin(cout[14]), .less(1'b0), .ctl(ctl), .cout(cout[15]), .out(result[15]), .sumAdd(sumAdd[15] ) ) ;
  ALU_Slice slice16( .a(dataA[16]), .b(dataB[16]), .cin(cout[15]), .less(1'b0), .ctl(ctl), .cout(cout[16]), .out(result[16]), .sumAdd(sumAdd[16] ) ) ;
  ALU_Slice slice17( .a(dataA[17]), .b(dataB[17]), .cin(cout[16]), .less(1'b0), .ctl(ctl), .cout(cout[17]), .out(result[17]), .sumAdd(sumAdd[17] ) ) ;
  ALU_Slice slice18( .a(dataA[18]), .b(dataB[18]), .cin(cout[17]), .less(1'b0), .ctl(ctl), .cout(cout[18]), .out(result[18]), .sumAdd(sumAdd[18] ) ) ;
  ALU_Slice slice19( .a(dataA[19]), .b(dataB[19]), .cin(cout[18]), .less(1'b0), .ctl(ctl), .cout(cout[19]), .out(result[19]), .sumAdd(sumAdd[19] ) ) ;
  ALU_Slice slice20( .a(dataA[20]), .b(dataB[20]), .cin(cout[19]), .less(1'b0), .ctl(ctl), .cout(cout[20]), .out(result[20]), .sumAdd(sumAdd[20] ) ) ;
  ALU_Slice slice21( .a(dataA[21]), .b(dataB[21]), .cin(cout[20]), .less(1'b0), .ctl(ctl), .cout(cout[21]), .out(result[21]), .sumAdd(sumAdd[21] ) ) ;
  ALU_Slice slice22( .a(dataA[22]), .b(dataB[22]), .cin(cout[21]), .less(1'b0), .ctl(ctl), .cout(cout[22]), .out(result[22]), .sumAdd(sumAdd[22] ) ) ;
  ALU_Slice slice23( .a(dataA[23]), .b(dataB[23]), .cin(cout[22]), .less(1'b0), .ctl(ctl), .cout(cout[23]), .out(result[23]), .sumAdd(sumAdd[23] ) ) ;
  ALU_Slice slice24( .a(dataA[24]), .b(dataB[24]), .cin(cout[23]), .less(1'b0), .ctl(ctl), .cout(cout[24]), .out(result[24]), .sumAdd(sumAdd[24] ) ) ;
  ALU_Slice slice25( .a(dataA[25]), .b(dataB[25]), .cin(cout[24]), .less(1'b0), .ctl(ctl), .cout(cout[25]), .out(result[25]), .sumAdd(sumAdd[25] ) ) ;
  ALU_Slice slice26( .a(dataA[26]), .b(dataB[26]), .cin(cout[25]), .less(1'b0), .ctl(ctl), .cout(cout[26]), .out(result[26]), .sumAdd(sumAdd[26] ) ) ;
  ALU_Slice slice27( .a(dataA[27]), .b(dataB[27]), .cin(cout[26]), .less(1'b0), .ctl(ctl), .cout(cout[27]), .out(result[27]), .sumAdd(sumAdd[27] ) ) ;
  ALU_Slice slice28( .a(dataA[28]), .b(dataB[28]), .cin(cout[27]), .less(1'b0), .ctl(ctl), .cout(cout[28]), .out(result[28]), .sumAdd(sumAdd[28] ) ) ;
  ALU_Slice slice29( .a(dataA[29]), .b(dataB[29]), .cin(cout[28]), .less(1'b0), .ctl(ctl), .cout(cout[29]), .out(result[29]), .sumAdd(sumAdd[29] ) ) ;
  ALU_Slice slice30( .a(dataA[30]), .b(dataB[30]), .cin(cout[29]), .less(1'b0), .ctl(ctl), .cout(cout[30]), .out(result[30]), .sumAdd(sumAdd[30] ) ) ;
  ALU_Slice slice31( .a(dataA[31]), .b(dataB[31]), .cin(cout[30]), .less(1'b0), .ctl(ctl), .cout(cout[31]), .out(result[31]), .sumAdd(sumAdd[31] ) ) ;

  assign dataOut = result ;

endmodule