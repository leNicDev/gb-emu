module main

import os
import emulator

fn main() {
	exit_code := emulator.run(os.args)
	exit(exit_code)
}
