module cart

import os
import encoding.binary

struct RomHeader {
	entry []u8
	logo []u8

	title []u8
	new_lic_code u16
	sgb_flag u8
	cart_type u8
	rom_size u8
	ram_size u8
	dest_code u8
	lic_code u8
	version u8
	checksum u8
	global_checksum u16
}

struct CartContext {
	filename string
	rom_size u32
	rom_data []u8
	header RomHeader
}

__global cart_context &CartContext

pub fn load(filename string) {
	println('Loading cartridge ${filename}...')

	file_size := os.file_size(filename)

	file := os.open_file(filename, "r") or {
		panic(err)
		return
	}

	mut rom_data := file.read_bytes(int(file_size))

	cart_context = &CartContext{
		filename: filename
		rom_size: u32(rom_data.len)
		rom_data: rom_data
		header: RomHeader{
			entry: rom_data[0x100..0x104]
			logo: rom_data[0x104..0x134]
			title: rom_data[0x134..0x144]
			new_lic_code: binary.big_endian_u16_at(rom_data, 0x144)
			sgb_flag: rom_data[0x146]
			cart_type: rom_data[0x147]
			rom_size: rom_data[0x148]
			ram_size: rom_data[0x149]
			dest_code: rom_data[0x14A]
			lic_code: rom_data[0x14B]
			version: rom_data[0x14C]
			checksum: rom_data[0x14D]
			global_checksum: binary.big_endian_u16_at(rom_data, 0x14E)
		}
	}

	rom_title := cart_context.header.title.bytestr()
	rom_type_name := cart_type_name(cart_context)
	rom_licensee_name := cart_licensee_name(cart_context)
	rom_size := 32 * (1 << cart_context.header.rom_size)
	ram_size := ram_sizes[cart_context.header.ram_size]

	println("Loaded cartridge:")
	println('\tTitle       : ${rom_title}')
	println('\tLicensee    : ${rom_licensee_name}')
	println('\tType        : ${rom_type_name}')
	println('\tROM Size    : ${rom_size} KiB')
	println('\tRAM Size    : ${ram_size}')
	println('\tROM version : ${cart_context.header.version}')

	checksum_status := match validate_checksum(cart_context) {
		true { 'PASSED' }
		false { 'FAILED' }
	}
	println("\tChecksum    : ${cart_context.header.checksum:X} (${checksum_status})")
}

pub fn read(address u16) u8 {
	return cart_context.rom_data[address]
}

pub fn write(address u16, value u8) {
	panic('Cartridge writing is not implemented yet.')
}


fn cart_licensee_name(ctx &CartContext) string {
	if ctx.header.lic_code == 0x33 {
		return rom_licensees_new[ctx.header.new_lic_code]
	}
	return rom_licensees_old[ctx.header.lic_code]
}

fn cart_type_name(ctx &CartContext) string {
	if ctx.header.cart_type <= 0x22 {
		return rom_types[ctx.header.cart_type]
	}
	return "Unknown"
}

fn validate_checksum(ctx &CartContext) bool {
	mut checksum := u8(0)
	for address in 0x134..0x14D {
		checksum = checksum - ctx.rom_data[address] - 1
	}
	return checksum == ctx.header.checksum
}