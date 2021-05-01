class_name PNGDecoder
extends Reference

enum {
	CHUNK_IHDR = 0x49484452,
	CHUNK_PLTE = 0x504c5445,
	CHUNK_IEND = 0x49454e44,
};

enum {
	COLOR_GRAYSCALE = 0,
	COLOR_TRUECOLOR = 2,
	COLOR_INDEXED = 3,
	COLOR_GRAYSCALE_ALPHA = 4,
	COLOR_TRUECOLOR_ALPHA = 6,
};

enum {PALETTE_DISALLOWED, PALETTE_ALLOWED, PALETTE_REQUIRED};

const SIGNATURE: PoolByteArray = PoolByteArray([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]);

var seen_ihdr: bool = false;
var seen_plte: bool = false;
var finished: bool = false;
var ok: bool = false;
var length: int = 0;
var buffer: SerialBuffer = SerialBuffer.new(true);
var width: int = 0;
var height: int = 0;
var color_type: int = COLOR_GRAYSCALE;
var bps: int = 0; # Bits per sample.
var spp: int = 0; # Samples per pixel.
var bpp: int = 0; # Bits per pixel.
var palette_requirement: int = PALETTE_DISALLOWED;
var palette_size: int = 0;

func create_icns_entry() -> ICNSEntry:
	var entry: ICNSEntry = ICNSEntry.new(length, buffer.get_data_array(), width, height);
	
	if not finished or not ok:
		entry.valid = false;
	
	return entry;


func create_ico_entry() -> ICOEntry:
	var entry: ICOEntry = ICOEntry.new(
			length, buffer.get_data_array(), width, height, palette_size, bpp
	);
	
	if not finished or not ok:
		entry.valid = false;
	
	return entry;


func decode_file(path: String) -> void:
	var file: File = File.new();
	var error: int = file.open(path, File.READ);
	
	if error != OK:
		file.close();
		print("Failed to open source file! Error: %d" % error);
		ok = false;
		finished = true;
		return;
	
	var data: PoolByteArray = file.get_buffer(file.get_len());
	file.close();
	
	start(data);
	
	while not finished:
		read_chunk();


func start(data: PoolByteArray) -> void:
	finished = false;
	ok = false;
	seen_ihdr = false;
	seen_plte = false;
	
	length = data.size();
	buffer.load_data_length(data, length);
	
	if not buffer.can_read(8):
		print("Source file is too short to read signature!");
		finished = true;
		return;
	
	if buffer.get_data(8) != SIGNATURE:
		print("Source file does not match PNG signature!");
		finished = true;
		return;


func read_ihdr(chunk_length: int) -> void:
	if seen_ihdr:
		print("PNG file has more than one IHDR chunk!");
		finished = true;
		return;
	
	seen_ihdr = true;
	
	if chunk_length < 13:
		print("PNG file's IHDR chunk is too short!");
		finished = true;
		return;
	
	width = buffer.get_u32();
	
	if width == 0:
		print("PNG file has an invalid width of 0!");
		finished = true;
		return;
	
	height = buffer.get_u32();
	
	if height == 0:
		print("PNG file has an invalid height of 0!");
		finished = true;
		return;
	
	bps = buffer.get_u8();
	
	if bps != 1 and bps != 2 and bps != 4 and bps != 8 and bps != 16:
		print("PNG file has an unsupported bit depth!");
		finished = true;
		return;
	
	color_type = buffer.get_u8();
	
	match color_type:
		COLOR_GRAYSCALE:
			spp = 1;
			palette_requirement = PALETTE_DISALLOWED;
		COLOR_TRUECOLOR:
			if bps < 8:
				print("PNG file has a bit depth too small for truecolor!");
				finished = true;
				return;
			
			spp = 3;
			palette_requirement = PALETTE_ALLOWED;
		COLOR_INDEXED:
			if bps == 16:
				print("PNG file has a bit depth too large for indexed color!");
				finished = true;
				return;
			
			spp = 1;
			palette_requirement = PALETTE_REQUIRED;
		COLOR_GRAYSCALE_ALPHA:
			if bps < 8:
				print("PNG file has a bit depth too small for grayscale with alpha!");
				finished = true;
				return;
			
			spp = 2;
			palette_requirement = PALETTE_DISALLOWED;
		COLOR_TRUECOLOR_ALPHA:
			if bps < 8:
				print("PNG file has a bit depth too small for truecolor with alpha!");
				finished = true;
				return;
			
			spp = 4;
			palette_requirement = PALETTE_ALLOWED;
		_:
			print("PNG file has an unsupported color type!");
			finished = true;
			return;
	
	bpp = bps * spp;


func read_plte(chunk_length: int) -> void:
	if seen_plte:
		print("PNG file has more than one PLTE chunk!");
		finished = true;
		return;
	
	seen_plte = true;
	
	if palette_requirement == PALETTE_DISALLOWED:
		print("PNG file contained a PLTE chunk for a color type that does not support it!");
		finished = true;
		return;
	
	if chunk_length % 3 != 0:
		print("PNG file contained a PLTE chunk with an invalid size!");
		finished = true;
		return;
	
	# warning-ignore: INTEGER_DIVISION
	palette_size = chunk_length / 3;


func read_iend() -> void:
	if not seen_ihdr:
		print("PNG file did not contain an IHDR chunk!");
		finished = true;
		return;
	
	if palette_requirement == PALETTE_REQUIRED and not seen_plte:
		print("PNG file did not contain a required PLTE chunk for indexed color!");
		finished = true;
		return;
	
	ok = true;
	finished = true;


func read_chunk() -> void:
	if not buffer.can_read(8):
		print("Hit end of PNG file before reading chunk header!");
		finished = true;
		return;
	
	var chunk_length: int = buffer.get_u32();
	var chunk_type: int = buffer.get_u32();
	var pos_end: int = buffer.get_position() + chunk_length + 4;
	
	if not buffer.can_read(chunk_length + 4):
		print("Hit end of PNG file before end of chunk!");
		finished = true;
		return;
	
	match chunk_type:
		CHUNK_IHDR:
			read_ihdr(chunk_length);
		CHUNK_PLTE:
			read_plte(chunk_length);
		CHUNK_IEND:
			read_iend();
	
	buffer.seek(pos_end);
