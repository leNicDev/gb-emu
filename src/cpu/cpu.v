module cpu

import bus
import common

struct CpuRegisters {
	mut:
		a u8
		f u8
		b u8
		c u8
		d u8
		e u8
		h u8
		l u8
		pc u16
		sp u16
}

struct CpuContext {
	mut:
		registers CpuRegisters

		fetched_data u16
		mem_dest u16
		dest_is_mem bool
		current_opcode u8
		current_instruction Instruction

		halted bool
		stepping bool
}

__global cpu_context &CpuContext

pub fn init() {
	cpu_context = &CpuContext{
		registers: CpuRegisters{
			pc: 0x100
		}

		fetched_data: 0
		mem_dest: 0
		current_opcode: 0
		
		halted: false
		stepping: false
	}
}

pub fn step() bool {
	if !cpu_context.halted {
		pc := cpu_context.registers.pc

		fetch_instruction()
		fetch_data()

		in_name := instruction_names[cpu_context.current_instruction.in_type]
		byte_1 := cpu_context.current_opcode
		byte_2 := bus.read(pc + 1)
		byte_3 := bus.read(pc + 2)
		println('${pc:04X}: ${in_name:7} (${byte_1:X} ${byte_2:X} ${byte_3:X}) A: ${cpu_context.registers.a:X} B: ${cpu_context.registers.b:X} C: ${cpu_context.registers.c:X}')

		execute_instruction()
	}

	return true
}

fn fetch_instruction() {
	// set current opcode to current address inside the program counter
	cpu_context.current_opcode = bus.read(cpu_context.registers.pc)
	
	// increment program counter by one address
	cpu_context.registers.pc++

	cpu_context.current_instruction = instruction_by_opcode(cpu_context.current_opcode) or {
		panic('Unknown instruction ${cpu_context.current_opcode:X}')
	}
}

fn fetch_data() {
	cpu_context.mem_dest = 0
	cpu_context.dest_is_mem = false

	match cpu_context.current_instruction.addr_mode {
		.am_imp { return }

		.am_r {
			cpu_context.fetched_data = read_register(cpu_context.current_instruction.reg_1)
			return
		}

		.am_r_d8 {
			cpu_context.fetched_data = bus.read(cpu_context.registers.pc)
			cycles(1)
			cpu_context.registers.pc++
			return
		}

		.am_d16 {
			lo := bus.read(cpu_context.registers.pc)
			cycles(1)
			hi := bus.read(cpu_context.registers.pc + 1)
			cycles(1)

			cpu_context.fetched_data = lo | (u16(hi) << 8)
			cpu_context.registers.pc += 2
			return
		}

		else {
			panic("Unknown addressing mode ${cpu_context.current_instruction.addr_mode:X}")
			return
		}
	}
}

fn execute_instruction() {
	instruction_processor := instruction_processors[cpu_context.current_instruction.in_type] or {
		panic("Failed to get instruction processor for instruction ${cpu_context.current_instruction.in_type:X}")
	}
	instruction_processor(cpu_context)
}

fn read_register(reg_type RegisterType) u16 {
	match reg_type {
		.rt_a { return cpu_context.registers.a }
		.rt_f { return cpu_context.registers.f }
		.rt_b { return cpu_context.registers.b }
		.rt_c { return cpu_context.registers.c }
		.rt_d { return cpu_context.registers.d }
		.rt_e { return cpu_context.registers.e }
		.rt_h { return cpu_context.registers.h }
		.rt_l { return cpu_context.registers.l }

		.rt_af { return u16(cpu_context.registers.a) }
		.rt_bc { return common.combine(cpu_context.registers.b, cpu_context.registers.c) }
		.rt_de { return common.combine(cpu_context.registers.d, cpu_context.registers.e) }
		.rt_hl { return common.combine(cpu_context.registers.h, cpu_context.registers.l) }

		.rt_pc { return cpu_context.registers.pc }
		.rt_sp { return cpu_context.registers.sp }

		else { return 0 }
	}
}

fn cycles(cycles int) {}