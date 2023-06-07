module HiLo( clk, MULTUAns, HiOut, LoOut, reset );

	input clk ;
	input reset ;
	input [63:0] MULTUAns ;
	output [31:0] HiOut ;
	output [31:0] LoOut ;

	reg [63:0] HiLo ;

	always@( posedge clk or reset )
	begin
		if ( reset )
		begin
			HiLo = 64'd0 ;
		end
		else 
		begin
			HiLo = MULTUAns ;
		end
	end

	assign HiOut = HiLo[63:32] ;
	assign LoOut = HiLo[31:0] ;
	
endmodule