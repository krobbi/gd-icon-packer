class_name ICNSBuilder
extends BaseIconBuilder

func push_entry(entry: BaseIconEntry) -> void:
	if entry is ICNSEntry:
		.push_entry(entry);


func build() -> PoolByteArray:
	# ICNS files are big-endian:
	var header_block: SerialBuffer = SerialBuffer.new(true);
	var body_block: SerialBuffer = SerialBuffer.new(true);
	
	header_block.put_ascii("icns"); # Magic literal.
	
	# ICNS headers have a 4-byte integer representing the total file size. The
	# header contributes 8 bytes to the file.
	var file_size: int = 8;
	
	for i in range(entries.size()):
		var entry: ICNSEntry = entries[i];
		
		# ICNS entries have a type, length, and data:
		body_block.put_ascii(entry.type);
		body_block.put_u32(entry.length);
		body_block.put_data_length(entry.data, entry.length);
		
		# Each entry type and length contributes 8 bytes to the file:
		file_size += 8 + entry.length;
	
	header_block.put_u32(file_size);
	header_block.put_data(body_block.get_data_array());
	return header_block.get_data_array();
