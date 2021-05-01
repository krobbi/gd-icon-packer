class_name BaseIconBuilder
extends Reference

var entries: Array = Array();

func push_entry(entry: BaseIconEntry) -> void:
	if not entry.valid:
		return;
	
	entries.push_back(entry);


func build() -> PoolByteArray:
	return PoolByteArray();
