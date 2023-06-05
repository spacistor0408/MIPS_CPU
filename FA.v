`timescale 1ns/1ns
module FA( a, b, cin, sum, cout ) ;
  
  input a, b, cin ;
  output sum, cout ;
  
  wire e1, e2, e3 ;
  
  xor (e1, a, b) ;
  and (e2, a, b) ;
  
  xor (sum, e1, cin ) ;
  and(e3, e1, cin) ;
  xor(cout, e3, e2) ;
  
endmodule