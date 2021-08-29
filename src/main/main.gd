extends Node

func _ready() -> void:
	var packer: GDIconPacker = GDIconPacker.new();
	
	packer.pack_file("res://icon.png", packer.Platform.WINDOWS);
	packer.build_icons("user://icon");
