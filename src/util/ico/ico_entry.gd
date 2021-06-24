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
	
	if width < 1 or height < 1 or width > 256 or height > 256:
		valid = false;
		return;
	
	if width == 256:
		width = 0;
	
	if height == 256:
		height = 0;
	
	valid = true;
