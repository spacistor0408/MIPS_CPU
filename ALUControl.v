module ALUControl( clk, sel, seltoALU, seltoSHT, seltoMULTU, seltoMUX );
	input clk ;
	input  [5:0] sel ;
	output [5:0] seltoALU ;
	output [5:0] seltoSHT ;
	output [5:0] seltoMULTU ;
	output [5:0] seltoMUX ;

	reg [5:0] temp ;    // 暫存	
	reg [6:0] counter ;

	parameter AND = 6'b100100;  //36
	parameter OR  = 6'b100101;  //37
	parameter ADD = 6'b100000;  //32
	parameter SUB = 6'b100010;  //34
	parameter SLT = 6'b101010;  //42
	parameter SRL = 6'b000010;  //02
	parameter MULTU = 6'b011001; //25
	
	always@( sel )
	begin
		if ( sel == MULTU )
		begin
			// 訊號變乘法，歸零
			counter = 0 ;
		end
	end

	always@( posedge clk )
	begin
		temp = sel ;
		if ( sel == MULTU )
		begin
			// 計一次
			counter = counter + 1 ;
			
			if ( counter > 32 )
			begin
				// 打開HI LO
				temp = 6'b111111 ; // OUT
			end
		end
	end

	assign seltoALU = temp ;
	assign seltoSHT = temp ;
	assign seltoMULTU = temp ;
	assign seltoMUX = temp ;

endmodule