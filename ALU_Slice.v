//-----------------------------------------------------------------------------
// Title         : ALU Slice
// Input Port
// 	1. a: 1-but dataA
// 	2. b: 1-but dataB
// 	3. cin: 1-bit carry in
// 	4. less: 1-bit lsee
// 	5. ctl: 3-bit control signal to decide alu operation
// Output Port
// 	1. cout: 1-bit carry out
// 	2. out: 1-bit result

//-----------------------------------------------------------------------------

module ALU_Slice( a, b, cin, less, ctl, cout, out, sumAdd ) ;
  
  input a, b, cin, less ;
  input[2:0] ctl ;
  output cout, out, sumAdd ;
  
  wire e1, e2, bi, slt ;
  
  //   ctl
  //   AND  : 000
  //   OR   : 001
  //   ADD  : 010
  //   SUB  : 110
  //   LSN  : 111 
  
  and (e1, a, b) ;
  or (e2, a, b) ;
  xor (bi, b, ctl[2]) ;
  FA fa( .a(a), .b(bi), .cin(cin), .sum(sum), .cout(cout) ) ;
  
  assign sumAdd = sum ;
  assign slt = less? 1'b1: 1'b0 ;
  
  MUX4_1 mux4to1( .i0(e1), .i1(e2), .i2(sum), .i3(less), .sel(ctl[1:0]), .out(out) ) ;
  
endmodule