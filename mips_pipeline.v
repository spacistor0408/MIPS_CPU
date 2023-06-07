//	Title: MIPS Single-Cycle Processor
//	Editor: Selene (Computer System and Architecture Lab, ICE, CYCU)
module mips_single( clk, rst );
	input clk, rst;
	
	// instruction bus
	wire[31:0] IF_instr, ID_instr;
	
	// break out important fields from instruction
	wire [5:0] ID_opcode, ID_funct;
    wire [4:0] ID_rs, ID_rt, ID_rd, ID_shamt;
    wire [5:0] EX_funct;
    wire [4:0] EX_rt, EX_rd;

    wire [15:0] ID_immed;
    wire [31:0] ID_extend_immed, b_offset;
    wire [31:0] EX_extend_immed;
    wire [25:0] jumpoffset;
    
	// datapath signals
    wire [31:0] rfile_wd, alu_b, alu_out, b_tgt, pc_next,
                pc, jump_addr, branch_addr;

    wire [31:0] pc_incr;
    wire [31:0] ID_pc_incr;

    wire [31:0] MEM_dmem_rdata;
    wire [31:0] WB_dmem_rdata;

    wire [31:0] ID_rfile_rd1, ID_rfile_rd2;
    wire [31:0] EX_rfile_rd1, EX_rfile_rd2;
    wire [31:0] MEM_rfile_rd2;

    wire [4:0]  EX_rfile_wn;
    wire [4:0]  MEM_rfile_wn;
    wire [4:0]  WB_rfile_wn;

	wire [63:0] multu_Ans;
    wire [31:0] hi_out, lo_out, shift_Ans;

	// control signals
    wire ID_RegDst, ID_ALUSrc, ID_Branch, ID_MemRead, ID_MemWrite, ID_RegWrite, ID_MemtoReg, PCSrc, ID_Jump;
    wire EX_RegDst, EX_ALUSrc, EX_Branch, EX_MemRead, EX_MemWrite, EX_RegWrite, EX_MemtoReg, EX_Zero;
    wire MEM_Branch, MEM_MemRead, MEM_MemWrite, MEM_RegWrite, MEM_MemtoReg, MEM_Zero;
    wire WB_RegWrite, WB_MemtoReg;

    wire multuOp;
    wire [1:0] total_alu_sel;
    wire [31:0] EX_total_alu_out;
    wire [31:0] MEM_total_alu_out;
    wire [31:0] WB_total_alu_out;

    wire [1:0] ID_ALUOp;
    wire [1:0] EX_ALUOp;
    wire [2:0] Operation;
	
    assign ID_opcode = ID_instr[31:26];
    assign ID_rs = ID_instr[25:21];
    assign ID_rt = ID_instr[20:16];
    assign ID_rd = ID_instr[15:11];
    assign ID_shamt = ID_instr[10:6];
    assign ID_funct = ID_instr[5:0];
    assign ID_immed = ID_instr[15:0];
    assign jumpoffset = ID_instr[25:0];
	
	// branch offset shifter
    assign b_offset = ID_extend_immed << 2;
	
	// jump offset shifter & concatenation
	assign jump_addr = { pc_incr[31:28], jumpoffset <<2 };

    // module instantiations

    mux2 #(32) PCMUX( .sel(PCSrc), .a(pc_incr), .b(b_tgt), .y(branch_addr) );
	
    // jump
	mux2 #(32) JMUX( .sel(ID_Jump), .a(branch_addr), .b(jump_addr), .y(pc_next) );

    // Branch Adder
    add32 BRADD( .a(pc_incr), .b(b_offset), .result(b_tgt) );
	
	
    // ----------------- stage1 IF ----------------- //

    // PC
	reg32 PC( .clk(clk), .rst(rst), .en_reg(1'b1), .d_in(pc_next), .d_out(pc) );
	
    // Instruction Memory
    memory InstrMem( .clk(clk), .MemRead(1'b1), .MemWrite(1'b0), .wd(32'd0), .addr(pc), .rd(IF_instr) );

    // PC = PC+4
    add32 PCADD( .a(pc), .b(32'd4), .result(pc_incr) );

    IF_ID IF_ID_Reg( .clk(clk), .rst(rst), .en_reg(1'b1), 
                     .instr(IF_instr),     .pc_incr(pc_incr), 
                     .instr_out(ID_instr), .pc_incr_out(ID_pc_incr) );
    // ----------------- stage2 ID ----------------- //

    // Control Unit
    control_single CTL(.opcode(ID_opcode), .RegDst(ID_RegDst), .ALUSrc(ID_ALUSrc), .MemtoReg(ID_MemtoReg), 
                    .RegWrite(ID_RegWrite), .MemRead(ID_MemRead), .MemWrite(ID_MemWrite), .Branch(ID_Branch), 
                    .Jump(ID_Jump), .ALUOp(ID_ALUOp));

    // Register File
	reg_file RegFile( .clk(clk), .RegWrite(WB_RegWrite), .RN1(ID_rs), .RN2(ID_rt), .WN(WB_rfile_wn), 
					  .WD(rfile_wd), .RD1(ID_rfile_rd1), .RD2(ID_rfile_rd2) );

	// sign-extender
	sign_extend SignExt( .immed_in(ID_immed), .ext_immed_out(ID_extend_immed) );

    ID_EX ID_EX_Reg( .clk(clk), .rst(rst), .en_reg(1'b1),
                     .RegDst(ID_RegDst),         .ALUOp(ID_ALUOp),         .ALUSrc(ID_ALUSrc),
                     .RegDst_out(EX_RegDst),     .ALUOp_out(EX_ALUOp),     .ALUSrc_out(EX_ALUSrc),
                     .Branch(ID_Branch),         .MemRead(ID_MemRead),     .MemWrite(ID_MemWrite),
                     .Branch_out(EX_Branch),     .MemRead_out(EX_MemRead), .MemWrite_out(EX_MemWrite),
                     .RegWrite(ID_RegWrite),     .MemtoReg(ID_MemtoReg),
                     .RegWrite_out(EX_RegWrite), .MemtoReg_out(EX_MemtoReg),

                     .rd1(ID_rfile_rd1),         .rd2(ID_rfile_rd2),       .rt(ID_rt),     .rd(ID_rd),     .extend_immed(ID_extend_immed),     .funct(ID_funct),
                     .rd1_out(EX_rfile_rd1),     .rd2_out(EX_rfile_rd2),   .rt_out(EX_rt), .rd_out(EX_rd), .extend_immed_out(EX_extend_immed), .funct_out(EX_funct) );
    // ----------------- stage3 EX ----------------- //
    
    // ALU control
    alu_ctl ALUCTL( .ALUOp(EX_ALUOp), .Funct(EX_funct), .ALUOperation(Operation), .multuOp(multuOp), .total_alu_sel(total_alu_sel) );

    // ALUMUX
    mux2 #(32) ALUMUX( .sel(EX_ALUSrc), .a(EX_rfile_rd2), .b(EX_extend_immed), .y(alu_b) );

    // ALU
    ALU alu( .ctl(Operation), .dataA(EX_rfile_rd1), .dataB(alu_b), .dataOut(alu_out), .zero(Zero) );

    // Multiplier
    Multiplier MULTU( .clk(clk), .dataA(EX_rfile_rd1), .dataB(alu_b), .multuOp(multuOp), .dataOut(multu_Ans), .reset(rst) );

    // HiLo register
    HiLo HILO( .clk(clk), .MULTUAns(multu_Ans), .HiOut(hi_out), .LoOut(lo_out), .reset(rst) );

    // Shifter
    Shifter SHT( .dataA(EX_rfile_rd1), .dataB(alu_b), .dataOut(shift_Ans), .reset(rst) );

    // Total ALU MUX
    mux4_32bit TotalALU_MUX( .i0(alu_out), .i1(hi_out), .i2(lo_out), .i3(shift_Ans), .sel(total_alu_sel), .out(EX_total_alu_out) );

    // RFMUX Read File MUX
    mux2 #(5) RFMUX( .sel(EX_RegDst), .a(EX_rt), .b(EX_rd), .y(EX_rfile_wn) );

    EX_MEM EX_MEM_Reg( .clk(clk), .rst(rst), .en_reg(1'b1),
                       .Branch(EX_Branch),          .MemRead(EX_MemRead),      .MemWrite(EX_MemWrite),
                       .Branch_out(MEM_Branch),     .MemRead_out(MEM_MemRead), .MemWrite_out(MEM_MemWrite),
                       .RegWrite(EX_RegWrite),      .MemtoReg(EX_MemtoReg), 
                       .RegWrite_out(MEM_RegWrite), .MemtoReg_out(MEM_MemtoReg), 

                       .zero(EX_Zero),     .wn(EX_rfile_wn),       .total_alu(EX_total_alu_out),      .rd2(EX_rfile_rd2),
                       .zero_out(MEM_Zero), .wn_out(MEM_rfile_wn), .total_alu_out(MEM_total_alu_out), .rd2_out(MEM_rfile_rd2) );
    // ----------------- stage4 MEM ----------------- //

    // Data Memory
    memory DatMem( .clk(clk), .MemRead(MEM_MemRead), .MemWrite(MEM_MemWrite), .wd(MEM_rfile_rd2), 
				   .addr(MEM_total_alu_out), .rd(MEM_dmem_rdata) );	

    // Branch AND
    and BR_AND(PCSrc, MEM_Branch, MEM_Zero);

    MEM_WB MEM_WB_Reg( .clk(clk), .rst(rst), .en_reg(1'b1),
                       .RegWrite(MEM_RegWrite),     .MemtoReg(MEM_MemtoReg),
                       .RegWrite_out(WB_RegWrite), .MemtoReg_out(WB_MemtoReg),

                       .wn(MEM_rfile_wn),     .rd(MEM_dmem_rdata),   .total_alu(MEM_total_alu_out),
                       .wn_out(WB_rfile_wn), .rd_out(WB_dmem_rdata), .total_alu_out(WB_total_alu_out) );
    // ----------------- stage5 WB ----------------- //

    // WRMUX
    mux2 #(32) WRMUX( .sel(WB_MemtoReg), .a(WB_total_alu_out), .b(WB_dmem_rdata), .y(rfile_wd) );

				   
endmodule
