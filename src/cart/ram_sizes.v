module cart

const ram_sizes := {
	0x00: "0" // no RAM
	0x01: "0" // unused
	0x02: "8 KiB" // 1 bank
	0x03: "32 KiB" // 4 banks of 8 KiB each
	0x04: "128 KiB" // 16 banks of 8 KiB each
	0x05: "64 KiB" // 8 banks of 8 KiB each
}