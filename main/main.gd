extends Node

func _ready() -> void:
	var packer: GDIconPacker = GDIconPacker.new();
	
	packer.pack_file("res://resources/icon.png");
	packer.build_icons("user://icon");
