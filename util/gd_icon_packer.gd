class_name GDIconPacker
extends RefCounted

var png: PNGDecoder = PNGDecoder.new();
var icns: ICNSBuilder = ICNSBuilder.new();
var ico: ICOBuilder = ICOBuilder.new();

enum Platform { WINDOWS, MACOS, ALL };

func pack_file(path: String, platform: Platform = Platform.WINDOWS) -> void:
	png.decode_file(path);
	
	if png.ok:
		if platform == Platform.WINDOWS or platform == Platform.ALL:
			ico.push_entry(png.create_ico_entry())
		
		if platform == Platform.MACOS or platform == Platform.ALL:
			push_warning("Generated ICNS files will have poor compatibility.")
			icns.push_entry(png.create_icns_entry())
	else:
		print("Failed to validate %s!" % path);


func build_icons(path: String) -> void:
	write_builder(icns, "%s.icns" % path);
	write_builder(ico, "%s.ico" % path);
	print("Done!");


func write_builder(builder: BaseIconBuilder, path: String) -> void:
	if builder.entries.is_empty():
		return
	
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	
	if !file:
		file.close();
		print("Failed to write %s!" % path);
		return;
	
	file.store_buffer(builder.build());
	file.close();
