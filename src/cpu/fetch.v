module cpu

import bus

fn fetch_data() {
	cpu_context.mem_dest = 0
	cpu_context.dest_is_mem = false

	match cpu_context.current_instruction.addr_mode {
		.am_imp { return }

		.am_r {
			cpu_context.fetched_data = read_register(cpu_context.current_instruction.reg_1)
			return
		}

		.am_r_r {
			cpu_context.fetched_data = read_register(cpu_context.current_instruction.reg_2)
			return
		}

		.am_r_d8 {
			cpu_context.fetched_data = bus.read(cpu_context.registers.pc)
			cycles(1)
			cpu_context.registers.pc++
			return
		}

		.am_d16, .am_r_d16 {
			lo := bus.read(cpu_context.registers.pc)
			cycles(1)
			hi := bus.read(cpu_context.registers.pc + 1)
			cycles(1)

			cpu_context.fetched_data = lo | (u16(hi) << 8)
			cpu_context.registers.pc += 2
			return
		}

		.am_mr_r {
			cpu_context.fetched_data = read_register(cpu_context.current_instruction.reg_2)
			cpu_context.mem_dest = read_register(cpu_context.current_instruction.reg_1)
			cpu_context.dest_is_mem = true

			if cpu_context.current_instruction.reg_1 == RegisterType.rt_c {
				cpu_context.mem_dest |= 0xFF00
			}

			return
		}

		.am_r_mr {
			mut address := read_register(cpu_context.current_instruction.reg_2)

			if cpu_context.current_instruction.reg_1 == RegisterType.rt_c {
				address |= 0xFF00
			}

			cpu_context.fetched_data = bus.read(address)
			cycles(1)
			return
		}

		.am_r_hli {
			cpu_context.fetched_data = bus.read(read_register(cpu_context.current_instruction.reg_2))
			cycles(1)
			set_register(RegisterType.rt_hl, read_register(RegisterType.rt_hl) + 1)
			return
		}

		.am_r_hld {
			cpu_context.fetched_data = bus.read(read_register(cpu_context.current_instruction.reg_2))
			cycles(1)
			set_register(RegisterType.rt_hl, read_register(RegisterType.rt_hl) - 1)
			return
		}

		.am_hli_r {
			cpu_context.fetched_data = read_register(cpu_context.current_instruction.reg_2)
			cpu_context.mem_dest = read_register(cpu_context.current_instruction.reg_1)
			cpu_context.dest_is_mem = true
			set_register(RegisterType.rt_hl, read_register(RegisterType.rt_hl) + 1)
			return
		}

		.am_hld_r {
			cpu_context.fetched_data = read_register(cpu_context.current_instruction.reg_2)
			cpu_context.mem_dest = read_register(cpu_context.current_instruction.reg_1)
			cpu_context.dest_is_mem = true
			set_register(RegisterType.rt_hl, read_register(RegisterType.rt_hl) - 1)
			return
		}

		.am_r_a8 {
			cpu_context.fetched_data = bus.read(cpu_context.registers.pc)
			cycles(1)
			cpu_context.registers.pc++
			return
		}

		.am_a8_r {
			cpu_context.mem_dest = bus.read(cpu_context.registers.pc) | 0xFF00
			cpu_context.dest_is_mem = true
			cycles(1)
			cpu_context.registers.pc++
			return
		}

		.am_hl_spr {
			cpu_context.fetched_data = bus.read(cpu_context.registers.pc)
			cycles(1)
			cpu_context.registers.pc++
			return
		}

		.am_d8 {
			cpu_context.fetched_data = bus.read(cpu_context.registers.pc)
			cycles(1)
			cpu_context.registers.pc++
			return
		}

		.am_a16_r, .am_d16_r {
			lo := bus.read(cpu_context.registers.pc)
			cycles(1)
			hi := bus.read(cpu_context.registers.pc + 1)
			cycles(1)

			cpu_context.mem_dest = lo | (u16(hi) << 8)
			cpu_context.dest_is_mem = true

			cpu_context.registers.pc += 2
			cpu_context.fetched_data = read_register(cpu_context.current_instruction.reg_2)
			return
		}

		.am_mr_d8 {
			cpu_context.fetched_data = bus.read(cpu_context.registers.pc)
			cycles(1)
			cpu_context.registers.pc++
			cpu_context.mem_dest = read_register(cpu_context.current_instruction.reg_1)
			cpu_context.dest_is_mem = true
			return
		}

		.am_mr {
			cpu_context.mem_dest = read_register(cpu_context.current_instruction.reg_1)
			cpu_context.dest_is_mem = true
			cpu_context.fetched_data = bus.read(read_register(cpu_context.current_instruction.reg_1))
			cycles(1)
			return
		}

		.am_r_a16 {
			lo := bus.read(cpu_context.registers.pc)
			cycles(1)
			hi := bus.read(cpu_context.registers.pc + 1)
			cycles(1)

			address := lo | (u16(hi) << 8)
			cpu_context.registers.pc += 2
			cpu_context.fetched_data = bus.read(address)
			cycles(1)
			return
		}
	}
}