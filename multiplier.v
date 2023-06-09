module Multiplier( clk, dataA, dataB, multuOp, dataOut, reset ) ;
  input clk ;
  input reset ;
  input [31:0] dataA ;
  input [31:0] dataB ;
  input multuOp ;
  output [63:0] dataOut ;
  
  reg [63:0] dataOut;
  reg [63:0] product ;
  reg [63:0] multiplicand ;
  reg [31:0] multiplier ;
  reg [5:0] counter ;
  reg signal ;

  always@( posedge clk or reset )
  begin
    // reset zero
    if ( reset ) product = 64'b0 ;
    // Multiply
    else
    begin
      if ( multuOp == 1'b1 ) 
        begin
          signal = 1'b1;
          counter = 6'b0 ;
          multiplicand = {32'b0, dataA} ;
          multiplier = dataB ;
        end

      if ( signal == 1'b1 )
      begin
        if ( counter == 6'd32 )
          begin
            dataOut = product;
            signal = 1'b0 ;
          end

        else if ( counter < 8'd32 )
          begin
            if ( multiplier[0] )
              begin
                product = product + multiplicand ; 
              end
            multiplicand = multiplicand << 1 ;
            multiplier = multiplier >> 1 ;
          end

        counter = counter + 1 ;
      end
      
    end
  end 

endmodule