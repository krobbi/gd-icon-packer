class_name SerialBuffer
extends Reference

var _used_bytes: int = 0;
var _buffer: StreamPeerBuffer = StreamPeerBuffer.new();

func _init(big_endian: bool) -> void:
	_buffer.set_big_endian(big_endian);
	seek_front();


func get_size() -> int:
	return _used_bytes;


func get_position() -> int:
	return _buffer.get_position();


func get_data_array() -> PoolByteArray:
	if _used_bytes > 0:
		return _buffer.data_array.subarray(0, _used_bytes - 1);
	else:
		return PoolByteArray();


func get_u8() -> int:
	return _buffer.get_u8();


func get_u16() -> int:
	return _buffer.get_u16();


func get_u32() -> int:
	return _buffer.get_u32();


func get_ascii(length: int) -> String:
	return get_data(length).get_string_from_ascii();


func get_data(length: int) -> PoolByteArray:
	# This function returns two values, an @GlobalScope.Error code and a data
	# array. - @StreamPeer documentation.
	return _buffer.get_data(length)[1];


func can_read(bytes: int) -> bool:
	return _buffer.get_position() + bytes <= _used_bytes;


func put_u8(value: int) -> void:
	_buffer.put_u8(value);
	_used_bytes += 1;


func put_u16(value: int) -> void:
	_buffer.put_u16(value);
	_used_bytes += 2;


func put_u32(value: int) -> void:
	_buffer.put_u32(value);
	_used_bytes += 4;


func put_ascii(value: String) -> void:
	put_data(value.to_ascii());


func put_data(data: PoolByteArray) -> void:
	var length: int = data.size();
	put_data_length(data, length);


func put_data_length(data: PoolByteArray, length: int) -> void:
	# warning-ignore: RETURN_VALUE_DISCARDED
	_buffer.put_data(data);
	_used_bytes += length;


func load_data(data: PoolByteArray) -> void:
	var length: int = data.size();
	load_data_length(data, length);


func load_data_length(data: PoolByteArray, length: int) -> void:
	seek_front();
	_used_bytes = 0;
	put_data_length(data, length);
	seek_front();


func seek(position: int) -> void:
	_buffer.seek(position);


func seek_front() -> void:
	_buffer.seek(0);


func seek_back() -> void:
	_buffer.seek(_used_bytes);


func jump(amount: int) -> void:
	_buffer.seek(_buffer.get_position() + amount);


func jump_back(amount: int) -> void:
	_buffer.seek(_buffer.get_position() - amount);
