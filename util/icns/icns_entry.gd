class_name ICNSEntry
extends BaseIconEntry

var type: String;

func _init(length_val: int, data_val: PackedByteArray, width: int, height: int) -> void:
	super(length_val, data_val)
	
	if width != height or width < 1:
		valid = false;
		return;
	
	valid = true;
	
	match width:
		16:
			type = "icp4";
		32:
			type = "icp5"
		64:
			type = "icp6";
		128:
			type = "ic07";
		256:
			type = "ic08";
		512:
			type = "ic09";
		_:
			valid = false;
