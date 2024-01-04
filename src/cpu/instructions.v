module cpu

enum AddressingMode {
	am_imp
	am_r_d16
	am_r_r
	am_mr_r
	am_r
	am_r_d8
	am_r_mr
	am_r_hli
	am_r_hld
	am_hli_r
	am_r_a8
	am_a8_r
	am_hl_spr
	am_d16
	am_d8
	am_d16_r
	am_mr_d8
	am_mr
	am_a16_r
	am_r_a16
}

enum RegisterType {
	rt_none
	rt_a
	rt_f
	rt_b
	rt_c
	rt_d
	rt_e
	rt_h
	rt_l
	rt_af
	rt_bc
	rt_de
	rt_hl
	rt_sp
	rt_pc
}

enum InstructionType {
	in_none
	in_nop
	in_ld
	in_inc
	in_dec
	in_rlca
	in_add
	in_rrca
	in_stop
	in_rla
	in_jr
	in_rra
	in_daa
	in_cpl
	in_scf
	in_ccf
	in_halt
	in_adc
	in_sub
	in_sbc
	in_and
	in_xor
	in_or
	in_cp
	in_pop
	in_jp
	in_push
	in_ret
	in_cb
	in_call
	in_reti
	in_ldh
	in_jphl
	in_di
	in_ei
	in_rst
	in_err

	// cb instructions
	in_rlc
	in_rrc
	in_rl
	in_rr
	in_sla
	in_sra
	in_swap
	in_srl
	in_bit
	in_res
	in_set
}

fn (ins InstructionType) name() string {
	return instruction_names[int(ins)]
}

const instruction_names := [
	"<NONE>"
	"NOP"
	"LD"
	"INC"
	"DEC"
	"RLCA"
	"ADD"
	"RRCA"
	"STOP"
	"RLA"
	"JR"
	"RRA"
	"DAA"
	"CPL"
	"SCF"
	"CCF"
	"HALT"
	"ADC"
	"SUB"
	"SBC"
	"AND"
	"XOR"
	"OR"
	"CP"
	"POP"
	"JP"
	"PUSH"
	"RET"
	"CB"
	"CALL"
	"RETI"
	"LDH"
	"JPHL"
	"DI"
	"EI"
	"RST"
	"IN_ERR"
	"IN_RLC"
	"IN_RRC"
	"IN_RL"
	"IN_RR"
	"IN_SLA"
	"IN_SRA"
	"IN_SWAP"
	"IN_SRL"
	"IN_BIT"
	"IN_RES"
	"IN_SET"
]

enum ConditionType {
	ct_none
	ct_nz
	ct_z
	ct_nc
	ct_c
}

struct Instruction {
	in_type InstructionType
	addr_mode AddressingMode
	reg_1 RegisterType
	reg_2 RegisterType
	cond_type ConditionType
	param u8
}

const all_instructions := {
	0x00: Instruction{
		in_type: InstructionType.in_nop
		addr_mode: AddressingMode.am_imp
	}
	0x05: Instruction{
		in_type: InstructionType.in_dec
		addr_mode: AddressingMode.am_r
		reg_1: RegisterType.rt_b
	}
	0x0E: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_d8
		reg_1: RegisterType.rt_c
	}
	0xAF: Instruction{
		in_type: InstructionType.in_xor
		addr_mode: AddressingMode.am_r
		reg_1: RegisterType.rt_a
	}
	0xC3: Instruction{
		in_type: InstructionType.in_jp
		addr_mode: AddressingMode.am_d16
	}
}

pub fn instruction_by_opcode(opcode u8) ?Instruction {
	if (all_instructions[opcode].in_type == InstructionType.in_none) {
		return none
	}
	return all_instructions[opcode]
}