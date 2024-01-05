module common

pub fn bit(a u8, n u8) bool {
	return a & (1 << n) == 1
}

pub fn bit_set(a u8, n u8, value bool) u8 {
	if value {
		return a | (1 << n)
	} else {
		return a & ~(1 << n)
	}
}

pub fn between(a u8, b u8, c u8) bool {
	return ((a >= b) && (a <= c))
}

pub fn reverse(n u16) u16 {
	return ((n & 0xFF00) >> 8) | ((n & 0xFF) << 8)
}

pub fn combine(hi u8, lo u8) u16 {
	return (u16(hi) << 8) | u16(lo)
}

// flags

pub fn cpu_flag_z(a u8) bool {
	return bit(a, 7)
}

pub fn cpu_flag_c(a u8) bool {
	return bit(a, 4)
}