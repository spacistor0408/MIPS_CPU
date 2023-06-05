//	Title: MIPS Single-Cycle Processor
//	Editor: Selene (Computer System and Architecture Lab, ICE, CYCU)
module mips_single( clk, rst );
	input clk, rst;
	
	// instruction bus
	wire[31:0] ID_instr, EX_instr;
	
	// break out important fields from instruction
	wire [5:0] opcode, funct;
    wire [4:0] rs, rt, rd, shamt;
    wire [15:0] immed;
    wire [31:0] extend_immed, b_offset;
    wire [25:0] jumpoffset;
    
	// datapath signals
    wire [4:0] rfile_wn;
    wire [31:0] rfile_rd1, rfile_rd2, rfile_wd, alu_b, alu_out, b_tgt, pc_next,
                pc, IF_pc_incr, dmem_rdata, jump_addr, branch_addr,
                ID_pc_incr;
	wire [63:0] multu_Ans;
    wire [31:0] hi_out, lo_out, shift_Ans;

	// control signals
    wire RegWrite, Branch, PCSrc, RegDst, MemtoReg, MemRead, MemWrite, ALUSrc, Zero, Jump;
    wire multuOp, total_alu_sel, total_alu_out;
    wire [1:0] ALUOp;
    wire [2:0] Operation;
	
    assign opcode = EX_instr[31:26];
    assign rs = EX_instr[25:21];
    assign rt = EX_instr[20:16];
    assign rd = EX_instr[15:11];
    assign shamt = EX_instr[10:6];
    assign funct = EX_instr[5:0];
    assign immed = EX_instr[15:0];
    assign jumpoffset = EX_instr[25:0];
	
	// branch offset shifter
    assign b_offset = extend_immed << 2;
	
	// jump offset shifter & concatenation
	assign jump_addr = { IF_pc_incr[31:28], jumpoffset <<2 };

	// module instantiations
	
    // ----------------- stage1 IF ----------------- //

    // PC
	reg32 PC( .clk(clk), .rst(rst), .en_reg(1'b1), .d_in(pc_next), .d_out(pc) );
	
    // Instruction Memory
    memory InstrMem( .clk(clk), .MemRead(1'b1), .MemWrite(1'b0), .wd(32'd0), .addr(pc), .rd(instr) );

    // PC = PC+4
    add32 PCADD( .a(pc), .b(32'd4), .result(IF_pc_incr) );

    IF_ID IF_ID_Reg( .clk(clk), .rst(rst), .en_reg(1'b1), 
                     .instr(ID_instr),     .pc_incr(IF_pc_incr), 
                     .instr_out(EX_instr), .pc_incr_out(ID_pc_incr) );
    // ----------------- stage2 ID ----------------- //

    // Control Unit
    control_single CTL(.opcode(opcode), .RegDst(RegDst), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), 
                    .RegWrite(RegWrite), .MemRead(MemRead), .MemWrite(MemWrite), .Branch(Branch), 
                    .Jump(Jump), .ALUOp(ALUOp));

    // Register File
	reg_file RegFile( .clk(clk), .RegWrite(RegWrite), .RN1(rs), .RN2(rt), .WN(rfile_wn), 
					  .WD(rfile_wd), .RD1(rfile_rd1), .RD2(rfile_rd2) );

	// sign-extender
	sign_extend SignExt( .immed_in(immed), .ext_immed_out(extend_immed) );

    // ALU control
    alu_ctl ALUCTL( .ALUOp(ALUOp), .Funct(funct), .ALUOperation(Operation), .multuOp(multuOp), .total_alu_sel(total_alu_sel) );

    // RFMUX Read File MUX
    mux2 #(5) RFMUX( .sel(RegDst), .a(rt), .b(rd), .y(rfile_wn) );

    ID_EX ID_EX_Reg( .clk(clk), .rst(rst), .en_reg(1'b1),
                     .RegDst(),     .ALUOp(),     .ALUSrc(),
                     .RegDst_out(), .ALUOp_out(), .ALUSrc_out(),
                     .rd1(),     .rd2(),     .wn(),     .extend_immed(),     .alu_ctl(),     .multuOp(),     .total_alu_sel(),
                     .rd1_out(), .rd2_out(), .wn_out(), .extend_immed_out(), .alu_ctl_out(), .multuOp_out(), .total_alu_sel_out() );
    // ----------------- stage3 EX ----------------- //
    
    // ALUMUX
    mux2 #(32) ALUMUX( .sel(ALUSrc), .a(rfile_rd2), .b(extend_immed), .y(alu_b) );

    // ALU
    alu ALU( .ctl(Operation), .a(rfile_rd1), .b(alu_b), .result(alu_out), .zero(Zero) );

    // Multiplier
    multiplier MULTU( .clk(clk), .dataA(rfile_rd1), .dataB(alu_b), .multuOp(multuOp), .dataOut(multu_Ans), .reset(rst) );

    // HiLo register
    HiLo HILO( .clk(clk), .MULTUAns(multu_Ans), .HiOut(hi_out), .LoOut(lo_out), .reset(rst) );

    // Shifter
    Shifter SHT( .dataA(rfile_rd1), .dataB(alu_b), .dataOut(shift_Ans), .reset(rst) );

    // Total ALU MUX
    MUX4_1 TotalALU_MUX( .i0(alu_out), .i1(hi_out), .i2(lo_out), .i3(shift_Ans), .sel(total_alu_sel), .out(total_alu_out) );

    EX_MEM EX_MEM_Reg();
    // ----------------- stage4 MEM ----------------- //

    // Data Memory
    memory DatMem( .clk(clk), .MemRead(MemRead), .MemWrite(MemWrite), .wd(rfile_rd2), 
				   .addr(total_alu_out), .rd(dmem_rdata) );	

    // Branch AND
    and BR_AND(PCSrc, Branch, Zero);

    MEM_WB MEM_WB_Reg( .clk(clk), .rst(rst), .en_reg(1'b1),
                       .RegWrite(),     .MemtoReg(),
                       .RegWrite_out(), .MemtoReg_out(),
                       .wn(),     .rd(),     .total_alu(),
                       .wn_out(), .rd_out(), .total_alu_out() );
    // ----------------- stage5 WB ----------------- //

    // WRMUX
    mux2 #(32) WRMUX( .sel(MemtoReg), .a(total_alu_out), .b(dmem_rdata), .y(rfile_wd) );
	

    
    // Branch Adder
    add32 BRADD( .a(ID_pc_incr), .b(b_offset), .result(b_tgt) );

    mux2 #(32) PCMUX( .sel(PCSrc), .a(pc_incr), .b(b_tgt), .y(branch_addr) );
	
	mux2 #(32) JMUX( .sel(Jump), .a(branch_addr), .b(jump_addr), .y(pc_next) );

				   
endmodule
