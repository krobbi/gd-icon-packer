class_name BaseIconEntry
extends Reference

var valid: bool = false;
var length: int;
var data: PoolByteArray;

func _init(length_val: int, data_val: PoolByteArray) -> void:
	length = length_val;
	data = data_val;
