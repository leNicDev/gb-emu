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
	am_hld_r
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
	// 0x0X
	0x00: Instruction{
		in_type: InstructionType.in_nop
		addr_mode: AddressingMode.am_imp
	}
	0x01: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_d16
		reg_1: RegisterType.rt_bc
	}
	0x02: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_mr_r
		reg_1: RegisterType.rt_bc
		reg_2: RegisterType.rt_a
	}
	0x05: Instruction{
		in_type: InstructionType.in_dec
		addr_mode: AddressingMode.am_r
		reg_1: RegisterType.rt_b
	}
	0x06: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_d8
		reg_1: RegisterType.rt_b
	}
	0x08: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_a16_r
		reg_1: RegisterType.rt_none
		reg_2: RegisterType.rt_sp
	}
	0x0A: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_mr
		reg_1: RegisterType.rt_a
		reg_2: RegisterType.rt_bc
	}
	0x0E: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_d8
		reg_1: RegisterType.rt_c
	}

	// 0x1X
	0x11: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_d16
		reg_1: RegisterType.rt_de
	}
	0x12: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_mr_r
		reg_1: RegisterType.rt_de
		reg_2: RegisterType.rt_a
	}
	0x15: Instruction{
		in_type: InstructionType.in_dec
		addr_mode: AddressingMode.am_r
		reg_1: RegisterType.rt_d
	}
	0x16: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_d8
		reg_1: RegisterType.rt_d
	}
	0x1A: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_mr
		reg_1: RegisterType.rt_a
		reg_2: RegisterType.rt_de
	}
	0x1E: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_d8
		reg_1: RegisterType.rt_e
	}

	// 0x2X
	0x21: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_d16
		reg_1: RegisterType.rt_hl
	}
	0x22: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_hli_r
		reg_1: RegisterType.rt_hl
		reg_2: RegisterType.rt_a
	}
	0x25: Instruction{
		in_type: InstructionType.in_dec
		addr_mode: AddressingMode.am_r
		reg_1: RegisterType.rt_h
	}
	0x26: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_d8
		reg_1: RegisterType.rt_h
	}
	0x2A: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_hli
		reg_1: RegisterType.rt_a
		reg_2: RegisterType.rt_hl
	}
	0x2E: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_d8
		reg_1: RegisterType.rt_l
	}

	// 0x3X
	0x31: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_d16
		reg_1: RegisterType.rt_sp
	}
	0x32: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_hld_r
		reg_1: RegisterType.rt_hl
		reg_2: RegisterType.rt_a
	}
	0x35: Instruction{
		in_type: InstructionType.in_dec
		addr_mode: AddressingMode.am_r
		reg_1: RegisterType.rt_hl
	}
	0x36: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_mr_d8
		reg_1: RegisterType.rt_hl
	}
	0x3A: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_hld
		reg_1: RegisterType.rt_a
		reg_2: RegisterType.rt_hl
	}
	0x3E: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_d8
		reg_1: RegisterType.rt_a
	}

	// 0x4X
	0x40: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_b
		reg_2: RegisterType.rt_b
	}
	0x41: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_b
		reg_2: RegisterType.rt_c
	}
	0x42: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_b
		reg_2: RegisterType.rt_d
	}
	0x43: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_b
		reg_2: RegisterType.rt_e
	}
	0x44: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_b
		reg_2: RegisterType.rt_h
	}
	0x45: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_b
		reg_2: RegisterType.rt_l
	}
	0x46: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_mr
		reg_1: RegisterType.rt_b
		reg_2: RegisterType.rt_hl
	}
	0x47: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_b
		reg_2: RegisterType.rt_a
	}
	0x48: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_c
		reg_2: RegisterType.rt_b
	}
	0x49: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_c
		reg_2: RegisterType.rt_c
	}
	0x4A: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_c
		reg_2: RegisterType.rt_d
	}
	0x4B: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_c
		reg_2: RegisterType.rt_e
	}
	0x4C: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_c
		reg_2: RegisterType.rt_h
	}
	0x4D: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_c
		reg_2: RegisterType.rt_l
	}
	0x4E: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_mr
		reg_1: RegisterType.rt_c
		reg_2: RegisterType.rt_hl
	}
	0x4F: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_c
		reg_2: RegisterType.rt_a
	}

	// 0x5X
	0x50: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_d
		reg_2: RegisterType.rt_b
	}
	0x51: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_d
		reg_2: RegisterType.rt_c
	}
	0x52: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_d
		reg_2: RegisterType.rt_d
	}
	0x53: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_d
		reg_2: RegisterType.rt_e
	}
	0x54: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_d
		reg_2: RegisterType.rt_h
	}
	0x55: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_d
		reg_2: RegisterType.rt_l
	}
	0x56: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_mr
		reg_1: RegisterType.rt_d
		reg_2: RegisterType.rt_hl
	}
	0x57: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_d
		reg_2: RegisterType.rt_a
	}
	0x58: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_e
		reg_2: RegisterType.rt_b
	}
	0x59: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_e
		reg_2: RegisterType.rt_c
	}
	0x5A: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_e
		reg_2: RegisterType.rt_d
	}
	0x5B: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_e
		reg_2: RegisterType.rt_e
	}
	0x5C: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_e
		reg_2: RegisterType.rt_h
	}
	0x5D: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_e
		reg_2: RegisterType.rt_l
	}
	0x5E: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_mr
		reg_1: RegisterType.rt_e
		reg_2: RegisterType.rt_hl
	}
	0x5F: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_e
		reg_2: RegisterType.rt_a
	}

	// 0x6X
	0x60: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_h
		reg_2: RegisterType.rt_b
	}
	0x61: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_h
		reg_2: RegisterType.rt_c
	}
	0x62: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_h
		reg_2: RegisterType.rt_d
	}
	0x63: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_h
		reg_2: RegisterType.rt_e
	}
	0x64: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_h
		reg_2: RegisterType.rt_h
	}
	0x65: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_h
		reg_2: RegisterType.rt_l
	}
	0x66: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_mr
		reg_1: RegisterType.rt_h
		reg_2: RegisterType.rt_hl
	}
	0x67: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_h
		reg_2: RegisterType.rt_a
	}
	0x68: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_l
		reg_2: RegisterType.rt_b
	}
	0x69: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_l
		reg_2: RegisterType.rt_c
	}
	0x6A: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_l
		reg_2: RegisterType.rt_d
	}
	0x6B: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_l
		reg_2: RegisterType.rt_e
	}
	0x6C: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_l
		reg_2: RegisterType.rt_h
	}
	0x6D: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_l
		reg_2: RegisterType.rt_l
	}
	0x6E: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_mr
		reg_1: RegisterType.rt_l
		reg_2: RegisterType.rt_hl
	}
	0x6F: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_l
		reg_2: RegisterType.rt_a
	}

	// 0x7X
	0x70: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_mr_r
		reg_1: RegisterType.rt_hl
		reg_2: RegisterType.rt_b
	}
	0x71: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_mr_r
		reg_1: RegisterType.rt_hl
		reg_2: RegisterType.rt_c
	}
	0x72: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_mr_r
		reg_1: RegisterType.rt_hl
		reg_2: RegisterType.rt_d
	}
	0x73: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_mr_r
		reg_1: RegisterType.rt_hl
		reg_2: RegisterType.rt_e
	}
	0x74: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_mr_r
		reg_1: RegisterType.rt_hl
		reg_2: RegisterType.rt_h
	}
	0x75: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_mr_r
		reg_1: RegisterType.rt_hl
		reg_2: RegisterType.rt_l
	}
	0x76: Instruction{
		in_type: InstructionType.in_halt
	}
	0x77: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_mr_r
		reg_1: RegisterType.rt_hl
		reg_2: RegisterType.rt_a
	}
	0x78: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_a
		reg_2: RegisterType.rt_b
	}
	0x79: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_a
		reg_2: RegisterType.rt_c
	}
	0x7A: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_a
		reg_2: RegisterType.rt_d
	}
	0x7B: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_a
		reg_2: RegisterType.rt_e
	}
	0x7C: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_a
		reg_2: RegisterType.rt_h
	}
	0x7D: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_a
		reg_2: RegisterType.rt_l
	}
	0x7E: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_mr
		reg_1: RegisterType.rt_a
		reg_2: RegisterType.rt_hl
	}
	0x7F: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_r
		reg_1: RegisterType.rt_a
		reg_2: RegisterType.rt_a
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

	// 0xEX
	0xE2: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_mr_r
		reg_1: RegisterType.rt_c
		reg_2: RegisterType.rt_a
	}
	0xEA: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_a16_r
		reg_1: RegisterType.rt_none
		reg_2: RegisterType.rt_a
	}

	// 0xFX
	0xF2: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_mr
		reg_1: RegisterType.rt_a
		reg_2: RegisterType.rt_c
	}
	0xF3: Instruction{
		in_type: InstructionType.in_di
	}
	0xFA: Instruction{
		in_type: InstructionType.in_ld
		addr_mode: AddressingMode.am_r_a16
		reg_1: RegisterType.rt_a
	}
}

pub fn instruction_by_opcode(opcode u8) ?Instruction {
	if all_instructions[opcode].in_type == InstructionType.in_none {
		return none
	}
	return all_instructions[opcode]
}