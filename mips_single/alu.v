/*
	Title:	ALU
	Author: Garfield (Computer System and Architecture Lab, ICE, CYCU)
	Input Port
		1. ctl: 由alu_ctl解碼完的控制訊號
		2. a:   inputA,第一筆要處理的資料
		3. b:   inputB,第二筆要處理的資料
	Output Port
		1. result: 最後處理完的結果
		2. zero:   branch指令所需要之輸出
*/


module alu(ctl, a, b, result, zero);
  input [2:0] ctl;
  input [31:0] a, b;
  output [31:0] result;
  output zero;

  reg [31:0] result;
  reg zero;

  always @(a or b or ctl)
  begin
    case (ctl)
      3'b000 : result = a & b; // AND
      3'b001 : result = a | b; // OR
      3'b010 : result = a + b; // ADD
      3'b110 : result = a - b; // SUBTRACT  
      default : result = 32'hzzzzzzzz;
   endcase
   if (result == 32'd0) zero = 1;
   else zero = 0;
 end
endmodule

