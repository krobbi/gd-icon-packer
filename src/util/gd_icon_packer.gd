class_name GDIconPacker
extends Reference

var png: PNGDecoder = PNGDecoder.new();
var icns: ICNSBuilder = ICNSBuilder.new();
var ico: ICOBuilder = ICOBuilder.new();

func pack_file(path: String) -> void:
	png.decode_file(path);
	
	if png.ok:
		icns.push_entry(png.create_icns_entry());
		ico.push_entry(png.create_ico_entry());
	else:
		print("Failed to validate %s!" % path);


func build_icons(path: String) -> void:
	write_builder(icns, "%s.icns" % path);
	write_builder(ico, "%s.ico" % path);


func write_builder(builder: BaseIconBuilder, path: String) -> void:
	var file: File = File.new();
	var error: int = file.open(path, File.WRITE);
	
	if error != OK:
		file.close();
		print("Failed to write %s! Error: %d" % [path, error]);
		return;
	
	file.store_buffer(builder.build());
	file.close();
