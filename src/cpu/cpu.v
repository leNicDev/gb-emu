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

		master_interrupt_enabled bool
}

__global cpu_context &CpuContext

pub fn init() {
	cpu_context = &CpuContext{
		registers: CpuRegisters{
			pc: 0x100
			a: 0x01
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
		print_cpu_state(pc, in_name, byte_1, byte_2, byte_3, cpu_context.registers.a, cpu_context.registers.b, cpu_context.registers.c)

		execute_instruction()
	}

	return true
}

pub fn set_flags(z i8, n i8, h i8, c i8) {
	if z >= 0 {
		common.bit_set(cpu_context.registers.f, 7, z == 1)
	}

	if n >= 0 {
		common.bit_set(cpu_context.registers.f, 6, n == 1)
	}

	if h >= 0 {
		common.bit_set(cpu_context.registers.f, 5, h == 1)
	}

	if c >= 0 {
		common.bit_set(cpu_context.registers.f, 4, c == 1)
	}
}

fn fetch_instruction() {
	// set current opcode to current address inside the program counter
	cpu_context.current_opcode = bus.read(cpu_context.registers.pc)
	
	// increment program counter by one address
	cpu_context.registers.pc++

	cpu_context.current_instruction = instruction_by_opcode(cpu_context.current_opcode) or {
		in_name := instruction_names[cpu_context.current_instruction.in_type]
		byte_1 := cpu_context.current_opcode
		byte_2 := bus.read(cpu_context.registers.pc + 1)
		byte_3 := bus.read(cpu_context.registers.pc + 2)
		print_cpu_state(cpu_context.registers.pc - 1, in_name, byte_1, byte_2, byte_3, cpu_context.registers.a, cpu_context.registers.b, cpu_context.registers.c)
		panic('${cpu_context.registers.pc - 1:04X}: Unknown instruction ${cpu_context.current_opcode:02X}')
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

pub fn set_register(reg_type RegisterType, value u16) {
	match reg_type {
		.rt_a {
			cpu_context.registers.a = u8(value)
			return
		}
		.rt_f {
			cpu_context.registers.f = u8(value)
			return
		}
		.rt_b {
			cpu_context.registers.b = u8(value)
			return
		}
		.rt_c {
			cpu_context.registers.c = u8(value)
			return
		}
		.rt_d {
			cpu_context.registers.d = u8(value)
			return
		}
		.rt_e {
			cpu_context.registers.e = u8(value)
			return
		}
		.rt_h {
			cpu_context.registers.h = u8(value)
			return
		}
		.rt_l {
			cpu_context.registers.l = u8(value)
			return
		}

		.rt_af {
			cpu_context.registers.a = common.hi(value)
			cpu_context.registers.f = common.lo(value)
			return
		}
		.rt_bc {
			cpu_context.registers.b = common.hi(value)
			cpu_context.registers.c = common.lo(value)
			return
		}
		.rt_de {
			cpu_context.registers.d = common.hi(value)
			cpu_context.registers.e = common.lo(value)
			return
		}
		.rt_hl {
			cpu_context.registers.h = common.hi(value)
			cpu_context.registers.l = common.lo(value)
			return
		}

		.rt_pc {
			cpu_context.registers.pc = value
			return
		}
		.rt_sp {
			cpu_context.registers.sp = value
			return
		}

		.rt_none { return }
	}
}

fn cycles(cycles int) {}

fn print_cpu_state(pc u16, in_name string, byte_1 u8, byte_2 u8, byte_3 u8, a u8, b u8, c u8) {
	println('${pc:04X}: ${in_name:7} (${byte_1:02X} ${byte_2:02X} ${byte_3:02X}) A: ${a:02X} B: ${b:02X} C: ${c:02X}')
}