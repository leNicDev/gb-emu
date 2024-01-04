module emulator

import sdl
import cpu
import cart

struct EmulationContext {
mut:
	paused bool
	running bool
	ticks u64
}

pub fn run(args []string) int {
	println("Running emulator")

	// init sdl
	sdl.init(sdl.init_video)

	// init cpu
	cpu.init()

	// init emulation context
	mut ctx := EmulationContext{paused: false, running: true, ticks: 0}

	cart.load(args[1])

	for {
		if !ctx.running {
			break
		}

		if ctx.paused {
			sdl.delay(10)
			continue
		}

		if !cpu.step() {
			return -3
		}

		ctx.ticks++
	}

	return 0
}

fn load_cartridge(filename string) bool {
	return false
}