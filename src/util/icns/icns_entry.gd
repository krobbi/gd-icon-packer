class_name ICNSEntry
extends BaseIconEntry

var type: String;

func _init(length_val: int, data_val: PoolByteArray, width: int, height: int).(length_val, data_val) -> void:
	if width != height:
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
