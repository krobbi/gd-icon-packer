class_name ICOBuilder
extends BaseIconBuilder

func push_entry(entry: BaseIconEntry) -> void:
	if entry is ICOEntry:
		super.push_entry(entry);


func build() -> PackedByteArray:
	# ICO files are little-endian, PNG files are big-endian:
	var index_block: SerialBuffer = SerialBuffer.new(false);
	var image_block: SerialBuffer = SerialBuffer.new(true);
	
	var entries_count: int = entries.size();
	
	index_block.put_u16(0); # Reserved. Must be 0.
	index_block.put_u16(1); # Image type. 1 for icon images, 2 for cursor images.
	index_block.put_u16(entries_count); # Number of imges in the file.
	
	# Offset to the first image data. The header contributes 6 bytes to the file
	# and each entry contributes 16 bytes:
	var image_offset: int = entries_count * 16 + 6;
	
	for i in range(entries_count):
		var entry: ICOEntry = entries[i];
		
		# Entries have a width, height, palette size, color planes, and bits per pixel:
		index_block.put_u8(entry.width);
		index_block.put_u8(entry.height);
		index_block.put_u8(entry.palette_size);
		index_block.put_u8(0); # Reserved. Should be 0.
		index_block.put_u16(0); # Color planes. Should be 0 or 1.
		index_block.put_u16(entry.bpp);
		index_block.put_u32(entry.length);
		index_block.put_u32(image_offset + image_block.get_size());
		
		image_block.put_data_length(entry.data, entry.length);
	
	index_block.put_data(image_block.get_data_array());
	return index_block.get_data_array();
