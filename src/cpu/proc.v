module cpu

import common

const instruction_processors := {
	InstructionType.in_none: proc_none
	InstructionType.in_nop: proc_nop
	InstructionType.in_ld: proc_ld
	InstructionType.in_jp: proc_jp
}

fn check_conditions(ctx &CpuContext) bool {
	c := common.cpu_flag_c(ctx.registers.f)
	z := common.cpu_flag_z(ctx.registers.f)

	return match ctx.current_instruction.cond_type {
		.ct_none { true }
		.ct_c { c }
		.ct_nc { !c }
		.ct_z { z }
		.ct_nz { !z }
	}
}

fn proc_none(ctx &CpuContext) {
	panic("Invalid instruction")
}

fn proc_nop(ctx &CpuContext) {
	// do nothing
}

fn proc_ld(ctx &CpuContext) {
	// TODO
}

fn proc_jp(mut ctx &CpuContext) {
	if check_conditions(ctx) {
		ctx.registers.pc = ctx.fetched_data
		cycles(1)
	}
}