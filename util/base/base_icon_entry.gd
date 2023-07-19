class_name BaseIconEntry
extends RefCounted

var valid: bool = false;
var length: int;
var data: PackedByteArray;

func _init(length_val: int, data_val: PackedByteArray) -> void:
	length = length_val;
	data = data_val;
