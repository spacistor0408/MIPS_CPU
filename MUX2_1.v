`timescale 1ns/1ns
module MUX2_1( i0, i1, sel, out );
  
  input i0, i1 ;
  input sel ;
  output out ;
  
  assign out = (sel)? i1: i0 ;
  
endmodule