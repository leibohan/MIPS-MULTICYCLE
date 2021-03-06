`define ADD_OP 6'h00
`define ADDU_OP 6'h00
`define ADDI_OP 6'h08
`define ADDIU_OP 6'h09
`define SUB_OP 6'h00
`define SUBU_OP 6'b00
`define SLT_OP 6'h00
`define SLTU_OP 6'h00
`define SLTI_OP 6'h0a
`define SLTIU_OP 6'h0b
`define AND_OP 6'h00
`define ANDI_OP 6'h0c
`define OR_OP 6'h00
`define ORI_OP 6'h0d
`define XOR_OP 6'h00
`define XORI_OP 6'h0e
`define LUI_OP 6'h0f
`define NOR_OP 6'h00
`define SLL_OP 6'h00
`define SLLV_OP 6'h00
`define SRL_OP 6'h00
`define SRLV_OP 6'h00
`define SRA_OP 6'h00
`define SRAV_OP 6'h00
`define LB_OP 6'h20
`define LH_OP 6'h21
`define LW_OP 6'h23
`define LBU_OP 6'h24
`define LHU_OP 6'h25
`define SB_OP 6'h28
`define SH_OP 6'h29
`define SW_OP 6'h2b
`define BLTZ_OP 6'h01
`define BGEZ_OP 6'h01
`define BEQ_OP 6'h04
`define BNE_OP 6'h05
`define BLEZ_OP 6'h06
`define BGTZ_OP 6'h07
`define JR_OP 6'h00
`define JALR_OP 6'h00
`define J_OP 6'h02
`define JAL_OP 6'h03

`define SLL_FUNCT 6'h00
`define SRL_FUNCT 6'h02
`define SRA_FUNCT 6'h03
`define SLLV_FUNCT 6'h04
`define SRLV_FUNCT 6'h06
`define SRAV_FUNCT 6'h07
`define JR_FUNCT 6'h08
`define JALR_FUNCT 6'h09
`define ADD_FUNCT 6'h20
`define ADDU_FUNCT 6'h21
`define SUB_FUNCT 6'h22
`define SUBU_FUNCT 6'h23
`define AND_FUNCT 6'h24
`define OR_FUNCT 6'h25
`define XOR_FUNCT 6'h26
`define NOR_FUNCT 6'h27
`define SLT_FUNCT 6'h2a
`define SLTU_FUNCT 6'h2b

`define BLTZ_FUNCT 6'h00
`define BGEZ_FUNCT 6'h01
`define BLEZ_FUNCT 6'h00
`define BGTZ_FUNCT 6'h00
