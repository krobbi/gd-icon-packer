class_name GDIconPacker
extends Reference

var png: PNGDecoder = PNGDecoder.new();
var icns: ICNSBuilder = ICNSBuilder.new();
var ico: ICOBuilder = ICOBuilder.new();

enum Platform {
	MACOS = 0b01,
	WINDOWS = 0b10,
	ALL = 0b11,
};

func pack_file(path: String, platforms: int = Platform.ALL) -> void:
	png.decode_file(path);
	
	if png.ok:
		if platforms & Platform.MACOS != 0:
			icns.push_entry(png.create_icns_entry());
		
		if platforms & Platform.WINDOWS != 0:
			ico.push_entry(png.create_ico_entry());
	else:
		print("Failed to validate %s!" % path);


func build_icons(path: String) -> void:
	write_builder(icns, "%s.icns" % path);
	write_builder(ico, "%s.ico" % path);
	print("Done!");


func write_builder(builder: BaseIconBuilder, path: String) -> void:
	var file: File = File.new();
	var error: int = file.open(path, File.WRITE);
	
	if error != OK:
		file.close();
		print("Failed to write %s! Error: %d" % [path, error]);
		return;
	
	file.store_buffer(builder.build());
	file.close();
