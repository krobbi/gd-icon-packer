class_name ICOEntry
extends BaseIconEntry

var width: int;
var height: int;
var palette_size: int;
var bpp: int;

func _init(
		length_val: int, data_val: PoolByteArray,
		width_val: int, height_val: int, palette_size_val: int, bpp_val: int
).(length_val, data_val) -> void:
	width = width_val;
	height = height_val;
	palette_size = palette_size_val;
	bpp = bpp_val;
	
	if width < 0 or height < 0 or width > 256 or height > 256:
		return;
	
	valid = true;
