
module TotalALU( clk, dataA, dataB, ALUOp, Output, reset );
input reset ;
input clk ;
input [31:0] dataA ;
input [31:0] dataB ;
input [2:0] ALUOp ;
output [31:0] Output ;

/*
定義各種訊號
*/
//============================
wire [5:0]  SignaltoALU ;
wire [5:0]  SignaltoSHT ;
wire [5:0]  SignaltoMULT ;
wire [5:0]  SignaltoMUX ;
wire [31:0] ALUOut, HiOut, LoOut, ShifterOut ;
wire [31:0] dataOut ;
wire [63:0] MULTUAns ;
/*
定義各種接線
*/
//============================

ALUControl ALUControl( .clk(clk), .sel(ALUOp), .seltoALU(SignaltoALU), .seltoSHT(SignaltoSHT), .seltoMULTU(SignaltoMULT), .seltoMUX(SignaltoMUX) );

ALU ALU( .dataA(dataA), .dataB(dataB), .Signal(SignaltoALU), .dataOut(ALUOut), .reset(reset) );
Multiplier Multiplier( .clk(clk), .dataA(dataA), .dataB(dataB), .Signal(SignaltoMULT), .dataOut(MULTUAns), .reset(reset) );
Shifter Shifter( .dataA(dataA), .dataB(dataB), .Signal(SignaltoSHT), .dataOut(ShifterOut), .reset(reset) );
HiLo HiLo( .clk(clk), .MULTUAns(MULTUAns), .HiOut(HiOut), .LoOut(LoOut), .reset(reset) );

MUX MUX( .ALUOut(ALUOut), .HiOut(HiOut), .LoOut(LoOut), .Shifter(ShifterOut), .sel(SignaltoMUX), .dataOut(dataOut) ); // deside which output result
/*
建立各種module
*/
assign Output = dataOut ;


endmodule