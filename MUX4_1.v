module MUX4_1( i0, i1, i2, i3, sel, out );
  
  input i0, i1, i2, i3 ;
  input[1:0] sel ;
  output out ;
  
  assign out = (sel[1])?(sel[0]?i3:i2):(sel[0]?i1:i0) ;
  
endmodule